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
import java.util.UUID;

import com.bytee.db.DBConnection;

@WebServlet("/ComplaintServlet")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2, // 2MB
    maxFileSize = 1024 * 1024 * 10,      // 10MB
    maxRequestSize = 1024 * 1024 * 50    // 50MB
)
public class ComplaintServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    // IMPORTANT: Make sure this folder exists on your C: drive!
    private static final String UPLOAD_DIR = "C:/bytee_uploads";

    // STEP 1: Show the form (Pre-fill Room Info)
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user_id") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String userId = (String) session.getAttribute("user_id");

        try {
            Connection conn = DBConnection.getConnection();
            
            // Find the user's room to auto-fill the form
            String sql = "SELECT r.room_id, ru.block, ru.level, ru.room_number " +
                         "FROM rooms r " +
                         "JOIN room_units ru ON r.room_unit_id = ru.room_unit_id " +
                         "WHERE r.occupant_id = ?";
            
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, userId);
            
            // This is a SELECT query, so executeQuery() is CORRECT here
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                request.setAttribute("room_id", rs.getString("room_id"));
                request.setAttribute("room_label", "Block " + rs.getString("block") + ", Unit " + rs.getString("room_number"));
                request.getRequestDispatcher("file_complaint.jsp").forward(request, response);
            } else {
                response.sendRedirect("dashboard.jsp?msg=NoRoomForComplaint");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("dashboard.jsp");
        }
    }

    // STEP 2: Save the Complaint (Handle Image Upload)
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        String userId = (String) session.getAttribute("user_id");
        
        // 1. Get Text Data
        String roomId = request.getParameter("room_id");
        String category = request.getParameter("category");
        String description = request.getParameter("description");
        
        // 2. Handle File Upload
        String imageFileName = null; 
        
        Part filePart = request.getPart("complaint_image");
        if (filePart != null && filePart.getSize() > 0) {
            String contentType = filePart.getContentType();
            
            // Security Check: Only allow Images
            if (contentType.equals("image/jpeg") || contentType.equals("image/png")) {
                String fileName = filePart.getSubmittedFileName();
                File uploadDir = new File(UPLOAD_DIR);
                if (!uploadDir.exists()) uploadDir.mkdir();
                
                // Rename file to prevent duplicates (timestamp + original name)
                imageFileName = System.currentTimeMillis() + "_" + fileName;
                String fullPath = UPLOAD_DIR + File.separator + imageFileName;
                filePart.write(fullPath);
            } else {
                // Reject invalid files
                response.sendRedirect("dashboard.jsp?msg=InvalidFileType");
                return;
            }
        }

        try {
            Connection conn = DBConnection.getConnection();
            
         // 3. Insert Data
         // 1. Generate the Short ID (8 chars)
            String rawId = UUID.randomUUID().toString();
            String newComplaintId = rawId.substring(0, 8).toUpperCase();

            // 2. Prepare the SQL (6 question marks)
            String sql = "INSERT INTO complaints (complaint_id, user_id, room_id, category, description, image_path) VALUES (?, ?, ?, ?, ?, ?)";
            
            PreparedStatement stmt = conn.prepareStatement(sql);
            
            // 3. Fill all 6 question marks
            stmt.setString(1, newComplaintId); // The new Short ID
            stmt.setString(2, userId);         // The logged-in student
            stmt.setString(3, roomId);         // The room ID
            stmt.setString(4, category);       // e.g., "Electrical"
            stmt.setString(5, description);    // e.g., "Fan broken"
            stmt.setString(6, imageFileName);  // The filename (or null)
            
            // 4. Save to Database
            stmt.executeUpdate();
            
            response.sendRedirect("dashboard.jsp?msg=ComplaintFiled");
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("dashboard.jsp?msg=Error");
        }
    }
}