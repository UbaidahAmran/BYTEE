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

@WebServlet("/AdminAnnouncementServlet")
public class AdminAnnouncementServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        
        // 1. Auth Check
        HttpSession session = request.getSession(false);
        String role = (session != null) ? (String) session.getAttribute("user_role") : null;
        if (!"Admin".equalsIgnoreCase(role)) { response.sendRedirect("Login.jsp"); return; }

        String editId = request.getParameter("edit_id");
        Connection conn = null;

        try {
            conn = DBConnection.getConnection();
            
            // 2. IF EDITING: Fetch specific announcement details
            if (editId != null) {
                PreparedStatement stmt = conn.prepareStatement("SELECT * FROM announcements WHERE announcement_id = ?");
                stmt.setString(1, editId);
                ResultSet rsEdit = stmt.executeQuery();
                if(rsEdit.next()) {
                    request.setAttribute("editNews", rsEdit); // Send single item to form
                }
            }

            // 3. ALWAYS: Fetch list of all announcements
            String sql = "SELECT * FROM announcements ORDER BY date_posted DESC";
            ResultSet rsList = conn.prepareStatement(sql).executeQuery();
            request.setAttribute("newsList", rsList); // Send list to table
            
            request.getRequestDispatcher("admin_announcements.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("admin_dashboard.jsp?error=DbError");
        }
    }
}