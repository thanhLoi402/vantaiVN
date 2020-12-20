<%@page import="tdt.db.viettel.splus.monitor.SPStatistUserActionDAO"%>
<%@page import="tdt.db.viettel.splus.monitor.SPStatistUserAction"%>
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
        Long countTopupTrans = null;
        Long countChargeTrans = null;
        Long countTransDone = null;
        Long totalMoneyTopup = null;
        Long totalMoneyCharge = null;
        Long totalMT = null;
        Long totalMtInviteNotMO = null;
        String msisdn_id = request.getParameter("msisdn_id");
        if (msisdn_id == null) {
            msisdn_id = "";
        }
        String strCountTopupTrans = request.getParameter("countTopupTrans");
        if (strCountTopupTrans != null && !strCountTopupTrans.trim().equals("")) {
            try {
                countTopupTrans = Long.valueOf(strCountTopupTrans);
            } catch (Exception e) {
                e.printStackTrace();
                countTopupTrans = null;
            }
        }
        String strCountChargeTrans = request.getParameter("countChargeTrans");
        if (strCountChargeTrans != null && !strCountChargeTrans.trim().equals("")) {
            try {
                countChargeTrans = Long.valueOf(strCountChargeTrans);
            } catch (Exception e) {
                e.printStackTrace();
                countChargeTrans = null;
            }
        }
        String strCountTransDone = request.getParameter("countTransDone");
        if (strCountTransDone != null && !strCountTransDone.trim().equals("")) {
            try {
                countTransDone = Long.valueOf(strCountTransDone);
            } catch (Exception e) {
                e.printStackTrace();
                countTransDone = null;
            }
        }
        String strTotalMoneyTopup = request.getParameter("totalMoneyTopup");
        if (strTotalMoneyTopup != null && !strTotalMoneyTopup.trim().equals("")) {
            try {
                totalMoneyTopup = Long.valueOf(strTotalMoneyTopup);
            } catch (Exception e) {
                e.printStackTrace();
                totalMoneyTopup = null;
            }
        }
        String strTotalMoneyCharge = request.getParameter("totalMoneyCharge");
        if (strTotalMoneyCharge != null && !strTotalMoneyCharge.trim().equals("")) {
            try {
                totalMoneyCharge = Long.valueOf(strTotalMoneyCharge);
            } catch (Exception e) {
                e.printStackTrace();
                totalMoneyCharge = null;
            }
        }
        String strTotalMT = request.getParameter("totalMT");
        if (strTotalMT != null && !strTotalMT.trim().equals("")) {
            try {
                totalMT = Long.valueOf(strTotalMT);
            } catch (Exception e) {
                e.printStackTrace();
                totalMT = null;
            }
        }
        String strTotalMtInviteNotMO = request.getParameter("totalMtInviteNotMO");
        if (strTotalMtInviteNotMO != null && !strTotalMtInviteNotMO.trim().equals("")) {
            try {
                totalMtInviteNotMO = Long.valueOf(strTotalMtInviteNotMO);
            } catch (Exception e) {
                e.printStackTrace();
                totalMtInviteNotMO = null;
            }
        }

        if (!"".equals(msisdn_id) && (countTopupTrans != null || countChargeTrans != null || countTransDone != null || totalMoneyTopup != null || totalMoneyCharge != null || totalMT != null || totalMtInviteNotMO != null)) {
            SPStatistUserAction statistUserAction = new SPStatistUserAction();
            try {
                statistUserAction.setMsisdnId(msisdn_id.trim());
                statistUserAction.setCountTopupTrans(countTopupTrans);
                statistUserAction.setCountChargeTrans(countChargeTrans);
                statistUserAction.setCountTransDone(countTransDone);
                statistUserAction.setTotalMoneyTopup(totalMoneyTopup);
                statistUserAction.setTotalMoneyCharge(totalMoneyCharge);
                statistUserAction.setTotalMt(totalMT);
                statistUserAction.setTotalInviteNotMO(totalMtInviteNotMO);

                SPStatistUserActionDAO statistUserActionDAO = new SPStatistUserActionDAO();
                if (statistUserActionDAO.countAllById(msisdn_id.trim()) > 0) {
                    // update
                    statistUserActionDAO.updateObj(statistUserAction);
                    resultInsertThreshold = "<span style='font-size: 13px;margin: 10px 0 0 10px;color:green;'>Update DL success.</span>";
                } else {
                    //insert
                    resultInsertThreshold = "<span style='font-size: 13px;margin: 10px 0 0 10px;color:green;'>Insert DL success.</span>";
                    statistUserActionDAO.insertRow(statistUserAction);
                }
            } catch (Exception e) {
                e.printStackTrace();
                resultInsertThreshold = "<span style='font-size: 13px;margin: 10px 0 0 10px;color:#dd3d08;'>Insert or update DL false.</span>";
            }
        } else {
            resultInsertThreshold = "<span style='font-size: 13px;margin: 10px 0 0 10px;color:#dd3d08;'>Msisdn_id và ít nhất 1 trường DL còn lại khác null.</span>";
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
                    <span align="center" style="font-size: 15px;margin: 15px; font-weight: bold">Form nhập lịch sử Tb</span>
                    <%
                        if (!"".equals(resultInsertThreshold)) {
                            out.print(resultInsertThreshold);
                        }
                        %>
                    <form method="post" name="frmUpdate" style="padding: 15px;">
                        <label for="msisdn_id">MSISDN_IN</label>
                        <input type="text" id="msisdn_id" class="text-input small-input" name="msisdn_id" value="" placeholder="Nhập MSISDN_ID" style="margin-bottom: 15px;"/>
                        <div class="clear"></div>
                        <label for="countTopupTrans">Số giao dịch topup</label>
                        <input type="number" id="countTopupTrans" class="text-input small-input" name="countTopupTrans" value="" placeholder="Số giao dịch topup" style="margin-bottom: 15px;"/>
                        <div class="clear"></div>
                        <label for="countChargeTrans">Số giao dịch charge</label>
                        <input type="number" id="countChargeTrans" class="text-input small-input" name="countChargeTrans" value="" placeholder="Số giao dịch charge" style="margin-bottom: 15px;"/>
                        <div class="clear"></div>
                        <label for="countTransDone">Số giao dịch hoàn thành</label>
                        <input type="number" id="countTransDone" class="text-input small-input" name="countTransDone" value="" placeholder="Số giao dịch hoàn thành" style="margin-bottom: 15px;"/>
                        <div class="clear"></div>
                        <label for="totalMoneyTopup">Tổng số tiền topup</label>
                        <input type="number" id="totalMoneyTopup" class="text-input small-input" name="totalMoneyTopup" value="" placeholder="Tổng số tiền topup" style="margin-bottom: 15px;"/>
                        <div class="clear"></div>
                        <label for="totalMoneyCharge">Tổng số tiền charge</label>
                        <input type="number" id="totalMoneyCharge" class="text-input small-input" name="totalMoneyCharge" value="" placeholder="Tổng số tiền charge" style="margin-bottom: 15px;"/>
                        <div class="clear"></div>
                        <label for="totalMT">Tổng số MT(Invite)</label>
                        <input type="number" id="totalMT" class="text-input small-input" name="totalMT" value="" placeholder="Tổng số MT(Invite)" style="margin-bottom: 15px;"/>
                        <div class="clear"></div>
                        <label for="totalMtInviteNotMO">Tổng MT invite chưa có MO phản hồi</label>
                        <input type="number" id="totalMtInviteNotMO" class="text-input small-input" name="totalMtInviteNotMO" value="" placeholder="Tổng MT invite chưa có MO phản hồi" style="margin-bottom: 15px;"/>
                        <div class="clear"></div>
                        <input type="button" value="Insert or update DL" class="button" onclick="frmUpdate.submit();"/>
                    </form>
                </div> <!-- End .content-box -->
                <div class="clear"></div>
                <%@include file="/admin/include/footer.jsp" %>
            </div>
        </div>
    </body>
</html>
