package com.bytee.servlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.bytee.db.DBConnection;

@WebServlet("/RoomListServlet")
public class RoomListServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        
        // 1. Security Check: Is user logged in?
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user_name") == null) {
            response.sendRedirect("Login.jsp");
            return;
        }

        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = DBConnection.getConnection();
            
            // UPDATE: Complex 3-Table Join to match your new schema
            String sql = "SELECT " +
                         "  r.room_id, " +
                         "  r.bed_number, " +
                         "  ru.room_number AS unit_number, " +
                         "  ru.block, " +
                         "  ru.level, " +
                         "  c.name AS college_name, " +
                         "  c.gender_restriction " +
                         "FROM rooms r " +
                         "JOIN room_units ru ON r.room_unit_id = ru.room_unit_id " +
                         "JOIN colleges c ON ru.college_id = c.college_id " +
                         "WHERE r.status = 'Available'";
                         // Optional: Add "ORDER BY c.name, ru.room_number" to sort it nicely
            
            stmt = conn.prepareStatement(sql);
            rs = stmt.executeQuery();
            
            request.setAttribute("roomData", rs);
            request.getRequestDispatcher("roomlist.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("dashboard.jsp");
        }
        // Note: We are NOT closing the connection here because the ResultSet needs it open to be read in the JSP.
        // In a pro app, we'd use a different pattern, but this works for learning.
    }
}