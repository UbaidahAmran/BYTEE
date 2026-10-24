<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.ResultSet" %>
<!DOCTYPE html>
<html>
<head>
    <title>My Profile - BYTEE</title>
    <style>
        body { font-family: 'Segoe UI', sans-serif; background: #f4f6f8; padding: 20px; }
        .container { max-width: 1000px; margin: 0 auto; display: flex; gap: 20px; flex-wrap: wrap; }
        
        /* Left Column: Preview Card */
        .profile-card { flex: 1; background: white; padding: 30px; border-radius: 10px; box-shadow: 0 4px 6px rgba(0,0,0,0.1); text-align: center; height: fit-content; }
        .avatar { width: 150px; height: 150px; border-radius: 50%; object-fit: cover; border: 5px solid #007bff; margin-bottom: 15px; }
        .role-badge { background: #28a745; color: white; padding: 5px 10px; border-radius: 15px; font-size: 0.8em; }
        
        /* Right Column: Edit Form */
        .edit-form { flex: 2; background: white; padding: 30px; border-radius: 10px; box-shadow: 0 4px 6px rgba(0,0,0,0.1); }
        
        /* Form Elements */
        label { display: block; margin-top: 15px; font-weight: bold; color: #555; }
        input, select, textarea { width: 100%; padding: 10px; margin-top: 5px; border: 1px solid #ddd; border-radius: 5px; box-sizing: border-box; }
        .readonly { background: #e9ecef; color: #6c757d; cursor: not-allowed; }
        
        .btn-save { background: #007bff; color: white; padding: 12px 20px; border: none; border-radius: 5px; font-size: 1em; cursor: pointer; margin-top: 20px; width: 100%; }
        .btn-save:hover { background: #0056b3; }
        
        .nav-link { text-decoration: none; color: #555; display: inline-block; margin-bottom: 20px; }
    </style>
</head>
<body>

    <div style="max-width: 1000px; margin: 0 auto;">
        <a href="dashboard.jsp" class="nav-link">← Back to Dashboard</a>
    </div>

    <% 
        ResultSet rs = (ResultSet) request.getAttribute("userData");
        if (rs != null) {
            String img = rs.getString("profile_image");
            if (img == null || img.isEmpty()) img = "default_avatar.png";
    %>

    <div class="container">
        
        <div class="profile-card">
            <img src="ImageServlet?file=<%= img %>" class="avatar" alt="Profile Pic">
            <h2><%= rs.getString("full_name") %></h2>
            <span class="role-badge">Student</span>
            <p style="color: #777; margin-top: 15px;"><%= rs.getString("faculty") %></p>
            <p style="color: #777; margin-top: 15px;"><%= rs.getString("home_state") %></p>
            <hr>
            <p style="text-align: left; color: #555; font-style: italic;">
                "<%= rs.getString("about_me") %>"
            </p>
        </div>

        <div class="edit-form">
            <h2 style="margin-top: 0;">Edit Profile</h2>
            
            <form action="ProfileServlet" method="post" enctype="multipart/form-data">
                
                <div style="display: flex; gap: 15px;">
                    <div style="flex: 1;">
                        <label>Matric Number (Locked)</label>
                        <input type="text" value="<%= rs.getString("matric_number") %>" class="readonly" readonly>
                    </div>
                    <div style="flex: 1;">
                        <label>Email (Locked)</label>
                        <input type="text" value="<%= rs.getString("email") %>" class="readonly" readonly>
                    </div>
                </div>

                <label>Full Name</label>
                <input type="text" name="full_name" value="<%= rs.getString("full_name") %>" required>

                <label>Faculty</label>
                <select name="faculty">
                    <option value="<%= rs.getString("faculty") %>" selected>Current: <%= rs.getString("faculty") %></option>
                    <option value="Faculty of Science and Technology (FST)">Faculty of Science & Technology (FST)</option>
                    <option value="Faculty of Medicine (FPSK)">Faculty of Medicine (FPSK)</option>
                    <option value="Faculty of Engineering (FKAB)">Faculty of Engineering (FKAB)</option>
                    <option value="Faculty of Major Language Studies (FPBU)">Faculty of Major Language Studies (FPBU)</option>
                    </select>

                <label>Home State</label>
                <select name="home_state">
                    <option value="<%= rs.getString("home_state") %>" selected>Current: <%= rs.getString("home_state") %></option>
                    <option value="Johor">Johor</option>
                    <option value="Selangor">Selangor</option>
                    <option value="Kelantan">Kelantan</option>
                    <option value="Sabah">Sabah</option>
                    <option value="Sarawak">Sarawak</option>
                    <option value="KL/Putrajaya">KL/Putrajaya</option>
                    </select>

                <label>About Me</label>
                <textarea name="about_me" rows="4"><%= rs.getString("about_me") %></textarea>

                <label>Change Profile Picture</label>
                <input type="file" name="profile_image" accept=".jpg, .jpeg, .png">

                <button type="submit" class="btn-save">Save Changes</button>
            </form>
        </div>

    </div>

    <% } else { %>
        <p>Error loading profile.</p>
    <% } %>

</body>
</html>