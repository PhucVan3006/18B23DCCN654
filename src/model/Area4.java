package model;

// Lop thuc the Area4 - khu vuc dat ban trong nha hang
import java.util.ArrayList;
import java.util.List;

public class Area4 {
    private int id;
    private String name;
    private String description;
    private List<Table4> tables = new ArrayList<>();

    public Area4() { }
    public Area4(int id, String name) { this.id = id; this.name = name; }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
    public List<Table4> getTables() { return tables; }
    public void setTables(List<Table4> tables) { this.tables = tables; }
}
