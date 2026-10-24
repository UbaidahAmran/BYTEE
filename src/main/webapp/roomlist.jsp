<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.ResultSet" %>
<!DOCTYPE html>
<html>
<head>
    <title>Available Rooms</title>
    <style>
        body { font-family: sans-serif; padding: 20px; background-color: #f9f9f9; }
        table { width: 100%; border-collapse: collapse; background: white; margin-top: 20px; }
        th, td { padding: 12px; border: 1px solid #ddd; text-align: left; }
        th { background-color: #007bff; color: white; }
        tr:nth-child(even) { background-color: #f2f2f2; }
        .btn-book { background-color: #28a745; color: white; padding: 8px 12px; text-decoration: none; border-radius: 4px; border: none; cursor: pointer;}
        .btn-book:hover { background-color: #218838; }
        .nav { margin-bottom: 20px; }
    </style>
</head>
<body>

    <div class="nav">
        <a href="dashboard.jsp">← Back to Dashboard</a>
    </div>

    <h1>Available Rooms</h1>

   <table>
        <thead>
            <tr>
                <th>College</th>
                <th>Unit Info</th>
                <th>Bed Type</th>
                <th>Gender</th>
                <th>Action</th>
            </tr>
        </thead>
        <tbody>
            <% 
                ResultSet rs = (ResultSet) request.getAttribute("roomData");
                if (rs != null) {
                    while (rs.next()) {
            %>
            <tr>
                <td><%= rs.getString("college_name") %></td>
                
                <td>
                    Blk <%= rs.getString("block") %>, 
                    Lvl <%= rs.getInt("level") %> 
                    (Unit <%= rs.getString("unit_number") %>)
                </td>
                
                <td><%= rs.getString("bed_number") %></td>
                
                <td><%= rs.getString("gender_restriction") %></td>
                
                <td>
                    <form action="BookRoomServlet" method="post">
                        <input type="hidden" name="room_id" value="<%= rs.getString("room_id") %>">
                        <button type="submit" class="btn-book">Book Now</button>
                    </form>
                </td>
            </tr>
            <% 
                    }
                    rs.getStatement().getConnection().close();
                } else {
            %>
            <tr><td colspan="5">No rooms available.</td></tr>
            <% } %>
        </tbody>
    </table>
</body>
</html>