<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.ResultSet" %>
<!DOCTYPE html>
<html>
<head>
    <title>My Room & Roommates - BYTEE</title>
    <style>
        body { font-family: 'Segoe UI', sans-serif; background-color: #f4f6f8; padding: 20px; }
        .container { max-width: 900px; margin: 0 auto; }
        
        .header-link { display: inline-block; margin-bottom: 20px; color: #555; text-decoration: none; }
        
        /* --- SECTION 1: BOOKING CARD --- */
        .booking-card { 
            background: white; padding: 30px; border-radius: 12px; 
            box-shadow: 0 4px 10px rgba(0,0,0,0.05); margin-bottom: 40px; 
            border-left: 6px solid #28a745; 
        }
        .booking-header { display: flex; justify-content: space-between; align-items: start; }
        .college-name { font-size: 1.5em; color: #333; margin: 0; }
        .status-badge { background: #e6ffed; color: #28a745; padding: 5px 12px; border-radius: 20px; font-weight: bold; font-size: 0.9em; border: 1px solid #28a745; }
        
        .details-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 20px; margin-top: 20px; }
        .detail-item strong { display: block; color: #777; font-size: 0.9em; margin-bottom: 4px; }
        .detail-item span { font-size: 1.1em; color: #333; font-weight: 500; }
        
        .btn-cancel { 
            background: #fff; color: #dc3545; border: 1px solid #dc3545; 
            padding: 8px 15px; border-radius: 5px; cursor: pointer; font-size: 0.9em; transition: 0.3s;
        }
        .btn-cancel:hover { background: #dc3545; color: white; }

        /* --- SECTION 2: ROOMMATES GRID --- */
        .section-title { font-size: 1.3em; margin-bottom: 20px; color: #333; border-bottom: 2px solid #ddd; padding-bottom: 10px; display: inline-block; }
        
        .mates-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(200px, 1fr)); gap: 20px; }
        
        .mate-card {
            background: white; padding: 20px; border-radius: 10px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.05); text-align: center;
            border-top: 4px solid #ccc;
        }
        
        .avatar { width: 70px; height: 70px; border-radius: 50%; object-fit: cover; margin-bottom: 10px; border: 2px solid #f4f6f8; }
        .mate-name { font-weight: bold; color: #333; margin: 0; font-size: 1em; }
        .bed-tag { background: #eee; font-size: 0.8em; padding: 2px 8px; border-radius: 4px; color: #666; margin-bottom: 10px; display: inline-block; }
        
        .is-me { border-top-color: #28a745; background: #f9fff9; }
        .is-mate { border-top-color: #007bff; }
        .is-empty { border: 2px dashed #ddd; border-top: 2px dashed #ddd; opacity: 0.6; box-shadow: none; background: transparent; }
        
        .btn-view { display: inline-block; margin-top: 10px; font-size: 0.85em; color: #007bff; text-decoration: none; border: 1px solid #007bff; padding: 4px 10px; border-radius: 15px; }
        .btn-view:hover { background: #007bff; color: white; }

    </style>
</head>
<body>

    <div class="container">
        <a href="dashboard.jsp" class="header-link">← Back to Dashboard</a>

        <% 
            ResultSet rs = (ResultSet) request.getAttribute("myBookings");
            boolean hasBooking = false;
            
            if (rs != null && rs.next()) {
                hasBooking = true;
        %>
        
        <div class="booking-card">
            <div class="booking-header">
                <div>
                    <h2 class="college-name"><%= rs.getString("college_name") %></h2>
                    <div style="margin-top: 5px;">
                        Booked on: <%= rs.getTimestamp("booking_date") %>
                    </div>
                </div>
                <span class="status-badge">Confirmed</span>
            </div>
            
            <div class="details-grid">
                <div class="detail-item">
                    <strong>Unit Location</strong>
                    <span>Block <%= rs.getString("block") %>, Level <%= rs.getString("level") %> (Unit <%= rs.getString("room_number") %>)</span>
                </div>
                <div class="detail-item">
                    <strong>My Bed</strong>
                    <span><%= rs.getString("bed_number") %></span>
                </div>
            </div>
            
            <hr style="border: 0; border-top: 1px solid #eee; margin: 20px 0;">
            
            <form action="CancelReservationServlet" method="post" onsubmit="return confirm('Are you sure you want to cancel? This will release your room immediately.');">
                <input type="hidden" name="room_id" value="<%= rs.getString("room_id") %>">
                <button type="submit" class="btn-cancel">Cancel Reservation</button>
            </form>
        </div>

        <h3 class="section-title">My Housemates</h3>
        <div class="mates-grid">
            <% 
                ResultSet rsMates = (ResultSet) request.getAttribute("myRoommates");
                String myId = (String) session.getAttribute("user_id");

                if (rsMates != null) {
                    while (rsMates.next()) {
                        String name = rsMates.getString("full_name");
                        String occupantId = rsMates.getString("user_id");
                        String bed = rsMates.getString("bed_number");
                        
                        boolean isOccupied = (name != null);
                        boolean isMe = isOccupied && occupantId.equals(myId);
                        
                        String cardClass = "mate-card";
                        if (isMe) cardClass += " is-me";
                        else if (isOccupied) cardClass += " is-mate";
                        else cardClass += " is-empty";
            %>
            
            <div class="<%= cardClass %>">
                <span class="bed-tag"><%= bed %></span><br>
                
                <% if (isOccupied) { 
                       String img = rsMates.getString("profile_image");
                       if (img == null || img.isEmpty()) img = "default_avatar.png";
                %>
                    <img src="ImageServlet?file=<%= img %>" class="avatar">
                    <p class="mate-name">
                        <%= name %> 
                        <% if (isMe) { %><span style="color:#28a745">(You)</span><% } %>
                    </p>
                    
                    <% if (!isMe) { %>
                        <a href="PublicProfileServlet?id=<%= occupantId %>" class="btn-view">View Profile</a>
                    <% } %>
                    
                <% } else { %>
                    <div style="height: 70px; width: 70px; background: #eee; border-radius: 50%; margin: 0 auto 10px auto; display: flex; align-items: center; justify-content: center; color: #aaa;">?</div>
                    <p class="mate-name" style="color: #999;">Empty</p>
                <% } %>
            </div>
            
            <% 
                    }
                } 
            %>
        </div>

        <% } else { %>
            <div style="text-align: center; padding: 50px;">
                <h2>No active reservation found.</h2>
                <a href="BookingWizardServlet?step=1" style="background: #007bff; color: white; padding: 10px 20px; text-decoration: none; border-radius: 5px;">Book a Room Now</a>
            </div>
        <% } %>

    </div>

</body>
</html>