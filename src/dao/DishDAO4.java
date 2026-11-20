package dao;

import java.sql.*;
import java.util.*;
import model.Category4;
import model.Dish4;

public class DishDAO4 extends DAO4 {
    public DishDAO4() { super(); }

    private Dish4 read(ResultSet rs) throws SQLException {
        Dish4 m = new Dish4();
        m.setId(rs.getInt("id"));
        m.setName(rs.getString("name"));
        m.setPrice(rs.getDouble("price"));
        m.setDescription(rs.getString("description"));
        m.setSaleStatus(rs.getString("saleStatus"));
        m.setImage(rs.getString("image"));
        m.setCategory(new Category4(rs.getInt("idCategory4"), rs.getString("tenLoai")));
        return m;
    }

    private static final String SELECT_BASE =
        "SELECT d.id, d.name, d.price, d.description, d.saleStatus, d.image, " +
        "       d.idCategory4, c.name AS tenLoai " +
        "FROM tblDish4 d LEFT JOIN tblCategory4 c ON d.idCategory4 = c.id ";

    // Lay danh sach toan bo mon an
    public List<Dish4> getAllDish() {
        List<Dish4> ds = new ArrayList<>();
        if (con == null) return ds;
        try (PreparedStatement ps = con.prepareStatement(SELECT_BASE + "ORDER BY d.id");
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) ds.add(read(rs));
        } catch (Exception e) {
            lastError = "Lỗi đọc bảng tblDish4: " + e.getMessage();
        }
        return ds;
    }

    // Tim mon an theo tu khoa (chuc nang tim kiem tren man hinh danh sach)
    public List<Dish4> searchByKeyword(String keyword) {
        List<Dish4> ds = new ArrayList<>();
        if (con == null) return ds;
        try (PreparedStatement ps = con.prepareStatement(
                SELECT_BASE + "WHERE d.name LIKE ? ORDER BY d.id")) {
            ps.setString(1, "%" + keyword + "%");
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) ds.add(read(rs));
            }
        } catch (Exception e) {
            lastError = "Lỗi tìm kiếm món ăn: " + e.getMessage();
        }
        return ds;
    }

    // Tim mon an theo ten - dung de kiem tra trung ten truoc khi them
    public Dish4 getDishByName(String name) {
        if (con == null) return null;
        try (PreparedStatement ps = con.prepareStatement(SELECT_BASE + "WHERE d.name = ?")) {
            ps.setString(1, name);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return read(rs);
            }
        } catch (Exception e) {
            lastError = "Lỗi kiểm tra trùng tên món ăn: " + e.getMessage();
        }
        return null;
    }

    // Ghi mot mon an moi vao bang tblDish4
    public boolean insertDish(Dish4 dish) {
        if (con == null) return false;
        String sql = "INSERT INTO tblDish4(name, price, description, saleStatus, image, idCategory4) " +
                     "VALUES(?, ?, ?, ?, ?, ?)";
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, dish.getName());
            ps.setDouble(2, dish.getPrice());
            ps.setString(3, dish.getDescription());
            ps.setString(4, dish.getSaleStatus());
            ps.setString(5, dish.getImage());
            if (dish.getCategory() != null) ps.setInt(6, dish.getCategory().getId());
            else ps.setNull(6, Types.INTEGER);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            lastError = "Lỗi ghi món ăn mới: " + e.getMessage();
            return false;
        }
    }
}
