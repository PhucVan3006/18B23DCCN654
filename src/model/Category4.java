package model;

// Lop thuc the Category4 - loai mon an
public class Category4 {
    private int id;
    private String name;
    private String description;

    public Category4() { }
    public Category4(int id, String name) { this.id = id; this.name = name; }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
}
