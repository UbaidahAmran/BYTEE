<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.ResultSet" %>
<!DOCTYPE html>
<html>
<head>
    <title>Select Bed - BYTEE</title>
    <style>
        body { font-family: 'Segoe UI', sans-serif; background: #f4f6f8; padding: 20px; }
        .container { max-width: 900px; margin: 0 auto; }
        
        /* Unit Card */
        .unit-card { background: white; padding: 20px; border-radius: 8px; margin-bottom: 20px; border-left: 5px solid #6c757d; }
        .unit-header { font-size: 1.2em; font-weight: bold; margin-bottom: 15px; color: #333; }
        
        /* Grid */
        .bed-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(150px, 1fr)); gap: 15px; }
        
        /* Bed Button Base */
        .bed-btn { 
            padding: 15px; text-align: center; border: 1px solid #ddd; border-radius: 5px; transition: 0.2s; 
            background: #fff; display: block; width: 100%; box-sizing: border-box; text-decoration: none;
        }
        
        /* AVAILABLE */
        .available { border-color: #28a745; color: #28a745; background: #f0fff4; cursor: pointer; }
        .available:hover { background: #28a745; color: white; }
        
        /* OCCUPIED (Updated: No more deny cursor!) */
        .occupied { 
            border-color: #007bff; /* Blue border to invite clicking */
            color: #555; 
            background: #f8f9fa; 
            cursor: pointer; /* THE FIX: Makes it look clickable */
            position: relative;
        }
        .occupied:hover { 
            background: #e2e6ea; 
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
        }
        
        /* --- MODAL (POPUP) STYLES --- */
        .modal-overlay {
            display: none; /* Hidden by default */
            position: fixed; top: 0; left: 0; width: 100%; height: 100%;
            background: rgba(0,0,0,0.5); /* Dim background */
            z-index: 1000;
            justify-content: center; align-items: center;
        }
        
        .modal-content {
            background: white;
            width: 90%; max-width: 500px; height: 80%;
            border-radius: 10px;
            position: relative;
            overflow: hidden;
            box-shadow: 0 5px 15px rgba(0,0,0,0.3);
            display: flex; flex-direction: column;
        }
        
        .close-btn {
            position: absolute; top: 10px; right: 15px;
            font-size: 24px; font-weight: bold; color: #333; cursor: pointer; z-index: 10;
        }
        
        iframe { width: 100%; height: 100%; border: none; }
    </style>
</head>
<body>
    <div class="container">
        <a href="BookingWizardServlet?step=2&college_id=<%= request.getAttribute("collegeId") %>">← Back to Blocks</a>
        <h1>Select Your Room (Block <%= request.getAttribute("currentBlock") %>)</h1>

        <% 
            ResultSet rs = (ResultSet) request.getAttribute("roomList");
            String currentUnitId = "";
            boolean firstLoop = true;
            
            while (rs.next()) {
                String rowUnitId = rs.getString("room_unit_id");
                
                if (!rowUnitId.equals(currentUnitId)) {
                    if (!firstLoop) { %> </div></div> <% } 
                    currentUnitId = rowUnitId;
                    firstLoop = false;
        %>
            <div class="unit-card">
                <div class="unit-header">
                    Block <%= rs.getString("block") %> - Level <%= rs.getString("level") %> 
                    (Unit <%= rs.getString("unit_number") %>)
                </div>
                <div class="bed-grid">
        <%      } 
                
                String status = rs.getString("status");
                String bedNum = rs.getString("bed_number");
                String roomId = rs.getString("room_id");
                String occupantId = rs.getString("occupant_id");
        %>
            
            <% if ("Available".equalsIgnoreCase(status)) { %>
                <form action="BookingConfirmServlet" method="post">
                    <input type="hidden" name="room_id" value="<%= roomId %>">
                    <button type="submit" class="bed-btn available">
                        <strong><%= bedNum %></strong><br>
                        Available
                    </button>
                </form>
            <% } else { %>
                <div onclick="openProfile('<%= occupantId %>')" class="bed-btn occupied">
                    <strong><%= bedNum %></strong><br>
                    Occupied<br>
                    <small style="color: #007bff;">(See Profile)</small>
                </div>
            <% } %>

        <% 
            } 
            if (!firstLoop) { %> </div></div> <% } 
        %>
    </div>

    <div id="profileModal" class="modal-overlay" onclick="closeModal()">
        <div class="modal-content" onclick="event.stopPropagation()">
            <span class="close-btn" onclick="closeModal()">&times;</span>
            <iframe id="profileFrame" src=""></iframe>
        </div>
    </div>

    <script>
        function openProfile(userId) {
            if(!userId || userId === 'null') {
                alert("No profile information available.");
                return;
            }
            // 1. Point the iframe to the servlet
            document.getElementById("profileFrame").src = "PublicProfileServlet?id=" + userId;
            
            // 2. Show the modal
            document.getElementById("profileModal").style.display = "flex";
        }

        function closeModal() {
            // 1. Hide modal
            document.getElementById("profileModal").style.display = "none";
            
            // 2. Clear iframe so it stops loading/playing
            document.getElementById("profileFrame").src = "";
        }
    </script>
</body>
</html>