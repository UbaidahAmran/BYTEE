package com.bytee.controller;

import java.io.IOException;
import javax.servlet.*;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

// apply to everything "/*"
@WebFilter("/*") 
public class AuthFilter implements Filter {

    public void doFilter(ServletRequest req, ServletResponse res, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest request = (HttpServletRequest) req;
        HttpServletResponse response = (HttpServletResponse) res;
        HttpSession session = request.getSession(false);

        // 1. Get the current URL
        String uri = request.getRequestURI();
        
        // 2. Define Public Pages (The "Whitelist")
        // These are the ONLY pages a user can see without logging in.
        boolean isStaticResource = uri.contains("/css/") || uri.contains("/images/") || uri.contains("/js/");
        boolean isPublicPage = uri.endsWith("Login.jsp") || 
                               uri.endsWith("register.jsp") || 
                               uri.endsWith("index.jsp") || 
                               uri.endsWith("home.jsp") || 
                               uri.endsWith("forgot_password.jsp") || 
                               uri.endsWith("college_details.jsp") ||
                               uri.endsWith("reset_password.jsp");
        
        
        // Allow the Controller AND the RegisterServlet to process public requests
        boolean isController = uri.contains("Controller") || uri.contains("CollegeDetailServlet") ||uri.contains("RegisterServlet"); 

        // 3. Logic: Are they logged in?
        boolean isLoggedIn = (session != null && session.getAttribute("user_name") != null);

        if (isLoggedIn) {
            // === USER IS LOGGED IN ===
            
            // Fix the "Back Button" Cache Issue globally here
            response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
            response.setHeader("Pragma", "no-cache"); 
            response.setDateHeader("Expires", 0); 

            // If they are logged in but try to go to Login page again, send them to dashboard
            if (uri.endsWith("Login.jsp") || uri.endsWith("register.jsp")) {
                 // Check role to decide where to send them
                 String role = (String) session.getAttribute("role");
                 if ("Admin".equals(role)) response.sendRedirect("admin_home.jsp");
                 else response.sendRedirect("student_home.jsp");
                 return;
            }

            chain.doFilter(request, response); // Let them proceed
            
        } else {
            // === USER IS NOT LOGGED IN ===
            
            // If they are trying to access a public page, let them in.
            if (isPublicPage || isStaticResource || isController) {
                chain.doFilter(request, response);
            } else {
                // If they try to access a private page, kick them to Login
                response.sendRedirect(request.getContextPath() + "/Login.jsp?msg=LoginRequired");
            }
        }
    }

    public void init(FilterConfig f) throws ServletException {}
    public void destroy() {}
}