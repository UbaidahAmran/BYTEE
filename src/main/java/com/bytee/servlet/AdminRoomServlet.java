package com.bytee.servlet;

import java.io.IOException;
import java.io.PrintWriter;
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

@WebServlet("/AdminRoomServlet")
public class AdminRoomServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        
        // 1. Auth Check
        HttpSession session = request.getSession(false);
        String role = (session != null) ? (String) session.getAttribute("user_role") : null;
        if (role == null || !role.equalsIgnoreCase("Admin")) {
            response.sendRedirect("Login.jsp");
            return;
        }

        try {
            Connection conn = DBConnection.getConnection();
            
            // ============================================================
            // 2. PREPARE DROPDOWN DATA
            // ============================================================
            
            // We ONLY need to fetch Colleges dynamically now.
            // Blocks, Levels, and Beds are hardcoded in JSP.
            String sqlColleges = "SELECT * FROM colleges";
            PreparedStatement stmtCol = conn.prepareStatement(sqlColleges);
            request.setAttribute("collegeList", stmtCol.executeQuery());

            // ============================================================
            // 3. FETCH MAIN ROOM LIST
            // ============================================================
            
            String sql = "SELECT r.room_id, r.bed_number, r.status, " +
                         "ru.block, ru.level, ru.room_number, " +
                         "c.name AS college_name, " +
                         "u.full_name, u.matric_number " +
                         "FROM rooms r " +
                         "JOIN room_units ru ON r.room_unit_id = ru.room_unit_id " +
                         "JOIN colleges c ON ru.college_id = c.college_id " +
                         "LEFT JOIN users u ON r.occupant_id = u.user_id " +
                         "ORDER BY c.name, ru.block, ru.level, ru.room_number, r.bed_number";
            
            PreparedStatement stmt = conn.prepareStatement(sql);
            ResultSet rs = stmt.executeQuery();
            
            request.setAttribute("roomList", rs);
            request.getRequestDispatcher("admin_rooms.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            response.setContentType("text/html");
            PrintWriter out = response.getWriter();
            out.println("<h3>Error Loading Rooms</h3>");
            out.println("<p>" + e.getMessage() + "</p>");
        }
    }
}