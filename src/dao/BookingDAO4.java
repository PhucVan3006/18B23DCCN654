package dao;

import java.sql.*;
import model.Booking4;

public class BookingDAO4 extends DAO4 {
    public BookingDAO4() { super(); }

    // Ghi phieu dat ban, tra ve id vua sinh (-1 neu error)
    public int saveBooking(Booking4 booking) {
        if (con == null) return -1;
        String sql = "INSERT INTO tblBooking4(bookingCode, bookingTime, arrivalTime, " +
                     "numGuest, duration, bookingStatus, note, idCustomer4) " +
                     "VALUES(?, NOW(), ?, ?, ?, ?, ?, ?)";
        try (PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, booking.getBookingCode());
            ps.setTimestamp(2, booking.getArrivalTime());
            ps.setInt(3, booking.getNumGuest());
            ps.setInt(4, booking.getDuration());
            ps.setString(5, booking.getBookingStatus());
            ps.setString(6, booking.getNote());
            ps.setInt(7, booking.getCustomer().getId());
            ps.executeUpdate();
            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) {
                    booking.setId(rs.getInt(1));
                    return booking.getId();
                }
            }
        } catch (Exception e) {
            lastError = "Lỗi lưu phiếu đặt bàn: " + e.getMessage();
        }
        return -1;
    }

    // Sinh ma dat ban dang DByyyyMMdd-xxx
    public String generateBookingCode(java.util.Date arrivalDate) {
        java.text.SimpleDateFormat f = new java.text.SimpleDateFormat("yyyyMMdd");
        int stt = 1;
        if (con != null) {
            try (PreparedStatement ps = con.prepareStatement(
                    "SELECT COUNT(*) FROM tblBooking4 WHERE DATE(arrivalTime) = DATE(?)")) {
                ps.setTimestamp(1, new Timestamp(arrivalDate.getTime()));
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) stt = rs.getInt(1) + 1;
                }
            } catch (Exception ignored) { }
        }
        return "DB" + f.format(arrivalDate) + "-" + String.format("%03d", stt);
    }
}
