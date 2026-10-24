<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.ResultSet" %>
<!DOCTYPE html>
<html>
<head>
    <title>College Details - BYTEE</title>
    <style>
        body { font-family: 'Segoe UI', sans-serif; background-color: #f8f9fa; padding: 40px; }
        .container { max-width: 900px; margin: 0 auto; background: white; padding: 0; border-radius: 10px; box-shadow: 0 5px 15px rgba(0,0,0,0.1); overflow: hidden; }
        
        /* Hero Image Area */
        .banner { width: 100%; height: 350px; object-fit: cover; }
        
        .content { padding: 40px; }
        h1 { margin-top: 0; color: #333; font-size: 2.5em; }
        
        .badge { background: #007bff; color: white; padding: 5px 10px; border-radius: 5px; font-size: 0.9em; vertical-align: middle; margin-left: 10px; }
        .meta { color: #666; margin-bottom: 20px; font-size: 1.1em; }
        
        .desc { line-height: 1.8; color: #444; font-size: 1.1em; margin-bottom: 30px; }
        
        /* Action Buttons */
        .actions { display: flex; gap: 15px; margin-top: 30px; }
        
        .btn { padding: 12px 25px; border-radius: 5px; text-decoration: none; font-weight: bold; display: inline-block; text-align: center; }
        .btn-360 { background-color: #17a2b8; color: white; }
        .btn-360:hover { background-color: #138496; }
        
        .btn-book { background-color: #28a745; color: white; }
        .btn-book:hover { background-color: #218838; }
        
        .btn-back { color: #666; padding: 12px 0; margin-right: 20px; }
    </style>
</head>
<body>

    <% 
        ResultSet rs = (ResultSet) request.getAttribute("collegeData");
        if (rs != null) {
            String img = rs.getString("main_image");
            if (img == null || !img.startsWith("images/")) img = "https://via.placeholder.com/900x350?text=No+Image";
    %>

    <div class="container">
        <img src="<%= img %>" class="banner" alt="College Banner">
        
        <div class="content">
            <% 
    // 1. Get the gender from database
    String gender = rs.getString("gender_restriction");
    
    // 2. Default color (Grey)
    String badgeColor = "#6c757d"; 
    
    // 3. Set specific colors
    if ("Male".equalsIgnoreCase(gender)) {
        badgeColor = "#007bff"; // Blue
    } else if ("Female".equalsIgnoreCase(gender)) {
        badgeColor = "#e83e8c"; // Pink
    }
%>

<h1>
    <%= rs.getString("name") %> 
    
    <span class="badge" style="background-color: <%= badgeColor %>; color: white;">
        <%= gender %> Only
    </span>
</h1>
            
            <p class="meta">📍 <%= rs.getString("location") %></p>
            
            <hr style="border: 0; border-top: 1px solid #eee; margin: 20px 0;">
            
            <div class="desc">
                <%= rs.getString("description") %>
            </div>

            <hr style="border: 0; border-top: 1px solid #eee; margin: 30px 0;">

            <div style="background: #f1f8ff; padding: 25px; border-radius: 8px; border-left: 5px solid #007bff; margin-top: 30px;">
                <h3 style="margin-top: 0; color: #007bff;">📍 Commute Calculator</h3>
                <p style="margin-bottom: 15px;">Select a faculty to see the distance from <strong><%= rs.getString("name") %></strong>.</p>
                
                <div style="display: flex; gap: 10px; flex-wrap: wrap;">
                    
                    <select id="destinationInput" style="flex: 2; padding: 10px; border: 1px solid #ccc; border-radius: 4px;">
                        <option value="">-- Select Your Destination --</option>
                        <option value="Faculty of Quranic and Sunnah Studies, USIM">Faculty of Quranic & Sunnah Studies (FPQS)</option>
                        <option value="Faculty of Science and Technology, USIM">Faculty of Science & Technology (FST)</option>
                        <option value="Faculty of Medicine and Health Sciences, USIM">Faculty of Medicine (FPSK)</option>
                        <option value="Faculty of Engineering and Built Environment, USIM">Faculty of Engineering (FKAB)</option>
                        <option value="Faculty of Major Language Studies, USIM">Faculty of Major Language Studies (FPBU)</option>
                        <option value="Faculty of Leadership and Management, USIM">Faculty of Leadership (FKP)</option>
                        <option value="Faculty of Syariah and Law, USIM">Faculty of Syariah & Law (FSU)</option>
                        <option value="Faculty of Economics and Muamalat, USIM">Faculty of Economics (FEM)</option>
                        <option value="USIM Library, Nilai">USIM Library</option>
                        <option value="Kompleks Sukan Tunku Najihah, USIM">USIM Sports Complex</option>
                    </select>
                    
                    <select id="travelMode" style="flex: 1; padding: 10px; border: 1px solid #ccc; border-radius: 4px;">
                        <option value="driving">🚗 Driving</option>
                        <option value="walking">🚶 Walking</option>
                        <option value="transit">🚌 Bus</option>
                    </select>
                    
                    <button onclick="checkDistance()" style="background: #007bff; color: white; border: none; padding: 10px 20px; border-radius: 4px; cursor: pointer; font-weight: bold;">
                        Go
                    </button>
                </div>
            </div>

            <div style="margin-top: 20px; border-radius: 8px; overflow: hidden; border: 1px solid #ddd;">
                <iframe 
                    width="100%" 
                    height="300" 
                    frameborder="0" 
                    style="border:0"
                    src="https://maps.google.com/maps?q=<%= rs.getString("lat_long") %>&z=15&output=embed">
                </iframe>
            </div>

           <script>
                function checkDistance() {
                    var origin = "<%= rs.getString("lat_long") %>"; 
                    var destination = document.getElementById("destinationInput").value;
                    var mode = document.getElementById("travelMode").value;
                    
                    if(destination === "") {
                        alert("Please select a faculty first.");
                        return;
                    }

                    // We don't need to append "USIM" here anymore because 
                    // we put it directly inside the <option value="..."> tags above.
                    
                    var url = "https://www.google.com/maps/dir/?api=1" + 
                              "&origin=" + encodeURIComponent(origin) + 
                              "&destination=" + encodeURIComponent(destination) + 
                              "&travelmode=" + mode;
                    
                    window.open(url, '_blank');
                }
            </script>
            
            <div class="actions">
                <a href="index.jsp" class="btn btn-back">← Back</a>
                
                <a href="<%= rs.getString("view_360_url") %>" target="_blank" class="btn btn-360">
                    🔄 Experience 360° Virtual Tour
                </a>
                
                <a href="BookingWizardServlet?step=2&college_id=<%= rs.getString("college_id") %>" class="btn btn-book">
    					📅 Book a Room Here
				</a>
            </div>
        </div>
    </div>

    <% } else { %>
        <p>College details not found.</p>
    <% } %>

</body>
</html>