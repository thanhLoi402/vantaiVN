<%@ page import="tdt.db.vas.viettel.splus.sms.MOQueue" %>
<%@ page import="tdt.db.vas.viettel.splus.sms.MOQueueDAO" %>
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
    String resultInsertMO = "";
    String senderNumber = request.getParameter("senderNumber");
    if(senderNumber == null)
        senderNumber = "";
    String receiverNumber = request.getParameter("receiverNumber");
    if(receiverNumber == null)
        receiverNumber = "";
    String serviceNumber = request.getParameter("serviceNumber");
    if(serviceNumber == null)
        serviceNumber = "";
    String mobileOperator = request.getParameter("mobileOperator");
    if(mobileOperator == null)
        mobileOperator = "";
    String commandCode = request.getParameter("commandCode");
    if(commandCode == null)
        commandCode = "";
    String info = request.getParameter("info");
    if(info == null)
        info = "";
    String requestId = request.getParameter("requestId");
    if(requestId == null)
        requestId = "";
    if(!"".equals(senderNumber) && !"".equals(receiverNumber) && !"".equals(serviceNumber) && !"".equals(mobileOperator)
            && !"".equals(commandCode) && !"".equals(info) && !"".equals(requestId)) {
        BigDecimal inserted = null;
        try {
            MOQueue moQueue = new MOQueue();
            moQueue.setSenderNumber(senderNumber);
            moQueue.setReceiverNumber(receiverNumber);
            moQueue.setServiceNumber(serviceNumber);
            moQueue.setMobileOperator(mobileOperator);
            moQueue.setCommandCode(commandCode);
            moQueue.setInfo(info);
            moQueue.setRequestId(requestId);

            MOQueueDAO moQueueDAO = new MOQueueDAO();
            inserted = moQueueDAO.add2MOQueueOSP(moQueue);
        } catch (Exception e) {
            e.printStackTrace();
        }
        if(inserted != null && inserted.intValue() > 0) {
            resultInsertMO = "<span style='font-size: 13px;margin: 10px 0 0 10px;color:green;'>Insert MO_QUEUE success.</span>";
        }
        else {
            resultInsertMO = "<span style='font-size: 13px;margin: 10px 0 0 10px;color:#dd3d08;'>Insert MO_QUEUE unsuccess.</span>";
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
            <span align="center" style="font-size: 15px;margin: 15px; font-weight: bold">Form nhập MO_QUEUE</span>
            <%
                if(!"".equals(resultInsertMO)) {
                    out.print(resultInsertMO);
                }
            %>
            <form method="post" name="frmList" style="padding: 15px;">
                <label for="senderNumber">SENDER_NUMBER</label>
                <input type="text" id="senderNumber" class="text-input small-input" name="senderNumber" value="<%=senderNumber%>" placeholder="Nhập SENDER_NUMBER" style="margin-bottom: 15px;"/>
                <div class="clear"></div>
                <label for="receiverNumber">RECEIVER_NUMBER</label>
                <input type="text" id="receiverNumber" class="text-input small-input" name="receiverNumber" value="<%=receiverNumber%>" placeholder="Nhập RECEIVER_NUMBER" style="margin-bottom: 15px;"/>
                <div class="clear"></div>
                <label for="serviceNumber">SERVICE_NUMBER</label>
                <input type="text" id="serviceNumber" class="text-input small-input" name="serviceNumber" value="<%=!"".equals(serviceNumber) ? serviceNumber : "511" %>" placeholder="Nhập SERVICE_NUMBER" style="margin-bottom: 15px;"/>
                <div class="clear"></div>
                <label for="mobileOperator">MOBILE_OPERATOR</label>
                <input type="text" id="mobileOperator" class="text-input small-input" name="mobileOperator" value="<%=!"".equals(mobileOperator) ? mobileOperator : "VIETTEL" %>" placeholder="Nhập MOBILE_OPERATOR" style="margin-bottom: 15px;"/>
                <div class="clear"></div>
                <label for="commandCode">COMMAND_CODE</label>
                <input type="text" id="commandCode" class="text-input small-input" name="commandCode" value="<%=commandCode%>" placeholder="Nhập COMMAND_CODE" style="margin-bottom: 15px;"/>
                <div class="clear"></div>
                <label for="info">INFO</label>
                <textarea id="info" name="info" style="width: 380px !important;margin-bottom: 10px;height: 80px;"><%=info%></textarea>
                <div class="clear"></div>
                <label for="requestId">REQUEST_ID</label>
                <input type="text" id="requestId" class="text-input small-input" name="requestId" value="<%=requestId%>" placeholder="Nhập REQUEST_ID" style="margin-bottom: 15px;"/>
                <div class="clear"></div>
                <input type="button" value="Submit" class="button" onclick="frmList.submit();"/>
            </form>
        </div> <!-- End .content-box -->
        <%@include file="/admin/include/footer.jsp" %>
    </div>
</div>
</body>
</html>
