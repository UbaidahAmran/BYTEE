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

@WebServlet("/BookingConfirmServlet")
public class BookingConfirmServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        
        // 1. Auth Check
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user_id") == null) {
            response.sendRedirect("Login.jsp");
            return;
        }

        String roomId = request.getParameter("room_id");

        try {
            Connection conn = DBConnection.getConnection();
            
            // 2. Fetch Full Details for the Confirmation Card
            String sql = "SELECT c.name AS college_name, c.location, ru.block, ru.level, ru.room_number, r.bed_number, r.status " +
                         "FROM rooms r " +
                         "JOIN room_units ru ON r.room_unit_id = ru.room_unit_id " +
                         "JOIN colleges c ON ru.college_id = c.college_id " +
                         "WHERE r.room_id = ?";
            
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, roomId);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                // Check if someone else stole it while you were clicking!
                if (!"Available".equalsIgnoreCase(rs.getString("status"))) {
                    response.sendRedirect("dashboard.jsp?error=RoomTaken");
                    return;
                }

                // Send details to JSP
                request.setAttribute("room_id", roomId);
                request.setAttribute("college_name", rs.getString("college_name"));
                request.setAttribute("location", rs.getString("location"));
                request.setAttribute("unit_info", "Block " + rs.getString("block") + ", Level " + rs.getString("level") + " (Unit " + rs.getString("room_number") + ")");
                request.setAttribute("bed_info", rs.getString("bed_number"));
                
                request.getRequestDispatcher("booking_confirm.jsp").forward(request, response);
            } else {
                response.sendRedirect("BookingWizardServlet?step=1");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("dashboard.jsp");
        }
    }
}