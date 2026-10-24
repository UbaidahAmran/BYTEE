<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.net.URLEncoder" %> <!DOCTYPE html>
<html>
<head>
    <title>Select Block - BYTEE</title>
    <style>
        body { font-family: 'Segoe UI', sans-serif; background: #f4f6f8; padding: 20px; }
        .container { max-width: 800px; margin: 0 auto; text-align: center; }
        
        .grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(150px, 1fr)); gap: 20px; margin-top: 30px; }
        
        .block-card { 
            background: white; padding: 40px 20px; border-radius: 10px; 
            box-shadow: 0 4px 6px rgba(0,0,0,0.1); text-decoration: none; color: #333; 
            border: 2px solid transparent; transition: 0.2s;
        }
        .block-card:hover { border-color: #007bff; transform: translateY(-5px); }
        .block-card h2 { margin: 0; font-size: 2em; color: #007bff; }
        .block-card span { color: #777; }
        
        .error-msg { color: red; background: #fff; padding: 20px; border-radius: 5px; }
    </style>
</head>
<body>
    <div class="container">
        <a href="BookingWizardServlet?step=1" style="float: left; text-decoration: none; color: #555;">← Back to Colleges</a>
        <br><br>
        
        <h1>Step 2: Select Block</h1>
        
        <% 
            String cName = (String) request.getAttribute("collegeName");
            if (cName == null) cName = "Selected College";
        %>
        <p>Choosing a room in: <strong><%= cName %></strong></p>
        
        <div class="grid">
            <% 
                ResultSet rs = (ResultSet) request.getAttribute("blockList");
                String collegeId = (String) request.getAttribute("collegeId");
                boolean hasBlock = false;
                
                if (rs != null) {
                    while (rs.next()) {
                        hasBlock = true;
                        String blockName = rs.getString("block");
                        
                        // SAFE ENCODING: Handles spaces (e.g., "Block A" -> "Block+A")
                        String encodedBlock = "";
                        try {
                             encodedBlock = URLEncoder.encode(blockName, "UTF-8");
                        } catch (Exception e) {
                             encodedBlock = blockName; // Fallback
                        }
            %>
            <a href="BookingWizardServlet?step=3&college_id=<%= collegeId %>&block=<%= encodedBlock %>" class="block-card">
                <h2><%= blockName %></h2>
                <span>View Rooms</span>
            </a>
            <% 
                    }
                } 
            %>
            
            <% if (!hasBlock) { %>
                <div class="error-msg" style="grid-column: 1 / -1;">
                    <h3>No Blocks Found</h3>
                    <p>We couldn't find any room units for this college in the database.</p>
                    <p><em>(Check if 'room_units' table has data linked to College ID: <%= collegeId %>)</em></p>
                </div>
            <% } %>
        </div>
    </div>
</body>
</html>