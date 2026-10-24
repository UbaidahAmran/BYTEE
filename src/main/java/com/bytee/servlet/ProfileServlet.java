package com.bytee.servlet;

import java.io.File;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part;

import com.bytee.db.DBConnection;

@WebServlet("/ProfileServlet")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2,
    maxFileSize = 1024 * 1024 * 5, 
    maxRequestSize = 1024 * 1024 * 10
)
public class ProfileServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final String UPLOAD_DIR = "C:/bytee_uploads";

    // 1. VIEW PROFILE (Fetch Data)
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user_id") == null) {
            response.sendRedirect("Login.jsp");
            return;
        }

        String userId = (String) session.getAttribute("user_id");

        try {
            Connection conn = DBConnection.getConnection();
            String sql = "SELECT * FROM users WHERE user_id = ?";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, userId);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                request.setAttribute("userData", rs);
                request.getRequestDispatcher("profile.jsp").forward(request, response);
            } else {
                response.sendRedirect("Login.jsp");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("dashboard.jsp");
        }
    }

    // 2. UPDATE PROFILE (Save Data)
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        String userId = (String) session.getAttribute("user_id");

        // Get Text Data
        String fullName = request.getParameter("full_name");
        String faculty = request.getParameter("faculty");
        String state = request.getParameter("home_state");
        String aboutMe = request.getParameter("about_me");
        
        // Handle File Upload
        Part filePart = request.getPart("profile_image");
        String newFileName = null;

        if (filePart != null && filePart.getSize() > 0) {
            String fileName = filePart.getSubmittedFileName();
            File uploadDir = new File(UPLOAD_DIR);
            if (!uploadDir.exists()) uploadDir.mkdir();
            
            // Rename to prevent caching issues: "userid_timestamp_name.jpg"
            newFileName = userId + "_" + System.currentTimeMillis() + "_" + fileName;
            filePart.write(UPLOAD_DIR + File.separator + newFileName);
        }

        try {
            Connection conn = DBConnection.getConnection();
            
            // Logic: Did they upload a new picture?
            String sql;
            PreparedStatement stmt;

            if (newFileName != null) {
                // Update EVERYTHING including image
                sql = "UPDATE users SET full_name=?, faculty=?, home_state=?, about_me=?, profile_image=? WHERE user_id=?";
                stmt = conn.prepareStatement(sql);
                stmt.setString(1, fullName);
                stmt.setString(2, faculty);
                stmt.setString(3, state);
                stmt.setString(4, aboutMe);
                stmt.setString(5, newFileName);
                stmt.setString(6, userId);
            } else {
                // Update TEXT ONLY (Keep old image)
                sql = "UPDATE users SET full_name=?, faculty=?, home_state=?, about_me=? WHERE user_id=?";
                stmt = conn.prepareStatement(sql);
                stmt.setString(1, fullName);
                stmt.setString(2, faculty);
                stmt.setString(3, state);
                stmt.setString(4, aboutMe);
                stmt.setString(5, userId);
            }

            stmt.executeUpdate();

            // Update Session Name (in case they changed it)
            session.setAttribute("user_name", fullName);

            // Reload page to see changes
            response.sendRedirect("ProfileServlet?msg=Updated");

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("ProfileServlet?error=UpdateFailed");
        }
    }
}