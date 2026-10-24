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

import com.bytee.db.DBConnection;

@WebServlet("/PublicCollegeServlet")
public class PublicCollegeServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        
        // NO LOGIN CHECK HERE! This is for the public.
        
        try {
            Connection conn = DBConnection.getConnection();
            
            // 1. Get Colleges
            String sqlColleges = "SELECT * FROM colleges";
            PreparedStatement stmt1 = conn.prepareStatement(sqlColleges);
            ResultSet rsColleges = stmt1.executeQuery();
            
            // 2. Get Public Announcements (Limit to top 3)
            String sqlNews = "SELECT * FROM announcements ORDER BY date_posted DESC LIMIT 3";
            PreparedStatement stmt2 = conn.prepareStatement(sqlNews);
            ResultSet rsNews = stmt2.executeQuery();
            
            // Send both to the JSP
            request.setAttribute("collegeList", rsColleges);
            request.setAttribute("newsList", rsNews);
            
            request.getRequestDispatcher("home.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}