<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Login - BYTEE Hostel</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.1/css/all.min.css">
    
    <style>
        body {
            background: #f4f7f6;
            display: flex;
            align-items: center;
            justify-content: center;
            height: 100vh;
            margin: 0;
            font-family: 'Segoe UI', sans-serif;
        }
        .login-card {
            background: white;
            padding: 40px;
            border-radius: 12px;
            box-shadow: 0 10px 25px rgba(0,0,0,0.1);
            width: 100%;
            max-width: 400px;
            position: relative;
        }
        .brand-logo {
            text-align: center;
            margin-bottom: 25px;
            color: #007bff;
            font-weight: bold;
            font-size: 2rem;
        }
        .form-control {
            border-radius: 20px;
            padding: 10px 20px;
        }
        .btn-login {
            border-radius: 20px;
            padding: 10px;
            font-weight: bold;
            background: #007bff;
            border: none;
        }
        .btn-login:hover {
            background: #0056b3;
        }
        .home-btn {
            position: absolute;
            top: 20px;
            left: 20px;
            text-decoration: none;
            color: #6c757d;
            font-size: 0.9rem;
        }
        .home-btn:hover {
            color: #333;
            text-decoration: none;
        }
    </style>
</head>
<body>

    <a href="index.jsp" class="btn btn-outline-secondary btn-sm" style="position: fixed; top: 20px; left: 20px; border-radius: 20px;">
        <i class="fas fa-arrow-left"></i> Back to Home
    </a>

    <div class="login-card">
        <div class="brand-logo">BYTEE</div>
        <h5 class="text-center text-muted mb-4">Sign In to your account</h5>

        <% 
            String msg = request.getParameter("msg"); 
            if ("invalid".equals(msg)) {
        %>
            <div class="alert alert-danger text-center" role="alert">
                <small><strong>Error:</strong> Incorrect Matric Number or Password.</small>
            </div>
        <% 
            } else if ("RegistrationSuccess".equals(msg)) {
        %>
            <div class="alert alert-success text-center" role="alert">
                <small>Account created! Please login.</small>
            </div>
        <% 
            } else if ("PasswordResetSuccess".equals(msg)) {
        %>
            <div class="alert alert-success text-center" role="alert">
                <small>Password updated! Please login.</small>
            </div>
        <% } %>
        <form action="Controller" method="post">
            <input type="hidden" name="page" value="login">
            
            <div class="form-group">
                <label>Matric Number / Admin ID</label>
                <div class="input-group">
                    <div class="input-group-prepend">
                        <span class="input-group-text bg-white border-right-0" style="border-radius: 20px 0 0 20px;"><i class="fas fa-user"></i></span>
                    </div>
                    <input type="text" name="matric_number" class="form-control border-left-0" required placeholder="1210001">
                </div>
            </div>

            <div class="form-group">
                <label>Password</label>
                <div class="input-group">
                    <div class="input-group-prepend">
                        <span class="input-group-text bg-white border-right-0" style="border-radius: 20px 0 0 20px;"><i class="fas fa-lock"></i></span>
                    </div>
                    <input type="password" name="password" class="form-control border-left-0" required placeholder="••••••">
                </div>
            </div>

            <button type="submit" class="btn btn-primary btn-block btn-login">LOGIN</button>
            
            <div class="text-center mt-3">
                <a href="Controller?page=forgot_password" class="text-muted" style="font-size: 0.9em;">Forgot Password?</a>
            </div>
            
            <hr>
            
            <div class="text-center">
                <span class="text-muted" style="font-size: 0.9em;">Don't have an account?</span><br>
                <a href="register.jsp" style="font-weight: 600;">Register Here</a>
            </div>
        </form>
    </div>

</body>
</html>