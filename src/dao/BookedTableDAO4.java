package dao;

import java.sql.*;
import java.util.*;
import model.BookedTable4;
import model.Booking4;
import model.Table4;

public class BookedTableDAO4 extends DAO4 {
    public BookedTableDAO4() { super(); }

    /**
     * Kiem tra lai ban con trong trong khoang [startTime, endTime) hay khong.
     * Goi ngay truoc khi ghi du lieu de tranh truong hop hai khach cung
     * dat mot ban trong cung mot khung gio.
     */
    public boolean checkTableAvailable(int idTable, Timestamp startTime, Timestamp endTime) {
        if (con == null) return false;
        StringBuilder inList = new StringBuilder();
        for (int i = 0; i < BookedTable4.OCCUPYING.length; i++)
            inList.append(i == 0 ? "?" : ",?");
        String sql = "SELECT COUNT(*) FROM tblBookedTable4 " +
                     "WHERE idTable4 = ? AND seatingStatus IN (" + inList + ") " +
                     "  AND startTime < ? " +
                     // gio ket thuc hieu luc, giong TableDAO4.getBanTrong
                     "  AND COALESCE(actualEndTime, " +
                     "        IF(seatingStatus IN ('" + BookedTable4.OVERDUE + "','" +
                                  BookedTable4.PENDING_PAYMENT + "'), " +
                     "           GREATEST(endTime, NOW() + INTERVAL 15 MINUTE), " +
                     "           endTime)) > ?";
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            int i = 1;
            ps.setInt(i++, idTable);
            for (String st : BookedTable4.OCCUPYING) ps.setString(i++, st);
            ps.setTimestamp(i++, endTime);
            ps.setTimestamp(i++, startTime);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1) == 0;
            }
        } catch (Exception e) {
            lastError = "Lỗi kiểm tra bàn trống: " + e.getMessage();
        }
        return false;
    }

    // Ghi chi tiet mot ban duoc giu cho phieu dat ban
    public boolean saveBookedTable(BookedTable4 bt) {
        if (con == null) return false;
        String sql = "INSERT INTO tblBookedTable4(startTime, endTime, seatingStatus, idBooking4, idTable4) " +
                     "VALUES(?, ?, ?, ?, ?)";
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setTimestamp(1, bt.getStartTime());
            ps.setTimestamp(2, bt.getEndTime());
            ps.setString(3, bt.getSeatingStatus());
            ps.setInt(4, bt.getBooking().getId());
            ps.setInt(5, bt.getTable().getId());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            lastError = "Lỗi lưu chi tiết bàn đặt: " + e.getMessage();
            return false;
        }
    }

    // Cac luot dang phuc vu ma da qua gio du kien, kem luot dat ke tiep (neu co)
    public List<BookedTable4> getOverdueTables() {
        List<BookedTable4> ds = new ArrayList<>();
        if (con == null) return ds;
        String sql = "SELECT bt.id, bt.startTime, bt.endTime, bt.actualEndTime, bt.seatingStatus, " +
                     "       t.id AS idBan, t.name AS tenBan, t.capacity " +
                     "FROM tblBookedTable4 bt JOIN tblTable4 t ON bt.idTable4 = t.id " +
                     "WHERE bt.actualEndTime IS NULL " +
                     "  AND bt.seatingStatus IN ('SERVING','OVERDUE','PENDING_PAYMENT') " +
                     "  AND bt.endTime < NOW() " +
                     "ORDER BY bt.endTime";
        try (PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) ds.add(read(rs));
        } catch (Exception e) {
            lastError = "Lỗi đọc danh sách bàn quá giờ: " + e.getMessage();
        }
        return ds;
    }

    // Cac luot dat dang chiem cho trong ngay, dung de ve so do ban
    public List<BookedTable4> getBookedTablesOfDay(java.sql.Date date) {
        List<BookedTable4> ds = new ArrayList<>();
        if (con == null) return ds;
        String sql = "SELECT bt.id, bt.startTime, bt.endTime, bt.actualEndTime, bt.seatingStatus, " +
                     "       t.id AS idBan, t.name AS tenBan, t.capacity " +
                     "FROM tblBookedTable4 bt JOIN tblTable4 t ON bt.idTable4 = t.id " +
                     "WHERE DATE(bt.startTime) = ? " +
                     "  AND bt.seatingStatus IN ('BOOKED','SERVING','OVERDUE'," +
                     "                           'PENDING_PAYMENT','WAITING_TABLE') " +
                     "ORDER BY bt.startTime";
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setDate(1, date);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) ds.add(read(rs));
            }
        } catch (Exception e) {
            lastError = "Lỗi đọc lượt đặt trong ngày: " + e.getMessage();
        }
        return ds;
    }

    private BookedTable4 read(ResultSet rs) throws SQLException {
        BookedTable4 bt = new BookedTable4();
        bt.setId(rs.getInt("id"));
        bt.setStartTime(rs.getTimestamp("startTime"));
        bt.setEndTime(rs.getTimestamp("endTime"));
        bt.setActualEndTime(rs.getTimestamp("actualEndTime"));
        bt.setSeatingStatus(rs.getString("seatingStatus"));
        Table4 b = new Table4();
        b.setId(rs.getInt("idBan"));
        b.setName(rs.getString("tenBan"));
        b.setCapacity(rs.getInt("capacity"));
        bt.setTable(b);
        bt.setBooking(new Booking4());
        return bt;
    }

    // Trang thai hien tai cua mot luot dat
    public String getSeatingStatus(int id) {
        if (con == null) return null;
        try (PreparedStatement ps = con.prepareStatement(
                "SELECT seatingStatus FROM tblBookedTable4 WHERE id = ?")) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getString(1);
            }
        } catch (Exception e) {
            lastError = "Lỗi đọc trạng thái lượt đặt: " + e.getMessage();
        }
        return null;
    }

    // Chuyen trang thai mot luot dat (nhan ban, tra ban, huy, khach khong den...)
    public boolean updateSeatingStatus(int id, String status) {
        if (con == null) return false;
        boolean traBan = BookedTable4.RETURNED.equals(status);
        // Khach an xong moi thanh toan: chi cho tra ban khi luot dat da sang
        // "Cho thanh toan" (module Thanh toan da ghi Bill4.payTime).
        if (traBan && !BookedTable4.PENDING_PAYMENT.equals(getSeatingStatus(id))) {
            lastError = "Phải thanh toán hoá đơn trước khi trả bàn.";
            return false;
        }
        String sql = traBan
            ? "UPDATE tblBookedTable4 SET seatingStatus = ?, actualEndTime = NOW() WHERE id = ?"
            : "UPDATE tblBookedTable4 SET seatingStatus = ? WHERE id = ?";
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, id);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            lastError = "Lỗi cập nhật trạng thái lượt đặt: " + e.getMessage();
            return false;
        }
    }

    // Doi sang ban khac khi ban cu chua duoc tra
    public boolean changeTable(int idBookedTable, int idNewTable) {
        if (con == null) return false;
        try (PreparedStatement ps = con.prepareStatement(
                "UPDATE tblBookedTable4 SET idTable4 = ?, seatingStatus = ? WHERE id = ?")) {
            ps.setInt(1, idNewTable);
            ps.setString(2, BookedTable4.TABLE_CHANGED);
            ps.setInt(3, idBookedTable);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            lastError = "Lỗi đổi bàn: " + e.getMessage();
            return false;
        }
    }
}
