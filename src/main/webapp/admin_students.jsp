<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.ResultSet" %>
<!DOCTYPE html>
<html>
<head>
    <title>Student Directory - Admin</title>
    <link href="https://fonts.googleapis.com/css?family=Segoe+UI:400,600,700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    
    <style>
        body { font-family: 'Segoe UI', sans-serif; background-color: #f0f2f5; padding: 20px; }
        .container { max-width: 1200px; margin: 0 auto; }
        
        /* Header */
        .header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 25px; }
        .btn-back { text-decoration: none; color: #555; font-weight: 600; }
        .btn-back:hover { color: #007bff; }
        
        .btn-new { background: #28a745; color: white; text-decoration: none; padding: 10px 20px; border-radius: 8px; font-weight: bold; box-shadow: 0 4px 6px rgba(40,167,69,0.2); }
        .btn-new:hover { background: #218838; }

        /* Table */
        .card { background: white; border-radius: 12px; box-shadow: 0 4px 10px rgba(0,0,0,0.05); overflow: hidden; }
        table { width: 100%; border-collapse: collapse; }
        th { background: #f8f9fa; text-align: left; padding: 15px; color: #666; font-size: 0.85em; text-transform: uppercase; border-bottom: 2px solid #eee; }
        td { padding: 12px 15px; border-bottom: 1px solid #eee; vertical-align: middle; }
        
        .avatar { width: 40px; height: 40px; border-radius: 50%; object-fit: cover; vertical-align: middle; margin-right: 10px; border: 1px solid #eee; }
        
        /* Actions */
        .btn-edit { background: #e2e6ea; color: #333; padding: 6px 12px; border-radius: 6px; text-decoration: none; font-size: 0.85em; font-weight: 600; transition: 0.2s; }
        .btn-edit:hover { background: #dbe2e8; }
        
        .btn-del { border: none; background: transparent; color: #dc3545; cursor: pointer; font-size: 1.1em; padding: 5px; }
        .btn-del:hover { color: #bd2130; }
    </style>
</head>
<body>
    <div class="container">
        
        <div class="header">
            <div>
                <a href="AdminDashboardServlet" class="btn-back"><i class="fas fa-arrow-left"></i> Back to Control Center</a>
                <h1 style="margin: 10px 0 0 0;">Student Directory</h1>
            </div>
            <a href="admin_student_form.jsp" class="btn-new"><i class="fas fa-user-plus"></i> New Student</a>
        </div>

        <div class="card">
            <table>
                <thead>
                    <tr>
                        <th>Profile</th>
                        <th>Name & ID</th>
                        <th>Faculty</th>
                        <th>Email</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <% 
                        ResultSet rs = (ResultSet) request.getAttribute("studentList");
                        if (rs != null) {
                            while (rs.next()) {
                                String img = rs.getString("profile_image");
                                if (img == null || img.isEmpty()) img = "default_avatar.png";
                    %>
                    <tr>
                        <td>
                            <img src="ImageServlet?file=<%= img %>" class="avatar">
                        </td>
                        <td>
                            <strong><%= rs.getString("full_name") %></strong><br>
                            <span style="color:#777; font-size:0.9em;"><%= rs.getString("matric_number") %></span>
                        </td>
                        <td><%= rs.getString("faculty") %></td>
                        <td><%= rs.getString("email") %></td>
                        <td>
                            <a href="AdminStudentServlet?edit_id=<%= rs.getString("user_id") %>" class="btn-edit"><i class="fas fa-pen"></i> Edit</a>
                            
                            <form action="AdminActionServlet" method="post" style="display:inline;">
                                <input type="hidden" name="action" value="delete_student">
                                <input type="hidden" name="user_id" value="<%= rs.getString("user_id") %>">
                                <button type="submit" class="btn-del" onclick="return confirm('Delete student? This removes their booking!');">
                                    <i class="fas fa-trash-alt"></i>
                                </button>
                            </form>
                        </td>
                    </tr>
                    <% }} else { %>
                        <tr><td colspan="5" style="padding:30px; text-align:center;">No students found.</td></tr>
                    <% } %>
                </tbody>
            </table>
        </div>
    </div>
</body>
</html>