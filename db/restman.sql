-- =====================================================================
-- RestMan - De 18 - B23DCCN654
-- CSDL cho hai module: Add Dish 4 va Book Table Online 4
-- Chay toan bo tep nay trong MySQL Workbench hoac MySQL Command Line Client
-- =====================================================================

DROP DATABASE IF EXISTS restman;
CREATE DATABASE restman CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE restman;

-- Thiet lap ma hoa tieng Viet UTF-8 cho phien lam viec (tranh loi dau hoi ??? tren MySQL Workbench)
SET NAMES utf8mb4;
SET CHARACTER SET utf8mb4;

-- ------------------------- Nguoi dung -------------------------
CREATE TABLE tblMember4 (
  id        INT AUTO_INCREMENT PRIMARY KEY,
  username  VARCHAR(50)  NOT NULL UNIQUE,
  password  VARCHAR(100) NOT NULL,
  name      NVARCHAR(100),
  birthday  DATE,
  address   NVARCHAR(255),
  email     VARCHAR(100),
  phone     VARCHAR(15),
  role      VARCHAR(20) NOT NULL        -- MANAGER / SALES / WAREHOUSE / CUSTOMER
);

CREATE TABLE tblStaff4 (
  id       INT PRIMARY KEY,
  position NVARCHAR(50),
  CONSTRAINT fk_staff_member FOREIGN KEY (id) REFERENCES tblMember4(id)
);

CREATE TABLE tblCustomer4 (
  id           INT PRIMARY KEY,
  customerCode VARCHAR(20),
  CONSTRAINT fk_customer_member FOREIGN KEY (id) REFERENCES tblMember4(id)
);

-- ------------------------- Thuc don -------------------------
CREATE TABLE tblCategory4 (
  id          INT AUTO_INCREMENT PRIMARY KEY,
  name        NVARCHAR(50) NOT NULL,
  description NVARCHAR(255)
);

CREATE TABLE tblDish4 (
  id          INT AUTO_INCREMENT PRIMARY KEY,
  name        NVARCHAR(255) NOT NULL,
  price       DOUBLE NOT NULL,
  description NVARCHAR(500),
  saleStatus  NVARCHAR(20)  NOT NULL DEFAULT 'ON_SALE',
  image       VARCHAR(255),
  idCategory4 INT,
  CONSTRAINT fk_dish_category FOREIGN KEY (idCategory4) REFERENCES tblCategory4(id)
);

-- ------------------------- Co so vat chat -------------------------
CREATE TABLE tblRestaurant4 (
  id      INT AUTO_INCREMENT PRIMARY KEY,
  name    NVARCHAR(100),
  address NVARCHAR(255),
  phone   VARCHAR(15)
);

CREATE TABLE tblArea4 (
  id             INT AUTO_INCREMENT PRIMARY KEY,
  name           NVARCHAR(50) NOT NULL,
  description    NVARCHAR(255),
  idRestaurant4  INT,
  CONSTRAINT fk_area_restaurant FOREIGN KEY (idRestaurant4) REFERENCES tblRestaurant4(id)
);

CREATE TABLE tblTable4 (
  id        INT AUTO_INCREMENT PRIMARY KEY,
  name      NVARCHAR(50) NOT NULL,
  capacity  INT NOT NULL,
  tableType NVARCHAR(30),
  usable    BOOLEAN NOT NULL DEFAULT TRUE,   -- ban con dung duoc hay khong (hong / dang sua chua)
                                             -- "Trong" / "Dang phuc vu" KHONG luu o day:
                                             -- suy ra tu tblBookedTable4 tai tung thoi diem
  idArea4   INT,
  CONSTRAINT fk_table_area FOREIGN KEY (idArea4) REFERENCES tblArea4(id)
);

