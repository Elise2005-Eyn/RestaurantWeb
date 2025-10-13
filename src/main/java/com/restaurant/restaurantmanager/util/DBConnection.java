package com.restaurant.restaurantmanager.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {
    private static final String URL = "jdbc:sqlserver://NGOC\\SQLEXPRESS10;databaseName=restaurant_db;encrypt=true;trustServerCertificate=true;";
    private static final String USER = "sa";
    private static final String PASS = "123456";

    public static Connection getConnection() throws SQLException {
        try {
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
        } catch (ClassNotFoundException ex) {
            throw new SQLException("Khong tim thay JDBC Driver!", ex);
        }
        return DriverManager.getConnection(URL, USER, PASS);
    }
}
