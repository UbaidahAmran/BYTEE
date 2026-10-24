<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.ResultSet" %>
<!DOCTYPE html>
<html>
<head>
    <title>Manage Reservations - Admin</title>
    <link href="https://fonts.googleapis.com/css?family=Segoe+UI:400,600,700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    
    <style>
        body { font-family: 'Segoe UI', sans-serif; background-color: #f0f2f5; padding: 20px; }
        .container { max-width: 1100px; margin: 0 auto; }
        
        /* Header & Nav */
        .header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 25px; }
        .btn-back { text-decoration: none; color: #555; font-weight: 600; display: flex; align-items: center; gap: 8px; transition: 0.2s; }
        .btn-back:hover { color: #007bff; }
        .page-title { font-size: 1.8em; color: #333; margin: 0; }
        
        /* Card & Table */
        .card { background: white; border-radius: 12px; box-shadow: 0 4px 10px rgba(0,0,0,0.05); overflow: hidden; }
        
        table { width: 100%; border-collapse: collapse; }
        th { background: #f8f9fa; text-align: left; padding: 15px; color: #666; font-size: 0.85em; text-transform: uppercase; border-bottom: 2px solid #eee; }
        td { padding: 15px; border-bottom: 1px solid #eee; color: #444; vertical-align: middle; }
        tr:last-child td { border-bottom: none; }
        tr:hover { background-color: #fafafa; }
        
        /* Status Badges */
        .badge { padding: 5px 10px; border-radius: 15px; font-size: 0.8em; font-weight: 600; }
        .b-Confirmed { background: #d4edda; color: #155724; }
        
        /* Action Button */
        .btn-cancel { 
            background: #fff; color: #dc3545; border: 1px solid #dc3545; padding: 6px 12px; 
            border-radius: 6px; cursor: pointer; font-size: 0.85em; font-weight: 600; transition: 0.2s;
        }
        .btn-cancel:hover { background: #dc3545; color: white; }
    </style>
</head>
<body>

    <div class="container">
        <div class="header">
            <div>
                <a href="AdminDashboardServlet" class="btn-back"><i class="fas fa-arrow-left"></i> Back to Control Center</a>
                <h1 class="page-title" style="margin-top: 10px;">Reservation Management</h1>
            </div>
        </div>

        <div class="card">
            <table>
                <thead>
                    <tr>
                        <th>Booking Date</th>
                        <th>Student Info</th>
                        <th>Assigned Room</th>
                        <th>Status</th>
                        <th>Action</th>
                    </tr>
                </thead>
                <tbody>
                    <% 
                        ResultSet rs = (ResultSet) request.getAttribute("resList");
                        if (rs != null) {
                            while (rs.next()) {
                    %>
                    <tr>
                        <td>
                            <i class="far fa-calendar-alt" style="color:#888;"></i> 
                            <%= rs.getTimestamp("booking_date").toString().substring(0, 16) %>
                        </td>
                        <td>
                            <strong><%= rs.getString("full_name") %></strong><br>
                            <span style="font-size: 0.9em; color: #777;"><%= rs.getString("matric_number") %></span>
                        </td>
                        <td>
                            <span style="color:#007bff; font-weight:500;"><%= rs.getString("college_name") %></span><br>
                            <span style="font-size: 0.9em;">Block <%= rs.getString("block") %>, Unit <%= rs.getString("room_number") %> (Bed <%= rs.getString("bed_number") %>)</span>
                        </td>
                        <td><span class="badge b-<%= rs.getString("status") %>"><%= rs.getString("status") %></span></td>
                        <td>
                            <form action="AdminActionServlet" method="post" onsubmit="return confirm('⚠️ FORCE CANCEL: This will delete the booking and free up the bed. Proceed?');">
                                <input type="hidden" name="action" value="cancel_res">
                                <input type="hidden" name="room_id" value="<%= rs.getString("room_id") %>">
                                <input type="hidden" name="reservation_id" value="<%= rs.getString("reservation_id") %>">
                                <button type="submit" class="btn-cancel"><i class="fas fa-ban"></i> Force Cancel</button>
                            </form>
                        </td>
                    </tr>
                    <% 
                            }
                        } 
                    %>
                </tbody>
            </table>
        </div>
    </div>
</body>
</html>