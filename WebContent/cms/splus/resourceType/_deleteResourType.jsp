<%@page import="tdt.db.adm.AdminLog"%>
<%@page import="tdt.util.DateProc"%>
<%@page import="java.math.BigDecimal"%>
<%@ page language="java" contentType="application/json; charset=UTF-8"
         pageEncoding="UTF-8"%>
<jsp:useBean id="resourceTypeDAO" class="tdt.db.vas.viettel.splus.conf.ResourceTypeDAO" scope="session"></jsp:useBean>
<%@ include file="../../../admin/include/header.jsp" %>
<%     boolean isDelete = false;
    if (curPageIsDelete) {
        try {
            if (request.getParameter("id") != null) {
                isDelete = resourceTypeDAO.deleteRow(new Long(request.getParameter("id")));
                if (isDelete) {
                    String description = "resourceTypeDAO delete dữ liệu " + request.getParameter("id") + " ngày " + DateProc.getDateString(DateProc.createTimestamp()) + " ";
                    adminLogDAO.insertRow(session.getAttribute("datavasosp.adm.username").toString(), description, AdminLog.TYPE_DELETE);
                }
            }
        } catch (Exception ex) {
        }
    }
%>   
{"success" : "true", "isDelete" : <%=isDelete%>}