<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.ResultSet" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Room Inventory - Admin</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;500;700&display=swap" rel="stylesheet">
    
    <style>
        /* --- GLOBAL & LAYOUT --- */
        body { font-family: 'Roboto', sans-serif; background-color: #f0f2f5; margin: 0; padding: 30px; color: #333; }
        .page-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 25px; }
        .btn-back { text-decoration: none; color: #555; background: #fff; padding: 10px 20px; border-radius: 50px; display: inline-flex; align-items: center; gap: 8px; box-shadow: 0 2px 5px rgba(0,0,0,0.05); transition: 0.2s; }
        .btn-back:hover { background: #007bff; color: white; }

        /* --- ADD FORM --- */
        .control-bar { background: #ffffff; padding: 20px; border-radius: 12px; box-shadow: 0 4px 12px rgba(0,0,0,0.05); margin-bottom: 25px; display: flex; align-items: center; gap: 20px; flex-wrap: wrap; }
        .control-header { font-size: 18px; font-weight: 600; color: #2c3e50; margin-right: auto; }
        .form-select, .form-input { padding: 10px; border: 1px solid #e0e0e0; border-radius: 8px; outline: none; background: #f9f9f9; }
        .btn-add { background: #28a745; color: white; border: none; padding: 10px 20px; border-radius: 8px; font-weight: 600; cursor: pointer; }
        
        /* --- TABLE --- */
        .card { background: #fff; border-radius: 12px; box-shadow: 0 4px 12px rgba(0,0,0,0.05); overflow: hidden; }
        table { width: 100%; border-collapse: collapse; }
        th { background: #f8f9fa; color: #555; padding: 15px; text-align: left; border-bottom: 2px solid #eee; }
        td { padding: 15px; border-bottom: 1px solid #f0f0f0; vertical-align: middle; }
        
        /* --- ICONS & BUTTONS --- */
        .btn-icon { width: 35px; height: 35px; border-radius: 50%; border: none; background: transparent; cursor: pointer; display: inline-flex; align-items: center; justify-content: center; font-size: 1.1em; transition: 0.2s; }
        .btn-icon:hover { background-color: #f0f2f5; }
        .icon-assign { color: #28a745; }
        .icon-lock { color: #f39c12; }
        .icon-unlock { color: #17a2b8; }
        .icon-delete { color: #dc3545; }
        
        /* --- BADGES --- */
        .badge { padding: 6px 12px; border-radius: 20px; font-size: 0.8em; font-weight: 600; }
        .badge-success { background: #e6f9ed; color: #28a745; }
        .badge-warning { background: #fff8e1; color: #f39c12; }
        .badge-danger { background: #ffeaea; color: #dc3545; }
        .bed-badge { background: #f0f2f5; padding: 5px 10px; border-radius: 6px; font-size: 0.9em; border: 1px solid #e1e4e8; }

        /* --- MODAL (POPUP) --- */
        .modal-overlay {
            display: none; /* Hidden by default */
            position: fixed; top: 0; left: 0; width: 100%; height: 100%;
            background-color: rgba(0,0,0,0.5); z-index: 9999;
            justify-content: center; align-items: center;
        }
        .modal-box {
            background: white; width: 90%; max-width: 400px; padding: 30px;
            border-radius: 15px; text-align: center; box-shadow: 0 20px 40px rgba(0,0,0,0.2);
        }
        .modal-input { width: 100%; padding: 12px; margin: 15px 0; border: 2px solid #eee; border-radius: 8px; box-sizing: border-box; font-size: 16px; }
        .modal-input:focus { border-color: #28a745; outline: none; }
        .btn-modal { padding: 12px 25px; border: none; border-radius: 8px; cursor: pointer; font-weight: bold; font-size: 15px; margin: 5px; }
    </style>

    <script>
        function openModal(roomId) {
            document.getElementById('modalRoomId').value = roomId;
            document.getElementById('assignModal').style.display = 'flex';
            setTimeout(function() { document.getElementById('matricInput').focus(); }, 100);
        }

        function closeModal() {
            document.getElementById('assignModal').style.display = 'none';
        }
    </script>
</head>
<body>

    <div class="page-header">
        <a href="AdminDashboardServlet" class="btn-back"><i class="fas fa-arrow-left"></i> Back to Control Center</a>
    </div>

    <div class="control-bar">
        <div class="control-header">Room Inventory</div>
        <form action="AdminActionServlet" method="post" style="display:flex; gap:10px; flex-wrap:wrap; align-items:center;">
            <input type="hidden" name="action" value="add_room">
            <select name="college_id" required class="form-select" style="width:180px;">
                <option value="">Select College</option>
                <% ResultSet rsCol = (ResultSet) request.getAttribute("collegeList");
                   if(rsCol != null) { rsCol.beforeFirst(); while(rsCol.next()) { %>
                    <option value="<%= rsCol.getString("college_id") %>"><%= rsCol.getString("name") %></option>
                <% }} %>
            </select>
            <select name="block" required class="form-select" style="width:70px;"><option value="">Blk</option><option value="A">A</option><option value="B">B</option><option value="C">C</option><option value="D">D</option></select>
            <select name="level" required class="form-select" style="width:70px;"><option value="">Lvl</option><option value="1">1</option><option value="2">2</option><option value="3">3</option></select>
            <input type="text" name="unit" placeholder="ID (A-1-1)" required class="form-input" style="width:100px;">
            <select name="bed" required class="form-select" style="width:160px;">
                <option value="">Bed Type</option>
                <option value="Single Bed (1)">Single Bed (1)</option>
                <option value="Single Bed (2)">Single Bed (2)</option>
                <option value="Double Decker (Lower)">Double Decker (Lower)</option>
                <option value="Double Decker (Upper)">Double Decker (Upper)</option>
            </select>
            <button type="submit" class="btn-add">Add</button>
        </form>
    </div>

    <div class="card">
        <table>
            <thead>
                <tr>
                    <th>College</th> <th>Room ID</th> <th>Bed Type</th> <th>Status</th> <th>Occupant</th> <th style="text-align:right;">Actions</th>
                </tr>
            </thead>
            <tbody>
                <% ResultSet rs = (ResultSet) request.getAttribute("roomList");
                   if(rs != null) {
                       while(rs.next()) { 
                           String status = rs.getString("status");
                           String roomId = rs.getString("room_id");
                %>
                <tr>
                    <td><%= rs.getString("college_name") %></td>
                    <td><strong style="color:#007bff;"><%= rs.getString("room_number") %></strong></td>
                    <td><span class="bed-badge"><%= rs.getString("bed_number") %></span></td>
                    <td>
                        <% if("Available".equalsIgnoreCase(status)) { %><span class="badge badge-success">Available</span>
                        <% } else if("Maintenance".equalsIgnoreCase(status)) { %><span class="badge badge-warning">Maintenance</span>
                        <% } else { %><span class="badge badge-danger">Occupied</span><% } %>
                    </td>
                    <td>
                        <% if (rs.getString("full_name") != null) { %>
                            <strong><%= rs.getString("full_name") %></strong><br><small><%= rs.getString("matric_number") %></small>
                        <% } else { %> - <% } %>
                    </td>
                    <td style="text-align:right;">
                        
                        <% if ("Available".equals(status)) { %>
                            <button type="button" onclick="openModal('<%= roomId %>')" class="btn-icon icon-assign" title="Assign Student">
                                <i class="fas fa-user-plus"></i>
                            </button>
                        <% } else { %>
                            <button type="button" class="btn-icon" style="color:#ccc; cursor:default;" disabled>
                                <i class="fas fa-ban"></i>
                            </button>
                        <% } %>

                        <form action="AdminActionServlet" method="post" style="display:inline;">
                            <input type="hidden" name="room_id" value="<%= roomId %>">
                            
                            <% if ("Available".equals(status)) { %>
                                <button type="submit" name="action" value="toggle_maintenance" class="btn-icon icon-lock" title="Lock"><i class="fas fa-lock"></i></button>
                                <button type="submit" name="action" value="delete_room" class="btn-icon icon-delete" title="Delete" onclick="return confirm('Delete?');"><i class="fas fa-trash-alt"></i></button>
                            <% } else if ("Maintenance".equals(status)) { %>
                                <button type="submit" name="action" value="toggle_maintenance" class="btn-icon icon-unlock" title="Unlock"><i class="fas fa-lock-open"></i></button>
                                <button type="submit" name="action" value="delete_room" class="btn-icon icon-delete" title="Delete"><i class="fas fa-trash-alt"></i></button>
                            <% } %>
                        </form>
                    </td>
                </tr>
                <% }} else { %> <tr><td colspan="6" style="text-align:center; padding:20px;">No Rooms Found</td></tr> <% } %>
            </tbody>
        </table>
    </div>

    <div id="assignModal" class="modal-overlay" onclick="if(event.target == this) closeModal()">
        <div class="modal-box">
            <i class="fas fa-user-check" style="font-size: 3em; color: #28a745; margin-bottom: 10px;"></i>
            <h3>Assign Student</h3>
            <p style="color:#666;">Enter the student's Matric Number below:</p>
            
            <form action="AdminActionServlet" method="post">
                <input type="hidden" name="action" value="manual_book">
                <input type="hidden" name="room_id" id="modalRoomId">
                
                <input type="text" id="matricInput" name="matric_number" class="modal-input" placeholder="Matric No. (e.g. 123456)" required autocomplete="off">
                
                <div style="margin-top:15px;">
                    <button type="button" class="btn-modal" onclick="closeModal()" style="background:#f1f1f1; color:#555;">Cancel</button>
                    <button type="submit" class="btn-modal" style="background:#28a745; color:white;">Confirm</button>
                </div>
            </form>
        </div>
    </div>

</body>
</html>