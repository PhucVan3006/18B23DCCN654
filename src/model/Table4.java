package model;

// Lop thuc the Table4 - ban an
public class Table4 {
    private int id;
    private String name;
    private int capacity;
    private String tableType;
    // Ban con dung duoc hay khong (ban hong / dang sua chua thi false).
    // "Trong" hay "Dang phuc vu" KHONG luu o day vi suy ra duoc tu tblBookedTable4.
    private boolean usable = true;
    private Area4 area;         // thuoc tinh kieu doi tuong

    public Table4() { }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    public int getCapacity() { return capacity; }
    public void setCapacity(int capacity) { this.capacity = capacity; }
    public String getTableType() { return tableType; }
    public void setTableType(String tableType) { this.tableType = tableType; }
    public boolean isUsable() { return usable; }
    public void setUsable(boolean usable) { this.usable = usable; }
    public Area4 getArea() { return area; }
    public void setArea(Area4 area) { this.area = area; }
}
