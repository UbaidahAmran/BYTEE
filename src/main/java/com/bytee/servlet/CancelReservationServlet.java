package com.bytee.servlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.bytee.db.DBConnection;

@WebServlet("/CancelReservationServlet")
public class CancelReservationServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        
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
            conn.setAutoCommit(false); // START TRANSACTION

            // 1. Delete the Reservation (or you could UPDATE status = 'Cancelled')
            String sqlRes = "DELETE FROM reservations WHERE user_id = ? AND room_id = ?";
            PreparedStatement stmtRes = conn.prepareStatement(sqlRes);
            stmtRes.setString(1, userId);
            stmtRes.setString(2, roomId);
            stmtRes.executeUpdate();

            // 2. Free up the Room
            String sqlRoom = "UPDATE rooms SET status = 'Available', occupant_id = NULL WHERE room_id = ?";
            PreparedStatement stmtRoom = conn.prepareStatement(sqlRoom);
            stmtRoom.setString(1, roomId);
            stmtRoom.executeUpdate();

            conn.commit(); // COMMIT TRANSACTION
            
            // 3. Redirect back to "My Reservations" (which will now be empty)
            response.sendRedirect("MyReservationsServlet?msg=Cancelled");

        } catch (Exception e) {
            try { if(conn != null) conn.rollback(); } catch(Exception ex) {}
            e.printStackTrace();
            response.sendRedirect("MyReservationsServlet?error=CancelFailed");
        } finally {
            try { if(conn != null) conn.close(); } catch(Exception ex) {}
        }
    }
}