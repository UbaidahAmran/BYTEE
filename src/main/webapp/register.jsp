<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Register - BYTEE</title>
    <style>
        body { font-family: 'Segoe UI', sans-serif; background: #f4f6f8; display: flex; justify-content: center; align-items: center; min-height: 100vh; margin: 0; }
        .container { background: white; padding: 40px; border-radius: 10px; box-shadow: 0 4px 15px rgba(0,0,0,0.1); width: 100%; max-width: 500px; }
        h2 { text-align: center; color: #333; margin-bottom: 20px; }
        
        label { font-weight: 600; font-size: 0.9em; display: block; margin-top: 15px; color: #555; }
        input, select, textarea { width: 100%; padding: 10px; margin-top: 5px; border: 1px solid #ddd; border-radius: 5px; box-sizing: border-box; }
        
        button { width: 100%; padding: 12px; background: #007bff; color: white; border: none; border-radius: 5px; font-size: 1em; font-weight: bold; margin-top: 25px; cursor: pointer; }
        button:hover { background: #0056b3; }
        
        .login-link { text-align: center; margin-top: 20px; font-size: 0.9em; }
        .login-link a { color: #007bff; text-decoration: none; }
    </style>
</head>
<body>

    <div class="container">
        <h2>Create Account</h2>
        
        <form action="RegisterServlet" method="post" enctype="multipart/form-data">
            
            <label>Full Name</label>
            <input type="text" name="full_name" required placeholder="e.g. Ahmad Albab">

            <label>Email Address</label>
            <input type="email" name="email" required placeholder="student@bytee.com">

            <label>Matric Number</label>
            <input type="text" name="matric_number" required placeholder="e.g. 1210001">

            <label>Faculty</label>
            <select name="faculty" required>
                <option value="">Select Your Faculty</option>
                <option value="Faculty of Quranic and Sunnah Studies (FPQS)">Faculty of Quranic & Sunnah Studies (FPQS)</option>
                <option value="Faculty of Science and Technology (FST)">Faculty of Science & Technology (FST)</option>
                <option value="Faculty of Medicine and Health Sciences (FPSK)">Faculty of Medicine (FPSK)</option>
                <option value="Faculty of Engineering and Built Environment (FKAB)">Faculty of Engineering (FKAB)</option>
                <option value="Faculty of Major Language Studies (FPBU)">Faculty of Major Language Studies (FPBU)</option>
                <option value="Faculty of Leadership and Management (FKP)">Faculty of Leadership (FKP)</option>
                <option value="Faculty of Syariah and Law (FSU)">Faculty of Syariah & Law (FSU)</option>
                <option value="Faculty of Economics and Muamalat (FEM)">Faculty of Economics (FEM)</option>
                <option value="Faculty of Dentistry (FPg)">Faculty of Dentistry (FPg)</option>
            </select>

            <label>Password</label>
            <input type="password" name="password" required>

            <div style="display: flex; gap: 10px;">
                <div style="flex: 1;">
                    <label>Gender</label>
                    <select name="gender" required>
                        <option value="Male">Male</option>
                        <option value="Female">Female</option>
                    </select>
                </div>
                <div style="flex: 1;">
                    <label>Home State</label>
                    <select name="home_state" required>
                        <option value="">Select State</option>
                        <option value="Johor">Johor</option>
                        <option value="Kedah">Kedah</option>
                        <option value="Kelantan">Kelantan</option>
                        <option value="Melaka">Melaka</option>
                        <option value="Negeri Sembilan">Negeri Sembilan</option>
                        <option value="Pahang">Pahang</option>
                        <option value="Perak">Perak</option>
                        <option value="Perlis">Perlis</option>
                        <option value="Pulau Pinang">Pulau Pinang</option>
                        <option value="Sabah">Sabah</option>
                        <option value="Sarawak">Sarawak</option>
                        <option value="Selangor">Selangor</option>
                        <option value="Terengganu">Terengganu</option>
                        <option value="KL/Putrajaya">KL / Putrajaya</option>
                    </select>
                </div>
            </div>

            <label>Profile Picture</label>
            <input type="file" name="profile_image" accept=".jpg, .jpeg, .png" required>

            <label>About Me (Bio)</label>
            <textarea name="about_me" rows="3" placeholder="Describe yourself (e.g. I like quiet study time, I am a gamer, etc.)"></textarea>

            <button type="submit">Sign Up</button>
        </form>

        <div class="Login-link">
            Already have an account? <a href="Login.jsp">Login here</a>
        </div>
    </div>

</body>
</html>