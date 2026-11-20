package dao;

import java.sql.Connection;
import java.sql.DriverManager;

// Lop cha cua tang truy cap du lieu: giu mot ket noi dung chung
// cho moi lop DAO4 con (dung lai thiet ke o Hinh bieu do lop thiet ke).
public class DAO4 {
    protected Connection con;

    // Loi ket noi gan nhat, de cac trang .jsp hien thi cho nguoi dung
    public static String lastError = null;

    private static final String URL =
        "jdbc:mysql://localhost:3306/restman?useUnicode=true&characterEncoding=UTF-8&serverTimezone=Asia/Ho_Chi_Minh";
    private static final String USER = "root";
    private static final String PASS = "";

    public DAO4() {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            con = DriverManager.getConnection(URL, USER, PASS);
            lastError = null;
        } catch (ClassNotFoundException e) {
            lastError = "Không tìm thấy driver MySQL. Hãy chép mysql-connector-j-8.x.jar vào WEB-INF/lib.";
        } catch (Exception e) {
            lastError = "Không kết nối được CSDL restman: " + e.getMessage();
        }
    }

    public Connection getConnection() { return con; }

    public void closeConnection() {
        try { if (con != null) con.close(); } catch (Exception ignored) { }
    }
}
