<%@page import="java.text.SimpleDateFormat"%>
<%@page import="tdt.util.StringTool"%>
<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<jsp:useBean id="topupLogDAO" class="tdt.db.viettel.splus.logs.topup.TopupLogDAO" scope="session"></jsp:useBean>
<jsp:useBean id="chargeLogDAO" class="tdt.db.viettel.splus.logs.charge.ChargeLogDAO" scope="session"></jsp:useBean>
<jsp:useBean id="mTLogExtDAO" class="tdt.db.vas.viettel.splus.sms.MTLogExtDAO" scope="session"></jsp:useBean>
<jsp:useBean id="mpCdrThresholdQueueDay" class="tdt.db.service.MPCdrThresholdQueueDay" scope="session"></jsp:useBean>
<jsp:useBean id="mologExtDAO" class="tdt.db.vas.viettel.splus.sms.MOLogExtDAO" scope="session"></jsp:useBean>
<%@ page import="tdt.db.service.MpRespBO" %>
<%@page import="tdt.util.DateProc"%>
<style>
    #tblAlbum td{
        border: 1px solid #ddd !important;
    }
</style>
<%
    request.setCharacterEncoding("utf-8");
    response.setCharacterEncoding("utf-8");

    SimpleDateFormat sdf1 = new SimpleDateFormat("dd/MM/yyyy");
    SimpleDateFormat sdf2 = new SimpleDateFormat("yyMMdd");
    String staDate = request.getParameter("staDate");
    String actionData = request.getParameter("actionData");
    if (staDate == null) {
        staDate = request.getParameter("staDate1");
        if (staDate == null) {
            staDate = sdf1.format(new Date());
        }
    }
    
    List<MpRespBO> listRespCode = null;
    String titelTable = "";
    if (actionData != null && actionData.equals("TOPUP")) {
        listRespCode = topupLogDAO.getListRespCode(staDate, staDate);
        titelTable = "Topup rep";
    } else if (actionData != null && actionData.equals("CHARGE")) {
        listRespCode = chargeLogDAO.getListRespCode(staDate, staDate);
        titelTable = "Charge rep";
    } else if (actionData != null && actionData.equals("MT")) {
        listRespCode = mTLogExtDAO.getListRespCode(staDate, staDate);
        titelTable = "SentMT rep";
    } else if (actionData != null && actionData.equals("CDR")) {
        String strDateyyMmdd = sdf2.format(sdf1.parse(staDate));
        listRespCode = mpCdrThresholdQueueDay.getListRespCode(strDateyyMmdd, staDate);
        titelTable = "Action CDR";
    } else if (actionData != null && actionData.equals("MO")) {
        String strDateyyMmdd = sdf2.format(sdf1.parse(staDate));
        listRespCode = mologExtDAO.getListRespCode(staDate, staDate);
        titelTable = "Action MO";
    }

%>
<h4 align="left" style="margin: 1px 0px;"><%=titelTable%></h4>
<table class="table-striped" style="font-size: 12px !important; width: 100%; color: black; ">
    <thead>
        <tr class="header" bgcolor="c6c6c6" align="center">
            <th>STT</th>
            <th>Ngày tháng</th>
            <th>Mã lỗi</th>
            <th>Số request</th>
        </tr>
    </thead>
    <tfoot>
        <tr>
        </tr>
    </tfoot>
    <tbody>
        <%                                        int index = 1;
            if (listRespCode != null && listRespCode.size() > 0) {
                for (MpRespBO mpRespBO : listRespCode) {
        %>
        <tr class="list">
            <td style="width: 30px; text-align: center;"><b><%=index%></b></td>
            <td style="width: 30%; text-align: center;"><%=mpRespBO.getTime()%> </td>
            <td style="width: 30%; text-align: center;"><%=mpRespBO.getRespCode()%> </td>
            <td style="width: 30%; text-align: center;"><%=String.format("%,.0f", Double.valueOf(mpRespBO.getNumberRequest()))%> </td>
        </tr>
        <%
                    index = index + 1;
                }
            }
        %>
    </tbody>
</table>