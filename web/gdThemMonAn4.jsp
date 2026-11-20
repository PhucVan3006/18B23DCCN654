<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List, dao.CategoryDAO4, dao.DAO4, model.Category4, model.Dish4" %>
<%
    // Lop bien GDThemMonAn4: form nhap thong tin dish an moi
    CategoryDAO4 categoryDAO = new CategoryDAO4();
    List<Category4> listLoai = categoryDAO.getAllCategory();
    categoryDAO.closeConnection();

    String error      = request.getParameter("loi");
    String oldName  = request.getParameter("name");
    String oldCate  = request.getParameter("idCategory");
    String oldPrice = request.getParameter("price");
    String oldDesc  = request.getParameter("description");
    if (oldName  == null) oldName  = "";
    if (oldCate  == null) oldCate  = "";
    if (oldPrice == null) oldPrice = "";
    if (oldDesc  == null) oldDesc  = "";
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Thêm thông tin món ăn - RestMan</title>
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
    <div class="crumb">Trang chủ / <a href="gdQuanLiMonAn4.jsp">Quản lí món ăn</a> / Thêm thông tin món ăn</div>

    <div class="page-head">
        <div>
            <h1>Thêm thông tin món ăn</h1>
            <p>Các trường có dấu <span class="req">(*)</span> là bắt buộc nhập.</p>
        </div>
    </div>

    <% if (DAO4.lastError != null) { %>
        <div class="msg msg-error"><%= DAO4.lastError %></div>
    <% } else if (listLoai == null || listLoai.isEmpty()) { %>
        <div class="msg msg-error">
            Bảng tblCategory4 chưa có dữ liệu. Hãy chạy lại tệp db/restman.sql.
        </div>
    <% } %>
    <% if (error != null && !error.isEmpty()) { %>
        <div class="msg msg-error"><%= error %></div>
    <% } %>

    <form action="doThemMonAn4.jsp" method="post" enctype="multipart/form-data">
    <div class="card">
        <h2>Thông tin cơ bản</h2>
        <div class="grid">
            <div>
                <div class="field">
                    <label>Mã món ăn</label>
                    <input type="text" value="(hệ thống tự sinh)" readonly>
                </div>
                <div class="field">
                    <label>Tên món ăn <span class="req">(*)</span></label>
                    <input type="text" name="name" value="<%= oldName %>" placeholder="Ví dụ: Phở bò tái">
                </div>
                <div class="field">
                    <label>Loại món <span class="req">(*)</span></label>
                    <select name="idCategory">
                        <option value="">-- Chọn loại món --</option>
                        <% for (Category4 c : listLoai) {
                               String sel = String.valueOf(c.getId()).equals(oldCate) ? "selected" : ""; %>
                        <option value="<%= c.getId() %>" <%= sel %>><%= c.getName() %></option>
                        <% } %>
                    </select>
                </div>
                <div class="field">
                    <label>Đơn giá <span class="req">(*)</span></label>
                    <div class="suffix">
                        <input type="text" name="price" value="<%= oldPrice %>" placeholder="65000">
                        <span>VNĐ</span>
                    </div>
                </div>
                <div class="field">
                    <label>Mô tả</label>
                    <textarea name="description" placeholder="Mô tả ngắn về món ăn..."><%= oldDesc %></textarea>
                </div>
                <div class="field">
                    <label>Trạng thái</label>
                    <div class="radios">
                        <label><input type="radio" name="saleStatus" value="<%= Dish4.ON_SALE %>" checked> Đang bán</label>
                        <label><input type="radio" name="saleStatus" value="<%= Dish4.OFF_SALE %>"> Ngừng bán</label>
                    </div>
                </div>
            </div>
            <div>
                <div class="field">
                    <label>Ảnh minh hoạ</label>
                    <div class="drop">
                        <img id="preview" alt="">
                        <div class="ph" id="placeholder"><b>+</b><span>Chưa chọn ảnh</span></div>
                        <input type="file" name="anh" accept="image/*" onchange="xemAnh(this)">
                    </div>
                    <div class="hint">Chấp nhận .jpg, .png — tối đa 5 MB. Ảnh hiển thị trong danh sách thực đơn.</div>
                </div>
            </div>
        </div>

        <div class="actions">
            <button class="btn btn-primary" type="submit">Thêm món ăn</button>
            <button class="btn btn-ghost" type="reset">Nhập lại</button>
            <button class="btn btn-link" type="button"
                    onclick="window.location='gdQuanLiMonAn4.jsp'">Huỷ</button>
        </div>
    </div>
    </form>
</div>

<script>
    function xemAnh(input) {
        var img = document.getElementById('preview');
        var ph  = document.getElementById('placeholder');
        if (input.files && input.files[0]) {
            var reader = new FileReader();
            reader.onload = function (e) {
                img.src = e.target.result; img.style.display = 'block'; ph.style.display = 'none';
            };
            reader.readAsDataURL(input.files[0]);
        } else { img.style.display = 'none'; ph.style.display = 'flex'; }
    }
</script>
</body>
</html>
