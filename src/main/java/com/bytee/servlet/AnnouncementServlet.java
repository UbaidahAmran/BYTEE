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

@WebServlet("/AnnouncementServlet")
public class AnnouncementServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        
        // 1. Auth Check (Optional: You might want public announcements, but let's keep it safe)
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user_id") == null) {
            response.sendRedirect("Login.jsp");
            return;
        }

        try {
            Connection conn = DBConnection.getConnection();
            
            // 2. Query: Get latest news first
            String sql = "SELECT * FROM announcements ORDER BY date_posted DESC";
            
            PreparedStatement stmt = conn.prepareStatement(sql);
            ResultSet rs = stmt.executeQuery();
            
            request.setAttribute("newsList", rs);
            request.getRequestDispatcher("announcements.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("dashboard.jsp");
        }
    }
}