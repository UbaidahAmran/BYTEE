package com.bytee.controller;  

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

// We must import the DBConnection because it lives in a different package
import com.bytee.db.DBConnection;

@WebServlet("/Controller")
public class Controller extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        
        String page = request.getParameter("page");
        
        // If no "page" is specified (e.g. someone just types /Controller), send them to login
        if (page == null) {
            response.sendRedirect("Login.jsp");
            return;
        }

        // The Traffic Cop Logic
        switch (page) {
            case "login":
                handleLogin(request, response);
                break;
                
            case "logout":
                handleLogout(request, response);
                break;
                
            case "admin_home": 
                handleDashboard(request, response);
                break;
                
            case "student_home":
                handleStudentDashboard(request, response);
                break;
                
            case "forgot_password":
                response.sendRedirect("forgot_password.jsp");
                break;

            case "validate_reset":
                handleValidateReset(request, response);
                break;

            case "save_new_password":
                handleSaveNewPassword(request, response);
                break;
                
            default:
                response.sendRedirect("error.jsp"); // Fallback for bad URLs
                break;
        }
    }

    // ---------------------------------------------------------
    // ACTION 1: LOGGING IN
    // ---------------------------------------------------------
    private void handleLogin(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String matric = request.getParameter("matric_number");
        String pass = request.getParameter("password");
        
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            
            // 1. Fetch the 'role' column from the database
            // MAKE SURE your column name matches (e.g., 'role', 'user_role', 'type')
            String sql = "SELECT * FROM users WHERE matric_number = ? AND password = ?";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, matric);
            stmt.setString(2, pass);
            
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                HttpSession session = request.getSession();
                
                // 2. READ the role from the database instead of hardcoding "Student"
                // CHANGE "role" to whatever your column name is in MySQL
                String dbRole = rs.getString("role"); 
                
                session.setAttribute("user_role", dbRole);
                session.setAttribute("user_id", rs.getString("user_id"));
                session.setAttribute("user_name", rs.getString("full_name"));
                
                // 3. The Traffic Cop: Decide where to go based on Role
                if ("Admin".equalsIgnoreCase(dbRole)) {
                    // Go to Admin Dashboard
                    System.out.println("DEBUG: User is Admin. Going to Admin Dashboard.");
                    response.sendRedirect("Controller?page=admin_home"); 
                } else {
                    // Go to Student Dashboard
                    System.out.println("DEBUG: User is Student. Going to Student Home.");
                    response.sendRedirect("Controller?page=student_home"); 
                }

            } else {
            	response.sendRedirect("Login.jsp?msg=invalid");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("Login.jsp?error=DbError");
        } finally {
            try { if (conn != null) conn.close(); } catch (Exception e) {}
        }
    }

    // ---------------------------------------------------------
    // ACTION 2: LOGGING OUT
    // ---------------------------------------------------------
    private void handleLogout(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession(false);
        if (session != null) {
            session.invalidate(); // Kill the session
        }
        response.sendRedirect("Login.jsp?msg=LoggedOut");
    }

    // ---------------------------------------------------------
    // ACTION 3: LOADING ADMIN DASHBOARD (MAINTENANCE JOBS)
    // ---------------------------------------------------------
    private void handleDashboard(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Security: Admin Only
        HttpSession session = request.getSession(false);
        String role = (session != null) ? (String) session.getAttribute("user_role") : null;
        
        if (role == null || !role.equals("Admin")) {
            response.sendRedirect("Login.jsp");
            return;
        }

        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            
            // Fetch the list of maintenance jobs (Complaints)
            String sql = "SELECT c.complaint_id, c.category, c.description, c.status, c.date_filed, c.image_path, " +
                         "u.full_name, r.block, ru.room_number " +
                         "FROM complaints c " +
                         "JOIN users u ON c.user_id = u.user_id " +
                         "JOIN rooms r ON u.user_id = r.occupant_id " +
                         "JOIN room_units ru ON r.room_unit_id = ru.room_unit_id " +
                         "ORDER BY c.date_filed DESC";
            
            PreparedStatement stmt = conn.prepareStatement(sql);
            ResultSet rs = stmt.executeQuery();
            
            // Send the data to the View
            request.setAttribute("complaintList", rs);
            request.getRequestDispatcher("admin_dashboard.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("admin_dashboard.jsp?error=LoadFailed");
        } finally {
            // Note: In a forward(), we usually let the connection close automatically or handle it carefully.
            // For this simple example, we are relying on Java's garbage collection or a connection pool if we had one.
            // If we close 'conn' here, the 'rs' might die before the JSP reads it depending on the driver.
            // For now, we will leave it open for the JSP to read.
        }
    }
 // ==========================================
 // 4. STUDENT DASHBOARD LOADER
 // ==========================================
 private void handleStudentDashboard(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
     // 1. Security Check: Are they logged in?
     HttpSession session = request.getSession(false);
     if (session == null || session.getAttribute("user_id") == null) {
         response.sendRedirect("Login.jsp");
         return;
     }

     String userId = (String) session.getAttribute("user_id");
     Connection conn = null;
     
     try {
         conn = DBConnection.getConnection();
         
         // 2. Fetch Room Details for this Student
         // We join 'rooms' and 'room_units' (if you have that separation) or just query 'rooms'
         // Adjust these column names to match your database exactly!
         String sql = "SELECT * FROM rooms WHERE occupant_id = ?";
         
         PreparedStatement stmt = conn.prepareStatement(sql);
         stmt.setString(1, userId);
         ResultSet rs = stmt.executeQuery();

         if (rs.next()) {
             // CASE A: Student has a room
             request.setAttribute("room_status", "Assigned");
         } else {
             // CASE B: Student has NO room (New student)
             request.setAttribute("room_status", "None");
         }

         // 3. Forward to the Student View
         request.getRequestDispatcher("dashboard.jsp").forward(request, response);
         
     } catch (Exception e) {
         System.out.println("DEBUG: Student Dashboard Error");
         e.printStackTrace();
         response.sendRedirect("error.jsp");
     } finally {
         try { if (conn != null) conn.close(); } catch (Exception e) {}
     }
 }
 
