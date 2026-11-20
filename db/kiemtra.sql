-- Chay tung lenh de kiem tra CSDL da dung chua
SHOW DATABASES LIKE 'restman';
USE restman;
SHOW TABLES;

SELECT COUNT(*) AS so_loai_mon   FROM tblCategory4;   -- ki vong 5
SELECT COUNT(*) AS so_mon_an     FROM tblDish4;       -- ki vong 6
SELECT COUNT(*) AS so_khu_vuc    FROM tblArea4;       -- ki vong 4
SELECT COUNT(*) AS so_ban        FROM tblTable4;      -- ki vong 10
SELECT COUNT(*) AS so_phieu_dat  FROM tblBooking4;    -- ki vong 1

-- Xem cac luot giu ban va khoang thoi gian tuong ung
SELECT bt.id, t.name AS ban, bt.startTime, bt.endTime, bt.seatingStatus
FROM tblBookedTable4 bt JOIN tblTable4 t ON bt.idTable4 = t.id
ORDER BY bt.startTime;

-- Thu truy van tim ban trong cho khung 16:00 - 17:45 ngay 02/12/2026, 4 khach
SELECT t.id, t.name, t.capacity
FROM tblTable4 t
WHERE t.capacity >= 4 AND t.usable = TRUE
  AND t.id NOT IN (
      SELECT bt.idTable4 FROM tblBookedTable4 bt
      WHERE bt.seatingStatus IN ('BOOKED','SERVING','OVERDUE','WAITING_TABLE')
        AND bt.startTime < '2026-12-02 17:45:00'
        AND bt.endTime   > '2026-12-02 16:00:00');
