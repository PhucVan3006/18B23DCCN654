package dao;

import java.sql.*;
import java.util.*;
import model.Area4;
import model.BookedTable4;
import model.Table4;

public class TableDAO4 extends DAO4 {
    public TableDAO4() { super(); }

    private Table4 read(ResultSet rs) throws SQLException {
        Table4 b = new Table4();
        b.setId(rs.getInt("id"));
        b.setName(rs.getString("name"));
        b.setCapacity(rs.getInt("capacity"));
        b.setTableType(rs.getString("tableType"));
        b.setUsable(rs.getBoolean("usable"));
        b.setArea(new Area4(rs.getInt("idArea4"), rs.getString("tenKhuVuc")));
        return b;
    }

    private static final String SELECT_BASE =
        "SELECT t.id, t.name, t.capacity, t.tableType, t.usable, " +
        "       t.idArea4, a.name AS tenKhuVuc " +
        "FROM tblTable4 t LEFT JOIN tblArea4 a ON t.idArea4 = a.id ";

    /**
     * Tim cac ban con trong trong khoang [startTime, endTime).
     *
     * Dieu kien hai khoang thoi gian giao nhau:
     *     cu.startTime < moi.endTime  AND  cu.endTime > moi.startTime
     * Ban bi loai neu dang co mot luot dat giao khung gio va luot do
     * van con chiem cho (Da dat / Dang phuc vu / Qua gio / Cho xep ban).
     *
     * @param idArea 0 nghia la khong loc theo khu vuc
     */
    public List<Table4> getAvailableTables(Timestamp startTime, Timestamp endTime,
                                    int numGuest, int idArea) {
        List<Table4> ds = new ArrayList<>();
        if (con == null) return ds;

        StringBuilder inList = new StringBuilder();
        for (int i = 0; i < BookedTable4.OCCUPYING.length; i++)
            inList.append(i == 0 ? "?" : ",?");

        String sql = SELECT_BASE +
            "WHERE t.capacity >= ? AND t.usable = TRUE " +
            "  AND (? = 0 OR t.idArea4 = ?) " +
            "  AND t.id NOT IN ( " +
            "        SELECT bt.idTable4 FROM tblBookedTable4 bt " +
            "        WHERE bt.seatingStatus IN (" + inList + ") " +
            "          AND bt.startTime < ? " +
            // Gio ket thuc HIEU LUC: da tra ban thi lay gio thuc te; con dang qua gio
            // hoac cho thanh toan thi moc chan tu day len NOW() + 15' cho tron bua.
            "          AND COALESCE(bt.actualEndTime, " +
            "                IF(bt.seatingStatus IN ('" + BookedTable4.OVERDUE + "','" +
                                  BookedTable4.PENDING_PAYMENT + "'), " +
            "                   GREATEST(bt.endTime, NOW() + INTERVAL 15 MINUTE), " +
            "                   bt.endTime)) > ? ) " +
            "ORDER BY t.capacity, t.id";

        try (PreparedStatement ps = con.prepareStatement(sql)) {
            int i = 1;
            ps.setInt(i++, numGuest);
            ps.setInt(i++, idArea);
            ps.setInt(i++, idArea);
            for (String st : BookedTable4.OCCUPYING) ps.setString(i++, st);
            ps.setTimestamp(i++, endTime);     // cu.startTime < moi.endTime
            ps.setTimestamp(i++, startTime);   // cu.endTime   > moi.startTime
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) ds.add(read(rs));
            }
        } catch (Exception e) {
            lastError = "Lỗi tìm bàn trống: " + e.getMessage();
        }
        return ds;
    }

    public Table4 getTableById(int id) {
        if (con == null) return null;
        try (PreparedStatement ps = con.prepareStatement(SELECT_BASE + "WHERE t.id = ?")) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return read(rs);
            }
        } catch (Exception e) {
            lastError = "Lỗi đọc thông tin bàn: " + e.getMessage();
        }
        return null;
    }

    public List<Table4> getAllTable() {
        List<Table4> ds = new ArrayList<>();
        if (con == null) return ds;
        try (PreparedStatement ps = con.prepareStatement(SELECT_BASE + "ORDER BY t.id");
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) ds.add(read(rs));
        } catch (Exception e) {
            lastError = "Lỗi đọc bảng tblTable4: " + e.getMessage();
        }
        return ds;
    }

    // Dong hoac mo lai mot ban (ban hong, dang sua chua)
    public boolean updateTableUsable(int idTable, boolean usable) {
        if (con == null) return false;
        try (PreparedStatement ps = con.prepareStatement(
                "UPDATE tblTable4 SET usable = ? WHERE id = ?")) {
            ps.setBoolean(1, usable);
            ps.setInt(2, idTable);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            lastError = "Lỗi cập nhật tình trạng bàn: " + e.getMessage();
            return false;
        }
    }
}
