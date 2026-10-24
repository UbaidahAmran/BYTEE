package com.bytee.servlet;

import java.io.File;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.util.UUID;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;

import com.bytee.db.DBConnection;

@WebServlet("/RegisterServlet")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2, // 2MB
    maxFileSize = 1024 * 1024 * 5,       // 5MB
    maxRequestSize = 1024 * 1024 * 50
)
public class RegisterServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    // Use the same folder as complaints for simplicity
    private static final String UPLOAD_DIR = "C:/bytee_uploads";

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        
        try {
            // 1. Get Text Data
            String fullName = request.getParameter("full_name");
            String email = request.getParameter("email");
            String password = request.getParameter("password");
            String matric = request.getParameter("matric_number");
            String faculty = request.getParameter("faculty");
            String gender = request.getParameter("gender");
            String state = request.getParameter("home_state");
            String aboutMe = request.getParameter("about_me");
            
            // 2. Handle Profile Image
            String imageFileName = "default_avatar.png"; // Fallback
            Part filePart = request.getPart("profile_image");
            
            if (filePart != null && filePart.getSize() > 0) {
                String fileName = filePart.getSubmittedFileName();
                File uploadDir = new File(UPLOAD_DIR);
                if (!uploadDir.exists()) uploadDir.mkdir();
                
                // Name format: "matric_profile.jpg" to keep it organized
                imageFileName = matric + "_profile_" + fileName;
                String fullPath = UPLOAD_DIR + File.separator + imageFileName;
                filePart.write(fullPath);
            }

            // 3. Generate User ID (UUID)
            String newUserId = UUID.randomUUID().toString();

            // 4. Save to Database
            Connection conn = DBConnection.getConnection();
         // Updated SQL
            String sql = "INSERT INTO users (user_id, email, password, full_name, role, gender, matric_number, home_state, about_me, profile_image, faculty) " +
                         "VALUES (?, ?, ?, ?, 'Student', ?, ?, ?, ?, ?, ?)";
            
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, newUserId);
            stmt.setString(2, email);
            stmt.setString(3, password);
            stmt.setString(4, fullName);
            stmt.setString(5, gender);
            stmt.setString(6, matric);
            stmt.setString(7, state);
            stmt.setString(8, aboutMe);
            stmt.setString(9, imageFileName);
            stmt.setString(10, faculty);
            
            stmt.executeUpdate();
            
            // 5. Success! Send to Login
            response.sendRedirect("Login.jsp?msg=Registered");

        } catch (Exception e) {
            e.printStackTrace();
            // Likely error: Duplicate Email or Matric Number
            response.sendRedirect("register.jsp?error=DuplicateOrError");
        }
    }
}