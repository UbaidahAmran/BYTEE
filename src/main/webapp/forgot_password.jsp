<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Forgot Password - BYTEE</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <style>
        body { background: #f4f7f6; display: flex; align-items: center; justify-content: center; height: 100vh; }
        .card { width: 400px; padding: 20px; box-shadow: 0 4px 10px rgba(0,0,0,0.1); border: none; }
    </style>
</head>
<body>

    <div class="card">
        <h3 class="text-center mb-4">Reset Password</h3>
        
        <% if (request.getParameter("error") != null) { %>
            <div class="alert alert-danger text-center">Invalid Matric Number or Email.</div>
        <% } %>

        <form action="Controller" method="post">
            <input type="hidden" name="page" value="validate_reset">
            
            <div class="form-group">
                <label>Matric Number</label>
                <input type="text" name="matric_number" class="form-control" required placeholder="e.g. 1210001">
            </div>

            <div class="form-group">
                <label>Email Address</label>
                <input type="email" name="email" class="form-control" required placeholder="Registered email">
            </div>

            <button type="submit" class="btn btn-primary btn-block">Verify User</button>
            <a href="Login.jsp" class="btn btn-link btn-block">Back to Login</a>
        </form>
    </div>

</body>
</html>