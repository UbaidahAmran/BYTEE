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

@WebServlet("/MyReservationsServlet")
public class MyReservationsServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user_id") == null) {
            response.sendRedirect("Login.jsp");
            return;
        }
        
        String userId = (String) session.getAttribute("user_id");

        try {
            Connection conn = DBConnection.getConnection();
            
            // QUERY 1: Get Reservation Details
            String sqlBooking = "SELECT res.booking_date, res.status, r.room_id, " +
                         "r.bed_number, ru.room_number, ru.block, ru.level, c.name AS college_name " +
                         "FROM reservations res " +
                         "JOIN rooms r ON res.room_id = r.room_id " +
                         "JOIN room_units ru ON r.room_unit_id = ru.room_unit_id " +
                         "JOIN colleges c ON ru.college_id = c.college_id " +
                         "WHERE res.user_id = ?";
            
            PreparedStatement stmt1 = conn.prepareStatement(sqlBooking);
            stmt1.setString(1, userId);
            ResultSet rsBooking = stmt1.executeQuery();
            
            request.setAttribute("myBookings", rsBooking);

            // QUERY 2: Get Roommates (Neighbors in the same Unit)
            // Logic: Find the unit where 'userId' lives, then find everyone in that unit.
            String sqlRoommates = "SELECT u.user_id, u.full_name, u.profile_image, r.bed_number, r.status " +
                                  "FROM rooms r " +
                                  "LEFT JOIN users u ON r.occupant_id = u.user_id " +
                                  "WHERE r.room_unit_id = (SELECT room_unit_id FROM rooms WHERE occupant_id = ?) " +
                                  "ORDER BY r.bed_number";
            
            PreparedStatement stmt2 = conn.prepareStatement(sqlRoommates);
            stmt2.setString(1, userId);
            ResultSet rsRoommates = stmt2.executeQuery();
            
            request.setAttribute("myRoommates", rsRoommates);
            
            request.getRequestDispatcher("my_reservations.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("dashboard.jsp");
        }
    }
}