<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // Automatically forward the user to the Servlet
    // The Servlet will fetch the data and then load 'home.jsp'
    request.getRequestDispatcher("PublicCollegeServlet").forward(request, response);
%>