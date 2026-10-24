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

@WebServlet("/PublicProfileServlet")
public class PublicProfileServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        
        // 1. Auth Check (Must be logged in to spy on others!)
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user_id") == null) {
            response.sendRedirect("Login.jsp");
            return;
        }

        String loggedInUser = (String) session.getAttribute("user_id");
        String targetUserId = request.getParameter("id");

        // Edge Case: If I click my own face, go to the Edit page instead
        if (targetUserId != null && targetUserId.equals(loggedInUser)) {
            response.sendRedirect("ProfileServlet");
            return;
        }

        try {
            Connection conn = DBConnection.getConnection();
            
            // 2. Fetch PUBLIC details only (No password, no email)
            String sql = "SELECT full_name, faculty, home_state, about_me, profile_image, gender, role " +
                         "FROM users WHERE user_id = ?";
            
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, targetUserId);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                request.setAttribute("publicProfile", rs);
                request.getRequestDispatcher("public_profile.jsp").forward(request, response);
            } else {
                response.sendRedirect("dashboard.jsp?error=UserNotFound");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("dashboard.jsp");
        }
    }
}