<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List, java.text.SimpleDateFormat, java.util.Date,
                 dao.AreaDAO4, dao.DAO4, model.Area4" %>
<%
    // Lop bien GDTimBanTrong4: nhap tieu chi tim ban trong
    AreaDAO4 areaDAO = new AreaDAO4();
    List<Area4> listKhuVuc = areaDAO.getAllArea();
    areaDAO.closeConnection();

    String error = request.getParameter("loi");
    String homNay = new SimpleDateFormat("yyyy-MM-dd").format(new Date());
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Đặt bàn trực tuyến - RestMan</title>
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
        <a href="#">Liên hệ</a>
    </nav>
    <div class="user"><span>Đăng nhập</span></div>
</div>

<div class="wrap">
    <div class="crumb">Trang chủ / Đặt bàn trực tuyến</div>

    <div class="page-head">
        <div>
            <h1>Tìm bàn trống</h1>
            <p>Chọn thời gian bạn tới và số khách, hệ thống sẽ hiển thị những bàn còn trống.</p>
        </div>
    </div>

    <% if (DAO4.lastError != null) { %>
        <div class="msg msg-error"><%= DAO4.lastError %></div>
    <% } %>
    <% if (error != null && !error.isEmpty()) { %>
        <div class="msg msg-error"><%= error %></div>
    <% } %>

    <form action="gdChonBan4.jsp" method="get">
    <div class="card">
        <h2>Tiêu chí tìm kiếm</h2>
        <div class="row3">
            <div class="field">
                <label>Ngày đến <span class="req">(*)</span></label>
                <input type="date" name="ngayDen" value="<%= homNay %>" min="<%= homNay %>">
            </div>
            <div class="field">
                <label>Giờ đến <span class="req">(*)</span></label>
                <input type="time" name="gioDen" id="gioDen" value="18:00">
                <div class="hint">
                    Gợi ý:
                    <a href="#" onclick="datGio('11:00');return false">11:00</a> ·
                    <a href="#" onclick="datGio('17:30');return false">17:30</a> ·
                    <a href="#" onclick="datGio('19:30');return false">19:30</a>
                </div>
            </div>
            <div class="field">
                <label>Số khách <span class="req">(*)</span></label>
                <input type="number" name="soKhach" value="2" min="1" max="30">
            </div>
        </div>
        <div class="row3">
            <div class="field">
                <label>Khu vực</label>
                <select name="idKhuVuc">
                    <option value="0">-- Tất cả khu vực --</option>
                    <% for (Area4 a : listKhuVuc) { %>
                        <option value="<%= a.getId() %>"><%= a.getName() %></option>
                    <% } %>
                </select>
            </div>
            <div class="field">
                <label>Thời lượng dự kiến</label>
                <select name="duration">
                    <option value="60">60 phút</option>
                    <option value="90" selected>90 phút</option>
                    <option value="120">120 phút</option>
                    <option value="150">150 phút</option>
                </select>
                <div class="hint">Hệ thống giữ bàn thêm 15 phút để dọn bàn.</div>
            </div>
            <div class="field">
                <label>&nbsp;</label>
                <button class="btn btn-primary" type="submit" style="width:100%">Tìm bàn trống</button>
            </div>
        </div>
    </div>
    </form>
</div>

<script>
    function datGio(g) { document.getElementById('gioDen').value = g; }
</script>
</body>
</html>
