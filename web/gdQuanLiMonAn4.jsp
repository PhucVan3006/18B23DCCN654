<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List, java.text.DecimalFormat, dao.DishDAO4, dao.DAO4, model.Dish4" %>
<%
    // Lop bien GDQuanLiMonAn4: hien thi danh sach dish an hien co
    String tuKhoa = request.getParameter("tuKhoa");
    if (tuKhoa == null) tuKhoa = "";

    DishDAO4 dishDAO = new DishDAO4();
    List<Dish4> listMon = tuKhoa.isEmpty()
            ? dishDAO.getAllDish()
            : dishDAO.searchByKeyword(tuKhoa);
    dishDAO.closeConnection();

    DecimalFormat df = new DecimalFormat("#,###");
    String ok = request.getParameter("ok");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Quản lí thông tin món ăn - RestMan</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>

<div class="topbar">
    <a class="brand" href="gdQuanLiMonAn4.jsp">Rest<span>Man</span></a>
    <nav>
        <a href="#">Tổng quan</a>
        <a class="active" href="gdQuanLiMonAn4.jsp">Quản lí món ăn</a>
        <a href="#">Quản lí combo</a>
        <a href="#">Thống kê</a>
        <a href="gdSoDoBan4.jsp">Sơ đồ bàn</a>
    </nav>
    <div class="user"><div class="avatar">Q</div><span>Nhân viên quản lí</span></div>
</div>

<div class="wrap">
    <div class="crumb">Trang chủ / Quản lí thông tin món ăn</div>

    <div class="page-head">
        <div>
            <h1>Quản lí thông tin món ăn</h1>
            <p>Danh sách các món ăn hiện có trong thực đơn của nhà hàng.</p>
        </div>
        <button class="btn btn-primary" onclick="window.location='gdThemMonAn4.jsp'">+ Thêm món ăn</button>
    </div>

    <% if (DAO4.lastError != null) { %>
        <div class="msg msg-error"><%= DAO4.lastError %></div>
    <% } %>
    <% if ("1".equals(ok)) { %>
        <div class="msg msg-ok">Thêm thông tin món ăn thành công!</div>
    <% } %>

    <div class="card">
        <form method="get" action="gdQuanLiMonAn4.jsp" class="suffix" style="margin-bottom:16px">
            <input type="text" name="tuKhoa" value="<%= tuKhoa %>"
                   placeholder="Nhập tên món ăn cần tìm...">
            <button class="btn btn-ghost" type="submit">Tìm kiếm</button>
        </form>

        <table class="data">
            <tr>
                <th style="width:60px">Mã</th>
                <th style="width:80px">Ảnh</th>
                <th>Tên món ăn</th>
                <th>Loại món</th>
                <th>Đơn giá</th>
                <th>Trạng thái</th>
                <th style="width:110px">Thao tác</th>
            </tr>
            <% if (listMon.isEmpty()) { %>
                <tr><td colspan="7" class="empty">
                    <b>Chưa có món ăn nào phù hợp</b>
                    Thử xoá bớt từ khoá tìm kiếm hoặc thêm món ăn mới.</td></tr>
            <% } %>
            <% for (Dish4 m : listMon) { %>
            <tr>
                <td><%= m.getId() %></td>
                <td>
                    <% if (m.getImage() != null && !m.getImage().isEmpty()) { %>
                        <img class="thumb" src="images/<%= m.getImage() %>" alt="">
                    <% } else { %> — <% } %>
                </td>
                <td><%= m.getName() %></td>
                <td><%= m.getCategory() == null ? "" : m.getCategory().getName() %></td>
                <td><b><%= df.format(m.getPrice()) %></b> đ</td>
                <td>
                    <% if (Dish4.ON_SALE.equals(m.getSaleStatus())) { %>
                        <span class="badge badge-ok">Đang bán</span>
                    <% } else { %>
                        <span class="badge badge-off"><%= m.getSaleStatus() %></span>
                    <% } %>
                </td>
                <td><a href="#">Sửa</a> | <a href="#">Xoá</a></td>
            </tr>
            <% } %>
        </table>
        <div class="hint">Tổng số <%= listMon.size() %> món ăn.</div>
    </div>
</div>

</body>
</html>
