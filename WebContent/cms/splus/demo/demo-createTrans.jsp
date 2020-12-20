<%@page import="tdt.util.conf.ConfigUtil"%>
<%@page import="tdt.vas.viettel.splus.common.SPCommonTool"%>
<%@page import="tdt.vas.viettel.splus.common.SPlusTool"%>
<%@page import="tdt.vas.viettel.splus.common.MPCons"%>
<%@page import="tdt.db.vas.viettel.splus.service.TopupLog"%>
<%@ page import="tdt.db.vas.viettel.splus.service.TopupLogDAO" %>
<%@ page import="tdt.db.vas.viettel.splus.service.MPCommonDAO" %>
<%@ page import="java.sql.Timestamp" %>
<%@page language="java" pageEncoding="utf-8" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
        <title>Form nhập dữ liệu test</title>
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
        SimpleDateFormat formatDateyyyyMMddHHmmss = new SimpleDateFormat("yyyyMMddHHmmss");

        String resultInsertTopup = "";
        String msisdnId = request.getParameter("msisdnId");
        String rsCode = request.getParameter("rsCode");
        String scopeCode = request.getParameter("scopeCode");
        String strPckValue = request.getParameter("pckValue");
        String strPrice = request.getParameter("price");
        Integer pckValue = 0;
        BigDecimal price = new BigDecimal(0);
        if (msisdnId == null) {
            msisdnId = "";
        }
        if (rsCode == null) {
            rsCode = "";
        }
        if (scopeCode == null) {
            scopeCode = "";
        }
        if (strPckValue != null) {
            pckValue = new Integer(strPckValue);
        }
        if (strPrice != null) {
            price = new BigDecimal(strPrice);
        }
        if (!"".equals(msisdnId) && !"".equals(rsCode)&& !"".equals(scopeCode)&& !"".equals(strPckValue)&& !"".equals(strPrice)) {
            boolean isInserted = false;
            try {
                TopupLogDAO topupLogDAO = new TopupLogDAO();
                MPCommonDAO mpCommonDAO = new MPCommonDAO();
                TopupLog topupLog = new TopupLog();
                topupLog.setInviteId(new BigDecimal(0));
                topupLog.setSubInviteId(new BigDecimal(0));
                topupLog.setUserReqId(new BigDecimal(0));
                topupLog.setMsisdnId(msisdnId);
                topupLog.setMpTransId(MPCons.MP_TRANSID_PREFIX_TOPUP + mpCommonDAO.createTransId());
                topupLog.setMpType(ConfigUtil.getMpTopupType(rsCode, scopeCode));
                topupLog.setMpAmount(pckValue);
                topupLog.setMpPrice(price);
                topupLog.setMpRespDesc("DL_TEST_CMS");
                topupLog.setMpRespCode("0");
                topupLog.setMpRespTime(new Long(formatDateyyyyMMddHHmmss.format(new Date())));
                topupLog.setCapital(0L);
                isInserted = topupLogDAO.add2TopupLog(topupLog);

            } catch (Exception e) {
                e.printStackTrace();
            }
            if (isInserted) {
                resultInsertTopup = "<span style='font-size: 13px;margin: 10px 0 0 10px;color:green;'>Insert SP_TOPUP_LOG success.</span>";
            } else {
                resultInsertTopup = "<span style='font-size: 13px;margin: 10px 0 0 10px;color:#dd3d08;'>Insert SP_TOPUP_LOG unsuccess.</span>";
            }
        }else{
            resultInsertTopup = "<span style='font-size: 13px;margin: 10px 0 0 10px;color:#dd3d08;'>Phải nhập đủ dữ liệu</span>";
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
                    <span align="center" style="font-size: 15px;margin: 15px; font-weight: bold">Form nhập thông tin Topup_log</span>
                    <%
                        if (!"".equals(resultInsertTopup)) {
                            out.print(resultInsertTopup);
                        }
                %>
                    <form method="post" name="frmList" style="padding: 15px;">
                        <label for="msisdnId">MSISDN_IN</label>
                        <input type="text" id="msisdnId" class="text-input small-input" name="msisdnId" value="" placeholder="Nhập MSISDN_ID" style="margin-bottom: 15px;"/>
                        <div class="clear"></div>
                        
                        <label for="rsCode">Loại tài nguyên</label>
                        <select id="rsCode" name="rsCode" style="width: 260px;margin-bottom: 15px;">
                            <option value="VOICE">VOICE</option>
                            <option value="SMS">SMS</option>
                            <option value="DATA">DATA</option>
                        </select>
                        <div class="clear"></div>
                        
                        <label for="scopeCode">Phạm vi tài nguyên</label>
                        <select id="scopeCode" name="scopeCode" style="width: 260px;margin-bottom: 15px;">
                            <option value="IN">IN</option>
                            <option value="OUT">OUT</option>
                            <option value="UNKNOWN">UNKNOWN</option>
                        </select>
                        <div class="clear"></div>
                        
                        <label for="pckValue">Số lượng tài nguyên</label>
                        <input type="text" id="pckValue" class="text-input small-input" name="pckValue" value="" placeholder="Nhập số lượng tài nguyên" style="margin-bottom: 15px;"/>
                        <div class="clear"></div>
                        
                        <label for="price">Số tiền</label>
                        <input type="text" id="price" class="text-input small-input" name="price" value="" placeholder="Số tiền" style="margin-bottom: 15px;"/>
                        <div class="clear"></div>
                        
                        <input type="button" value="Submit" class="button" onclick="frmList.submit();"/>
                    </form>
                </div> <!-- End .content-box -->
                <%@include file="/admin/include/footer.jsp" %>
            </div>
        </div>
    </body>
</html>
