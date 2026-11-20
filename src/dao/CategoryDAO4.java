package dao;

import java.sql.*;
import java.util.*;
import model.Category4;

public class CategoryDAO4 extends DAO4 {
    public CategoryDAO4() { super(); }

    // Lay toan bo danh muc loai mon de do vao ComboBox
    public List<Category4> getAllCategory() {
        List<Category4> ds = new ArrayList<>();
        if (con == null) return ds;
        String sql = "SELECT id, name, description FROM tblCategory4 ORDER BY id";
        try (PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Category4 c = new Category4();
                c.setId(rs.getInt("id"));
                c.setName(rs.getString("name"));
                c.setDescription(rs.getString("description"));
                ds.add(c);
            }
        } catch (Exception e) {
            lastError = "Lỗi đọc bảng tblCategory4: " + e.getMessage();
        }
        return ds;
    }
}
