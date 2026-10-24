<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.ResultSet" %>
<!DOCTYPE html>
<html>
<head>
    <title>Campus Announcements</title>
    <style>
        body { font-family: 'Segoe UI', sans-serif; background-color: #f4f6f8; padding: 20px; }
        .container { max-width: 700px; margin: 0 auto; }
        .back-btn { display: inline-block; margin-bottom: 20px; text-decoration: none; color: #555; }
        
        /* News Card Design */
        .news-card {
            background: white;
            padding: 25px;
            margin-bottom: 20px;
            border-radius: 8px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.08);
            border-left: 5px solid #dc3545; /* Red accent for urgency */
        }
        
        .news-title { margin: 0 0 10px 0; color: #222; font-size: 1.2em; }
        .news-date { color: #888; font-size: 0.85em; margin-bottom: 15px; display: block; }
        .news-body { line-height: 1.6; color: #444; }
    </style>
</head>
<body>

<div class="container">
    <a href="dashboard.jsp" class="back-btn">← Back to Dashboard</a>
    <h1>📢 Campus News</h1>

    <% 
        ResultSet rs = (ResultSet) request.getAttribute("newsList");
        boolean hasNews = false;

        if (rs != null) {
            while (rs.next()) {
                hasNews = true;
    %>
    
    <div class="news-card">
        <h3 class="news-title"><%= rs.getString("title") %></h3>
        <span class="news-date">Posted on: <%= rs.getTimestamp("date_posted") %></span>
        <div class="news-body">
            <%= rs.getString("message") %>
        </div>
    </div>

    <% 
            }
        }
        
        if (!hasNews) {
    %>
        <p style="text-align: center; color: #777;">No announcements yet.</p>
    <% } %>

</div>

</body>
</html>