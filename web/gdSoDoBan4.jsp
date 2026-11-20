<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.*, java.text.SimpleDateFormat, java.sql.Date,
                 dao.TableDAO4, dao.BookedTableDAO4, dao.DAO4,
                 model.Table4, model.BookedTable4, model.Label4" %>
<%
    // Lop bien GDSoDoBan4: man hinh cua nhan vien ban hang.
    // Phat hien som cac ban qua gio de kip xu li truoc khi khach dat toi.
    TableDAO4 tableDAO = new TableDAO4();
    List<Table4> dsBan = tableDAO.getAllTable();
    tableDAO.closeConnection();

    BookedTableDAO4 btDAO = new BookedTableDAO4();
    Date homNay = new Date(System.currentTimeMillis());
    List<BookedTable4> dsLuot = btDAO.getBookedTablesOfDay(homNay);
    List<BookedTable4> dsQuaGio = btDAO.getOverdueTables();
    btDAO.closeConnection();

    // gom cac luot theo ma ban
    Map<Integer, List<BookedTable4>> theoBan = new HashMap<>();
    for (BookedTable4 bt : dsLuot) {
        theoBan.computeIfAbsent(bt.getTable().getId(), k -> new ArrayList<>()).add(bt);
    }
    SimpleDateFormat hm = new SimpleDateFormat("HH:mm");
    long now = System.currentTimeMillis();
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Sơ đồ bàn - RestMan</title>
    <link rel="stylesheet" href="css/style.css">
    <meta http-equiv="refresh" content="60">
</head>
<body>

<div class="topbar">
    <a class="brand" href="gdSoDoBan4.jsp">Rest<span>Man</span></a>
    <nav>
        <a href="#">Tổng quan</a>
        <a class="active" href="gdSoDoBan4.jsp">Sơ đồ bàn</a>
        <a href="#">Gọi món</a>
        <a href="#">Thanh toán</a>
        <a href="#">Xác nhận đặt bàn</a>
    </nav>
    <div class="user"><div class="avatar">B</div><span>Nhân viên bán hàng</span></div>
</div>

<div class="wrap">
    <div class="crumb">Trang chủ / Sơ đồ bàn</div>

    <div class="page-head">
        <div>
            <h1>Sơ đồ bàn — <%= new SimpleDateFormat("dd/MM/yyyy HH:mm").format(new java.util.Date()) %></h1>
            <p>Màn hình tự làm mới sau mỗi 60 giây.</p>
        </div>
    </div>

    <% if (DAO4.lastError != null) { %>
        <div class="msg msg-error"><%= DAO4.lastError %></div>
    <% } %>

    <% for (BookedTable4 bt : dsQuaGio) {
           long tre = (now - bt.getEndTime().getTime()) / 60000L; %>
        <div class="msg msg-error">
            ⚠ Bàn <b><%= bt.getTable().getName() %></b> đã quá giờ dự kiến <b><%= tre %> phút</b>
            (dự kiến trả bàn lúc <%= hm.format(bt.getEndTime()) %>).
            Hãy chuyển lượt đặt kế tiếp sang bàn trống khác hoặc liên hệ khách.
        </div>
    <% } %>

    <div class="card">
        <div class="ban-grid">
        <% for (Table4 b : dsBan) {
               List<BookedTable4> luots = theoBan.get(b.getId());
               String css = "trong";
               String mota = "Trống";
               if (luots != null) {
                   for (BookedTable4 bt : luots) {
                       boolean dangGiu = bt.getStartTime().getTime() <= now
                                      && bt.getEndTime().getTime()  >= now;
                       if (BookedTable4.OVERDUE.equals(bt.getSeatingStatus()) || bt.isOverdue()) {
                           css = "quagio";
                           mota = "Quá giờ — " + hm.format(bt.getStartTime())
                                + " → " + hm.format(bt.getEndTime());
                           break;
                       } else if (dangGiu && BookedTable4.SERVING.equals(bt.getSeatingStatus())) {
                           css = "phucvu";
                           mota = "Đang phục vụ — tới " + hm.format(bt.getEndTime());
                       } else if (css.equals("trong")) {
                           css = "dadat";
                           mota = "Đã đặt — lúc " + hm.format(bt.getStartTime());
                       }
                   }
               }
               if (!b.isUsable()) { css = "trong"; mota = "Ngừng sử dụng"; }
        %>
            <%
                String badge = "badge-ok";
                if ("quagio".equals(css))      badge = "badge-late";
                else if ("phucvu".equals(css)) badge = "badge-info";
                else if ("dadat".equals(css))  badge = "badge-warn";
            %>
            <div class="ban <%= css %>">
                <b><%= b.getName() %> — <%= b.getCapacity() %> chỗ</b>
                <span class="badge <%= badge %>"><%= mota.split(" — ")[0] %></span>
                <% if (mota.contains(" — ")) { %>
                    <small><%= mota.substring(mota.indexOf(" — ") + 3) %></small>
                <% } %>
            </div>
        <% } %>
        </div>
        <div class="legend">
            <span><i class="l1"></i>Trống</span>
            <span><i class="l2"></i>Đang phục vụ</span>
            <span><i class="l3"></i>Đã đặt trước</span>
            <span><i class="l4"></i>Quá giờ</span>
        </div>
    </div>

    <div class="card">
        <h2>Các lượt đặt trong ngày</h2>
        <table class="data">
            <tr><th>Bàn</th><th>Giờ bắt đầu</th><th>Giữ tới</th><th>Trạng thái</th><th>Thao tác</th></tr>
            <% if (dsLuot.isEmpty()) { %>
                <tr><td colspan="5" class="empty">
                    <b>Chưa có lượt đặt nào hôm nay</b>
                    Các phiếu đặt bàn trực tuyến sẽ hiện ở đây.</td></tr>
            <% } %>
            <% for (BookedTable4 bt : dsLuot) { %>
            <tr>
                <td><%= bt.getTable().getName() %></td>
                <td><%= hm.format(bt.getStartTime()) %></td>
                <td><%= hm.format(bt.getEndTime()) %></td>
                <%
                    String tt = bt.isOverdue() ? BookedTable4.OVERDUE : bt.getSeatingStatus();
                    String bd = "badge-info";
                    if (BookedTable4.OVERDUE.equals(tt))        bd = "badge-late";
                    else if (BookedTable4.BOOKED.equals(tt))    bd = "badge-warn";
                    else if (BookedTable4.RETURNED.equals(tt))  bd = "badge-ok";
                %>
                <td><span class="badge <%= bd %>"><%= Label4.seating(tt) %></span></td>
                <td>
                    <a href="doCapNhatBan4.jsp?id=<%= bt.getId() %>&tt=nhan">Nhận bàn</a> |
                    <a href="doCapNhatBan4.jsp?id=<%= bt.getId() %>&tt=tra">Trả bàn</a> |
                    <a href="doCapNhatBan4.jsp?id=<%= bt.getId() %>&tt=khongden">Không đến</a>
                </td>
            </tr>
            <% } %>
        </table>
    </div>
</div>

</body>
</html>
