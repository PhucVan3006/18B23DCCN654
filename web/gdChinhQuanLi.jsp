<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.net.URLEncoder" %>
<%
    String role = (String) session.getAttribute("role");
    if (!"quanli".equals(role)) {
        response.sendRedirect("gdDangNhap.jsp?loi=" + URLEncoder.encode("Quyền truy cập bị từ chối: Trang quản trị chỉ dành riêng cho Quản lí.", "UTF-8"));
        return;
    }
    String user = (String) session.getAttribute("user");
    String fullName = (String) session.getAttribute("fullName");
    if (fullName == null || fullName.isEmpty()) fullName = "Nguyễn Văn Quản Lí";
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Bảng điều khiển quản lí - RestMan</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>

<div class="topbar">
    <a class="brand" href="gdChinhQuanLi.jsp">Rest<span>Man</span></a>
    <nav>
        <a class="active" href="gdChinhQuanLi.jsp">Tổng quan</a>
        <a href="gdQuanLiMonAn4.jsp">Quản lí món ăn</a>
        <a href="gdSoDoBan4.jsp">Sơ đồ bàn</a>
        <a href="gdThongKe.jsp">Thống kê</a>
        <a href="gdNhaCungCap.jsp">Nhà cung cấp</a>
    </nav>
    <div class="user">
        <div class="avatar" style="background:#c9742c">Q</div>
        <span><%= fullName %></span>
        <span class="role-badge manager">Quản lí</span>
        <a style="color:#f5c6c0; margin-left:14px; font-size:12px;" href="logout.jsp">[Đăng xuất]</a>
    </div>
</div>

<div class="wrap">
    <div class="crumb">Hệ thống / Tổng quan quản lí</div>

    <div class="page-head">
        <div>
            <h1>Bảng điều khiển quản lí</h1>
            <p>Chào mừng bạn trở lại, <b><%= fullName %></b>. Xem tổng quan tình hình hoạt động nhà hàng.</p>
        </div>
        <a class="btn btn-primary" href="gdThemMonAn4.jsp">+ Thêm món ăn mới</a>
    </div>

    <!-- Cac chi so thong ke nhanh -->
    <div class="stat-grid">
        <div class="stat-card">
            <div class="stat-icon" style="background:#e3f4ea; color:#1f7a46">🍲</div>
            <div>
                <div class="stat-val">6</div>
                <div class="stat-lbl">Món ăn trong thực đơn</div>
            </div>
        </div>
        <div class="stat-card">
            <div class="stat-icon" style="background:#e8f1fc; color:#1f3b6e">🪑</div>
            <div>
                <div class="stat-val">10</div>
                <div class="stat-lbl">Tổng số bàn phục vụ</div>
            </div>
        </div>
        <div class="stat-card">
            <div class="stat-icon" style="background:#fef3e7; color:#c9742c">📅</div>
            <div>
                <div class="stat-val">5</div>
                <div class="stat-lbl">Lượt đặt bàn hôm nay</div>
            </div>
        </div>
        <div class="stat-card">
            <div class="stat-icon" style="background:#f3e8fc; color:#7928ca">💰</div>
            <div>
                <div class="stat-val">8.650.000 đ</div>
                <div class="stat-lbl">Doanh thu ước tính</div>
            </div>
        </div>
    </div>

    <!-- Cac chuc nang chinh cua Nhan vien quan li -->
    <div class="card">
        <h2>Chức năng quản trị hệ thống</h2>
        <div class="quick-grid">
            <a class="quick-tile" href="gdQuanLiMonAn4.jsp">
                <span class="tile-icon">📋</span>
                Quản lí món ăn
                <div class="tile-desc">Danh sách thực đơn, sửa, xoá</div>
            </a>
            <a class="quick-tile" href="gdThemMonAn4.jsp">
                <span class="tile-icon">➕</span>
                Thêm món ăn mới
                <div class="tile-desc">Nhập thông tin món & tải ảnh</div>
            </a>
            <a class="quick-tile" href="gdSoDoBan4.jsp">
                <span class="tile-icon">🪑</span>
                Sơ đồ bàn
                <div class="tile-desc">Xem và cập nhật trạng thái bàn</div>
            </a>
            <a class="quick-tile" href="gdThongKe.jsp">
                <span class="tile-icon">📊</span>
                Báo cáo & Thống kê
                <div class="tile-desc">Top món bán chạy & doanh thu</div>
            </a>
            <a class="quick-tile" href="gdNhaCungCap.jsp">
                <span class="tile-icon">🚚</span>
                Nhà cung cấp
                <div class="tile-desc">Quản lí đối tác nguyên liệu</div>
            </a>
        </div>
    </div>
</div>

</body>
</html>
