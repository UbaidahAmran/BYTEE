<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // Security Check: If they didn't pass step 1, kick them out
    if (session.getAttribute("reset_matric") == null) {
        response.sendRedirect("forgot_password.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Set New Password - BYTEE</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <style>
        body { background: #f4f7f6; display: flex; align-items: center; justify-content: center; height: 100vh; }
        .card { width: 400px; padding: 20px; box-shadow: 0 4px 10px rgba(0,0,0,0.1); border: none; }
    </style>
</head>
<body>

    <div class="card">
        <h3 class="text-center text-success mb-4">Identity Verified</h3>
        <p class="text-muted text-center">Please enter your new password.</p>

        <form action="Controller" method="post">
            <input type="hidden" name="page" value="save_new_password">
            
            <div class="form-group">
                <label>New Password</label>
                <input type="password" name="new_password" class="form-control" required>
            </div>

            <div class="form-group">
                <label>Confirm Password</label>
                <input type="password" name="confirm_password" class="form-control" required>
            </div>

            <button type="submit" class="btn btn-success btn-block">Update Password</button>
        </form>
    </div>

</body>
</html>