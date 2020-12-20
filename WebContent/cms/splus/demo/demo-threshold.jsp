<%@page import="tdt.db.vas.viettel.splus.user.service.UserCreditTmpDAO"%>
<%@page import="tdt.vas.viettel.splus.common.MPCons"%>
<%@ page import="tdt.db.vas.viettel.splus.cdr.CdrThresholdQueueDAO" %>
<%@ page import="tdt.db.vas.viettel.splus.cdr.CdrThresholdQueue" %>
<%@ page import="java.sql.Timestamp" %>
<%@ page import="tdt.db.vas.viettel.splus.user.service.UserCreditSpecialDAO" %>
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
        String resultInsertThreshold = "";
        String msisdnId = request.getParameter("msisdnId");
        if (msisdnId == null) {
            msisdnId = "";
        }
        String type = request.getParameter("type");
        if (type == null) {
            type = "";
        }
        String groupType = request.getParameter("groupType");
        if (groupType == null) {
            groupType = "";
        }
        System.out.println("groupType:"+ groupType);
        String lastActionType = request.getParameter("lastActionType");
        if (lastActionType == null) {
            lastActionType = "";
        }
        String actInScopeType = request.getParameter("actInScopeType");
        if (actInScopeType == null) {
            actInScopeType = "";
        }

        if (!"".equals(msisdnId) && !"".equals(type) && !"".equals(lastActionType) && !"".equals(actInScopeType)) {
            CdrThresholdQueue cdrThresholdQueue = new CdrThresholdQueue();
            boolean isInserted = false;
            try {
                cdrThresholdQueue.setMsisdnId(msisdnId.trim());
                cdrThresholdQueue.setType(Integer.valueOf(type.trim()));
                cdrThresholdQueue.setTimeMark(Long.valueOf(new SimpleDateFormat("yyyyMMddHHmmss").format(new Timestamp(System.currentTimeMillis()))));
                cdrThresholdQueue.setLastActType(Integer.valueOf(lastActionType.trim()));
                cdrThresholdQueue.setActInScopeType(Integer.valueOf(actInScopeType.trim()));
                cdrThresholdQueue.setFileName("WEB_PORTAL");
                cdrThresholdQueue.setGroupType(Integer.parseInt(groupType));
                
                CdrThresholdQueueDAO cdrThresholdQueueDAO = new CdrThresholdQueueDAO();
                isInserted = cdrThresholdQueueDAO.add2CdrThreshold(cdrThresholdQueue);
            } catch (Exception e) {
                e.printStackTrace();
            }
            if (isInserted) {
                resultInsertThreshold = "<span style='font-size: 13px;margin: 10px 0 0 10px;color:green;'>Insert CDR_THRESHOLD success.</span>";
            } else {
                resultInsertThreshold = "<span style='font-size: 13px;margin: 10px 0 0 10px;color:#dd3d08;'>Insert CDR_THRESHOLD unsuccess.</span>";
            }
        }

        String action = request.getParameter("action");
        String resultInsertCredit = "";
        String msisdnIdCreditTmp = request.getParameter("msisdnIdCreditTmp");
        if (msisdnIdCreditTmp == null) {
            msisdnIdCreditTmp = "";
        }
        String currPoint = request.getParameter("currPoint");
        if (currPoint == null) {
            currPoint = "";
        }
        String priPricePoint = request.getParameter("priPricePoint");
        if (priPricePoint == null || priPricePoint.trim().equals("")) {
            priPricePoint = "0";
        }
        String priPckPoint = request.getParameter("priPckPoint");
        if (priPckPoint == null || priPckPoint.trim().equals("")) {
            priPckPoint = "0";
        }
        if (!"".equals(msisdnIdCreditTmp) && !"".equals(currPoint)) {
            if (action != null && action.trim().equals("addCreditTmp")) {
                UserCreditTmpDAO userCreditTmpDAO1234 = new UserCreditTmpDAO();
                int insertOrUpdate = 0;
                try {
                    insertOrUpdate = userCreditTmpDAO1234.insertOrUpdate(msisdnIdCreditTmp.trim(), Integer.valueOf(currPoint.trim()), Integer.valueOf(priPricePoint.trim()), Integer.valueOf(priPckPoint.trim()), 123);
                } catch (Exception e) {
                    e.printStackTrace();
                }
                if (insertOrUpdate > 0) {
                    resultInsertCredit = "<span style='font-size: 13px;margin: 10px 0 0 10px;color:green;'>Insert Or Update USER_CREDIT_TMP success</span>";
                } else {
                    resultInsertCredit = "<span style='font-size: 13px;margin: 10px 0 0 10px;color:#dd3d08;'>Insert Or Update USER_CREDIT_TMP unsuccess</span>";
                }
            } else if (action != null && action.trim().equals("addCreditSpecial")) {
                UserCreditSpecialDAO userCreditSpecialDAO = new UserCreditSpecialDAO(); 
                int insertOrUpdate = 0;
                try {
                    insertOrUpdate = userCreditSpecialDAO.insertOrUpdate(msisdnIdCreditTmp.trim(), Integer.valueOf(currPoint.trim()), Integer.valueOf(priPricePoint.trim()), Integer.valueOf(priPckPoint.trim()), 0, "IVR"); 
                } catch (Exception e) {
                    e.printStackTrace();
                }
                if (insertOrUpdate > 0) {
                    resultInsertCredit = "<span style='font-size: 13px;margin: 10px 0 0 10px;color:green;'>Insert Or Update SP_USER_CREDIT_SPECIAL success</span>";
                } else {
                    resultInsertCredit = "<span style='font-size: 13px;margin: 10px 0 0 10px;color:#dd3d08;'>Insert Or Update SP_USER_CREDIT_SPECIAL unsuccess</span>";
                }
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
                    <span align="center" style="font-size: 15px;margin: 15px; font-weight: bold">Form nhập điểm tín dụng</span>
                    <%
                        if (!"".equals(resultInsertCredit)) {
                            out.print(resultInsertCredit);
                        }
                    %>
                    <form method="post" name="frmUpdate" style="padding: 15px;">
                        <label for="msisdnIdCreditTmp">MSISDN_IN</label>
                        <input type="hidden" name="action" value="">
                        <input type="text" id="msisdnIdCreditTmp" class="text-input small-input" name="msisdnIdCreditTmp" value="" placeholder="Nhập MSISDN_ID" style="margin-bottom: 15px;"/>
                        <div class="clear"></div>
                        <label for="currPoint">ĐIỂM TÍN DỤNG</label>
                        <input type="number" id="currPoint" class="text-input small-input" name="currPoint" value="" placeholder="Nhập điểm tín dụng" style="margin-bottom: 15px;"/>
                        <div class="clear"></div>
                        <label for="priPricePoint">ĐIỂM TÍN DỤNG ƯU TIÊN GIÁ</label>
                        <input type="number" id="priPricePoint" class="text-input small-input" name="priPricePoint" value="" placeholder="Nhập điểm tín dụng" style="margin-bottom: 15px;"/>
                        <div class="clear"></div>
                        <label for="priPckPoint">ĐIỂM TÍN DỤNG ƯU TIÊN GÓI</label>
                        <input type="number" id="priPckPoint" class="text-input small-input" name="priPckPoint" value="" placeholder="Nhập điểm tín dụng" style="margin-bottom: 15px;"/>
                        <div class="clear"></div>
                        <input type="button" value="Add credit tmp" class="button" onclick="addCreditTmp()"/>
                        <input type="button" value="Add credit special" class="button" onclick="addCreditSpecial()"/>
                    </form>
                </div> <!-- End .content-box -->
                <div class="clear"></div>
                <div class="content-box" style="padding: 15px;"><!-- Start Content Box -->
                    <span align="center" style="font-size: 15px;margin: 15px; font-weight: bold">Form nhập CDR_THRESHOLD</span>
                    <%
                        if (!"".equals(resultInsertThreshold)) {
                            out.print(resultInsertThreshold);
                        }
                        %>
                    <form method="post" name="frmList" style="padding: 15px;">
                        <label for="msisdnId">MSISDN_IN</label>
                        <input type="text" id="msisdnId" class="text-input small-input" name="msisdnId" value="" placeholder="Nhập MSISDN_ID" style="margin-bottom: 15px;"/>
                        <div class="clear"></div>
                        <label for="type">TYPE</label>
                        <select id="type" name="type" style="width: 260px;margin-bottom: 15px;">
                            <option value="1">THRESHOLD 0 - 1.000</option>
                            <option value="2">THRESHOLD 1.000 - 5.000</option>
                            <option value="3">THRESHOLD 5.000 - 50.000</option>
                        </select>
                        <div class="clear"></div>
                        <label for="groupType">GROUP_TYPE</label>
                        <select id="groupType" name="groupType" style="width: 260px;margin-bottom: 15px;">
                            <option value="1">Normal</option>
                            <option value="2">CallBase</option>
                            <option value="3">CallBase2</option>
                            <option value="4">DATA</option>
                        </select>
                        <div class="clear"></div>
                        <label>LAST ACTION TYPE</label>
                        <input type="radio" name="lastActionType" value="0" checked>VOICE
                        <input type="radio" name="lastActionType" value="1">SMS
                        <input type="radio" name="lastActionType" value="2">DATA
                        <input type="radio" name="lastActionType" value="-1" style="margin-bottom: 15px;">Unknow
                        <div class="clear"></div>
                        <label for="actInScopeType">Chọn ACT_IN_SCOPE_TYPE</label>
                        <select id="actInScopeType" name="actInScopeType" style="width: 260px;margin-bottom: 15px;">
                            <option value="1">Nội mạng</option>
                            <option value="2">Ngoại mạng</option>
                            <option value="-1">Unknow</option>
                        </select>
                        <div class="clear"></div>
                        <input type="button" value="Submit" class="button" onclick="frmList.submit();"/>
                    </form>
                </div> <!-- End .content-box -->

                <script type="text/javascript">

                    function addCreditTmp() {
                        document.frmUpdate.action.value = "addCreditTmp";
                        document.frmUpdate.submit();
                    }
                    function addCreditSpecial() {
                        document.frmUpdate.action.value = "addCreditSpecial";
                        document.frmUpdate.submit();
                    }

                </script>
                <%@include file="/admin/include/footer.jsp" %>
            </div>
        </div>
    </body>
</html>
