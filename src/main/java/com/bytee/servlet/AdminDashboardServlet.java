package com.bytee.servlet;

// --- 1. JAVA IMPORTS (Standard Java stuff) ---
import java.io.IOException;

// --- 2. SQL IMPORTS (Database stuff) ---
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

// --- 3. SERVLET IMPORTS (Web stuff) ---
// If these lines are RED, see the "Fixing Build Path" section below
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

// --- 4. YOUR CUSTOM IMPORTS ---
// If this is red, check if DBConnection.java is in the 'com.bytee.db' package
import com.bytee.db.DBConnection;

@WebServlet("/AdminDashboardServlet")
public class AdminDashboardServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        
        // 1. Get Session
        HttpSession session = request.getSession(false);
        
        // 2. Check if user is logged in AND is an Admin
        String role = (session != null) ? (String) session.getAttribute("user_role") : null;
        
        if (role == null || !role.equalsIgnoreCase("Admin")) {
            // Not an admin? Kick them out.
            response.sendRedirect("Login.jsp");
            return;
        }

        try {
            Connection conn = DBConnection.getConnection();
            
            // 3. Query: Get Complaints + Student Name + Room Location
            // We use LEFT JOIN because even if a room was deleted, we still want to see the complaint.
            String sql = "SELECT c.complaint_id, c.category, c.description, c.status, c.date_filed, c.image_path, " +
                         "u.full_name, " +
                         "ru.block, ru.room_number " +
                         "FROM complaints c " +
                         "JOIN users u ON c.user_id = u.user_id " +
                         "LEFT JOIN rooms r ON c.room_id = r.room_id " +
                         "LEFT JOIN room_units ru ON r.room_unit_id = ru.room_unit_id " +
                         "ORDER BY c.date_filed DESC";
            
            PreparedStatement stmt = conn.prepareStatement(sql);
            ResultSet rs = stmt.executeQuery();
            
            // 4. Send the list to the JSP
            request.setAttribute("complaintList", rs);
            request.getRequestDispatcher("admin_dashboard.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Database Error: " + e.getMessage());
        }
    }
}