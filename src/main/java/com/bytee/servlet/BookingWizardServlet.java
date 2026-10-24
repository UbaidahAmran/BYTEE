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

@WebServlet("/BookingWizardServlet")
public class BookingWizardServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user_id") == null) {
            response.sendRedirect("Login.jsp");
            return;
        }

        String userId = (String) session.getAttribute("user_id");
        String action = request.getParameter("step"); 

        try {
            Connection conn = DBConnection.getConnection();

            // --- SECURITY CHECK: DOES USER ALREADY HAVE A ROOM? ---
            // If they do, they are NOT allowed to browse for new ones.
            String checkSql = "SELECT reservation_id FROM reservations WHERE user_id = ? AND status = 'Confirmed'";
            PreparedStatement checkStmt = conn.prepareStatement(checkSql);
            checkStmt.setString(1, userId);
            ResultSet checkRs = checkStmt.executeQuery();
            
            if (checkRs.next()) {
                // User is already booked! Redirect to their room details.
                response.sendRedirect("MyReservationsServlet?msg=AlreadyBooked");
                return; // STOP EXECUTION HERE
            }

            // --- STEP 1: SELECT COLLEGE ---
            if (action == null || action.equals("1")) {
                
                String genderSQL = "SELECT gender FROM users WHERE user_id = ?";
                PreparedStatement stmtG = conn.prepareStatement(genderSQL);
                stmtG.setString(1, userId);
                ResultSet rsG = stmtG.executeQuery();
                String userGender = rsG.next() ? rsG.getString("gender") : "";

                String sql = "SELECT * FROM colleges WHERE gender_restriction = ? OR gender_restriction = 'Mixed'";
                PreparedStatement stmt = conn.prepareStatement(sql);
                stmt.setString(1, userGender);
                
                request.setAttribute("collegeList", stmt.executeQuery());
                request.getRequestDispatcher("booking_step1_college.jsp").forward(request, response);
            
            } 
            // --- STEP 2: SELECT BLOCK ---
            else if (action.equals("2")) {
                
                String collegeId = request.getParameter("college_id");
                
                String sql = "SELECT DISTINCT block FROM room_units WHERE college_id = ? ORDER BY block";
                PreparedStatement stmt = conn.prepareStatement(sql);
                stmt.setString(1, collegeId);
                
                request.setAttribute("blockList", stmt.executeQuery());
                request.setAttribute("collegeId", collegeId); 
                
                PreparedStatement stmtName = conn.prepareStatement("SELECT name FROM colleges WHERE college_id = ?");
                stmtName.setString(1, collegeId);
                ResultSet rsName = stmtName.executeQuery();
                if(rsName.next()) request.setAttribute("collegeName", rsName.getString("name"));
                
                request.getRequestDispatcher("booking_step2_block.jsp").forward(request, response);

            }
            // --- STEP 3: SELECT BED ---
            else if (action.equals("3")) {
                
                String collegeId = request.getParameter("college_id");
                String block = request.getParameter("block");
                
                String sqlRooms = "SELECT ru.room_unit_id, ru.block, ru.level, ru.room_number AS unit_number, " +
                                  "r.room_id, r.bed_number, r.status, r.occupant_id " +
                                  "FROM room_units ru " +
                                  "JOIN rooms r ON ru.room_unit_id = r.room_unit_id " +
                                  "WHERE ru.college_id = ? AND ru.block = ? " +
                                  "ORDER BY ru.level, ru.room_number, r.bed_number";
                
                PreparedStatement stmtR = conn.prepareStatement(sqlRooms);
                stmtR.setString(1, collegeId);
                stmtR.setString(2, block);
                
                request.setAttribute("roomList", stmtR.executeQuery());
                request.setAttribute("collegeId", collegeId); 
                request.setAttribute("currentBlock", block);
                
                request.getRequestDispatcher("booking_step3_beds.jsp").forward(request, response);
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("dashboard.jsp?error=DbError");
        }
    }
}