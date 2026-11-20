package dao;

import java.sql.*;
import java.util.*;
import model.Area4;

public class AreaDAO4 extends DAO4 {
    public AreaDAO4() { super(); }

    // Lay danh sach khu vuc de do vao ComboBox tren man hinh tim ban trong
    public List<Area4> getAllArea() {
        List<Area4> ds = new ArrayList<>();
        if (con == null) return ds;
        String sql = "SELECT id, name, description FROM tblArea4 ORDER BY id";
        try (PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Area4 a = new Area4();
                a.setId(rs.getInt("id"));
                a.setName(rs.getString("name"));
                a.setDescription(rs.getString("description"));
                ds.add(a);
            }
        } catch (Exception e) {
            lastError = "Lỗi đọc bảng tblArea4: " + e.getMessage();
        }
        return ds;
    }
}
