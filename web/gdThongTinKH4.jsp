<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.text.SimpleDateFormat, java.util.Date,
                 dao.TableDAO4, dao.DAO4, model.Table4" %>
<%
    // Lop bien GDThongTinKH4: nhap thong tin ca nhan de xac nhan dat ban
    request.setCharacterEncoding("UTF-8");
    String ngayDen  = request.getParameter("ngayDen");
    String gioDen   = request.getParameter("gioDen");
    String numGuest  = request.getParameter("soKhach");
    String duration = request.getParameter("duration");
    String sIdTable = request.getParameter("idTable");
    String error      = request.getParameter("loi");

    if (sIdTable == null || sIdTable.isEmpty()) {
        response.sendRedirect("gdTimBanTrong4.jsp?loi=Hãy chọn một bàn.");
        return;
    }

    TableDAO4 tableDAO = new TableDAO4();
    Table4 ban = tableDAO.getTableById(Integer.parseInt(sIdTable));
    tableDAO.closeConnection();

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
    <title>Thông tin khách hàng - RestMan</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>

<div class="topbar">
    <a class="brand" href="gdTimBanTrong4.jsp">Rest<span>Man</span></a>
    <nav>
        <a href="gdQuanLiMonAn4.jsp">Quản lí món ăn</a>
        <a class="active" href="gdTimBanTrong4.jsp">Đặt bàn trực tuyến</a>
    </nav>
    <div class="user"><div class="avatar" style="background:#1f7a46">K</div><span>Khách hàng</span></div>
</div>

<div class="wrap">
    <div class="crumb">Trang chủ / Đặt bàn trực tuyến / Chọn bàn / Thông tin khách hàng</div>

    <div class="page-head">
        <div>
            <h1>Thông tin khách hàng</h1>
            <p>Nhập thông tin liên hệ để nhà hàng xác nhận phiếu đặt bàn.</p>
        </div>
    </div>

    <% if (DAO4.lastError != null) { %>
        <div class="msg msg-error"><%= DAO4.lastError %></div>
    <% } %>
    <% if (error != null && !error.isEmpty()) { %>
        <div class="msg msg-error"><%= error %></div>
    <% } %>

    <div class="msg msg-warn">
        Bàn đã chọn: <b><%= ban == null ? "" : ban.getName() %></b>
        (<%= ban == null ? 0 : ban.getCapacity() %> chỗ,
        <%= ban == null || ban.getArea() == null ? "" : ban.getArea().getName() %>)
        — <b><%= gioDen %></b> ngày <b><%= ngayDen %></b>,
        giữ bàn tới <b><%= gioKetThuc %></b>.
    </div>

    <form action="doDatBan4.jsp" method="post">
        <input type="hidden" name="ngayDen"  value="<%= ngayDen %>">
        <input type="hidden" name="gioDen"   value="<%= gioDen %>">
        <input type="hidden" name="soKhach"  value="<%= numGuest %>">
        <input type="hidden" name="duration" value="<%= duration %>">
        <input type="hidden" name="idTable"  value="<%= sIdTable %>">
        <div class="card">
            <h2>Thông tin liên hệ</h2>
            <div class="grid">
                <div>
                    <div class="field">
                        <label>Họ và tên <span class="req">(*)</span></label>
                        <input type="text" name="hoTen" placeholder="Nguyễn Văn An">
                    </div>
                    <div class="field">
                        <label>Số điện thoại <span class="req">(*)</span></label>
                        <input type="text" name="soDienThoai" placeholder="0912345678">
                        <div class="hint">Gồm 10 chữ số, dùng để nhà hàng liên hệ xác nhận.</div>
                    </div>
                    <div class="field">
                        <label>Email</label>
                        <input type="text" name="email" placeholder="an@gmail.com">
                    </div>
                    <div class="field">
                        <label>Ghi chú</label>
                        <textarea name="ghiChu" placeholder="Ví dụ: cần ghế trẻ em, kê sát cửa sổ..."></textarea>
                    </div>
                </div>
                <div>
                    <div class="msg msg-warn" style="margin:0">
                        <b>Lưu ý</b><br>
                        Nhà hàng giữ bàn trong 15 phút kể từ giờ đến. Quá thời gian này,
                        phiếu đặt chuyển sang trạng thái <i>Khách không đến</i> và bàn
                        được giải phóng cho khách khác.
                    </div>
                </div>
            </div>
            <div class="actions">
                <button class="btn btn-primary" type="submit">Xác nhận đặt bàn</button>
                <button class="btn btn-ghost" type="button"
                        onclick="history.back()">Chọn bàn khác</button>
                <button class="btn btn-link" type="button"
                        onclick="window.location='gdTimBanTrong4.jsp'">Huỷ</button>
            </div>
        </div>
    </form>
</div>

</body>
</html>
