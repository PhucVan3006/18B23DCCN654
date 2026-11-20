<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.text.SimpleDateFormat, java.util.Date,
                 dao.TableDAO4, model.Table4" %>
<%
    // Lop bien GDKetQuaDatBan4: hien thi ma dat ban va chi tiet booking
    request.setCharacterEncoding("UTF-8");
    String ma       = request.getParameter("ma");
    String hoTen    = request.getParameter("hoTen");
    String sdt      = request.getParameter("sdt");
    String ngayDen  = request.getParameter("ngayDen");
    String gioDen   = request.getParameter("gioDen");
    String numGuest  = request.getParameter("soKhach");
    String duration = request.getParameter("duration");
    String sIdTable = request.getParameter("idTable");

    Table4 ban = null;
    if (sIdTable != null && !sIdTable.isEmpty()) {
        TableDAO4 dao = new TableDAO4();
        ban = dao.getTableById(Integer.parseInt(sIdTable));
        dao.closeConnection();
    }

    String gioKetThuc = "";
    try {
        SimpleDateFormat f = new SimpleDateFormat("yyyy-MM-dd HH:mm");
        Date den = f.parse(ngayDen + " " + gioDen);
        long ms = den.getTime() + (Integer.parseInt(duration) + 15) * 60000L;
        gioKetThuc = new SimpleDateFormat("HH:mm").format(new Date(ms));
    } catch (Exception ignored) { }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Đặt bàn thành công - RestMan</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>

<div class="topbar">
    <a class="brand" href="gdTimBanTrong4.jsp">Rest<span>Man</span></a>
    <nav>
        <a href="#">Trang chủ</a>
        <a href="#">Thực đơn</a>
        <a class="active" href="gdTimBanTrong4.jsp">Đặt bàn trực tuyến</a>
        <a href="#">Đặt món</a>
    </nav>
    <div class="user"><span>Đăng nhập</span></div>
</div>

<div class="wrap">
    <div class="crumb">Trang chủ / Đặt bàn trực tuyến / Kết quả</div>

    <div class="msg msg-ok">
        <b>Đặt bàn thành công!</b> Nhà hàng sẽ gọi điện xác nhận trong ít phút.
    </div>

    <div class="code-box">
        <span>Mã đặt bàn của bạn</span>
        <b><%= ma %></b>
    </div>

    <div class="card">
        <h2>Chi tiết phiếu đặt bàn</h2>
        <table class="data">
            <tr><th style="width:240px">Thông tin</th><th>Giá trị</th></tr>
            <tr><td>Mã đặt bàn</td><td><b><%= ma %></b></td></tr>
            <tr><td>Khách hàng</td><td><%= hoTen %> — <%= sdt %></td></tr>
            <tr><td>Bàn</td>
                <td><%= ban == null ? "" : ban.getName() %>
                    (<%= ban == null ? 0 : ban.getCapacity() %> chỗ,
                     <%= ban == null || ban.getArea() == null ? "" : ban.getArea().getName() %>)</td></tr>
            <tr><td>Số khách</td><td><%= numGuest %> người</td></tr>
            <tr><td>Thời gian đến</td><td><%= gioDen %> ngày <%= ngayDen %></td></tr>
            <tr><td>Thời lượng dự kiến</td>
                <td><%= duration %> phút (giữ bàn tới <%= gioKetThuc %>, gồm 15 phút dọn bàn)</td></tr>
            <tr><td>Trạng thái phiếu</td>
                <td><span class="badge badge-warn">Chờ xác nhận</span></td></tr>
        </table>
        <div class="hint">
            Nhà hàng chỉ giữ bàn trong 15 phút kể từ giờ đến. Quá thời gian này, phiếu đặt
            chuyển sang trạng thái "Khách không đến" và bàn được giải phóng.
        </div>
        <div class="actions">
            <button class="btn btn-primary" onclick="window.location='gdTimBanTrong4.jsp'">Về trang chủ</button>
            <button class="btn btn-ghost" onclick="window.print()">In phiếu</button>
        </div>
    </div>
</div>

</body>
</html>
