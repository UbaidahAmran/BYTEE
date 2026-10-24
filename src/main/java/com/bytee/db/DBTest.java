package com.bytee.db;

import java.sql.Connection;
import java.sql.DriverManager;

public class DBTest {
    public static void main(String[] args) {
        // Database credentials
    	String url = "jdbc:mysql://localhost:3306/bytee_db?useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true";
        String user = "bytee_user";
        String password = "CHANGE_ME"; // The password you set in the SQL script

        System.out.println("Connecting to database...");

        try {
            // 1. Load the MySQL Driver
            // This checks if the JAR is correctly found in Tomcat/lib
            Class.forName("com.mysql.cj.jdbc.Driver");
            
            // 2. Open the connection
            Connection conn = DriverManager.getConnection(url, user, password);
            
            if (conn != null) {
                System.out.println("SUCCESS! You are connected to 'bytee_db'.");
                conn.close();
            }
            
        } catch (ClassNotFoundException e) {
            System.out.println("ERROR: MySQL Driver not found!");
            System.out.println("Make sure the mysql-connector jar is in Tomcat/lib and you restarted Eclipse.");
            e.printStackTrace();
        } catch (Exception e) {
            System.out.println("ERROR: Connection failed!");
            e.printStackTrace();
        }
    }
}