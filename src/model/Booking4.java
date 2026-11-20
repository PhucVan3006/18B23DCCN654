package model;

import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

// Lop thuc the Booking4 - phieu dat ban
public class Booking4 {
    // cac gia tri hop le cua thuoc tinh bookingStatus
    public static final String PENDING          = "PENDING";
    public static final String CONFIRMED        = "CONFIRMED";
    public static final String PENDING_PAYMENT  = "PENDING_PAYMENT";
    public static final String COMPLETED        = "COMPLETED";
    public static final String COMPLETED_UNPAID = "COMPLETED_UNPAID";
    public static final String CANCELLED        = "CANCELLED";

    private int id;
    private String bookingCode;
    private Timestamp bookingTime;   // thoi diem lap phieu
    private Timestamp arrivalTime;   // gio khach den
    private int numGuest;
    private int duration = 90;       // thoi luong du kien (phut)
    private String bookingStatus;    // Cho xac nhan / Da xac nhan / Da huy / Hoan thanh
    private String note;
    private Customer4 customer;
    private Staff4 staff;                                   // nhan vien xac nhan phieu
    private List<BookedTable4> bookedTables = new ArrayList<>();

    public Booking4() { }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public String getBookingCode() { return bookingCode; }
    public void setBookingCode(String bookingCode) { this.bookingCode = bookingCode; }
    public Timestamp getBookingTime() { return bookingTime; }
    public void setBookingTime(Timestamp bookingTime) { this.bookingTime = bookingTime; }
    public Timestamp getArrivalTime() { return arrivalTime; }
    public void setArrivalTime(Timestamp arrivalTime) { this.arrivalTime = arrivalTime; }
    public int getNumGuest() { return numGuest; }
    public void setNumGuest(int numGuest) { this.numGuest = numGuest; }
    public int getDuration() { return duration; }
    public void setDuration(int duration) { this.duration = duration; }
    public String getBookingStatus() { return bookingStatus; }
    public void setBookingStatus(String bookingStatus) { this.bookingStatus = bookingStatus; }
    public String getNote() { return note; }
    public void setNote(String note) { this.note = note; }
    public Customer4 getCustomer() { return customer; }
    public void setCustomer(Customer4 customer) { this.customer = customer; }
    public Staff4 getStaff() { return staff; }
    public void setStaff(Staff4 staff) { this.staff = staff; }
    public List<BookedTable4> getBookedTables() { return bookedTables; }
    public void setBookedTables(List<BookedTable4> bookedTables) { this.bookedTables = bookedTables; }
}
