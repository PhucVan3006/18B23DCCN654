package model;

// Lop thuc the Staff4 - nhan vien, ke thua Member4.
// Nhan vien quan li / kho / ban hang phan biet nhau bang thuoc tinh role cua lop cha.
public class Staff4 extends Member4 {
    private String position;

    public Staff4() { }

    public String getPosition() { return position; }
    public void setPosition(String position) { this.position = position; }
}