-- ------------------------- Dat ban -------------------------
CREATE TABLE tblBooking4 (
  id           INT AUTO_INCREMENT PRIMARY KEY,
  bookingCode  VARCHAR(30),
  bookingTime  DATETIME NOT NULL,
  arrivalTime  DATETIME NOT NULL,
  numGuest     INT NOT NULL,
  duration     INT NOT NULL DEFAULT 90,      -- thoi luong du kien, phut
  -- Cho xac nhan / Da xac nhan / Da huy / Cho thanh toan / Hoan thanh
  -- / Hoan thanh - co cong no  (khach roi di ma chua tra tien, NVQL xac nhan)
  bookingStatus VARCHAR(30) NOT NULL DEFAULT 'PENDING',
  note         NVARCHAR(255),
  idCustomer4  INT,
  idStaff4     INT,
  CONSTRAINT fk_booking_customer FOREIGN KEY (idCustomer4) REFERENCES tblCustomer4(id),
  CONSTRAINT fk_booking_staff    FOREIGN KEY (idStaff4)    REFERENCES tblStaff4(id)
);

-- Lop lien ket giua Booking4 va Table4: moi dong la mot luot giu mot ban
CREATE TABLE tblBookedTable4 (
  id            INT AUTO_INCREMENT PRIMARY KEY,
  startTime     DATETIME NOT NULL,
  endTime       DATETIME NOT NULL,          -- = startTime + duration + 15 phut dem
  actualEndTime DATETIME NULL,              -- gio tra ban thuc te, ghi khi THANH TOAN XONG
  -- Da dat / Dang phuc vu / Qua gio / Cho thanh toan / Cho xep ban
  -- / Da doi ban / Da tra ban / Khach khong den / Da huy
  -- 5 trang thai dau = con chiem cho (mang DANG_CHIEM_BAN trong BookedTable4.java)
  seatingStatus VARCHAR(20) NOT NULL DEFAULT 'BOOKED',
  idBooking4    INT NOT NULL,
  idTable4      INT NOT NULL,
  CONSTRAINT fk_bt_booking FOREIGN KEY (idBooking4) REFERENCES tblBooking4(id),
  CONSTRAINT fk_bt_table   FOREIGN KEY (idTable4)   REFERENCES tblTable4(id)
);

CREATE INDEX idx_bt_table_time ON tblBookedTable4(idTable4, startTime, endTime);

-- =====================================================================
-- Du lieu mau
-- =====================================================================
INSERT INTO tblMember4(username, password, name, email, phone, role) VALUES
 ('ql01','123456','Trần Thị Quản Lí','ql01@restman.vn','0901000001','MANAGER'),
 ('bh01','123456','Lê Văn Bán Hàng','bh01@restman.vn','0901000002','SALES');
INSERT INTO tblStaff4(id, position) VALUES (1,'Quản lí nhà hàng'), (2,'Nhân viên bán hàng');

INSERT INTO tblCategory4(name, description) VALUES
 ('Khai vị','Món ăn nhẹ dùng đầu bữa'),
 ('Món chính','Món ăn chính của bữa'),
 ('Tráng miệng','Món ngọt dùng cuối bữa'),
 ('Đồ uống','Nước giải khát, bia, rượu'),
 ('Lẩu - Nướng','Món dùng chung cho nhóm khách');

INSERT INTO tblDish4(name, price, description, saleStatus, image, idCategory4) VALUES
 ('Phở bò tái', 65000, 'Phở bò truyền thống, nước dùng ninh xương 12 tiếng', 'ON_SALE', 'pho-bo-tai.png', 2),
 ('Nem rán Hà Nội', 45000, 'Nem rán giòn, nhân thịt và mộc nhĩ, 6 chiếc một đĩa', 'ON_SALE', 'nem-ran.png', 1),
 ('Gà nướng mật ong', 185000, 'Gà ta nướng than hoa, ướp mật ong, dùng cho 3-4 người', 'ON_SALE', 'ga-nuong.png', 5),
 ('Chè khúc bạch', 35000, 'Chè khúc bạch hạnh nhân, vải thiều', 'ON_SALE', 'che-khuc-bach.png', 3),
 ('Nước cam vắt', 30000, 'Cam tươi vắt nguyên chất, không đường', 'ON_SALE', 'nuoc-cam.png', 4),
 ('Combo gia đình 4 người', 550000, 'Gồm 1 lẩu, 2 món chính và 4 nước; giá lẻ 680.000đ', 'ON_SALE', 'combo-gia-dinh.png', 2);

