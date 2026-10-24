<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.ResultSet" %>
<!DOCTYPE html>
<html>
<head>
    <title>Select College - BYTEE</title>
    <style>
        body { font-family: 'Segoe UI', sans-serif; background: #f4f6f8; padding: 20px; }
        .container { max-width: 800px; margin: 0 auto; }
        .card { background: white; border-radius: 8px; box-shadow: 0 2px 5px rgba(0,0,0,0.1); margin-bottom: 20px; display: flex; overflow: hidden; }
        .card img { width: 200px; object-fit: cover; }
        .card-body { padding: 20px; flex: 1; }
        .btn-select { background: #007bff; color: white; padding: 10px 20px; text-decoration: none; border-radius: 5px; display: inline-block; margin-top: 10px; }
    </style>
</head>
<body>
    <div class="container">
        <h1>Step 1: Choose a Residence</h1>
        <p>Based on your gender, here are the colleges available to you:</p>

        <% 
            ResultSet rs = (ResultSet) request.getAttribute("collegeList");
            while (rs.next()) {
                String img = rs.getString("main_image");
                if (img == null || !img.startsWith("images/")) img = "https://via.placeholder.com/200";
        %>
        <div class="card">
            <img src="<%= img %>">
            <div class="card-body">
                <h2><%= rs.getString("name") %></h2>
                <p>Location: <%= rs.getString("location") %></p>
                <a href="BookingWizardServlet?step=2&college_id=<%= rs.getString("college_id") %>" class="btn-select">
                    Select This College &rarr;
                </a>
            </div>
        </div>
        <% } %>
        
        <a href="dashboard.jsp">Cancel</a>
    </div>
</body>
</html>