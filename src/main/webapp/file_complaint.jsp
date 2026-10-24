<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>File a Complaint</title>
    <style>
        body { font-family: sans-serif; padding: 20px; background-color: #f9f9f9; }
        .form-container { background: white; max-width: 500px; margin: 0 auto; padding: 30px; border-radius: 8px; box-shadow: 0 4px 10px rgba(0,0,0,0.1); }
        input, select, textarea { width: 100%; padding: 10px; margin: 10px 0; border: 1px solid #ddd; border-radius: 4px; box-sizing: border-box; }
        button { background-color: #dc3545; color: white; width: 100%; padding: 10px; border: none; border-radius: 4px; cursor: pointer; font-size: 16px; }
        button:hover { background-color: #c82333; }
        .readonly-field { background-color: #e9ecef; color: #495057; }
    </style>
</head>
<body>

    <div class="form-container">
        <h2>Report an Issue</h2>
        <p>Please describe the maintenance issue in your room.</p>
        
        <form action="ComplaintServlet" method="post" enctype="multipart/form-data">
            
            <input type="hidden" name="room_id" value="<%= request.getAttribute("room_id") %>">
            
            <label>Location (Auto-Detected)</label>
            <input type="text" value="<%= request.getAttribute("room_label") %>" class="readonly-field" readonly>

            <label>Category</label>
            <select name="category" required>
                <option value="">-- Select Category --</option>
                <option value="Electrical">Electrical</option>
                <option value="Plumbing">Plumbing</option>
                <option value="Furniture">Furniture</option>
                <option value="Cleanliness">Cleanliness</option>
                <option value="Other">Other</option>
            </select>

            <label>Attach Photo (Optional)</label>
            <input type="file" name="complaint_image" accept=".jpg, .jpeg, .png">

            <label>Description</label>
            <textarea name="description" rows="5" placeholder="Describe the problem..." required></textarea>

            <button type="submit">Submit Report</button>
        </form>
        
        <br>
        <div style="text-align: center;">
            <a href="dashboard.jsp">Cancel</a>
        </div>
    </div>

</body>
</html>