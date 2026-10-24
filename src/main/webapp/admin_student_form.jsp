<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.ResultSet" %>
<!DOCTYPE html>
<html>
<head>
    <title>Student Form - Admin</title>
    <style>
        body { font-family: 'Segoe UI', sans-serif; padding: 40px; background: #f4f6f8; }
        .form-container { background: white; max-width: 600px; margin: 0 auto; padding: 30px; border-radius: 8px; box-shadow: 0 4px 10px rgba(0,0,0,0.1); }
        input, select { width: 100%; padding: 10px; margin: 8px 0; border: 1px solid #ddd; border-radius: 4px; box-sizing: border-box; }
        .btn-save { background: #007bff; color: white; width: 100%; padding: 12px; border: none; border-radius: 4px; font-size: 1.1em; cursor: pointer; margin-top: 20px; }
        .btn-cancel { display: block; text-align: center; margin-top: 15px; color: #555; text-decoration: none; }
    </style>
</head>
<body>

    <%
        // Check if we are in EDIT mode (data exists) or ADD mode (null)
        ResultSet rs = (ResultSet) request.getAttribute("editStudent");
        boolean isEdit = (rs != null);
        
        String userId = isEdit ? rs.getString("user_id") : "";
        String name = isEdit ? rs.getString("full_name") : "";
        String matric = isEdit ? rs.getString("matric_number") : "";
        String email = isEdit ? rs.getString("email") : "";
        String password = isEdit ? rs.getString("password") : ""; // Be careful showing passwords
        String faculty = isEdit ? rs.getString("faculty") : "";
        String gender = isEdit ? rs.getString("gender") : "";
    %>

    <div class="form-container">
        <h2><%= isEdit ? "Edit Student" : "Add New Student" %></h2>
        
        <form action="AdminActionServlet" method="post">
            <input type="hidden" name="action" value="<%= isEdit ? "update_student" : "add_student" %>">
            <input type="hidden" name="user_id" value="<%= userId %>">
            
            <label>Full Name</label>
            <input type="text" name="full_name" value="<%= name %>" required>

            <label>Matric Number</label>
            <input type="text" name="matric_number" value="<%= matric %>" required>

            <label>Email</label>
            <input type="email" name="email" value="<%= email %>" required>

            <label>Password</label>
            <input type="text" name="password" value="<%= password %>" required>

            <label>Gender</label>
            <select name="gender">
                <option value="Male" <%= "Male".equals(gender) ? "selected" : "" %>>Male</option>
                <option value="Female" <%= "Female".equals(gender) ? "selected" : "" %>>Female</option>
            </select>

            <label>Faculty</label>
            <select name="faculty">
                <option value="">-- Select --</option>
                <option value="Faculty of Science and Technology (FST)" <%= faculty.contains("FST") ? "selected" : "" %>>FST</option>
                <option value="Faculty of Medicine (FPSK)" <%= faculty.contains("FPSK") ? "selected" : "" %>>FPSK</option>
                <option value="Faculty of Engineering (FKAB)" <%= faculty.contains("FKAB") ? "selected" : "" %>>FKAB</option>
                <option value="Faculty of Major Language Studies (FPBU)" <%= faculty.contains("FPBU") ? "selected" : "" %>>FPBU</option>
                <option value="Faculty of Leadership (FKP)" <%= faculty.contains("FKP") ? "selected" : "" %>>FKP</option>
                <option value="Faculty of Syariah and Law (FSU)" <%= faculty.contains("FSU") ? "selected" : "" %>>FSU</option>
                <option value="Faculty of Economics (FEM)" <%= faculty.contains("FEM") ? "selected" : "" %>>FEM</option>
            </select>
            
            <button type="submit" class="btn-save"><%= isEdit ? "Update Student" : "Create Student" %></button>
        </form>
        
        <a href="AdminStudentServlet" class="btn-cancel">Cancel</a>
    </div>

</body>
</html>