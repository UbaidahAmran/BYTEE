<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.ResultSet" %>
<!DOCTYPE html>
<html>
<head>
    <title>My Roommates - BYTEE</title>
    <style>
        body { font-family: 'Segoe UI', sans-serif; background-color: #f4f6f8; padding: 20px; }
        .container { max-width: 900px; margin: 0 auto; }
        
        /* Header */
        .header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 30px; }
        .back-link { text-decoration: none; color: #555; font-weight: 500; }
        .back-link:hover { color: #007bff; }
        
        /* Grid Layout */
        .grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(280px, 1fr)); gap: 20px; }
        
        /* Base Card Style */
        .mate-card {
            background: white; padding: 25px; border-radius: 12px;
            box-shadow: 0 4px 10px rgba(0,0,0,0.05);
            text-align: center; position: relative;
            transition: transform 0.2s;
            border-top: 5px solid #ccc; /* Default color */
        }
        .mate-card:hover { transform: translateY(-3px); }
        
        /* Avatar */
        .avatar {
            width: 80px; height: 80px; border-radius: 50%; object-fit: cover;
            margin-bottom: 15px; border: 3px solid #f4f6f8;
        }
        
        /* Typography */
        h3 { margin: 0; color: #333; font-size: 1.2em; }
        p { margin: 5px 0; color: #666; font-size: 0.9em; }
        .bed-label { background: #eee; padding: 3px 8px; border-radius: 4px; font-size: 0.8em; color: #555; display: inline-block; margin-bottom: 10px; }
        
        /* VARIANT: ME (Green) */
        .is-me { border-top-color: #28a745; background: #f0fff4; }
        .is-me .avatar { border-color: #28a745; }
        
        /* VARIANT: ROOMMATE (Blue) */
        .is-mate { border-top-color: #007bff; }
        
        /* VARIANT: EMPTY (Grey Dashed) */
        .is-empty { border: 2px dashed #ddd; background: transparent; box-shadow: none; opacity: 0.7; }
        .is-empty:hover { border-color: #bbb; opacity: 1; }
        
        /* Button */
        .btn-profile {
            display: inline-block; margin-top: 15px;
            text-decoration: none; background: #007bff; color: white;
            padding: 8px 16px; border-radius: 20px; font-size: 0.85em;
            transition: background 0.2s;
        }
        .btn-profile:hover { background: #0056b3; }

    </style>
</head>
<body>

<div class="container">
    <div class="header">
        <h1>My Apartment Mates</h1>
        <a href="dashboard.jsp" class="back-link">← Back to Dashboard</a>
    </div>

    <div class="grid">
        <% 
            ResultSet rs = (ResultSet) request.getAttribute("roommateList");
            
            // Get current user's name to identify "Me"
            // (Ideally, check by ID, but name works for display logic)
            String myName = (String) session.getAttribute("user_name"); 
            String myId = (String) session.getAttribute("user_id"); 

            if (rs != null) {
                while (rs.next()) {
                    String name = rs.getString("full_name");
                    String bed = rs.getString("bed_number");
                    String occupantId = rs.getString("user_id"); // Make sure RoommateServlet selects this!
                    
                    // Logic to determine card type
                    boolean isOccupied = (name != null);
                    boolean isMe = isOccupied && occupantId.equals(myId);
                    
                    String cardClass = "mate-card";
                    if (isMe) cardClass += " is-me";
                    else if (isOccupied) cardClass += " is-mate";
                    else cardClass += " is-empty";
        %>

        <div class="<%= cardClass %>">
            <span class="bed-label"><%= bed %></span>
            
            <% if (isOccupied) { 
       // 1. Get the real image filename from the database
       String img = rs.getString("profile_image");
       
       // 2. Safety Check: If they have no photo, use the default
       if (img == null || img.isEmpty()) {
           img = "default_avatar.png";
       }
%>
                <br>
                <img src="ImageServlet?file=<%= img %>" class="avatar" alt="Avatar">
                
                <h3>
                    <%= name %> 
                    <% if (isMe) { %> <span style="font-size:0.6em; color:#28a745;">(You)</span> <% } %>
                </h3>
                
                <% if (!isMe) { %>
                    <a href="PublicProfileServlet?id=<%= occupantId %>" class="btn-profile">View Profile</a>
                <% } else { %>
                    <p style="margin-top:15px; font-style:italic;">This is your bed.</p>
                <% } %>
                
            <% } else { %>
                <br>
                <div style="height: 80px; width: 80px; background: #eee; border-radius: 50%; margin: 0 auto 15px auto; display: flex; align-items: center; justify-content: center; color: #aaa; font-size: 2em;">?</div>
                <h3 style="color: #999;">Empty</h3>
                <p>No one lives here yet.</p>
            <% } %>
        </div>

        <% 
                }
            } else {
        %>
            <p>No roommate data found.</p>
        <% } %>
    </div>
</div>

</body>
</html>