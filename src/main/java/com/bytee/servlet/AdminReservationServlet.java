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

@WebServlet("/AdminReservationServlet")
public class AdminReservationServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Admin Auth Check
        HttpSession session = request.getSession(false);
        String role = (session != null) ? (String) session.getAttribute("user_role") : null;
        if (!"Admin".equalsIgnoreCase(role)) { response.sendRedirect("Login.jsp"); return; }

        try {
            Connection conn = DBConnection.getConnection();
            
            // Get ALL reservations
            String sql = "SELECT res.reservation_id, res.status, res.booking_date, " +
                         "u.full_name, u.matric_number, " +
                         "c.name AS college_name, ru.block, ru.room_number, r.bed_number, r.room_id " +
                         "FROM reservations res " +
                         "JOIN users u ON res.user_id = u.user_id " +
                         "JOIN rooms r ON res.room_id = r.room_id " +
                         "JOIN room_units ru ON r.room_unit_id = ru.room_unit_id " +
                         "JOIN colleges c ON ru.college_id = c.college_id " +
                         "ORDER BY res.booking_date DESC";
            
            PreparedStatement stmt = conn.prepareStatement(sql);
            request.setAttribute("resList", stmt.executeQuery());
            
            request.getRequestDispatcher("admin_reservations.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("admin_dashboard.jsp");
        }
    }
}