<%@ page import="tdt.db.vas.viettel.splus.service.ChargeQueue" %>
<%@ page import="tdt.db.vas.viettel.splus.service.ChargeQueueDAO" %>
<%@ page import="java.sql.Timestamp" %>
<%@page language="java" pageEncoding="utf-8" %>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>Form nhập dữ liệu test</title>
    <link rel="icon" href="<%=request.getContextPath() %>/images/icon/admin.ico" type="image/x-icon"/>
    <link rel="stylesheet" href="<%=request.getContextPath() %>/admin/login/resources/css/reset.css" type="text/css" media="screen"/>
    <link rel="stylesheet" href="<%=request.getContextPath() %>/admin/login/resources/css/style.css" type="text/css" media="screen"/>
    <link rel="stylesheet" href="<%=request.getContextPath() %>/admin/login/resources/css/invalid.css" type="text/css" media="screen"/>
    <link rel="stylesheet" href="<%=request.getContextPath() %>/admin/login/resources/css/jquery.datetimepicker.min.css" type="text/css" media="screen"/>
    <script type="text/javascript" src="<%=request.getContextPath() %>/admin/login/resources/scripts/jquery-3.1.1.min.js"></script>
    <script type="text/javascript" src="<%=request.getContextPath() %>/admin/login/resources/scripts/jquery.datetimepicker.full.min.js"></script>
    <style>
        .text-input {
            margin-right: 5px;
        }
        select {
            width: 157px;
            margin-top: 5px;
            margin-right: 5px;
        }
    </style>
</head>
<%@ include file="/admin/include/header.jsp" %>
<%
    response.setCharacterEncoding("utf-8");
    request.setCharacterEncoding("utf-8");
    String resultInsertTopup = "";
    String msisdnId = request.getParameter("msisdnId");
    if(msisdnId == null)
        msisdnId = "";
    String type = request.getParameter("type");
    if(type == null)
        type = "";
    if(!"".equals(msisdnId) && !"".equals(type)) {
        ChargeQueue chargeQueue = new ChargeQueue();
        boolean isInserted = false;
        try {
            chargeQueue.setMsisdnId(msisdnId);
            chargeQueue.setType(Integer.valueOf(type));
            chargeQueue.setSource("WEB_PORTAL");
            ChargeQueueDAO chargeQueueDAO = new ChargeQueueDAO();
            isInserted = chargeQueueDAO.add2ChargeQueue(chargeQueue);
        } catch (Exception e) {
            e.printStackTrace();
        }
        if(isInserted) {
            resultInsertTopup = "<span style='font-size: 13px;margin: 10px 0 0 10px;color:green;'>Insert SP_CHARGE_QUEUE success.</span>";
        }
        else {
            resultInsertTopup = "<span style='font-size: 13px;margin: 10px 0 0 10px;color:#dd3d08;'>Insert SP_CHARGE_QUEUE false.</span>";
        }
    }
%>
<body>
<div id="body-wrapper"> <!-- Wrapper for the radial gradient background -->
    <jsp:include page="/admin/include/left.jsp"/>
    <div id="main-content" style="padding: 15px;"> <!-- Main Content Section with everything -->
        <%@ include file="/admin/include/tool.jsp" %>
        <div class="clear"></div>
        <!-- Page Head -->
        <div class="content-box" style="padding: 15px;"><!-- Start Content Box -->
            <span align="center" style="font-size: 15px;margin: 15px; font-weight: bold">Form nhập CDR_TOPUP</span>
            <%
                if(!"".equals(resultInsertTopup)) {
                    out.print(resultInsertTopup);
                }
            %>
            <form method="post" name="frmList" style="padding: 15px;">
                <label for="msisdnId">MSISDN_IN</label>
                <input type="text" id="msisdnId" class="text-input small-input" name="msisdnId" value="" placeholder="Nhập MSISDN_ID" style="margin-bottom: 15px;"/>
                <div class="clear"></div>
                <label for="type">TYPE</label>
                <select id="type" name="type" style="width: 260px;margin-bottom: 15px;">
                    <option value="1">TOPUP 0 - 5001</option>
                    <option value="2">TOPUP 5001 - 10001</option>
                    <option value="3">TOPUP 10001 - 20001</option>
                    <option value="4">TOPUP 20001 - 30001</option>
                    <option value="5">TOPUP 30001 - 50001</option>
                    <option value="6">TOPUP 50001 - 100001</option>
                    <option value="7">TOPUP 100001 - 1000000</option>
                </select>
                <div class="clear"></div>
                <input type="button" value="Submit" class="button" onclick="frmList.submit();"/>
            </form>
        </div> <!-- End .content-box -->
        <%@include file="/admin/include/footer.jsp" %>
    </div>
</div>
</body>
</html>
