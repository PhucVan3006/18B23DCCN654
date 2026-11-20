package model;

import java.sql.Timestamp;

// Lop lien ket giua Booking4 va Table4:
// mot dong = mot luot giu mot ban trong mot khoang thoi gian
public class BookedTable4 {
    // cac gia tri hop le cua thuoc tinh seatingStatus
    public static final String BOOKED          = "BOOKED";
    public static final String SERVING         = "SERVING";
    public static final String OVERDUE         = "OVERDUE";
    public static final String PENDING_PAYMENT = "PENDING_PAYMENT";
    public static final String WAITING_TABLE   = "WAITING_TABLE";
    public static final String TABLE_CHANGED   = "TABLE_CHANGED";
    public static final String RETURNED        = "RETURNED";
    public static final String NO_SHOW         = "NO_SHOW";
    public static final String CANCELLED       = "CANCELLED";

    // cac trang thai con chiem cho cua ban (dung khi kiem tra trung khung gio)
    public static final String[] OCCUPYING =
        { BOOKED, SERVING, OVERDUE, PENDING_PAYMENT, WAITING_TABLE };

    // cac trang thai khach con ngoi tai ban (chua tra ban) -> moc chan bi day dong
    public static final String[] GUEST_PRESENT = { OVERDUE, PENDING_PAYMENT };

    private int id;
    private Timestamp startTime;
    private Timestamp endTime;        // = startTime + duration + 15 phut dem
    private Timestamp actualEndTime;  // null neu khach chua tra ban
    private String seatingStatus = BOOKED;
    private Booking4 booking;
    private Table4 table;

    public BookedTable4() { }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public Timestamp getStartTime() { return startTime; }
    public void setStartTime(Timestamp startTime) { this.startTime = startTime; }
    public Timestamp getEndTime() { return endTime; }
    public void setEndTime(Timestamp endTime) { this.endTime = endTime; }
    public Timestamp getActualEndTime() { return actualEndTime; }
    public void setActualEndTime(Timestamp actualEndTime) { this.actualEndTime = actualEndTime; }
    public String getSeatingStatus() { return seatingStatus; }
    public void setSeatingStatus(String seatingStatus) { this.seatingStatus = seatingStatus; }
    public Booking4 getBooking() { return booking; }
    public void setBooking(Booking4 booking) { this.booking = booking; }
    public Table4 getTable() { return table; }
    public void setTable(Table4 table) { this.table = table; }

    // Luot nay da qua gio du kien ma chua tra ban hay chua?
    public boolean isOverdue() {
        if (actualEndTime != null || endTime == null) return false;
        return System.currentTimeMillis() > endTime.getTime();
    }

    // Chi duoc tra ban khi da sang "Cho thanh toan": khach an xong moi thanh toan,
    // module Thanh toan ghi Bill4.payTime roi moi cho phep tra ban.
    public boolean canCheckOut() {
        return PENDING_PAYMENT.equals(seatingStatus);
    }
}
