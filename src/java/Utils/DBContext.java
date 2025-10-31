package Utils;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBContext {

    private static final String DB_NAME = "rms_db";
    private static final String USER_NAME = "sa";
    private static final String PASSWORD = "123";
    private static final String HOST = "localhost";
    private static final String PORT = "1433";

    protected Connection connection;

    public DBContext() {
        try {
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
            String url = "jdbc:sqlserver://" + HOST + ":" + PORT
                    + ";databaseName=" + DB_NAME
                    + ";encrypt=true;trustServerCertificate=true";
            connection = DriverManager.getConnection(url, USER_NAME, PASSWORD);
            System.out.println("[DB] Connected successfully");
        } catch (ClassNotFoundException | SQLException e) {
            System.out.println("[DB] Connection failed: " + e.getMessage());
        }
    }

    public void close() {
        try {
            if (connection != null && !connection.isClosed()) {
                connection.close();
            }
        } catch (SQLException e) {
            System.out.println("[DB] Close connection failed: " + e.getMessage());
        }
    }

    public static void main(String[] args) {
        DBContext db = new DBContext();
        try {
            if (db.connection != null && !db.connection.isClosed()) {
                System.out.println(" Kết nối thành công tới database: " + DB_NAME);
                System.out.println(" User: " + USER_NAME);
                System.out.println(" URL: jdbc:sqlserver://" + HOST + ":" + PORT + ";databaseName=" + DB_NAME);

                var stmt = db.connection.createStatement();
                var rs = stmt.executeQuery("SELECT COUNT(*) AS total FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_TYPE='BASE TABLE'");
                if (rs.next()) {
                    System.out.println(" Tổng số bảng trong DB: " + rs.getInt("total"));
                }

                rs.close();
                stmt.close();
            } else {
                System.out.println(" Không thể kết nối tới database!");
            }
        } catch (Exception e) {
            System.out.println("️ Lỗi khi test kết nối: " + e.getMessage());
            e.printStackTrace();
        } finally {
            db.close();
            System.out.println(" Đã đóng kết nối.");
        }
    }
}