//STEP 1: Check if User Exists
private void handleValidateReset(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
  String matric = request.getParameter("matric_number");
  String email = request.getParameter("email");
  
  Connection conn = null;
  try {
      conn = DBConnection.getConnection();
      // Check if Matric AND Email match the same user
      String sql = "SELECT * FROM users WHERE matric_number = ? AND email = ?";
      PreparedStatement stmt = conn.prepareStatement(sql);
      stmt.setString(1, matric);
      stmt.setString(2, email);
      
      if (stmt.executeQuery().next()) {
          // Success: User found. Save matric in session temporarily so we know who to update.
          request.getSession().setAttribute("reset_matric", matric);
          response.sendRedirect("reset_password.jsp");
      } else {
          // Failed: No match found
          response.sendRedirect("forgot_password.jsp?error=invalid");
      }
  } catch (Exception e) {
      e.printStackTrace();
  } finally {
      try { if(conn != null) conn.close(); } catch(Exception e) {}
  }
}

//STEP 2: Update the Password
private void handleSaveNewPassword(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
  String newPass = request.getParameter("new_password");
  String confirmPass = request.getParameter("confirm_password");
  
  // Get the matric number we saved in Step 1
  String matric = (String) request.getSession().getAttribute("reset_matric");
  
  if (matric == null) {
      response.sendRedirect("forgot_password.jsp"); // Security fallback
      return;
  }

  if (!newPass.equals(confirmPass)) {
      // Simple client-side check could prevent this, but good to have
      response.sendRedirect("reset_password.jsp?error=mismatch"); 
      return;
  }

  Connection conn = null;
  try {
      conn = DBConnection.getConnection();
      String sql = "UPDATE users SET password = ? WHERE matric_number = ?";
      PreparedStatement stmt = conn.prepareStatement(sql);
      stmt.setString(1, newPass);
      stmt.setString(2, matric);
      
      stmt.executeUpdate();
      
      // Clear the session variable and go to login
      request.getSession().removeAttribute("reset_matric");
      response.sendRedirect("Login.jsp?msg=PasswordResetSuccess");
      
  } catch (Exception e) {
      e.printStackTrace();
  } finally {
      try { if(conn != null) conn.close(); } catch(Exception e) {}
  }
}
}