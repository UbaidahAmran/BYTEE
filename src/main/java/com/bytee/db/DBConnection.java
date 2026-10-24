package com.bytee.db;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {
    // Centralized configuration
    private static final String URL = "jdbc:mysql://localhost:3306/bytee_db?useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true";
    private static final String USER = "bytee_user";
    private static final String PASSWORD = "CHANGE_ME";

    // A simple method to give us a connection whenever we ask
    public static Connection getConnection() throws ClassNotFoundException, SQLException {
        Class.forName("com.mysql.cj.jdbc.Driver");
        return DriverManager.getConnection(URL, USER, PASSWORD);
    }
}