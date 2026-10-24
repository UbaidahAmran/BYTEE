<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.ResultSet" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>BYTEE - Your Home On Campus</title>
    
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.1/dist/umd/popper.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>

    <style>
        body { margin: 0; font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; background: #f8f9fa; }
        
        /* Navigation (Kept your custom style, but fixed for Bootstrap conflict) */
        .custom-navbar { background: white; padding: 15px 40px; box-shadow: 0 2px 5px rgba(0,0,0,0.05); display: flex; justify-content: space-between; align-items: center; }
        .logo { font-weight: bold; font-size: 24px; color: #007bff; text-decoration: none; }
        .nav-links a { text-decoration: none; color: #333; margin-left: 20px; font-weight: 500; font-size: 1rem; }
        .btn-login { background: #007bff; color: white !important; padding: 8px 18px; border-radius: 20px; transition: 0.3s; }
        .btn-login:hover { background: #0056b3; text-decoration: none; }

        /* SLIDER CUSTOMIZATION */
        .carousel-item {
            height: 500px; /* Adjust height here */
            background-color: #000;
        }
        .carousel-item img {
            height: 100%;
            width: 100%;
            object-fit: cover;
            opacity: 0.6; /* Darken image slightly so text is readable */
        }
        .carousel-caption {
            bottom: 35%; /* Center vertically */
        }
        .carousel-caption h1 {
            font-size: 3.5rem;
            font-weight: 700;
            text-shadow: 2px 2px 5px rgba(0,0,0,0.7);
        }
        .carousel-caption p {
            font-size: 1.3rem;
            margin-bottom: 25px;
            text-shadow: 1px 1px 3px rgba(0,0,0,0.7);
        }
        .cta-btn { 
            background: #28a745; color: white; padding: 15px 35px; font-size: 1.1em; 
            text-decoration: none; border-radius: 5px; font-weight: bold; border: none;
        }
        .cta-btn:hover { background: #218838; color: white; text-decoration: none; }

        /* Sections */
        .section { padding: 50px 10%; }
        .section h2 { text-align: center; margin-bottom: 40px; color: #333; }

        /* Grid Layout */
        .grid-container { display: grid; grid-template-columns: repeat(auto-fit, minmax(300px, 1fr)); gap: 30px; }
        
        /* Cards */
        .custom-card { background: white; border-radius: 10px; overflow: hidden; box-shadow: 0 4px 15px rgba(0,0,0,0.1); transition: transform 0.2s; border: none; }
        .custom-card:hover { transform: translateY(-5px); }
        .custom-card img { width: 100%; height: 200px; object-fit: cover; }
        .card-body-custom { padding: 20px; }
        .card-title-custom { margin: 0 0 10px 0; font-size: 1.2em; color: #007bff; font-weight: 600; }
        .card-text-custom { color: #666; font-size: 0.9em; line-height: 1.5; }
        .card-footer-custom { padding: 15px 20px; border-top: 1px solid #eee; display: flex; justify-content: space-between; align-items: center; background: white; }
        .gender-badge { font-size: 0.8em; padding: 3px 8px; border-radius: 4px; background: #eee; color: #555; }
        
        /* Remove text styles if you had them on .logo and style the image instead */
		.logo img {
    		height: 60px;       
    		width: auto;        
    		vertical-align: middle; 
    		margin-right: 10px; 
		}
    </style>
</head>
<body>

    <div class="custom-navbar">
        <a href="PublicCollegeServlet" class="logo">
    	<img src="images/logo.png" alt="BYTEE Logo"> 
		</a>
        <div class="nav-links">
            <a href="#colleges">Colleges</a>
            <a href="#news">Announcements</a>
            <% 
                // 1. Retrieve User Name AND Role
                String userName = (String) session.getAttribute("user_name");
                String userRole = (String) session.getAttribute("user_role");

                // 2. Check if user is logged in
                if (userName != null) {
                    
                    // 3. Check if Admin
                    if ("Admin".equalsIgnoreCase(userRole)) {
            %>
                        <a href="AdminDashboardServlet" class="btn-login">Admin Panel</a>
            <% 
                    } else { 
            %>
                        <a href="dashboard.jsp" class="btn-login">My Dashboard</a>
            <% 
                    }
                } else { 
            %>
                <a href="Login.jsp" class="btn-login">Login / Register</a>
            <% } %>
        </div>
    </div>

    <div id="byteeSlider" class="carousel slide" data-ride="carousel">
        <ol class="carousel-indicators">
            <li data-target="#byteeSlider" data-slide-to="0" class="active"></li>
            <li data-target="#byteeSlider" data-slide-to="1"></li>
            <li data-target="#byteeSlider" data-slide-to="2"></li>
        </ol>
        <div class="carousel-inner">
            
            <div class="carousel-item active">
                <img src="images/slider1.jpg" class="d-block w-100" alt="Hostel">
                <div class="carousel-caption d-none d-md-block">
                    <h1>Your Home On Campus</h1>
                    <p>Explore dorms, meet roommates, and book your perfect stay.</p>
                    <a href="BookingWizardServlet?step=1" class="cta-btn">Book Your Room Now</a>
                </div>
            </div>

            <div class="carousel-item">
                <img src="images/slider2.jpg" class="d-block w-100" alt="Library">
                <div class="carousel-caption d-none d-md-block">
                    <h1>World Class Facilities</h1>
                    <p>High-speed WiFi, Study Lounges, and 24/7 Security.</p>
                    <a href="#colleges" class="cta-btn">View Colleges</a>
                </div>
            </div>

            <div class="carousel-item">
    <img src="images/slider3.jpg" class="d-block w-100" alt="Students">
    <div class="carousel-caption d-none d-md-block">
        <h1>Join the Community</h1>
        <p>Make lifelong friends in a vibrant student environment.</p>
        
        <% 
            // SMART LINK LOGIC
            // 1. Default destination is Login
            String joinButtonLink = "Login.jsp";
            String joinButtonText = "Join Us Today";
            
            // 2. Check if someone is logged in
            String currentSessionRole = (String) session.getAttribute("user_role");
            String currentSessionUser = (String) session.getAttribute("user_name");

            if (currentSessionUser != null) {
                // 3. Change link based on Role
                if ("Admin".equalsIgnoreCase(currentSessionRole)) {
                    joinButtonLink = "AdminDashboardServlet";
                    joinButtonText = "Go to Admin Panel"; // Optional: Change text for Admin
                } else {
                    joinButtonLink = "dashboard.jsp";
                    joinButtonText = "Go to Dashboard";   // Optional: Change text for Student
                }
            }
        %>
        
        <a href="<%= joinButtonLink %>" class="cta-btn"><%= joinButtonText %></a>
        
    </div>
</div>
        </div>
        
        <a class="carousel-control-prev" href="#byteeSlider" role="button" data-slide="prev">
            <span class="carousel-control-prev-icon" aria-hidden="true"></span>
            <span class="sr-only">Previous</span>
        </a>
        <a class="carousel-control-next" href="#byteeSlider" role="button" data-slide="next">
            <span class="carousel-control-next-icon" aria-hidden="true"></span>
            <span class="sr-only">Next</span>
        </a>
    </div>

    <div id="colleges" class="section">
        <h2>Explore Our Colleges</h2>
        <div class="grid-container">
            <% 
                ResultSet rsC = (ResultSet) request.getAttribute("collegeList");
                if (rsC != null) {
                    while (rsC.next()) {
                        String img = rsC.getString("main_image");
                        if (img == null || img.startsWith("Colleges_Images")) { 
                            img = "https://via.placeholder.com/400x200?text=" + rsC.getString("name").replaceAll(" ", "+");
                        }
            %>
            <div class="custom-card">
                <a href="CollegeDetailServlet?id=<%= rsC.getString("college_id") %>" style="text-decoration: none; color: inherit;">
                    <img src="<%= img %>" alt="College Image">
                    <div class="card-body-custom">
                        <h3 class="card-title-custom"><%= rsC.getString("name") %></h3>
                        <p class="card-text-custom"><%= rsC.getString("description").substring(0, Math.min(rsC.getString("description").length(), 100)) %>...</p>
                    </div>
                </a>
                <div class="card-footer-custom">
                    <span class="gender-badge"><%= rsC.getString("gender_restriction") %> Only</span>
                    <a href="CollegeDetailServlet?id=<%= rsC.getString("college_id") %>" style="color: #007bff; text-decoration: none; font-size: 0.9em;">
                        See Full Details &rarr;
                    </a>
                </div>
            </div>
            <% 
                    }
                } 
            %>
        </div>
    </div>

    <div id="news" class="section" style="background: white;">
        <h2>Latest Announcements</h2>
        <div class="grid-container">
            <% 
                ResultSet rsN = (ResultSet) request.getAttribute("newsList");
                if (rsN != null) {
                    while (rsN.next()) {
            %>
            <div class="custom-card" style="border-left: 5px solid #dc3545;">
                <div class="card-body-custom">
                    <h3 class="card-title-custom" style="color: #333;"><%= rsN.getString("title") %></h3>
                    <p class="card-text-custom"><%= rsN.getString("message") %></p>
                    <small style="color: #999; display: block; margin-top: 10px;">
                        Posted: <%= rsN.getTimestamp("date_posted") %>
                    </small>
                </div>
            </div>
            <% 
                    }
                } 
            %>
        </div>
    </div>
	<div class="section" style="background: #e9ecef; padding: 60px 10%;">
    <div class="container-fluid">
        <div class="row">
            

            <div class="col-md-7">
                <h3 style="color: #007bff; margin-bottom: 20px;">Frequently Asked Questions</h3>
                
                <div class="accordion" id="faqAccordion">
                    
                    <div class="card">
                        <div class="card-header" id="headingOne">
                            <h2 class="mb-0">
                                <button class="btn btn-link btn-block text-left" type="button" data-toggle="collapse" data-target="#collapseOne" aria-expanded="true" aria-controls="collapseOne" style="color: #333; text-decoration: none; font-weight: 600;">
                                    How do I book a room?
                                </button>
                            </h2>
                        </div>
                        <div id="collapseOne" class="collapse show" aria-labelledby="headingOne" data-parent="#faqAccordion">
                            <div class="card-body">
                                First, register for an account. Once logged in, click "Book Now" on the dashboard. You can select your preferred college, block, and room type based on availability.
                            </div>
                        </div>
                    </div>

                    <div class="card">
                        <div class="card-header" id="headingTwo">
                            <h2 class="mb-0">
                                <button class="btn btn-link btn-block text-left collapsed" type="button" data-toggle="collapse" data-target="#collapseTwo" aria-expanded="false" aria-controls="collapseTwo" style="color: #333; text-decoration: none; font-weight: 600;">
                                    Can I change my room after booking?
                                </button>
                            </h2>
                        </div>
                        <div id="collapseTwo" class="collapse" aria-labelledby="headingTwo" data-parent="#faqAccordion">
                            <div class="card-body">
                                You Absolutely can. Just make sure you do it before the reservation deadline
                            </div>
                        </div>
                    </div>

                    <div class="card">
                        <div class="card-header" id="headingThree">
                            <h2 class="mb-0">
                                <button class="btn btn-link btn-block text-left collapsed" type="button" data-toggle="collapse" data-target="#collapseThree" aria-expanded="false" aria-controls="collapseThree" style="color: #333; text-decoration: none; font-weight: 600;">
                                    What if something in my room is broken?
                                </button>
                            </h2>
                        </div>
                        <div id="collapseThree" class="collapse" aria-labelledby="headingThree" data-parent="#faqAccordion">
                            <div class="card-body">
                                Please log in and use the "Report Complaint" feature. Upload a photo of the damage, and our maintenance team will attend to it within 24-48 hours.
                            </div>
                        </div>
                    </div>
                    
                    <div class="card">
                        <div class="card-header" id="headingThree">
                            <h2 class="mb-0">
                                <button class="btn btn-link btn-block text-left collapsed" type="button" data-toggle="collapse" data-target="#collapseThree" aria-expanded="false" aria-controls="collapseThree" style="color: #333; text-decoration: none; font-weight: 600;">
                                    Can I book a room for my friend?
                                </button>
                            </h2>
                        </div>
                        <div id="collapseThree" class="collapse" aria-labelledby="headingThree" data-parent="#faqAccordion">
                            <div class="card-body">
                               No. Each student must log in with their own account to make a reservation. This ensures that our occupancy records are accurate.
                            </div>
                        </div>
                    </div>
                    
                    <div class="card">
                        <div class="card-header" id="headingThree">
                            <h2 class="mb-0">
                                <button class="btn btn-link btn-block text-left collapsed" type="button" data-toggle="collapse" data-target="#collapseThree" aria-expanded="false" aria-controls="collapseThree" style="color: #333; text-decoration: none; font-weight: 600;">
                                    Are the rooms furnished?
                                </button>
                            </h2>
                        </div>
                        <div id="collapseThree" class="collapse" aria-labelledby="headingThree" data-parent="#faqAccordion">
                            <div class="card-body">
                               Yes, all rooms come with a bed, mattress, study desk, chair, and wardrobe for each student. Explore the 360 virtual tour for better visual.
                            </div>
                        </div>
                    </div>

                </div> 
                </div> 
                
                <div class="col-md-5 mb-4">
                <h3 style="color: #007bff; margin-bottom: 20px;">Contact Us</h3>
                <p><strong>Pusat Perumahan Pelajar Bangunan Hal Ehwal Pelajar</strong><br>
                Universiti Sains Islam Malaysia<br>
                Bandar Baru Nilai<br>
                71800, Nilai, Negeri Sembilan, Malaysia</p>
                
                <p>
                    <strong>Tel:</strong> +606-798 6180<br>
                    <strong>Fax:</strong> +606-798 6171<br>
                    <strong>Email:</strong> info.prupel@usim.edu.my.
                </p>
                
                </div>
                
                </div> </div>
</div>
    <div style="background: #333; color: white; padding: 40px; text-align: center;">
    <p>&copy; 2025 BYTEE - Universiti Sains Islam Malaysia</p>
    <p style="font-size: 0.9em;">
        <a href="#" data-toggle="modal" data-target="#tosModal" style="color: #aaa; text-decoration: underline;">Terms of Service</a> 
        &nbsp;|&nbsp; 
        <a href="#" style="color: #aaa; text-decoration: none;">Privacy Policy</a>
    </p>
	</div>
	
	<div class="modal fade" id="tosModal" tabindex="-1" aria-labelledby="tosLabel" aria-hidden="true">
    <div class="modal-dialog modal-lg modal-dialog-scrollable"> <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="tosLabel">Terms of Service - BYTEE Hostel</h5>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <div class="modal-body" style="text-align: left; color: #333;">
                
                <h6>1. Acceptance of Terms</h6>
                <p>By accessing and using the BYTEE Hostel Management System, you agree to comply with and be bound by these terms. This service is provided exclusively for students of Universiti Sains Islam Malaysia (USIM).</p>

                <h6>2. Room Allocation</h6>
                <p>Room assignments are made based on availability and the specific criteria set by the University management. BYTEE reserves the right to reassign rooms or consolidate vacancies if necessary for administrative or maintenance purposes.</p>

                <h6>3. Code of Conduct</h6>
                <p>Residents must adhere to the University's code of conduct. The following are strictly prohibited within hostel premises:</p>
                <ul>
                    <li>Possession or use of illegal substances or alcohol.</li>
                    <li>Smoking inside the rooms or hallways.</li>
                    <li>Excessive noise during quiet hours (11:00 PM - 6:00 AM).</li>
                    <li>Unauthorized guests or subletting of rooms.</li>
                </ul>

                <h6>4. Maintenance & Damages</h6>
                <p>Residents are responsible for the condition of their assigned room. Any damage to furniture, fixtures, or the structure of the room must be reported immediately via the "Complaint" system. Residents may be held financially liable for damages caused by negligence.</p>

                <h6>5. Personal Property</h6>
                <p>BYTEE and the University are not responsible for the loss, theft, or damage of personal belongings. Residents are advised to keep their valuables specific and lock their doors when away.</p>

                <h6>6. Termination of Residency</h6>
                <p>The University reserves the right to terminate the residency of any student found violating these terms or the University's disciplinary rules. In such cases, no refund of hostel fees will be provided.</p>

                <hr>
                <p><small>Last Updated: December 2025</small></p>

            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
            </div>
        </div>
    </div>
</div>

</body>
</html>