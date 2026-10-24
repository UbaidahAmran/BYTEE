<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.ResultSet" %>
<!DOCTYPE html>
<html>
<head>
    <title>Admin Control Center - BYTEE</title>
    <link href="https://fonts.googleapis.com/css?family=Segoe+UI:400,600,700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    
    <style>
        body { margin: 0; font-family: 'Segoe UI', sans-serif; background-color: #f0f2f5; }
        
        /* --- NAVIGATION BAR --- */
        .navbar {
            background-color: white; padding: 15px 30px;
            display: flex; justify-content: space-between; align-items: center;
            box-shadow: 0 2px 10px rgba(0,0,0,0.05); position: sticky; top: 0; z-index: 100;
        }
        .logo { font-size: 1.5em; font-weight: bold; color: #343a40; text-decoration: none; }
        .nav-right { display: flex; align-items: center; gap: 20px; }
        .admin-badge { background: #343a40; color: white; padding: 5px 12px; border-radius: 20px; font-size: 0.85em; font-weight: 600; }
        .btn-logout { 
            color: #dc3545; text-decoration: none; font-weight: 500; border: 1px solid #dc3545; 
            padding: 6px 15px; border-radius: 20px; transition: 0.3s; 
        }
        .btn-logout:hover { background-color: #dc3545; color: white; }

        /* --- LAYOUT --- */
        .container { max-width: 1200px; margin: 40px auto; padding: 0 20px; }
        
        /* --- HERO BANNER --- */
        .hero {
            background: linear-gradient(135deg, #2c3e50, #4ca1af); /* Professional Blue-Grey */
            color: white; padding: 40px; border-radius: 12px; margin-bottom: 40px;
            box-shadow: 0 10px 20px rgba(44, 62, 80, 0.3);
        }
        .hero h1 { margin: 0; font-size: 2.2em; }
        .hero p { margin: 10px 0 0 0; opacity: 0.9; font-size: 1.1em; }

        /* --- QUICK ACTION CARDS (GRID) --- */
        .grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(250px, 1fr)); gap: 25px; margin-bottom: 40px; }
        
        .card {
            background: white; padding: 25px; border-radius: 12px;
            text-decoration: none; color: #333; position: relative;
            box-shadow: 0 4px 6px rgba(0,0,0,0.02); transition: transform 0.2s, box-shadow 0.2s;
            display: flex; align-items: center; gap: 20px;
            border-left: 5px solid #ccc; /* Default */
        }
        .card:hover { transform: translateY(-5px); box-shadow: 0 10px 20px rgba(0,0,0,0.08); }
        
        .card-icon { font-size: 2em; width: 50px; text-align: center; }
        .card-info h3 { margin: 0 0 5px 0; font-size: 1.2em; }
        .card-info p { margin: 0; color: #777; font-size: 0.9em; }

        /* Card Colors */
        .c-res { border-left-color: #007bff; } .c-res i { color: #007bff; }
        .c-room { border-left-color: #28a745; } .c-room i { color: #28a745; }
        .c-stud { border-left-color: #ffc107; } .c-stud i { color: #ffc107; }
        .c-news { border-left-color: #17a2b8; } .c-news i { color: #17a2b8; }

        /* --- COMPLAINTS SECTION --- */
        .panel { background: white; border-radius: 12px; padding: 30px; box-shadow: 0 4px 10px rgba(0,0,0,0.05); }
        .panel-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px; border-bottom: 2px solid #f0f2f5; padding-bottom: 15px; }
        .panel h2 { margin: 0; font-size: 1.4em; color: #333; }
        
        /* Modern Table */
        table { width: 100%; border-collapse: collapse; }
        th { text-align: left; color: #888; font-size: 0.85em; text-transform: uppercase; padding: 15px 10px; border-bottom: 2px solid #eee; }
        td { padding: 15px 10px; border-bottom: 1px solid #eee; vertical-align: middle; color: #444; }
        tr:last-child td { border-bottom: none; }
        tr:hover { background-color: #f9f9f9; }
        
        /* Badges & Buttons */
        .badge { padding: 5px 10px; border-radius: 12px; font-size: 0.8em; font-weight: 600; }
        .b-Pending { background: #fff3cd; color: #856404; }
        .b-Resolved { background: #d4edda; color: #155724; }
        
        .btn-resolve { 
            background: #28a745; color: white; border: none; padding: 8px 15px; 
            border-radius: 20px; cursor: pointer; font-size: 0.85em; font-weight: bold;
            transition: 0.2s;
        }
        .btn-resolve:hover { background: #218838; }
        
        .photo-link { color: #007bff; text-decoration: none; font-weight: 500; }
        .photo-link:hover { text-decoration: underline; }

    </style>
</head>
<body>

    <nav class="navbar">
        <a href="AdminDashboardServlet" class="logo">BYTEE <span style="font-weight:400; font-size:0.8em;">Admin</span></a>
        <div class="nav-right">
            <span class="admin-badge"><i class="fas fa-shield-alt"></i> Administrator</span>
            <a href="Controller?page=logout" class="btn-logout">Logout</a>
        </div>
    </nav>

    <div class="container">
        
        <div class="hero">
            <h1>Control Center</h1>
            <p>Manage reservations, rooms, and student requests efficiently.</p>
        </div>

        <div class="grid">
            
            <a href="AdminReservationServlet" class="card c-res">
                <div class="card-icon"><i class="fas fa-clipboard-list"></i></div>
                <div class="card-info">
                    <h3>Reservations</h3>
                    <p>View & Cancel Bookings</p>
                </div>
            </a>
            
            <a href="AdminRoomServlet" class="card c-room">
                <div class="card-icon"><i class="fas fa-bed"></i></div>
                <div class="card-info">
                    <h3>Room Inventory</h3>
                    <p>Add, Delete or Assign</p>
                </div>
            </a>
            
            <a href="AdminStudentServlet" class="card c-stud">
                <div class="card-icon"><i class="fas fa-user-graduate"></i></div>
                <div class="card-info">
                    <h3>Student Directory</h3>
                    <p>Manage Student Profiles</p>
                </div>
            </a>
            
            <a href="AdminAnnouncementServlet" class="card c-news">
                <div class="card-icon"><i class="fas fa-bullhorn"></i></div>
                <div class="card-info">
                    <h3>Announcements</h3>
                    <p>Post Campus News</p>
                </div>
            </a>
            
        </div>

        <div class="panel">
            <div class="panel-header">
                <h2>📢 Recent Complaints & Requests</h2>
                <span style="color: #888; font-size: 0.9em;">Prioritize "Pending" items</span>
            </div>
            
            <table>
                <thead>
                    <tr>
                        <th>Date</th>
                        <th>Student / Location</th>
                        <th>Category</th>
                        <th>Description</th>
                        <th>Photo</th>
                        <th>Status</th>
                        <th>Action</th>
                    </tr>
                </thead>
                <tbody>
                    <% 
                        ResultSet rs = (ResultSet) request.getAttribute("complaintList");
                        boolean hasData = false;
                        if(rs != null) {
                            while(rs.next()) {
                                hasData = true;
                                String img = rs.getString("image_path");
                    %>
                    <tr>
                        <td><%= rs.getTimestamp("date_filed").toString().substring(0, 16) %></td>
                        <td>
                            <strong><%= rs.getString("full_name") %></strong><br>
                            <span style="font-size:0.85em; color:#666;">
                                Blk <%= rs.getString("block") %> - <%= rs.getString("room_number") %>
                            </span>
                        </td>
                        <td><%= rs.getString("category") %></td>
                        <td><%= rs.getString("description") %></td>
                        <td>
                            <% if (img != null && !img.isEmpty()) { %>
                                <a href="ImageServlet?file=<%= img %>" target="_blank" class="photo-link">
                                    <i class="fas fa-image"></i> View
                                </a>
                            <% } else { %>
                                <span style="color:#ccc;">-</span>
                            <% } %>
                        </td>
                        <td><span class="badge b-<%= rs.getString("status") %>"><%= rs.getString("status") %></span></td>
                        <td>
                            <% if(!"Resolved".equals(rs.getString("status"))) { %>
                                <form action="AdminActionServlet" method="post">
                                    <input type="hidden" name="action" value="resolve_complaint">
                                    <input type="hidden" name="complaint_id" value="<%= rs.getString("complaint_id") %>">
                                    <button type="submit" class="btn-resolve">
                                        <i class="fas fa-check"></i> Resolve
                                    </button>
                                </form>
                            <% } else { %>
                                <span style="color:#28a745; font-weight:bold;"><i class="fas fa-check-circle"></i> Done</span>
                            <% } %>
                        </td>
                    </tr>
                    <% 
                            }
                        } 
                        if (!hasData) {
                    %>
                    <tr>
                        <td colspan="7" style="text-align:center; padding: 40px; color: #999;">
                            <i class="fas fa-check-circle" style="font-size: 2em; margin-bottom: 10px;"></i><br>
                            No complaints found. Good job!
                        </td>
                    </tr>
                    <% } %>
                </tbody>
            </table>
        </div>

    </div>

</body>
</html>