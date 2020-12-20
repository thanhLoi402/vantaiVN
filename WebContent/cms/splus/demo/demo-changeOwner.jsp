<%@ page import="tdt.db.vas.viettel.splus.cdr.CdrChangeOwnerQueue" %>
<%@ page import="tdt.db.vas.viettel.splus.cdr.CdrChangeOwnerDAO" %>
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
    String exportTime = request.getParameter("exportTime");
    String creditTime = request.getParameter("creditTime");
    String topupTransId = request.getParameter("topupTransId");
    String debt = request.getParameter("debt");
    if(exportTime == null)
        exportTime = "";
    if(creditTime == null)
        creditTime = "";
    if(topupTransId == null)
        topupTransId = "";
    if(debt == null)
        debt = "";
    if(!"".equals(msisdnId) && !"".equals(exportTime) && !"".equals(creditTime)&& !"".equals(topupTransId)&& !"".equals(debt)) {
        CdrChangeOwnerQueue cdrChangeOwnerQueue = new CdrChangeOwnerQueue();
        boolean isInserted = false;
        try {
            cdrChangeOwnerQueue.setMsisdnId(msisdnId.trim());
            cdrChangeOwnerQueue.setTimeChange(new BigDecimal(exportTime.trim()));
            cdrChangeOwnerQueue.setTimeTopup(new BigDecimal(creditTime.trim()));
            cdrChangeOwnerQueue.setMpTransid(topupTransId.trim());
            cdrChangeOwnerQueue.setMpPrice(new BigDecimal(debt.trim()));
            cdrChangeOwnerQueue.setFileName("demo cms");
            cdrChangeOwnerQueue.setStatus(new BigDecimal(0));
            CdrChangeOwnerDAO cdrChangeOwnerDAO = new CdrChangeOwnerDAO();
            isInserted = cdrChangeOwnerDAO.add2CdrChangeOwnerByEachRecord(cdrChangeOwnerQueue);
        } catch (Exception e) {
            e.printStackTrace();
        }
        if(isInserted) {
            resultInsertTopup = "<span style='font-size: 13px;margin: 10px 0 0 10px;color:green;'>Insert CDR CHANGE OWNER success.</span>";
        }
        else {
            resultInsertTopup = "<span style='font-size: 13px;margin: 10px 0 0 10px;color:#dd3d08;'>Insert CDR CHANGE OWNER unsuccess.</span>";
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
            <span align="center" style="font-size: 15px;margin: 15px; font-weight: bold">Form nhập CDR_CHANGE_OWNER</span>
            <%
                if(!"".equals(resultInsertTopup)) {
                    out.print(resultInsertTopup);
                }
            %>
            <form method="post" name="frmList" style="padding: 15px;">
                <label for="msisdnId">MSISDN_IN</label>
                <input type="text" id="msisdnId" class="text-input small-input" name="msisdnId" value="" placeholder="Nhập MSISDN_ID" style="margin-bottom: 15px;"/>
                <div class="clear"></div>
                <label for="type">Time tạo cdr</label>
                <input type="text" id="exportTime" class="text-input small-input" name="exportTime" value="" placeholder="Nhập time dạng số yyyyMMddhh24miss" style="margin-bottom: 15px;"/>
                <div class="clear"></div>
                <label for="type">Time Topup</label>
                <input type="text" id="creditTime" class="text-input small-input" name="creditTime" value="" placeholder="Nhập time dạng số yyyyMMddhh24miss" style="margin-bottom: 15px;"/>
                <div class="clear"></div>
                <label for="type">Mã giao dịch ứng</label>
                <input type="text" id="topupTransId" class="text-input small-input" name="topupTransId" value="" placeholder="topup transID" style="margin-bottom: 15px;"/>
                <div class="clear"></div>
                <label for="type">Số tiền còn nợ của giao dịch ứng</label>
                <input type="text" id="debt" class="text-input small-input" name="debt" value="" placeholder="debt" style="margin-bottom: 15px;"/>
                <div class="clear"></div>
                <input type="button" value="Submit" class="button" onclick="frmList.submit();"/>
            </form>
        </div> <!-- End .content-box -->
        <%@include file="/admin/include/footer.jsp" %>
    </div>
</div>
</body>
</html>
