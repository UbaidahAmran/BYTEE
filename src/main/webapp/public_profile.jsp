<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.ResultSet" %>
<!DOCTYPE html>
<html>
<head>
    <title>Student Profile - BYTEE</title>
    <style>
        body { font-family: 'Segoe UI', sans-serif; background: #f4f6f8; display: flex; justify-content: center; align-items: center; min-height: 100vh; margin: 0; }
        
        .profile-card {
            background: white;
            width: 100%;
            max-width: 400px;
            padding: 40px;
            border-radius: 15px;
            box-shadow: 0 10px 25px rgba(0,0,0,0.1);
            text-align: center;
            position: relative;
        }
        
        .avatar {
            width: 150px; height: 150px;
            border-radius: 50%;
            object-fit: cover;
            border: 5px solid white;
            box-shadow: 0 4px 10px rgba(0,0,0,0.1);
            margin-top: -80px; /* Pop out effect */
            background: #fff;
        }
        
        .top-banner {
            position: absolute; top: 0; left: 0; right: 0; height: 100px;
            background: linear-gradient(135deg, #007bff, #00d2ff);
            border-radius: 15px 15px 0 0;
            z-index: 0;
        }
        
        .content { position: relative; z-index: 1; margin-top: 60px; }
        
        h1 { margin: 10px 0 5px 0; color: #333; font-size: 1.8em; }
        .faculty { color: #007bff; font-weight: bold; font-size: 0.9em; margin-bottom: 20px; display: block; }
        
        .info-grid {
            display: grid; grid-template-columns: 1fr 1fr; gap: 15px;
            text-align: left; background: #f8f9fa; padding: 15px; border-radius: 10px; margin-bottom: 20px;
        }
        .info-item span { display: block; font-size: 0.8em; color: #888; text-transform: uppercase; }
        .info-item strong { display: block; font-size: 1em; color: #333; }
        
        .bio-box {
            text-align: left;
            font-style: italic;
            color: #555;
            line-height: 1.5;
            margin-bottom: 25px;
        }
        
        .btn-back {
            text-decoration: none; background: #6c757d; color: white; padding: 10px 20px; border-radius: 20px; transition: 0.3s;
        }
        .btn-back:hover { background: #5a6268; }
    </style>
</head>
<body>

    <div class="profile-card">
        <div class="top-banner"></div>
        
        <% 
            ResultSet rs = (ResultSet) request.getAttribute("publicProfile");
            if (rs != null) {
                String img = rs.getString("profile_image");
                if (img == null || img.isEmpty()) img = "default_avatar.png";
        %>

        <div class="content">
            <img src="ImageServlet?file=<%= img %>" class="avatar" alt="User Photo">
            
            <h1><%= rs.getString("full_name") %></h1>
            <span class="faculty"><%= rs.getString("faculty") %></span>
            
            <div class="info-grid">
                <div class="info-item">
                    <span>Home State</span>
                    <strong><%= rs.getString("home_state") %></strong>
                </div>
                <div class="info-item">
                    <span>Gender</span>
                    <strong><%= rs.getString("gender") %></strong>
                </div>
            </div>
            
            <div class="bio-box">
                "<%= rs.getString("about_me") %>"
            </div>
            
            <a href="javascript:history.back()" class="btn-back">← Go Back</a>
        </div>
        
        <% } else { %>
            <p>User profile not found.</p>
        <% } %>
    </div>

</body>
</html>