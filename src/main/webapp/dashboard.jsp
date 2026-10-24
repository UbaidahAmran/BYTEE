<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, com.bytee.db.DBConnection" %>
<%
    // 1. Security Check
    if (session.getAttribute("user_name") == null) {
        response.sendRedirect("Login.jsp");
        return;
    }
    String userName = (String) session.getAttribute("user_name");
    String userId = (String) session.getAttribute("user_id");
    
    // 2. Check Booking Status
    boolean hasRoom = false;
    try {
        Connection conn = DBConnection.getConnection();
        String sql = "SELECT reservation_id FROM reservations WHERE user_id = ? AND status = 'Confirmed'";
        PreparedStatement stmt = conn.prepareStatement(sql);
        stmt.setString(1, userId);
        ResultSet rs = stmt.executeQuery();
        if (rs.next()) {
            hasRoom = true;
        }
        conn.close();
    } catch (Exception e) {
        e.printStackTrace();
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Student Dashboard - BYTEE</title>
    <link href="https://fonts.googleapis.com/css?family=Segoe+UI:400,600,700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    
    <style>
        body { margin: 0; font-family: 'Segoe UI', sans-serif; background-color: #f0f2f5; }
        
        .navbar {
            background-color: white; padding: 15px 30px;
            display: flex; justify-content: space-between; align-items: center;
            box-shadow: 0 2px 10px rgba(0,0,0,0.05); position: sticky; top: 0; z-index: 100;
        }
        .logo { font-size: 1.5em; font-weight: bold; color: #007bff; text-decoration: none; }
        .user-menu { display: flex; align-items: center; gap: 20px; }
        .user-name { font-weight: 600; color: #333; text-decoration: none; }
        .btn-logout { 
            color: #dc3545; text-decoration: none; font-weight: 500; border: 1px solid #dc3545; 
            padding: 6px 15px; border-radius: 20px; transition: 0.3s; 
        }
        .btn-logout:hover { background-color: #dc3545; color: white; }

        .container { max-width: 1100px; margin: 40px auto; padding: 0 20px; }
        
        .hero-banner {
            background: linear-gradient(135deg, #007bff, #0056b3); color: white;
            padding: 40px; border-radius: 15px; margin-bottom: 40px;
            box-shadow: 0 10px 20px rgba(0, 123, 255, 0.2);
        }
        .hero-banner h1 { margin: 0; font-size: 2.2em; }
        .hero-banner p { margin: 10px 0 0 0; opacity: 0.9; font-size: 1.1em; }
        
        .grid {
            display: grid; grid-template-columns: repeat(auto-fit, minmax(280px, 1fr)); gap: 25px;
        }
        
        .card {
            background: white; padding: 30px; border-radius: 12px;
            text-decoration: none; color: #333;
            box-shadow: 0 4px 6px rgba(0,0,0,0.02);
            transition: transform 0.2s, box-shadow 0.2s;
            border-left: 5px solid transparent;
            display: flex; flex-direction: column; justify-content: center;
        }
        .card:hover { transform: translateY(-5px); box-shadow: 0 10px 20px rgba(0,0,0,0.08); }
        
        .icon-box { font-size: 2.5em; margin-bottom: 15px; }
        .card h3 { margin: 0 0 5px 0; font-size: 1.3em; }
        .card p { margin: 0; color: #777; font-size: 0.9em; }

        /* Card Colors */
        .card-booking { border-left-color: #007bff; } .card-booking .icon-box { color: #007bff; }
        .card-maintenance { border-left-color: #ffc107; } .card-maintenance .icon-box { color: #ffc107; }
        .card-news { border-left-color: #17a2b8; } .card-news .icon-box { color: #17a2b8; }
        .card-profile { border-left-color: #6610f2; } .card-profile .icon-box { color: #6610f2; }
        .card-reserve { border-left-color: #28a745; } .card-reserve .icon-box { color: #28a745; }

    </style>
</head>
<body>

    <nav class="navbar">
        <a href="index.jsp" class="logo">BYTEE</a>
        <div class="user-menu">
            <a href="ProfileServlet" class="user-name"><i class="fas fa-user-circle"></i> <%= userName %></a>
            <a href="Controller?page=logout" class="btn-logout">Logout</a>
        </div>
    </nav>

    <div class="container">
        <div class="hero-banner">
            <h1>Welcome back, <%= userName %>!</h1>
            <p>
                <% if (hasRoom) { %>
                    You are all settled in. How can we help?
                <% } else { %>
                    Ready to find your new home?
                <% } %>
            </p>
        </div>

        <div class="grid">

            <% if (!hasRoom) { %>
                <a href="BookingWizardServlet?step=1" class="card card-reserve">
                    <div class="icon-box"><i class="fas fa-key"></i></div>
                    <h3>Reserve a Room</h3>
                    <p>Browse colleges and book your bed.</p>
                </a>
                
                <a href="AnnouncementServlet" class="card card-news">
                    <div class="icon-box"><i class="fas fa-bullhorn"></i></div>
                    <h3>Announcements</h3>
                    <p>Latest campus news.</p>
                </a>
                
                <a href="ProfileServlet" class="card card-profile">
                    <div class="icon-box"><i class="fas fa-id-card"></i></div>
                    <h3>My Profile</h3>
                    <p>Update your details.</p>
                </a>

            <% } else { %>
                <a href="MyReservationsServlet" class="card card-booking">
                    <div class="icon-box"><i class="fas fa-door-open"></i></div>
                    <h3>My Room</h3>
                    <p>View details and meet roommates.</p>
                </a>

                <a href="ComplaintServlet" class="card card-maintenance">
                    <div class="icon-box"><i class="fas fa-tools"></i></div>
                    <h3>Report Issue</h3>
                    <p>Something broken? Let us know.</p>
                </a>

                <a href="AnnouncementServlet" class="card card-news">
                    <div class="icon-box"><i class="fas fa-bullhorn"></i></div>
                    <h3>Announcements</h3>
                    <p>Latest campus news.</p>
                </a>

                <a href="ProfileServlet" class="card card-profile">
                    <div class="icon-box"><i class="fas fa-id-card"></i></div>
                    <h3>My Profile</h3>
                    <p>Update your details.</p>
                </a>

            <% } %>

        </div>
    </div>

</body>
</html>