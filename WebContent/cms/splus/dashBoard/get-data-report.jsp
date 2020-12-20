<%@ page import="org.json.JSONArray" %>
<jsp:useBean id="chartReportDAO" class="tdt.db.viettel.splus.report.ChartReportDAO" scope="session"></jsp:useBean>
<%@page language="java" pageEncoding="utf-8" %>
<%
    response.setCharacterEncoding("utf-8");
    request.setCharacterEncoding("utf-8");

    String type = request.getParameter("type");
    String dateFrom = request.getParameter("dateFrom");
    String dateTo = request.getParameter("dateTo");
    JSONArray json = new JSONArray();
    if(dateFrom != null && dateTo != null) {
        if(type.equals("MT")) {
            json = chartReportDAO.getMTReport(dateFrom, dateTo);
            out.print(json);
            return;
        }
        else if(type.equals("MO")) {
            json = chartReportDAO.getMOReport(dateFrom, dateTo);
            out.print(json);
            return;
        }
        else if(type.equals("TRANS")) {
            String dataType = request.getParameter("dataType");
            json = chartReportDAO.getTransPaymentReport(dateFrom, dateTo, dataType);
            System.out.println(json.toString());
            out.print(json);
            return;
        }
        else if(type.equals("CDR")) {
            json = chartReportDAO.getCDRReportNew(dateFrom, dateTo);
            System.out.println(json.toString());
            out.print(json);
            return;
        }
    }
    else {
        out.print(json);
        return;
    }
%>