<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.ResultSet" %>
<!DOCTYPE html>
<html>
<head>
    <title>Announcements - Admin</title>
    <link href="https://fonts.googleapis.com/css?family=Segoe+UI:400,600,700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    
    <style>
        body { font-family: 'Segoe UI', sans-serif; background-color: #f0f2f5; padding: 20px; }
        .container { max-width: 1200px; margin: 0 auto; }
        
        .header { margin-bottom: 25px; }
        .btn-back { text-decoration: none; color: #555; font-weight: 600; }
        
        .grid-layout { display: grid; grid-template-columns: 1fr 2fr; gap: 30px; }
        
        /* Editor Card */
        .editor-card { background: white; padding: 25px; border-radius: 12px; box-shadow: 0 4px 10px rgba(0,0,0,0.05); height: fit-content; border-top: 5px solid #17a2b8; }
        input, textarea { width: 100%; padding: 12px; margin: 10px 0 20px 0; border: 1px solid #ddd; border-radius: 6px; box-sizing: border-box; font-family: inherit; }
        .btn-pub { background: #17a2b8; color: white; border: none; padding: 10px 20px; border-radius: 6px; width: 100%; font-weight: bold; cursor: pointer; }
        .btn-pub:hover { background: #138496; }

        /* List Card */
        .list-card { background: white; border-radius: 12px; box-shadow: 0 4px 10px rgba(0,0,0,0.05); overflow: hidden; }
        .news-item { padding: 20px; border-bottom: 1px solid #eee; display: flex; justify-content: space-between; align-items: start; }
        .news-item:last-child { border-bottom: none; }
        
        .news-content h3 { margin: 0 0 5px 0; color: #333; font-size: 1.1em; }
        .news-meta { font-size: 0.85em; color: #888; margin-bottom: 8px; display: block; }
        
        .news-actions { display: flex; gap: 10px; }
        .btn-icon { color: #888; cursor: pointer; font-size: 1.1em; transition: 0.2s; }
        .btn-icon:hover { color: #007bff; }
        .btn-trash:hover { color: #dc3545; }
    </style>
</head>
<body>
    <div class="container">
        
        <div class="header">
            <a href="AdminDashboardServlet" class="btn-back"><i class="fas fa-arrow-left"></i> Back to Control Center</a>
            <h1 style="margin-top:10px;">Newsroom</h1>
        </div>

        <%
            ResultSet rsEdit = (ResultSet) request.getAttribute("editNews");
            boolean isEdit = (rsEdit != null);
            String title = isEdit ? rsEdit.getString("title") : "";
            String msg = isEdit ? rsEdit.getString("message") : "";
            String id = isEdit ? rsEdit.getString("announcement_id") : "";
        %>

        <div class="grid-layout">
            
            <div class="editor-card">
                <h3><%= isEdit ? "✏️ Edit Post" : "📢 New Announcement" %></h3>
                <form action="AdminActionServlet" method="post">
                    <input type="hidden" name="action" value="<%= isEdit ? "update_announcement" : "add_announcement" %>">
                    <input type="hidden" name="announcement_id" value="<%= id %>">
                    
                    <label style="font-weight:600; color:#555;">Headline</label>
                    <input type="text" name="title" value="<%= title %>" required placeholder="Important Notice...">
                    
                    <label style="font-weight:600; color:#555;">Message Body</label>
                    <textarea name="message" rows="6" required placeholder="Type your message here..."><%= msg %></textarea>
                    
                    <button type="submit" class="btn-pub">
                        <%= isEdit ? "Update Post" : "Publish Now" %>
                    </button>
                    
                    <% if(isEdit) { %>
                        <div style="text-align:center; margin-top:10px;">
                            <a href="AdminAnnouncementServlet" style="color:#666; font-size:0.9em;">Cancel Editing</a>
                        </div>
                    <% } %>
                </form>
            </div>

            <div class="list-card">
                <div style="padding: 15px 20px; background:#f8f9fa; border-bottom:1px solid #eee; font-weight:bold; color:#666;">
                    Recent Posts
                </div>
                
                <% 
                    ResultSet rs = (ResultSet) request.getAttribute("newsList");
                    if (rs != null) {
                        while (rs.next()) {
                            String body = rs.getString("message");
                            if(body.length() > 100) body = body.substring(0, 100) + "...";
                %>
                <div class="news-item">
                    <div class="news-content">
                        <h3><%= rs.getString("title") %></h3>
                        <span class="news-meta">
                            <i class="far fa-clock"></i> <%= rs.getTimestamp("date_posted").toString().substring(0, 16) %>
                        </span>
                        <p style="margin:0; color:#555; line-height:1.4;"><%= body %></p>
                    </div>
                    
                    <div class="news-actions">
                        <a href="AdminAnnouncementServlet?edit_id=<%= rs.getString("announcement_id") %>" class="btn-icon" title="Edit">
                            <i class="fas fa-pen"></i>
                        </a>
                        
                        <form action="AdminActionServlet" method="post" style="display:inline;">
                            <input type="hidden" name="action" value="delete_announcement">
                            <input type="hidden" name="announcement_id" value="<%= rs.getString("announcement_id") %>">
                            <button type="submit" class="btn-icon btn-trash" style="border:none; background:none;" onclick="return confirm('Delete?');">
                                <i class="fas fa-trash"></i>
                            </button>
                        </form>
                    </div>
                </div>
                <% }} %>
            </div>

        </div>
    </div>
</body>
</html>