<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.Timestamp, java.text.SimpleDateFormat, java.util.Date,
                 java.net.URLEncoder,
                 dao.*, model.*" %>
<%
    // Trang xu li: kiem tra thong tin, kiem tra lai ban con trong roi ghi du lieu
    request.setCharacterEncoding("UTF-8");

    String ngayDen  = request.getParameter("ngayDen");
    String gioDen   = request.getParameter("gioDen");
    String sSoKhach = request.getParameter("soKhach");
    String sDuration= request.getParameter("duration");
    String sIdTable = request.getParameter("idTable");
    String hoTen    = request.getParameter("hoTen");
    String sdt      = request.getParameter("soDienThoai");
    String email    = request.getParameter("email");
    String ghiChu   = request.getParameter("ghiChu");

    final int DEM_DON_BAN = 15;
    String error = null;
    Timestamp startTime = null, endTime = null;
    int numGuest = 0, duration = 90, idTable = 0;

    // --- Buoc 1: kiem tra thong tin khach hang ---
    if (hoTen == null || hoTen.trim().isEmpty())
        error = "Họ và tên không được để trống.";
    else if (sdt == null || !sdt.trim().matches("0\\d{9}"))
        error = "Số điện thoại phải gồm 10 chữ số và bắt đầu bằng 0.";
    else if (email != null && !email.trim().isEmpty()
             && !email.trim().matches("^[\\w.+-]+@[\\w-]+\\.[\\w.-]+$"))
        error = "Email không đúng định dạng.";

    if (error == null) {
        try {
            numGuest  = Integer.parseInt(sSoKhach);
            duration = Integer.parseInt(sDuration);
            idTable  = Integer.parseInt(sIdTable);
            SimpleDateFormat f = new SimpleDateFormat("yyyy-MM-dd HH:mm");
            Date den = f.parse(ngayDen + " " + gioDen);
            startTime = new Timestamp(den.getTime());
            endTime   = new Timestamp(den.getTime() + (duration + DEM_DON_BAN) * 60000L);
        } catch (Exception e) {
            error = "Dữ liệu đặt bàn không hợp lệ.";
        }
    }

    String maDatBan = null;

    if (error == null) {
        BookedTableDAO4 btDAO = new BookedTableDAO4();

        // --- Buoc 2: kiem tra lai ban van con trong trong khung gio ---
        if (!btDAO.checkTableAvailable(idTable, startTime, endTime)) {
            error = "Bàn vừa được khách khác đặt trong khung giờ này. Vui lòng chọn bàn khác.";
            btDAO.closeConnection();
        } else {
            // --- Buoc 3: tim hoac luu khach hang ---
            CustomerDAO4 khDAO = new CustomerDAO4();
            Customer4 customer = khDAO.getCustomerByPhone(sdt.trim());
            if (customer == null) {
                customer = new Customer4();
                customer.setName(hoTen.trim());
                customer.setPhone(sdt.trim());
                customer.setEmail(email == null ? "" : email.trim());
                if (khDAO.insertCustomer(customer) < 0) error = DAO4.lastError;
            }
            khDAO.closeConnection();

            // --- Buoc 4: ghi booking dat ban ---
            if (error == null) {
                BookingDAO4 bkDAO = new BookingDAO4();
                Booking4 booking = new Booking4();
                booking.setBookingCode(bkDAO.generateBookingCode(new Date(startTime.getTime())));
                booking.setArrivalTime(startTime);
                booking.setNumGuest(numGuest);
                booking.setDuration(duration);
                booking.setBookingStatus(Booking4.PENDING);
                booking.setNote(ghiChu);
                booking.setCustomer(customer);

                if (bkDAO.saveBooking(booking) < 0) {
                    error = DAO4.lastError;
                } else {
                    // --- Buoc 5: ghi chi tiet ban dat (lop lien ket) ---
                    TableDAO4 tDAO = new TableDAO4();
                    Table4 ban = tDAO.getTableById(idTable);
                    tDAO.closeConnection();

                    BookedTable4 bt = new BookedTable4();
                    bt.setStartTime(startTime);
                    bt.setEndTime(endTime);
                    bt.setSeatingStatus(BookedTable4.BOOKED);
                    bt.setBooking(booking);
                    bt.setTable(ban);

                    if (!btDAO.saveBookedTable(bt)) error = DAO4.lastError;
                    else maDatBan = booking.getBookingCode();
                }
                bkDAO.closeConnection();
            }
            btDAO.closeConnection();
        }
    }

    // --- Buoc 6: dieu huong ---
    if (error == null) {
        response.sendRedirect("gdKetQuaDatBan4.jsp?ma=" + URLEncoder.encode(maDatBan, "UTF-8")
                + "&hoTen=" + URLEncoder.encode(hoTen.trim(), "UTF-8")
                + "&sdt=" + URLEncoder.encode(sdt.trim(), "UTF-8")
                + "&idTable=" + idTable
                + "&ngayDen=" + ngayDen + "&gioDen=" + gioDen
                + "&soKhach=" + numGuest + "&duration=" + duration);
    } else {
        response.sendRedirect("gdThongTinKH4.jsp?loi=" + URLEncoder.encode(error, "UTF-8")
                + "&ngayDen=" + ngayDen + "&gioDen=" + gioDen
                + "&soKhach=" + sSoKhach + "&duration=" + sDuration
                + "&idTable=" + sIdTable);
    }
%>
