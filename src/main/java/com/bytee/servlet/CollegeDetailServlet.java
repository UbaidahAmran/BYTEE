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

@WebServlet("/CollegeDetailServlet")
public class CollegeDetailServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        
        // 1. Get the College ID from the URL link
        String id = request.getParameter("id");
        
        if (id == null) {
            response.sendRedirect("index.jsp");
            return;
        }

        try {
            Connection conn = DBConnection.getConnection();
            
            // 2. Query for THIS specific college
            String sql = "SELECT * FROM colleges WHERE college_id = ?";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, id);
            
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                // 3. Send data to the Detail Page
                request.setAttribute("collegeData", rs);
                request.getRequestDispatcher("college_details.jsp").forward(request, response);
            } else {
                response.sendRedirect("index.jsp"); // ID invalid
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("index.jsp");
        }
    }
}