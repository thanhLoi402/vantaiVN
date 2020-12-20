<%@ page import="tdt.db.vas.viettel.splus.sms.MTQueue" %>
<%@ page import="tdt.db.vas.viettel.splus.sms.MTQueueDAO" %>
<%@page language="java" pageEncoding="utf-8" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
        <title>Form nhập dữ liệu test MT</title>
        <link rel="icon" href="<%=request.getContextPath()%>/images/icon/admin.ico" type="image/x-icon"/>
        <link rel="stylesheet" href="<%=request.getContextPath()%>/admin/login/resources/css/reset.css" type="text/css" media="screen"/>
        <link rel="stylesheet" href="<%=request.getContextPath()%>/admin/login/resources/css/style.css" type="text/css" media="screen"/>
        <link rel="stylesheet" href="<%=request.getContextPath()%>/admin/login/resources/css/invalid.css" type="text/css" media="screen"/>
        <link rel="stylesheet" href="<%=request.getContextPath()%>/admin/login/resources/css/jquery.datetimepicker.min.css" type="text/css" media="screen"/>
        <script type="text/javascript" src="<%=request.getContextPath()%>/admin/login/resources/scripts/jquery-3.1.1.min.js"></script>
        <script type="text/javascript" src="<%=request.getContextPath()%>/admin/login/resources/scripts/jquery.datetimepicker.full.min.js"></script>
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
    <%    response.setCharacterEncoding("utf-8");
        request.setCharacterEncoding("utf-8");
        String resultInsertMT = "";
        String resultError = "";
        String senderNumber = request.getParameter("senderNumber");
        if (senderNumber == null) {
            senderNumber = "";
        } else {
            senderNumber = senderNumber.trim();
        }

        String serviceNumber = request.getParameter("serviceNumber");
        if (serviceNumber == null) {
            serviceNumber = "";
        } else {
            serviceNumber = serviceNumber.trim();
        }
        String mobileOperator = request.getParameter("mobileOperator");
        if (mobileOperator == null) {
            mobileOperator = "";
        } else {
            mobileOperator = mobileOperator.trim();
        }
        //    String commandCode = request.getParameter("commandCode");
        String commandCode = "AP_TEST";
        if (commandCode == null) {
            commandCode = "";
        } else {
            commandCode = commandCode.trim();
        }
        String contentType = request.getParameter("contentType");
        if (contentType == null) {
            contentType = "";
        } else {
            contentType = contentType.trim();
        }
        String messageType = request.getParameter("messageType");
        if (messageType == null) {
            messageType = "";
        } else {
            messageType = messageType.trim();
        }
        String info = request.getParameter("info");
        if (info == null) {
            info = "";
        } else {
            info = info.trim();
        }
        String requestId = request.getParameter("requestId");
        if (requestId == null) {
            requestId = "";
        } else {
            requestId = requestId.trim();
        }

        String action = request.getParameter("action");
        if (action == null) {
            action = "";
        }
        if (!"".equals(senderNumber) && !"".equals(serviceNumber) && !"".equals(mobileOperator)
                && !"".equals(commandCode) && !"".equals(info) && !"".equals(requestId) && !"".equals(contentType) && !"-1".equals(messageType)) {
            BigDecimal inserted;
            String senderNumberArr[] = senderNumber.split(";");
            if (senderNumberArr != null && senderNumberArr.length > 0) {
                int success  = 0; 
                int total = senderNumberArr.length;
                for (int i = 0; i < senderNumberArr.length; i++) {
                    if (senderNumberArr[i] != null && !senderNumberArr[i].trim().equals("")) {
                        try {
                            MTQueue mtQueue = new MTQueue();
                            mtQueue.setSenderNumber(senderNumberArr[i].trim());
                            mtQueue.setReceiverNumber(senderNumberArr[i].trim());
                            mtQueue.setServiceNumber(serviceNumber);
                            mtQueue.setMobileOperator(mobileOperator);
                            mtQueue.setCommandCode(commandCode);
                            mtQueue.setContentType(Integer.valueOf(contentType));
                            mtQueue.setMessageType(Integer.valueOf(messageType));
                            mtQueue.setInfo(info);
                            mtQueue.setRequestId(requestId);
                            mtQueue.setSource(session.getAttribute("datavasosp.adm.username").toString());
                            MTQueueDAO mtQueueDAO = new MTQueueDAO();
                            inserted = mtQueueDAO.addMT2Queue(mtQueue);
                            if (inserted != null && inserted.intValue() > 0) {
                                success++;
//                                resultInsertMT = "<span style='font-size: 13px;margin: 10px 0 0 10px;color:green;'>Insert MT_QUEUE success.</span>";
                            } else {
//                                resultInsertMT = "<span style='font-size: 13px;margin: 10px 0 0 10px;color:#dd3d08;'>Insert MT_QUEUE unsuccess.</span>";
                            }
                        } catch (Exception e) {
                            resultError = "<span style='font-size: 13px;margin: 10px 0 0 10px;color:#dd3d08;'>Error "+senderNumberArr[i].trim()+".<br />" + e.getMessage() + "</span>";
                            e.printStackTrace();
                        }
                    }
                }
                resultInsertMT = "<span style='font-size: 13px;margin: 10px 0 0 10px;color:green;'>Insert "+success+"/"+total+" record.</span>";
            }
        } else if ("1".equals(action)) {
            resultInsertMT = "<span style='font-size: 13px;margin: 10px 0 0 10px;color:#dd3d08;'>Insert MT_QUEUE unsuccess.<br />Chưa nhập đủ dữ liệu trên form.</span>";
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
                    <span align="center" style="font-size: 15px;margin: 15px; font-weight: bold">Form nhập MT_QUEUE</span>
                    <%
                        if (!"".equals(resultInsertMT)) {
                            out.println(resultInsertMT);
                        }
                        if (!"".equals(resultError)) {
                            out.println(resultError);
                        }
                    %>
                    <form method="post" name="frmList" style="padding: 15px;">
                        <input type="hidden" value="1" name="action">
                        <label for="senderNumber">Danh sách mã số điện thoại cách nhau bởi dấu ';'</label>
                        <textarea id="senderNumber" name="senderNumber" style="width: 380px !important;margin-bottom: 10px;height: 80px;"><%=senderNumber%></textarea>
                        <%--input type="text" id="senderNumber" class="text-input small-input" name="senderNumber" value="<%=senderNumber%>" placeholder="Nhập SENDER_NUMBER" style="margin-bottom: 15px;"/--%>
                        <div class="clear"></div>
                        <%--label for="receiverNumber">RECEIVER_NUMBER</label>
                        <input type="text" id="receiverNumber" class="text-input small-input" name="receiverNumber" value="<%=receiverNumber%>" placeholder="Nhập RECEIVER_NUMBER" style="margin-bottom: 15px;"/--%>
                        <div class="clear"></div>
                        <label for="serviceNumber">Đầu số dịch vụ</label>
                        <input type="text" id="serviceNumber" class="text-input small-input" name="serviceNumber" value="<%=!"".equals(serviceNumber) ? serviceNumber : "511"%>" placeholder="Nhập SERVICE_NUMBER" style="margin-bottom: 15px;"/>
                        <div class="clear"></div>
                        <label for="mobileOperator">Nhà mạng</label>
                        <input type="text" id="mobileOperator" class="text-input small-input" name="mobileOperator" value="<%=!"".equals(mobileOperator) ? mobileOperator : "VIETTEL"%>" placeholder="Nhập MOBILE_OPERATOR" style="margin-bottom: 15px;"/>
                        <div class="clear"></div>
                        <%--label for="commandCode">COMMAND_CODE</label>
                        <input type="text" id="commandCode" class="text-input small-input" name="commandCode" value="<%=commandCode%>" placeholder="Nhập COMMAND_CODE" style="margin-bottom: 15px;"/--%>
                        <div class="clear"></div>
                        <label for="contentType">Loại tin nhắn</label>
                        <input type="text" id="contentType" class="text-input small-input" name="contentType" value="<%= !"".equals(contentType) ? contentType : "0"%>" placeholder="Nhập CONTENT_TYPE" style="margin-bottom: 15px;"/>
                        <div class="clear"></div>
                        <select name="messageType" style="margin-bottom: 15px;width: 180px;">
                            <option value="1" <%= "1".equals(messageType) ? "selected" : ""%> >Sms thông thường</option>
                            <option value="2" <%= ("2".equals(messageType) || "".equals(messageType)) ? "selected" : ""%> >Tin mời sử dụng dịch vụ Airtime</option>
                        </select>
                        <div class="clear"></div> 
                        <label for="info">INFO</label>
                        <textarea id="info" name="info" style="width: 380px !important;margin-bottom: 10px;height: 80px;"><%=info%></textarea>
                        <div class="clear"></div>
                        <label for="requestId">REQUEST_ID</label>
                        <input type="text" id="requestId" class="text-input small-input" name="requestId" value="<%= !"".equals(requestId) ? requestId : "0"%>"  placeholder="Nhập REQUEST_ID" style="margin-bottom: 15px;"/>
                        <div class="clear"></div>
                        <input type="button" value="Submit" class="button" onclick="frmList.submit();"/>
                    </form>
                </div> <!-- End .content-box -->
                <%@include file="/admin/include/footer.jsp" %>
            </div>
        </div>
    </body>
</html>
