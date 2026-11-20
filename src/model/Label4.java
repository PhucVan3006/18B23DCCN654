package model;

import java.util.LinkedHashMap;
import java.util.Map;

/**
 * Anh xa ma trang thai (luu trong CSDL, tieng Anh) sang nhan hien thi tieng Viet.
 * CSDL va ma nguon chi lam viec voi ma; moi chuoi tieng Viet nguoi dung nhin thay
 * deu di qua lop nay, nen doi nhan hien thi khong phai sua du lieu.
 */
public class Label4 {

    // seatingStatus cua BookedTable4
    public static final Map<String, String> SEATING = new LinkedHashMap<>();
    // bookingStatus cua Booking4
    public static final Map<String, String> BOOKING = new LinkedHashMap<>();
    // saleStatus cua Dish4
    public static final Map<String, String> SALE = new LinkedHashMap<>();

    static {
        SEATING.put(BookedTable4.BOOKED,          "Đã đặt");
        SEATING.put(BookedTable4.SERVING,         "Đang phục vụ");
        SEATING.put(BookedTable4.OVERDUE,         "Quá giờ");
        SEATING.put(BookedTable4.PENDING_PAYMENT, "Chờ thanh toán");
        SEATING.put(BookedTable4.WAITING_TABLE,   "Chờ xếp bàn");
        SEATING.put(BookedTable4.TABLE_CHANGED,   "Đã đổi bàn");
        SEATING.put(BookedTable4.RETURNED,        "Đã trả bàn");
        SEATING.put(BookedTable4.NO_SHOW,         "Khách không đến");
        SEATING.put(BookedTable4.CANCELLED,       "Đã huỷ");

        BOOKING.put(Booking4.PENDING,          "Chờ xác nhận");
        BOOKING.put(Booking4.CONFIRMED,        "Đã xác nhận");
        BOOKING.put(Booking4.PENDING_PAYMENT,  "Chờ thanh toán");
        BOOKING.put(Booking4.COMPLETED,        "Hoàn thành");
        BOOKING.put(Booking4.COMPLETED_UNPAID, "Hoàn thành - có công nợ");
        BOOKING.put(Booking4.CANCELLED,        "Đã huỷ");

        SALE.put(Dish4.ON_SALE,  "Đang bán");
        SALE.put(Dish4.OFF_SALE, "Ngừng bán");
    }

    public static String seating(String code) { return get(SEATING, code); }
    public static String booking(String code) { return get(BOOKING, code); }
    public static String sale(String code)    { return get(SALE, code); }

    private static String get(Map<String, String> m, String code) {
        if (code == null) return "";
        String s = m.get(code);
        return s != null ? s : code;
    }

    private Label4() { }
}
