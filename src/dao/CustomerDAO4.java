package dao;

import java.sql.*;
import model.Customer4;

public class CustomerDAO4 extends DAO4 {
    public CustomerDAO4() { super(); }

    // Tim khach hang theo so dien thoai (khach cu thi khong tao ban ghi moi)
    public Customer4 getCustomerByPhone(String phone) {
        if (con == null) return null;
        String sql = "SELECT m.id, m.name, m.phone, m.email, c.customerCode " +
                     "FROM tblMember4 m JOIN tblCustomer4 c ON m.id = c.id " +
                     "WHERE m.phone = ?";
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, phone);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Customer4 customer = new Customer4();
                    customer.setId(rs.getInt("id"));
                    customer.setName(rs.getString("name"));
                    customer.setPhone(rs.getString("phone"));
                    customer.setEmail(rs.getString("email"));
                    customer.setCustomerCode(rs.getString("customerCode"));
                    return customer;
                }
            }
        } catch (Exception e) {
            lastError = "Lỗi tìm khách hàng: " + e.getMessage();
        }
        return null;
    }

    // Luu khach hang moi: ghi vao tblMember4 roi ghi tiep tblCustomer4
    // (quan he ke thua duoc cai dat bang khoa chinh dong thoi la khoa ngoai)
    public int insertCustomer(Customer4 customer) {
        if (con == null) return -1;
        String sqlM = "INSERT INTO tblMember4(username, password, name, email, phone, role) " +
                      "VALUES(?, ?, ?, ?, ?, 'CUSTOMER')";
        try {
            con.setAutoCommit(false);
            int id;
            try (PreparedStatement ps = con.prepareStatement(sqlM, Statement.RETURN_GENERATED_KEYS)) {
                ps.setString(1, "kh" + customer.getPhone());
                ps.setString(2, customer.getPhone());      // mat khau mac dinh
                ps.setString(3, customer.getName());
                ps.setString(4, customer.getEmail());
                ps.setString(5, customer.getPhone());
                ps.executeUpdate();
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (!rs.next()) { con.rollback(); return -1; }
                    id = rs.getInt(1);
                }
            }
            try (PreparedStatement ps = con.prepareStatement(
                    "INSERT INTO tblCustomer4(id, customerCode) VALUES(?, ?)")) {
                ps.setInt(1, id);
                ps.setString(2, String.format("KH%04d", id));
                ps.executeUpdate();
            }
            con.commit();
            customer.setId(id);
            return id;
        } catch (Exception e) {
            try { con.rollback(); } catch (Exception ignored) { }
            lastError = "Lỗi lưu khách hàng: " + e.getMessage();
            return -1;
        } finally {
            try { con.setAutoCommit(true); } catch (Exception ignored) { }
        }
    }
}
