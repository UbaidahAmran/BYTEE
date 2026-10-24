package com.bytee.servlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.bytee.db.DBConnection;

@WebServlet("/FinalizeBookingServlet")
public class FinalizeBookingServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        
        // 1. Auth Check
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user_id") == null) {
            response.sendRedirect("Login.jsp");
            return;
        }

        String userId = (String) session.getAttribute("user_id");
        String roomId = request.getParameter("room_id");
        
        Connection conn = null;
        
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false); // START TRANSACTION - Safety Mode ON
            
            // --- SECURITY CHECK 1: DOES USER ALREADY HAVE A ROOM? ---
            // If they already have a confirmed booking, stop them immediately.
            String checkUserSql = "SELECT reservation_id FROM reservations WHERE user_id = ? AND status = 'Confirmed'";
            PreparedStatement checkUserStmt = conn.prepareStatement(checkUserSql);
            checkUserStmt.setString(1, userId);
            ResultSet rsUser = checkUserStmt.executeQuery();
            
            if (rsUser.next()) {
                throw new Exception("DoubleBookingAttempt"); // Custom error trigger
            }
            
            // --- SECURITY CHECK 2: IS ROOM STILL AVAILABLE? ---
            // Maybe someone else clicked "Confirm" 1 millisecond before this user.
            String checkRoomSql = "SELECT status FROM rooms WHERE room_id = ?";
            PreparedStatement checkRoomStmt = conn.prepareStatement(checkRoomSql);
            checkRoomStmt.setString(1, roomId);
            ResultSet rsRoom = checkRoomStmt.executeQuery();
            
            if (rsRoom.next()) {
                String currentStatus = rsRoom.getString("status");
                if (!"Available".equalsIgnoreCase(currentStatus)) {
                    throw new Exception("RoomTaken"); // Custom error trigger
                }
            } else {
                throw new Exception("InvalidRoom");
            }

            // --- STEP 3: CREATE RESERVATION ---
            String insertResSql = "INSERT INTO reservations (user_id, room_id, status) VALUES (?, ?, 'Confirmed')";
            PreparedStatement stmtRes = conn.prepareStatement(insertResSql);
            stmtRes.setString(1, userId);
            stmtRes.setString(2, roomId);
            stmtRes.executeUpdate();
            
            // --- STEP 4: LOCK THE ROOM ---
            String updateRoomSql = "UPDATE rooms SET status = 'Occupied', occupant_id = ? WHERE room_id = ?";
            PreparedStatement stmtRoom = conn.prepareStatement(updateRoomSql);
            stmtRoom.setString(1, userId);
            stmtRoom.setString(2, roomId);
            stmtRoom.executeUpdate();
            
            // --- STEP 5: SAVE EVERYTHING ---
            conn.commit(); // Commit Transaction
            
            // Success! Send them to see their new room.
            response.sendRedirect("MyReservationsServlet"); 
            
        } catch (Exception e) {
            // IF ANYTHING GOES WRONG, UNDO EVERYTHING
            try { if(conn != null) conn.rollback(); } catch(Exception ex) {}
            
            e.printStackTrace();
            
            // Handle specific errors for better user feedback
            String errorMsg = e.getMessage();
            if ("DoubleBookingAttempt".equals(errorMsg)) {
                response.sendRedirect("MyReservationsServlet?msg=AlreadyHasRoom");
            } else if ("RoomTaken".equals(errorMsg)) {
                response.sendRedirect("dashboard.jsp?error=RoomTaken");
            } else {
                response.sendRedirect("dashboard.jsp?error=BookingFailed");
            }
            
        } finally {
            try { if(conn != null) conn.close(); } catch(Exception ex) {}
        }
    }
}