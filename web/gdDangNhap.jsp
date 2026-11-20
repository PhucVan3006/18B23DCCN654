<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    String loi = request.getParameter("loi");
    String tb  = request.getParameter("tb");
    String user = request.getParameter("username");
    if (user == null) user = "";
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Đăng nhập hệ thống - RestMan</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>

<div class="topbar">
    <a class="brand" href="index.jsp">Rest<span>Man</span></a>
    <nav>
        <a href="index.jsp">Trang chủ</a>
        <a href="gdQuanLiMonAn4.jsp">Thực đơn</a>
        <a href="gdTimBanTrong4.jsp">Đặt bàn trực tuyến</a>
    </nav>
    <div class="user">
        <a style="color:#fff; font-weight:600" href="gdDangNhap.jsp">Đăng nhập</a>
    </div>
</div>

<div class="login-wrap">
    <div class="login-card">
        <div class="login-header">
            <div class="login-icon">🍽️</div>
            <h1>Đăng nhập Rest<span>Man</span></h1>
            <p>Hệ thống Quản lí Nhà hàng & Đặt bàn trực tuyến</p>
        </div>

        <% if (loi != null && !loi.isEmpty()) { %>
            <div class="msg msg-error"><%= loi %></div>
        <% } %>
        <% if ("logout_ok".equals(tb)) { %>
            <div class="msg msg-ok">Bạn đã đăng xuất thành công!</div>
        <% } %>

        <form action="doDangNhap.jsp" method="post">
            <div class="field">
                <label for="inpUser">Tên đăng nhập <span class="req">(*)</span></label>
                <input type="text" id="inpUser" name="username" value="<%= user %>" placeholder="Ví dụ: quanli hoặc khachhang" required autofocus>
            </div>

            <div class="field">
                <label for="inpPass">Mật khẩu <span class="req">(*)</span></label>
                <input type="password" id="inpPass" name="password" placeholder="Nhập mật khẩu của bạn" required>
            </div>

            <div style="margin-top:22px;">
                <button class="btn-login" type="submit">Đăng nhập</button>
            </div>
        </form>

        <div class="demo-accounts">
            <div class="demo-title">
                <span>🔑 Tài khoản thử nghiệm nhanh</span>
            </div>
            <div class="demo-pills">
                <a class="demo-pill" href="javascript:void(0)" onclick="dienTK('quanli', '123456')">
                    <span class="role">Quản lí</span>
                    <span class="creds">quanli / 123456</span>
                </a>
                <a class="demo-pill" href="javascript:void(0)" onclick="dienTK('khachhang', '123456')">
                    <span class="role">Khách hàng</span>
                    <span class="creds">khachhang / 123456</span>
                </a>
            </div>
            <span class="demo-note">
                * Nhấp vào tài khoản để điền nhanh. Vai trò (Quản lí / Khách hàng) được nhận diện tự động từ cơ sở dữ liệu.
            </span>
        </div>
    </div>
</div>

<script>
function dienTK(u, p) {
    document.getElementById('inpUser').value = u;
    document.getElementById('inpPass').value = p;
}
</script>

</body>
</html>
