<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List, java.sql.Timestamp, java.text.SimpleDateFormat,
                 java.util.Date, java.net.URLEncoder,
                 dao.TableDAO4, dao.DAO4, model.Table4" %>
<%
    // Lop bien GDChonBan4: kiem tra tieu chi, tinh khoang thoi gian giu ban
    // va hien thi danh sach ban con trong
    request.setCharacterEncoding("UTF-8");
    String ngayDen  = request.getParameter("ngayDen");
    String gioDen   = request.getParameter("gioDen");
    String sSoKhach = request.getParameter("soKhach");
    String sKhuVuc  = request.getParameter("idKhuVuc");
    String sDuration= request.getParameter("duration");

    final int DEM_DON_BAN = 15;      // phut dem de don ban giua hai luot
    int numGuest = 0, idKhuVuc = 0, duration = 90;
    Timestamp startTime = null, endTime = null;
    String error = null;

    try {
        if (ngayDen == null || gioDen == null || ngayDen.isEmpty() || gioDen.isEmpty())
            throw new Exception("Hãy chọn đầy đủ ngày đến và giờ đến.");
        numGuest = Integer.parseInt(sSoKhach);
        if (numGuest <= 0) throw new Exception("Số khách phải là số nguyên lớn hơn 0.");
        if (sKhuVuc  != null && !sKhuVuc.isEmpty())  idKhuVuc = Integer.parseInt(sKhuVuc);
        if (sDuration != null && !sDuration.isEmpty()) duration = Integer.parseInt(sDuration);

        SimpleDateFormat f = new SimpleDateFormat("yyyy-MM-dd HH:mm");
        Date den = f.parse(ngayDen + " " + gioDen);
        if (den.before(new Date()))
            throw new Exception("Thời gian đến không được ở quá khứ.");

        startTime = new Timestamp(den.getTime());
        endTime   = new Timestamp(den.getTime() + (duration + DEM_DON_BAN) * 60000L);
    } catch (Exception e) {
        error = e.getMessage() == null ? "Tiêu chí tìm kiếm không hợp lệ." : e.getMessage();
    }

    if (error != null) {
        response.sendRedirect("gdTimBanTrong4.jsp?loi=" + URLEncoder.encode(error, "UTF-8"));
        return;
    }

    TableDAO4 tableDAO = new TableDAO4();
    List<Table4> listBan = tableDAO.getAvailableTables(startTime, endTime, numGuest, idKhuVuc);
    tableDAO.closeConnection();

    SimpleDateFormat hm = new SimpleDateFormat("HH:mm");
    SimpleDateFormat dmy = new SimpleDateFormat("dd/MM/yyyy");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Chọn bàn - RestMan</title>
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
    <div class="crumb">Trang chủ / <a href="gdTimBanTrong4.jsp">Đặt bàn trực tuyến</a> / Chọn bàn</div>

    <div class="page-head">
        <div>
            <h1>Chọn bàn</h1>
            <p>Danh sách các bàn còn trống theo tiêu chí bạn đã nhập.</p>
        </div>
        <button class="btn btn-ghost" onclick="window.location='gdTimBanTrong4.jsp'">Tìm lại</button>
    </div>

    <% if (DAO4.lastError != null) { %>
        <div class="msg msg-error"><%= DAO4.lastError %></div>
    <% } %>

    <div class="msg msg-warn">
        Tiêu chí: <b><%= dmy.format(startTime) %></b>,
        <b><%= hm.format(startTime) %> – <%= hm.format(endTime) %></b>
        (<%= duration %> phút + <%= DEM_DON_BAN %> phút dọn bàn),
        <b><%= numGuest %></b> khách — tìm thấy <b><%= listBan.size() %></b> bàn trống.
    </div>

    <% if (listBan.isEmpty()) { %>
        <div class="msg msg-error">
            Không còn bàn trống phù hợp trong khung giờ này. Vui lòng chọn khung giờ khác
            hoặc giảm số khách.
        </div>
    <% } else { %>
    <form action="gdThongTinKH4.jsp" method="get">
        <input type="hidden" name="ngayDen"  value="<%= ngayDen %>">
        <input type="hidden" name="gioDen"   value="<%= gioDen %>">
        <input type="hidden" name="soKhach"  value="<%= numGuest %>">
        <input type="hidden" name="duration" value="<%= duration %>">
        <div class="card">
            <table class="data">
                <tr>
                    <th style="width:60px">Chọn</th>
                    <th style="width:70px">Mã bàn</th>
                    <th>Tên bàn</th>
                    <th>Sức chứa</th>
                    <th>Loại bàn</th>
                    <th>Khu vực</th>
                </tr>
                <% boolean first = true;
                   for (Table4 b : listBan) { %>
                <tr>
                    <td><input type="radio" name="idTable" value="<%= b.getId() %>"
                               <%= first ? "checked" : "" %>></td>
                    <td>B<%= String.format("%02d", b.getId()) %></td>
                    <td><%= b.getName() %></td>
                    <td><span class="badge badge-info"><%= b.getCapacity() %> chỗ</span></td>
                    <td><%= b.getTableType() %></td>
                    <td><%= b.getArea() == null ? "" : b.getArea().getName() %></td>
                </tr>
                <% first = false; } %>
            </table>
            <div class="actions">
                <button class="btn btn-primary" type="submit">Tiếp tục</button>
                <button class="btn btn-ghost" type="button"
                        onclick="window.location='gdTimBanTrong4.jsp'">Tìm lại</button>
            </div>
        </div>
    </form>
    <% } %>
</div>

</body>
</html>