INSERT INTO tblRestaurant4(name, address, phone) VALUES
 ('RestMan Hà Đông','96 Trần Phú, Hà Đông, Hà Nội','02433512345');

INSERT INTO tblArea4(name, description, idRestaurant4) VALUES
 ('Tầng 1 - Khu A','Khu vực gần cửa, bàn nhỏ',1),
 ('Tầng 1 - Khu B','Khu vực giữa sảnh',1),
 ('Tầng 2 - VIP','Phòng riêng, có điều hoà riêng',1),
 ('Sân vườn','Khu ngoài trời',1);

INSERT INTO tblTable4(name, capacity, tableType, usable, idArea4) VALUES
 ('Bàn 01', 2, 'Bàn thường', TRUE, 1),
 ('Bàn 02', 4, 'Bàn thường', TRUE, 1),
 ('Bàn 03', 4, 'Bàn thường', TRUE, 1),
 ('Bàn 04', 4, 'Bàn thường', TRUE, 2),
 ('Bàn 05', 6, 'Bàn thường', TRUE, 2),
 ('Bàn 06', 2, 'Bàn thường', TRUE, 2),
 ('Bàn 07', 6, 'Bàn thường', TRUE, 2),
 ('Bàn VIP 01', 8, 'Phòng riêng', TRUE, 3),
 ('Bàn VIP 02', 6, 'Phòng riêng', TRUE, 3),
 ('Bàn sân vườn 01', 4, 'Bàn ngoài trời', TRUE, 4);

-- Mot phieu dat ban mau de thu nghiem rang buoc trung khung gio:
-- khach dat Ban 03 luc 14:30 ngay 02/12/2026, du kien 90' + 15' dem -> giu toi 16:15
INSERT INTO tblMember4(username, password, name, email, phone, role)
 VALUES ('kh_demo','123456','Nguyễn Văn An','an@gmail.com','0912345678','CUSTOMER');
INSERT INTO tblCustomer4(id, customerCode) VALUES (LAST_INSERT_ID(), 'KH0001');

INSERT INTO tblBooking4(bookingCode, bookingTime, arrivalTime, numGuest, duration, bookingStatus, idCustomer4)
 VALUES ('DB20261202-001', NOW(), '2026-12-02 14:30:00', 4, 90, 'CONFIRMED',
         (SELECT id FROM tblCustomer4 LIMIT 1));

INSERT INTO tblBookedTable4(startTime, endTime, seatingStatus, idBooking4, idTable4)
 VALUES ('2026-12-02 14:30:00', '2026-12-02 16:15:00', 'BOOKED',
         (SELECT id FROM tblBooking4 ORDER BY id DESC LIMIT 1),
         (SELECT id FROM tblTable4 WHERE name = 'Bàn 03'));

-- =====================================================================
-- Cau truy van loi: tim ban con trong trong mot khung gio
-- (dung trong TableDAO4.getBanTrong)
-- =====================================================================
-- SELECT t.* FROM tblTable4 t
-- WHERE t.capacity >= ? AND t.usable = TRUE
--   AND (? = 0 OR t.idArea4 = ?)
--   AND t.id NOT IN (
--        SELECT bt.idTable4 FROM tblBookedTable4 bt
--        WHERE bt.seatingStatus IN ('BOOKED','SERVING','OVERDUE',
--                                   'PENDING_PAYMENT','WAITING_TABLE')
--          AND bt.startTime < ?    -- endTime yeu cau
--          AND COALESCE(bt.actualEndTime,
--                IF(bt.seatingStatus IN ('OVERDUE','PENDING_PAYMENT'),
--                   GREATEST(bt.endTime, NOW() + INTERVAL 15 MINUTE),
--                   bt.endTime)) > ?   -- startTime yeu cau
--   );
-- Gio ket thuc HIEU LUC thay cho endTime du kien:
--   - da tra ban  -> actualEndTime (gio thuc te)
--   - qua gio / cho thanh toan -> NOW() + 15', tu day len cho tron bua an
--   - cac truong hop con lai -> endTime du kien
-- Nho vay mot ban con khach ngoi khong bao gio bi ban cho khung gio ke tiep.
