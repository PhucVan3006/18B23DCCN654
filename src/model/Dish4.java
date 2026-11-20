package model;

// Lop thuc the Dish4 - mon an trong thuc don
public class Dish4 {
    // cac gia tri hop le cua thuoc tinh saleStatus
    public static final String ON_SALE  = "ON_SALE";
    public static final String OFF_SALE = "OFF_SALE";

    private int id;
    private String name;
    private double price;
    private String description;
    private String saleStatus;   // Dang ban / Ngung ban
    private String image;         // ten tep anh minh hoa
    private Category4 category;       // thuoc tinh kieu doi tuong

    public Dish4() { }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    public double getPrice() { return price; }
    public void setPrice(double price) { this.price = price; }
    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
    public String getSaleStatus() { return saleStatus; }
    public void setSaleStatus(String saleStatus) { this.saleStatus = saleStatus; }
    public String getImage() { return image; }
    public void setImage(String image) { this.image = image; }
    public Category4 getCategory() { return category; }
    public void setCategory(Category4 category) { this.category = category; }
}
