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

@WebServlet("/AdminStudentServlet")
public class AdminStudentServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        
        // 1. Auth Check
        HttpSession session = request.getSession(false);
        String role = (session != null) ? (String) session.getAttribute("user_role") : null;
        if (!"Admin".equalsIgnoreCase(role)) { response.sendRedirect("Login.jsp"); return; }

        // 2. Edit Mode Check: If URL has '?edit_id=123', fetch that single user for editing
        String editId = request.getParameter("edit_id");
        if (editId != null) {
            loadStudentForEditing(editId, request, response);
            return;
        }

        // 3. Normal Mode: List ALL Students
        try {
            Connection conn = DBConnection.getConnection();
            
            // Get all students (Role != Admin)
            String sql = "SELECT * FROM users WHERE role = 'Student' ORDER BY full_name";
            PreparedStatement stmt = conn.prepareStatement(sql);
            ResultSet rs = stmt.executeQuery();
            
            request.setAttribute("studentList", rs);
            request.getRequestDispatcher("admin_students.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("admin_dashboard.jsp?error=DbError");
        }
    }

    // Helper method to load one student's data into the form
    private void loadStudentForEditing(String userId, HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            Connection conn = DBConnection.getConnection();
            PreparedStatement stmt = conn.prepareStatement("SELECT * FROM users WHERE user_id = ?");
            stmt.setString(1, userId);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                request.setAttribute("editStudent", rs);
                request.getRequestDispatcher("admin_student_form.jsp").forward(request, response);
            } else {
                response.sendRedirect("AdminStudentServlet?error=NotFound");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("AdminStudentServlet");
        }
    }
}