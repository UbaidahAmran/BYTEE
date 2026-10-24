package com.bytee.servlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.UUID;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.bytee.db.DBConnection;

@WebServlet("/AdminActionServlet")
public class AdminActionServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        
        // 1. Security Check: Admin Only
        HttpSession session = request.getSession(false);
        String role = (session != null) ? (String) session.getAttribute("user_role") : null;
        
        if (role == null || !role.equalsIgnoreCase("Admin")) {
            response.sendRedirect("Login.jsp");
            return;
        }

        String action = request.getParameter("action");
        Connection conn = null;

        try {
            conn = DBConnection.getConnection();
            
            // ============================================================
            // MODULE 1: COMPLAINTS
            // ============================================================
            if ("resolve_complaint".equals(action)) {
                String compId = request.getParameter("complaint_id");
                PreparedStatement stmt = conn.prepareStatement("UPDATE complaints SET status='Resolved' WHERE complaint_id=?");
                stmt.setString(1, compId);
                stmt.executeUpdate();
                response.sendRedirect("AdminDashboardServlet?msg=ComplaintResolved");
            }
            
            // ============================================================
            // MODULE 2: RESERVATIONS
            // ============================================================
            else if ("cancel_res".equals(action)) {
                String resId = request.getParameter("reservation_id");
                String roomId = request.getParameter("room_id");
                
                conn.setAutoCommit(false); // Start Transaction
                
                // A. Delete Reservation
                PreparedStatement stmt1 = conn.prepareStatement("DELETE FROM reservations WHERE reservation_id = ?");
                stmt1.setString(1, resId);
                stmt1.executeUpdate();
                
                // B. Free up the Room
                PreparedStatement stmt2 = conn.prepareStatement("UPDATE rooms SET status = 'Available', occupant_id = NULL WHERE room_id = ?");
                stmt2.setString(1, roomId);
                stmt2.executeUpdate();
                
                conn.commit(); // Commit
                response.sendRedirect("AdminReservationServlet?msg=Cancelled");
            }
            
            // ============================================================
            // MODULE 3: ROOM MANAGEMENT
            // ============================================================
         // ... inside doPost method ...

            else if ("add_room".equals(action)) {
                System.out.println("--- DEBUG: STARTING ADD ROOM ---");

                String collegeId = request.getParameter("college_id");
                String block = request.getParameter("block").toUpperCase();
                String level = request.getParameter("level");
                String unit = request.getParameter("unit");
                String bed = request.getParameter("bed");
                
                // PRINT THE DATA RECEIVED (Check console to see if College ID matches DB exactly)
                System.out.println("DEBUG DATA -> College: '" + collegeId + "' | Block: " + block + " | Unit: " + unit);

                try {
                    // A. Check if Unit exists, or Create it
                    String unitId = null;
                    PreparedStatement checkUnit = conn.prepareStatement("SELECT room_unit_id FROM room_units WHERE college_id=? AND block=? AND room_number=?");
                    checkUnit.setString(1, collegeId);
                    checkUnit.setString(2, block);
                    checkUnit.setString(3, unit);
                    ResultSet rsUnit = checkUnit.executeQuery();
                    
                    if (rsUnit.next()) {
                        unitId = rsUnit.getString("room_unit_id");
                        System.out.println("DEBUG: Found existing Unit ID: " + unitId);
                    } else {
                        System.out.println("DEBUG: Unit not found. Creating new Unit...");
                        unitId = UUID.randomUUID().toString();
                        PreparedStatement createUnit = conn.prepareStatement("INSERT INTO room_units (room_unit_id, college_id, block, level, room_number) VALUES (?, ?, ?, ?, ?)");
                        createUnit.setString(1, unitId);
                        createUnit.setString(2, collegeId); 
                        createUnit.setString(3, block);
                        createUnit.setString(4, level);
                        createUnit.setString(5, unit);
                        createUnit.executeUpdate();
                        System.out.println("DEBUG: New Unit Created Successfully.");
                    }
                    
                    // B. Create the Bed (Room)
                    System.out.println("DEBUG: Creating Bed/Room...");
                    String newRoomId = UUID.randomUUID().toString();
                    PreparedStatement createRoom = conn.prepareStatement("INSERT INTO rooms (room_id, room_unit_id, bed_number, status) VALUES (?, ?, ?, 'Available')");
                    createRoom.setString(1, newRoomId);
                    createRoom.setString(2, unitId);
                    createRoom.setString(3, bed);
                    createRoom.executeUpdate();
                    
                    System.out.println("--- DEBUG: SUCCESS! ROOM ADDED ---");
                    response.sendRedirect("AdminRoomServlet?msg=RoomCreated");

                } catch (Exception e) {
                    System.out.println("--- DEBUG: FAILED TO ADD ROOM ---");
                    e.printStackTrace(); // This prints the red error text
                    throw e; // Re-throw so the main catch block handles the redirect
                }
            }

            else if ("toggle_maintenance".equals(action)) {
                String roomId = request.getParameter("room_id");
                
                // Check current status first
                PreparedStatement check = conn.prepareStatement("SELECT status FROM rooms WHERE room_id = ?");
                check.setString(1, roomId);
                ResultSet rs = check.executeQuery();
                
                if (rs.next()) {
                    String current = rs.getString("status");
                    String newStatus = "Available".equals(current) ? "Maintenance" : "Available";
                    
                    PreparedStatement update = conn.prepareStatement("UPDATE rooms SET status = ? WHERE room_id = ?");
                    update.setString(1, newStatus);
                    update.setString(2, roomId);
                    update.executeUpdate();
                }
                response.sendRedirect("AdminRoomServlet?msg=StatusUpdated");
            }

            else if ("delete_room".equals(action)) {
                String roomId = request.getParameter("room_id");
                // Only delete if NOT occupied
                PreparedStatement stmt = conn.prepareStatement("DELETE FROM rooms WHERE room_id = ? AND status != 'Occupied'");
                stmt.setString(1, roomId);
                int rows = stmt.executeUpdate();
                
                if (rows > 0) {
                    response.sendRedirect("AdminRoomServlet?msg=Deleted");
                } else {
                    response.sendRedirect("AdminRoomServlet?error=CannotDeleteOccupiedRoom");
                }
            }

            else if ("manual_book".equals(action)) {
                String matric = request.getParameter("matric_number");
                String roomId = request.getParameter("room_id");
                
                PreparedStatement findUser = conn.prepareStatement("SELECT user_id FROM users WHERE matric_number = ?");
                findUser.setString(1, matric);
                ResultSet rs = findUser.executeQuery();
                
                if (rs.next()) {
                    String userId = rs.getString("user_id");
                    
                    conn.setAutoCommit(false); 
                    
                    PreparedStatement book = conn.prepareStatement("INSERT INTO reservations (user_id, room_id, status) VALUES (?, ?, 'Confirmed')");
                    book.setString(1, userId);
                    book.setString(2, roomId);
                    book.executeUpdate();
                    
                    PreparedStatement updateRoom = conn.prepareStatement("UPDATE rooms SET status = 'Occupied', occupant_id = ? WHERE room_id = ?");
                    updateRoom.setString(1, userId);
                    updateRoom.setString(2, roomId);
                    updateRoom.executeUpdate();
                    
                    conn.commit(); 
                    response.sendRedirect("AdminRoomServlet?msg=Assigned");
                } else {
                    response.sendRedirect("AdminRoomServlet?error=StudentNotFound");
                }
            }
            
            // ============================================================
            // MODULE 4: STUDENT MANAGEMENT (NEW)
            // ============================================================
            else if ("add_student".equals(action)) {
                String newId = UUID.randomUUID().toString();
                String name = request.getParameter("full_name");
                String matric = request.getParameter("matric_number");
                String email = request.getParameter("email");
                String pass = request.getParameter("password");
                String gender = request.getParameter("gender");
                String faculty = request.getParameter("faculty");
                
                String sql = "INSERT INTO users (user_id, full_name, matric_number, email, password, gender, faculty, role) VALUES (?, ?, ?, ?, ?, ?, ?, 'Student')";
                PreparedStatement stmt = conn.prepareStatement(sql);
                stmt.setString(1, newId);
                stmt.setString(2, name);
                stmt.setString(3, matric);
                stmt.setString(4, email);
                stmt.setString(5, pass);
                stmt.setString(6, gender);
                stmt.setString(7, faculty);
                stmt.executeUpdate();
                
                response.sendRedirect("AdminStudentServlet?msg=StudentCreated");
            }
            
            else if ("update_student".equals(action)) {
                String userId = request.getParameter("user_id");
                String name = request.getParameter("full_name");
                String matric = request.getParameter("matric_number");
                String email = request.getParameter("email");
                String pass = request.getParameter("password");
                String gender = request.getParameter("gender");
                String faculty = request.getParameter("faculty");
                
                String sql = "UPDATE users SET full_name=?, matric_number=?, email=?, password=?, gender=?, faculty=? WHERE user_id=?";
                PreparedStatement stmt = conn.prepareStatement(sql);
                stmt.setString(1, name);
                stmt.setString(2, matric);
                stmt.setString(3, email);
                stmt.setString(4, pass);
                stmt.setString(5, gender);
                stmt.setString(6, faculty);
                stmt.setString(7, userId);
                stmt.executeUpdate();
                
                response.sendRedirect("AdminStudentServlet?msg=StudentUpdated");
            }
            
            else if ("delete_student".equals(action)) {
                String userId = request.getParameter("user_id");
                
                conn.setAutoCommit(false);
                
                // 1. Delete Reservations
                PreparedStatement delRes = conn.prepareStatement("DELETE FROM reservations WHERE user_id=?");
                delRes.setString(1, userId);
                delRes.executeUpdate();
                
                // 2. Clear Rooms (Set them to Available)
                PreparedStatement clearRoom = conn.prepareStatement("UPDATE rooms SET status='Available', occupant_id=NULL WHERE occupant_id=?");
                clearRoom.setString(1, userId);
                clearRoom.executeUpdate();
                
                // 3. Delete Complaints
                PreparedStatement delComp = conn.prepareStatement("DELETE FROM complaints WHERE user_id=?");
                delComp.setString(1, userId);
                delComp.executeUpdate();

                // 4. Delete User
                PreparedStatement delUser = conn.prepareStatement("DELETE FROM users WHERE user_id=?");
                delUser.setString(1, userId);
                delUser.executeUpdate();
                
                conn.commit();
                response.sendRedirect("AdminStudentServlet?msg=StudentDeleted");
            }

            // ============================================================
            // MODULE 5: ANNOUNCEMENTS
            // ============================================================
            else if ("add_announcement".equals(action)) {
                String title = request.getParameter("title");
                String message = request.getParameter("message");
                
                String sql = "INSERT INTO announcements (title, message) VALUES (?, ?)";
                PreparedStatement stmt = conn.prepareStatement(sql);
                stmt.setString(1, title);
                stmt.setString(2, message);
                stmt.executeUpdate();
                
                response.sendRedirect("AdminAnnouncementServlet?msg=Posted");
            }
            
            else if ("update_announcement".equals(action)) {
                String id = request.getParameter("announcement_id");
                String title = request.getParameter("title");
                String message = request.getParameter("message");
                
                String sql = "UPDATE announcements SET title=?, message=? WHERE announcement_id=?";
                PreparedStatement stmt = conn.prepareStatement(sql);
                stmt.setString(1, title);
                stmt.setString(2, message);
                stmt.setString(3, id);
                stmt.executeUpdate();
                
                response.sendRedirect("AdminAnnouncementServlet?msg=Updated");
            }
            
            else if ("delete_announcement".equals(action)) {
                String id = request.getParameter("announcement_id");
                
                PreparedStatement stmt = conn.prepareStatement("DELETE FROM announcements WHERE announcement_id=?");
                stmt.setString(1, id);
                stmt.executeUpdate();
                
                response.sendRedirect("AdminAnnouncementServlet?msg=Deleted");
            }

        } catch (Exception e) {
            // Safety Net: Rollback transaction if anything crashed
            try { if (conn != null) conn.rollback(); } catch (Exception ex) {}
            
            e.printStackTrace();
            response.sendRedirect("AdminDashboardServlet?error=ActionFailed");
        } finally {
            try { if (conn != null) conn.close(); } catch (Exception ex) {}
        }
    }
}