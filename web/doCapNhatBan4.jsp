<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="dao.BookedTableDAO4, model.BookedTable4" %>
<%
    // Trang xu li: chuyen trang thai mot luot dat ban theo thao tac cua nhan vien
    String sId = request.getParameter("id");
    String tt  = request.getParameter("tt");
    if (sId != null && tt != null) {
        String tinhTrang = null;
        if ("nhan".equals(tt))          tinhTrang = BookedTable4.SERVING;
        else if ("tra".equals(tt))      tinhTrang = BookedTable4.RETURNED;
        else if ("khongden".equals(tt)) tinhTrang = BookedTable4.NO_SHOW;
        else if ("huy".equals(tt))      tinhTrang = BookedTable4.CANCELLED;
        else if ("cho".equals(tt))      tinhTrang = BookedTable4.WAITING_TABLE;

        if (tinhTrang != null) {
            BookedTableDAO4 dao = new BookedTableDAO4();
            dao.updateSeatingStatus(Integer.parseInt(sId), tinhTrang);
            dao.closeConnection();
        }
    }
    response.sendRedirect("gdSoDoBan4.jsp");
%>
