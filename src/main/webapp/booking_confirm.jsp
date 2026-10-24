<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Confirm Booking - BYTEE</title>
    <style>
        body { font-family: 'Segoe UI', sans-serif; background: #f4f6f8; padding: 20px; display: flex; justify-content: center; }
        .confirm-card { background: white; width: 100%; max-width: 500px; padding: 30px; border-radius: 10px; box-shadow: 0 4px 15px rgba(0,0,0,0.1); }
        
        h2 { text-align: center; color: #007bff; margin-bottom: 30px; }
        .detail-row { display: flex; justify-content: space-between; margin-bottom: 15px; border-bottom: 1px solid #eee; padding-bottom: 10px; }
        .label { font-weight: bold; color: #555; }
        .value { color: #333; text-align: right; }
        
        .alert { background: #fff3cd; color: #856404; padding: 10px; border-radius: 5px; font-size: 0.9em; margin: 20px 0; }
        
        .btn-confirm { width: 100%; padding: 15px; background: #28a745; color: white; border: none; border-radius: 5px; font-size: 1.1em; font-weight: bold; cursor: pointer; }
        .btn-confirm:hover { background: #218838; }
        
        .btn-cancel { display: block; text-align: center; margin-top: 15px; color: #dc3545; text-decoration: none; }
    </style>
</head>
<body>

    <div class="confirm-card">
        <h2>Review Your Booking</h2>
        
        <div class="detail-row">
            <span class="label">College</span>
            <span class="value"><%= request.getAttribute("college_name") %></span>
        </div>
        
        <div class="detail-row">
            <span class="label">Location</span>
            <span class="value"><%= request.getAttribute("location") %></span>
        </div>
        
        <div class="detail-row">
            <span class="label">Unit</span>
            <span class="value"><%= request.getAttribute("unit_info") %></span>
        </div>
        
        <div class="detail-row">
            <span class="label">Bed</span>
            <span class="value"><%= request.getAttribute("bed_info") %></span>
        </div>
        
        <div class="detail-row">
            <span class="label">Duration</span>
            <span class="value">1 Semester</span>
        </div>

        <div class="alert">
            ⚠️ <strong>Note:</strong> By clicking confirm, you agree to the hostel rules and regulations. This action cannot be undone.
        </div>

        <form action="FinalizeBookingServlet" method="post">
            <input type="hidden" name="room_id" value="<%= request.getAttribute("room_id") %>">
            <button type="submit" class="btn-confirm">Confirm & Reserve</button>
        </form>
        
        <a href="BookingWizardServlet?step=1" class="btn-cancel">Cancel</a>
    </div>

</body>
</html>