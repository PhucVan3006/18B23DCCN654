<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.io.*, java.net.URLEncoder, javax.servlet.http.Part,
                 dao.DishDAO4, model.Dish4, model.Category4" %>
<%
    // Trang xu li (khong co giao dien): kiem tra du lieu va ghi dish an moi
    request.setCharacterEncoding("UTF-8");

    String name   = request.getParameter("name");
    String idCate = request.getParameter("idCategory");
    String price  = request.getParameter("price");
    String desc   = request.getParameter("description");
    String saleStatus = request.getParameter("saleStatus");
    if (name == null) name = "";
    if (desc == null) desc = "";
    if (saleStatus == null) saleStatus = Dish4.ON_SALE;

    String error = null;

    // --- Buoc 1: kiem tra rang buoc du lieu ---
    double donGia = 0;
    if (name.trim().isEmpty())            error = "Tên món ăn không được để trống.";
    else if (name.length() > 255)         error = "Tên món ăn không được vượt quá 255 kí tự.";
    else if (idCate == null || idCate.isEmpty()) error = "Hãy chọn loại món.";
    else {
        try {
            donGia = Double.parseDouble(price.trim().replace(",", ""));
            if (donGia <= 0) error = "Đơn giá phải là số lớn hơn 0.";
        } catch (Exception e) { error = "Đơn giá phải là số."; }
    }

    // --- Buoc 2: luu tep anh minh hoa ---
    String tenAnh = null;
    if (error == null) {
        try {
            Part part = request.getPart("anh");
            if (part != null && part.getSize() > 0) {
                if (part.getSize() > 5 * 1024 * 1024) {
                    error = "Ảnh minh hoạ vượt quá 5 MB.";
                } else {
                    String goc = new File(part.getSubmittedFileName()).getName();
                    String duoi = goc.contains(".")
                            ? goc.substring(goc.lastIndexOf('.')).toLowerCase() : "";
                    if (!duoi.equals(".jpg") && !duoi.equals(".jpeg") && !duoi.equals(".png")) {
                        error = "Ảnh minh hoạ phải có định dạng .jpg hoặc .png.";
                    } else {
                        tenAnh = "dish_" + System.currentTimeMillis() + duoi;
                        String thuMuc = application.getRealPath("/images");
                        File d = new File(thuMuc);
                        if (!d.exists()) d.mkdirs();
                        part.write(thuMuc + File.separator + tenAnh);
                    }
                }
            }
        } catch (Exception e) {
            error = "Lỗi khi lưu ảnh minh hoạ: " + e.getMessage();
        }
    }

    // --- Buoc 3: kiem tra trung ten va ghi du lieu ---
    if (error == null) {
        DishDAO4 dao = new DishDAO4();
        if (dao.getDishByName(name.trim()) != null) {
            error = "Món ăn \"" + name.trim() + "\" đã tồn tại trong hệ thống.";
        } else {
            Dish4 dish = new Dish4();
            dish.setName(name.trim());
            dish.setPrice(donGia);
            dish.setDescription(desc.trim());
            dish.setSaleStatus(saleStatus);
            dish.setImage(tenAnh);
            dish.setCategory(new Category4(Integer.parseInt(idCate), null));
            if (!dao.insertDish(dish)) {
                error = (dao.lastError != null) ? dao.lastError : "Lỗi ghi dữ liệu, món ăn chưa được thêm.";
            }
        }
        dao.closeConnection();
    }

    // --- Buoc 4: dieu huong ---
    if (error == null) {
        response.sendRedirect("gdQuanLiMonAn4.jsp?ok=1");
    } else {
        String q = "loi=" + URLEncoder.encode(error, "UTF-8")
                 + "&name=" + URLEncoder.encode(name, "UTF-8")
                 + "&idCategory=" + (idCate == null ? "" : idCate)
                 + "&price=" + URLEncoder.encode(price == null ? "" : price, "UTF-8")
                 + "&description=" + URLEncoder.encode(desc, "UTF-8");
        response.sendRedirect("gdThemMonAn4.jsp?" + q);
    }
%>
