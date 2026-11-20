# RestMan - Hệ Thống Quản Lí Nhà Hàng & Đặt Bàn Trực Tuyến

- **Môn học:** Phân tích và Thiết kế Hệ thống Thông tin (PTTKHTTT)
- **Đề tài:** Đề 18
- **Sinh viên:** Nguyễn Văn Phúc
- **Mã sinh viên:** B23DCCN654 (Hậu tố bài làm: `4`)
- **Công nghệ:** Java Servlet / JSP, JDBC, MySQL 8, Apache Tomcat 9, NetBeans IDE

---

## 1. Phạm vi bài tập (2 Module chính theo Đề 18)

### Module 1: Thêm thông tin món ăn (Nhân viên Quản lí)
- `gdQuanLiMonAn4.jsp`: Màn hình danh sách món ăn, xem thực đơn hiện có, nút thêm món ăn mới.
- `gdThemMonAn4.jsp`: Form nhập thông tin món ăn (tên món, giá, danh mục, mô tả, chọn ảnh tải lên).
- `doThemMonAn4.jsp`: Servlet JSP xử lý kiểm tra trùng tên, lưu file ảnh và thêm món ăn vào CSDL qua `DishDAO4`.

### Module 2: Đặt bàn trực tuyến (Khách hàng)
- `gdTimBanTrong4.jsp`: Form tìm bàn trống theo tiêu chí (ngày đến, giờ đến, số lượng khách, khu vực bàn).
- `gdChonBan4.jsp`: Kiểm tra xung đột khung giờ (thuật toán lọc bàn còn trống không giao với các phiếu đã giữ), hiển thị danh sách bàn phù hợp.
- `gdThongTinKH4.jsp`: Form nhập thông tin khách hàng (họ tên, SĐT, email, ghi chú).
- `doDatBan4.jsp`: Xử lý lưu khách hàng (`CustomerDAO4`), tạo phiếu đặt bàn (`BookingDAO4`), và lưu chi tiết bàn đặt (`BookedTableDAO4`).
- `gdKetQuaDatBan4.jsp`: Màn hình hiển thị thông tin xác nhận đặt bàn thành công và mã đặt bàn.

---

## 2. Cấu trúc thư mục mã nguồn

```text
├── db/
│   └── restman.sql                     # Script khởi tạo cơ sở dữ liệu và dữ liệu mẫu
├── src/
│   ├── dao/                            # Tầng truy xuất dữ liệu (Data Access Objects)
│   │   ├── DAO4.java                   # Lớp kết nối CSDL cơ sở
│   │   ├── DishDAO4.java               # Xử lý dữ liệu món ăn
│   │   ├── CategoryDAO4.java           # Xử lý danh mục món
│   │   ├── TableDAO4.java              # Xử lý truy vấn bàn & tìm bàn trống
│   │   ├── AreaDAO4.java               # Xử lý danh mục khu vực (Tầng 1, Tầng 2, Sân thượng)
│   │   ├── BookingDAO4.java            # Lưu phiếu đặt bàn
│   │   ├── BookedTableDAO4.java        # Lưu chi tiết giữ bàn & kiểm tra trùng giờ
│   │   └── CustomerDAO4.java           # Xử lý lưu & tìm kiếm thông tin khách hàng
│   └── model/                          # Tầng thực thể (Entities)
│       ├── Dish4.java, Category4.java
│       ├── Table4.java, Area4.java
│       ├── Booking4.java, BookedTable4.java
│       └── Customer4.java, Member4.java, Staff4.java
├── web/
│   ├── css/style.css                   # Giao diện CSS hiện đại, responsive
│   ├── images/                         # Ảnh món ăn minh hoạ
│   ├── WEB-INF/
│   │   ├── lib/mysql-connector-j-8.4.0.jar  # Driver kết nối MySQL 8
│   │   └── web.xml                     # Cấu hình welcome-file & multipart upload
│   ├── gdQuanLiMonAn4.jsp, gdThemMonAn4.jsp, doThemMonAn4.jsp
│   └── gdTimBanTrong4.jsp, gdChonBan4.jsp, gdThongTinKH4.jsp, doDatBan4.jsp, gdKetQuaDatBan4.jsp
├── .gitignore
└── README.md
```

---

## 3. Hướng dẫn chạy chương trình

1. **Cơ sở dữ liệu:**
   - Mở MySQL (MySQL Workbench hoặc phpMyAdmin).
   - Chạy script `db/restman.sql` để tạo CSDL `restman` và dữ liệu thử nghiệm.
   - Tài khoản mặc định: `root` / mật khẩu rỗng (hoặc chỉnh lại trong `src/dao/DAO4.java`).

2. **Mở dự án bằng NetBeans:**
   - Mở NetBeans IDE: `File` -> `Open Project...` -> Chọn thư mục dự án.
   - Cấu hình Server: Apache Tomcat 9.
   - Nhấn **Run Project (F6)**. Trình duyệt sẽ tự động mở trang `gdQuanLiMonAn4.jsp`.
