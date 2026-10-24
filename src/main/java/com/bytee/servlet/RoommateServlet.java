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

@WebServlet("/RoommateServlet")
public class RoommateServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        System.out.println("DEBUG: RoommateServlet Started...");

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user_id") == null) {
            System.out.println("DEBUG: No session found. Redirecting to login.");
            response.sendRedirect("login.jsp");
            return;
        }
        
        String currentUserId = (String) session.getAttribute("user_id");
        System.out.println("DEBUG: Current User ID is: " + currentUserId);

        try {
            Connection conn = DBConnection.getConnection();
            
            // CORRECTION 1: Only ask for 'room_unit_id' from the 'rooms' table.
            // The 'rooms' table DOES NOT have 'room_number' anymore.
            String findMyUnitSQL = "SELECT room_unit_id FROM rooms WHERE occupant_id = ?";
            PreparedStatement stmt1 = conn.prepareStatement(findMyUnitSQL);
            stmt1.setString(1, currentUserId);
            ResultSet rs1 = stmt1.executeQuery();
            
            if (rs1.next()) {
                String myUnitId = rs1.getString("room_unit_id");
                System.out.println("DEBUG: User lives in Unit ID: " + myUnitId);
                
                // CORRECTION 2: Join 'rooms' -> 'users' AND 'rooms' -> 'room_units' (if you want to show unit info)
                // For now, this query is actually fine as is because it gets 'bed_number' from 'rooms'.
                String findMatesSQL = "SELECT u.user_id, u.full_name, u.email, u.profile_image, r.bed_number, r.status " +
                                      "FROM rooms r " +
                                      "LEFT JOIN users u ON r.occupant_id = u.user_id " +
                                      "WHERE r.room_unit_id = ? " +
                                      "ORDER BY r.bed_number";
                
                PreparedStatement stmt2 = conn.prepareStatement(findMatesSQL);
                stmt2.setString(1, myUnitId);
                ResultSet rsRoommates = stmt2.executeQuery();
                
                System.out.println("DEBUG: Roommate Query Run. Forwarding to JSP...");
                request.setAttribute("roommateList", rsRoommates);
                request.getRequestDispatcher("my_roommates.jsp").forward(request, response);
                
            } else {
                System.out.println("DEBUG: NO ROOM FOUND for this user.");
                response.sendRedirect("dashboard.jsp?msg=NoRoom");
            }
            
        } catch (Exception e) {
            System.out.println("DEBUG: CRASHED with error:");
            e.printStackTrace();
            response.sendRedirect("dashboard.jsp?msg=Error");
        }
    }
}