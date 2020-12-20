<%@page import="oracle.sql.ARRAY"%>
<%@ page import="tdt.vas.viettel.splus.common.SPlusTool" %>
<%@ page import="tdt.vas.viettel.splus.common.MPCons" %>
<%@ page import="tdt.vas.viettel.ws.mp.MPWsClientImpl" %>
<%@ page import="tdt.vas.viettel.ws.mp.MPWsClientConf" %>
<%@ page import="tdt.vas.viettel.splus.service.CreditInviteInfo" %>
<%@ page import="tdt.vas.viettel.splus.service.*" %>
<jsp:useBean id="mpCommonDAO" class="tdt.db.vas.viettel.splus.service.MPCommonDAO" scope="session"></jsp:useBean>
<%@page language="java" pageEncoding="utf-8" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
        <title>Form test webservice</title>
        <script type="text/javascript" src="<%=request.getContextPath()%>/admin/login/resources/scripts/jquery-3.1.1.min.js"></script>
        <script type="text/javascript" src="<%=request.getContextPath()%>/admin/login/resources/scripts/jquery.datetimepicker.full.min.js"></script>
        <link rel="icon" href="<%=request.getContextPath()%>/images/icon/admin.ico" type="image/x-icon"/>
        <link rel="stylesheet" href="<%=request.getContextPath()%>/admin/login/resources/css/reset.css" type="text/css" media="screen"/>
        <link rel="stylesheet" href="<%=request.getContextPath()%>/admin/login/resources/css/style.css" type="text/css" media="screen"/>
        <link rel="stylesheet" href="<%=request.getContextPath()%>/admin/login/resources/css/invalid.css" type="text/css" media="screen"/>
        <link rel="stylesheet" href="<%=request.getContextPath()%>/admin/login/resources/css/jquery.datetimepicker.min.css" type="text/css" media="screen"/>
        <style>
            .hidden {
                display: none;
            }
            input[type=button] {
                float: left;
            }
            .spinner {
                width: 70px;
                float: left;
                margin-left: 10px;
            }

            .spinner > div {
                width: 15px;
                height: 15px;
                background-color: #333;

                border-radius: 100%;
                display: inline-block;
                -webkit-animation: sk-bouncedelay 1.4s infinite ease-in-out both;
                animation: sk-bouncedelay 1.4s infinite ease-in-out both;
            }

            .spinner .bounce1 {
                -webkit-animation-delay: -0.32s;
                animation-delay: -0.32s;
            }

            .spinner .bounce2 {
                -webkit-animation-delay: -0.16s;
                animation-delay: -0.16s;
            }

            @-webkit-keyframes sk-bouncedelay {
                0%, 80%, 100% { -webkit-transform: scale(0) }
                40% { -webkit-transform: scale(1.0) }
            }

            @keyframes sk-bouncedelay {
                0%, 80%, 100% {
                    -webkit-transform: scale(0);
                    transform: scale(0);
                } 40% {
                    -webkit-transform: scale(1.0);
                    transform: scale(1.0);
                }
            }
        </style>
    </head>
    <%@ include file="/admin/include/header.jsp" %>
    <%    response.setCharacterEncoding("utf-8");
        request.setCharacterEncoding("utf-8");

        CheckServiceRes checkServiceRes;
        TopupServiceRes topupServiceRes;
        ChargeServiceRes chargeServiceRes;
        CheckSubsServiceRes checkSubsRes;
        MTServiceRes mtServiceRes;
        MOServiceRes moServiceRes;
        ActiveAirtimeBalRes activeAirtimeBalRes;
        CheckDebtAirtimeRes checkDebtAirtimeRes;
        VerifyCardRes verifyCardRes;
        System.out.println("MPWsClientConf.getCallAirtimeWSClientClassPath():"+ MPWsClientConf.getCallAirtimeWSClientClassPath());
        MPWsClientImpl wsClient = (MPWsClientImpl) Class.forName(MPWsClientConf.getCallAirtimeWSClientClassPath()).newInstance();

        String msisdnCheck = "";
        String origTransId = "";
        String origTransTime = "";
        StringBuilder resultWsCHECK = new StringBuilder();

        String msisdnIdTOPUP = "";
        String topupType = "";
        String amountTopup = "";
        String price = "";
        String feeTopup = "";
        StringBuilder resultWsTOPUP = new StringBuilder();

        String msisdnIdTopupData = "";
        String amountTopupData = "";
        String priceData = "";
        String feeTopupData = "";
        StringBuilder resultWsTOPUPDATA = new StringBuilder();

        String msisdnIdCHAGRE = "";
        String chargeType = "";
        String amountCharge = "";
        String topupTransId = "";
        String topupTransTime = "";
        String fee = "";
        StringBuilder resultWsCHARGE = new StringBuilder();

        String msisdnIdCHECKSUBS = "";
        StringBuilder resultWsCHECKSUBS = new StringBuilder();

        String msisdnIdCheckCreditData = "";
        StringBuilder resultWsCHECKCREDITDATA = new StringBuilder();

        String msisdnIdMT = "";
        String mtType = "";
        String moTransId = "";
        String shortCode = "";
        String mtMsg = "";
        StringBuilder resultWsMT = new StringBuilder();

        String msisdnIdMO = "";
        String shortCodeMT = "";
        String moMsg = "";
        StringBuilder resultWsMO = new StringBuilder();

        String msisdnIdActive = "";
        StringBuilder resultWsActive = new StringBuilder();

        String msisdnIdCheckDebtAirtime = "";
        StringBuilder resultWsCheckDebtAirtime = new StringBuilder();

        String msisdnIdVerifyCard = "";
        String pin = "";
        StringBuilder resultWsVerifyCard = new StringBuilder();

        String msisdnIdVoiceIVR = "";
        String inviteId = "";
        String creditInfo = "";
        StringBuilder responseVoiceIVR = new StringBuilder();

        String msisdnIdDebt = "";
        String topupTransIdDebt = "";
        StringBuilder resultWsDebt = new StringBuilder();

        String check = request.getParameter("action");
        System.out.println("check:"+ check);
        if ("wsCHECK".equals(check)) {
            msisdnCheck = request.getParameter("msisdnCheck");
            origTransId = request.getParameter("origTransId");
            origTransTime = request.getParameter("origTransTime");

            CheckServiceReq checkServiceReq = new CheckServiceReq();
            checkServiceReq.setSubId(msisdnCheck);
            checkServiceReq.setOrigtransid(origTransId.trim());
            checkServiceReq.setOrigtranstime(origTransTime.trim());
            checkServiceReq.setTransId(SPlusTool.createTransId(MPCons.MP_TRANSID_PREFIX_TEST));

            checkServiceRes = (CheckServiceRes) wsClient.sendRequestWS(checkServiceReq, MPWsClientConf.getReqTypeCheck());
            if (checkServiceRes != null) {
                resultWsCHECK.append("<h3>Result</h3>");
                resultWsCHECK.append("<p><b>DATE :</b> " + checkServiceRes.getDate() + " </p>");
                resultWsCHECK.append("<p><b>ERROR_CODE:</b> " + checkServiceRes.getErrorCode() + "</p>");
                resultWsCHECK.append("<p><b>TRANS_ID:</b> " + checkServiceRes.getTransId() + "</p>");
                resultWsCHECK.append("<p><b>ORIG_DESC:</b> " + checkServiceRes.getOrigDesc() + "</p>");
                resultWsCHECK.append("<p><b>ORIG_ERR_CODE:</b> " + checkServiceRes.getOrigErrCode() + "</p>");
            } else {
                resultWsCHECK.append("<p style='color: red;'><b>Không có kết quả trả về từ webservice</b></p>");
            }
        } else if ("wsTOPUP".equals(check)) {
            msisdnIdTOPUP = request.getParameter("msisdnIdTopup");
            topupType = request.getParameter("topupType");
            amountTopup = request.getParameter("amountTopup");
            price = request.getParameter("price");
            feeTopup = request.getParameter("feeTopup");

            TopupServiceReq topupServiceReq = new TopupServiceReq();
            topupServiceReq.setSubId(msisdnIdTOPUP.trim());
            topupServiceReq.setType(topupType.trim());
            topupServiceReq.setAmount(amountTopup.trim());
            topupServiceReq.setPrice(price.trim());
            topupServiceReq.setFee(feeTopup.trim());
            topupServiceReq.setTransId(SPlusTool.createTransId(MPCons.MP_TRANSID_PREFIX_TEST));
            //        topupServiceReq.setTransId("osp_test-"+ MPCons.MP_TRANSID_PREFIX_TEST + mpCommonDAO.createTransId());

            topupServiceRes = (TopupServiceRes) wsClient.sendRequestWS(topupServiceReq, MPWsClientConf.getReqTypeTopup());
            if (topupServiceRes != null) {
                resultWsTOPUP.append("<h3>Result</h3>");
                resultWsTOPUP.append("<p><b>DATE :</b> " + topupServiceRes.getMpTopupDate() + " </p>");
                resultWsTOPUP.append("<p><b>ERROR_CODE:</b> " + topupServiceRes.getMpTopupErrCode() + "</p>");
                resultWsTOPUP.append("<p><b>TRANS_ID:</b> " + topupServiceRes.getMpTopupTransid() + "</p>");
                resultWsTOPUP.append("<p><b>DESC:</b> " + topupServiceRes.getMpTopupDesc() + "</p>");
            } else {
                resultWsTOPUP.append("<p style='color: red;'><b>Không có kết quả trả về từ webservice</b></p>");
            }
        } else if ("wsCREDITDATA".equals(check)) {
            msisdnIdTopupData = request.getParameter("msisdnIdTopupData");
            amountTopupData = request.getParameter("amountTopupData");
            priceData = request.getParameter("priceData");
            feeTopupData = request.getParameter("feeTopupData");

            TopupServiceReq topupServiceReq = new TopupServiceReq();
            topupServiceReq.setSubId(msisdnIdTopupData.trim());
            topupServiceReq.setAmount(amountTopupData.trim());
            topupServiceReq.setPrice(priceData.trim());
            topupServiceReq.setFee(feeTopupData.trim());
            topupServiceReq.setTransId(SPlusTool.createTransId(MPCons.MP_TRANSID_PREFIX_TEST));
            //        topupServiceReq.setTransId("osp_test-"+ MPCons.MP_TRANSID_PREFIX_TEST + mpCommonDAO.createTransId());

            topupServiceRes = (TopupServiceRes) wsClient.sendRequestWS(topupServiceReq, MPWsClientConf.getReqTypeCreditData());
            if (topupServiceRes != null) {
                resultWsTOPUPDATA.append("<h3>Result</h3>");
                resultWsTOPUPDATA.append("<p><b>DATE :</b> " + topupServiceRes.getMpTopupDate() + " </p>");
                resultWsTOPUPDATA.append("<p><b>ERROR_CODE:</b> " + topupServiceRes.getMpTopupErrCode() + "</p>");
                resultWsTOPUPDATA.append("<p><b>TRANS_ID:</b> " + topupServiceRes.getMpTopupTransid() + "</p>");
                resultWsTOPUPDATA.append("<p><b>DESC:</b> " + topupServiceRes.getMpTopupDesc() + "</p>");
            } else {
                resultWsTOPUPDATA.append("<p style='color: red;'><b>Không có kết quả trả về từ webservice</b></p>");
            }
        } else if ("wsCHARGE".equals(check)) {
            msisdnIdCHAGRE = request.getParameter("msisdnIdCharge");
            chargeType = request.getParameter("chargeType");
            amountCharge = request.getParameter("amountCharge");
            topupTransId = request.getParameter("topupTransId");
            //        topupTransTime = request.getParameter("topupTransTime");
            //        fee = request.getParameter("fee");

            ChargeServiceReq chargeServiceReq = new ChargeServiceReq();
            chargeServiceReq.setSubId(msisdnIdCHAGRE.trim());
            chargeServiceReq.setType(chargeType.trim());
            chargeServiceReq.setAmount(amountCharge.trim());
            chargeServiceReq.setTransId(SPlusTool.createTransId(MPCons.MP_TRANSID_PREFIX_TEST));
            //        chargeServiceReq.setTransId("osp_test-"+ MPCons.MP_TRANSID_PREFIX_TEST + mpCommonDAO.createTransId());
            chargeServiceReq.setTopupTransId(topupTransId.trim());
            //        chargeServiceReq.setTopupTransTime(topupTransTime.trim());
            //        chargeServiceReq.setFee(fee.trim());

            chargeServiceRes = (ChargeServiceRes) wsClient.sendRequestWS(chargeServiceReq, MPWsClientConf.getReqTypeCharge());
            if (chargeServiceRes != null) {
                resultWsCHARGE.append("<h3>Result</h3>");
                resultWsCHARGE.append("<p><b>DATE :</b> " + chargeServiceRes.getMpChargeDate() + " </p>");
                resultWsCHARGE.append("<p><b>ERROR_CODE:</b> " + chargeServiceRes.getMpChargeErrCode() + "</p>");
                resultWsCHARGE.append("<p><b>TRANS_ID:</b> " + chargeServiceRes.getMpChargeTransid() + "</p>");
                resultWsCHARGE.append("<p><b>DESC:</b> " + chargeServiceRes.getMpChargeDesc() + "</p>");
            } else {
                resultWsCHARGE.append("<p style='color: red;'><b>Không có kết quả trả về từ webservice</b></p>");
            }
        } else if ("wsCHECKSUBS".equals(check)) {
            msisdnIdCHECKSUBS = request.getParameter("msisdnIdCheckSubs");
            CheckSubsServiceReq checkSubs = new CheckSubsServiceReq();
            checkSubs.setSubId(msisdnIdCHECKSUBS.trim());
            checkSubs.setTransId(SPlusTool.createTransId(MPCons.MP_TRANSID_PREFIX_TEST));

            checkSubsRes = (CheckSubsServiceRes) wsClient.sendRequestWS(checkSubs, MPWsClientConf.getReqTypeCheckSubs());
            if (checkSubsRes != null) {
                resultWsCHECKSUBS.append("<h3>Result</h3>");
                resultWsCHECKSUBS.append("<p><b>DATE :</b> " + checkSubsRes.getDate() + " </p>");
                resultWsCHECKSUBS.append("<p><b>ERROR_CODE:</b> " + checkSubsRes.getErrorCode() + "</p>");
                resultWsCHECKSUBS.append("<p><b>TRANS_ID:</b> " + checkSubsRes.getTransId() + "</p>");
                resultWsCHECKSUBS.append("<p><b>DESC:</b> " + checkSubsRes.getDesc() + "</p>");
                resultWsCHECKSUBS.append("<p><b>DCOM:</b> " + checkSubsRes.getDcom() + " (-1:không xác định; 0: không phải Dcom; 1: Dcom)</p>");
                resultWsCHECKSUBS.append("<p><b>STA_TIME:</b> " + checkSubsRes.getStatime() + "</p>");
                resultWsCHECKSUBS.append("<p><b>UNIQUE_SUB_ID:</b> " + checkSubsRes.getUniqueSubId() + "</p>");
            } else {
                resultWsCHECKSUBS.append("<p style='color: red;'><b>Không có kết quả trả về từ webservice</b></p>");
            }
        } else if ("wsCHECKCREDITDATA".equals(check)) {
            msisdnIdCheckCreditData = request.getParameter("msisdnIdCheckCreditData");
            CheckSubsServiceReq checkSubs = new CheckSubsServiceReq();
            checkSubs.setSubId(msisdnIdCheckCreditData.trim());
            checkSubs.setTransId(SPlusTool.createTransId(MPCons.MP_TRANSID_PREFIX_TEST));

            checkSubsRes = (CheckSubsServiceRes) wsClient.sendRequestWS(checkSubs, MPWsClientConf.getReqTypeCheckDataCredit());
            if (checkSubsRes != null) {
                resultWsCHECKCREDITDATA.append("<h3>Result</h3>");
                resultWsCHECKCREDITDATA.append("<p><b>DATE :</b> " + checkSubsRes.getDate() + " </p>");
                resultWsCHECKCREDITDATA.append("<p><b>ERROR_CODE:</b> " + checkSubsRes.getErrorCode() + "</p>");
                resultWsCHECKCREDITDATA.append("<p><b>TRANS_ID:</b> " + checkSubsRes.getTransId() + "</p>");
                resultWsCHECKCREDITDATA.append("<p><b>DESC:</b> " + checkSubsRes.getDesc() + "</p>");
            } else {
                resultWsCHECKCREDITDATA.append("<p style='color: red;'><b>Không có kết quả trả về từ webservice</b></p>");
            }
        } else if ("wsMT".equals(check)) {
            msisdnIdMT = request.getParameter("msisdnIdMT");
            mtType = request.getParameter("mtType");
            moTransId = request.getParameter("moTransId");
            shortCodeMT = request.getParameter("shortCodeMT");
            mtMsg = request.getParameter("mt");

            MTServiceReq mtServiceReq = new MTServiceReq();
            mtServiceReq.setSubId(msisdnIdMT.trim());
            mtServiceReq.setType(mtType.trim());
            mtServiceReq.setMoTransId(moTransId.trim());
            mtServiceReq.setMt(mtMsg.trim());
            mtServiceReq.setShortCode(shortCodeMT.trim());
            mtServiceReq.setTransId(SPlusTool.createTransId(MPCons.MP_TRANSID_PREFIX_TEST));

            mtServiceRes = (MTServiceRes) wsClient.sendRequestWS(mtServiceReq, MPWsClientConf.getReqTypeSendMT());
            if (mtServiceRes != null) {
                resultWsMT.append("<h3>Result</h3>");
                resultWsMT.append("<p><b>DATE :</b> " + mtServiceRes.getDesc() + " </p>");
                resultWsMT.append("<p><b>ERROR_CODE:</b> " + mtServiceRes.getErrCode() + "</p>");
                resultWsMT.append("<p><b>TRANS_ID:</b> " + mtServiceRes.getTransId() + "</p>");
                resultWsMT.append("<p><b>DESC:</b> " + mtServiceRes.getDesc() + "</p>");
            } else {
                resultWsMT.append("<p style='color: red;'><b>Không có kết quả trả về từ webservice</b></p>");
            }
        } else if ("wsMO".equals(check)) {
            msisdnIdMO = request.getParameter("msisdnIdMO");
            shortCode = request.getParameter("shortCode");
            moMsg = request.getParameter("mo");

            MOServiceReq moServiceReq = new MOServiceReq();
            moServiceReq.setSubId(msisdnIdMO.trim());
            moServiceReq.setShortCode(shortCode.trim());
            moServiceReq.setMo(moMsg.trim());
            moServiceReq.setTransId(SPlusTool.createTransId(MPCons.MP_TRANSID_PREFIX_TEST));

            moServiceRes = (MOServiceRes) wsClient.sendRequestWS(moServiceReq, MPWsClientConf.getReqTypeMO());
            if (moServiceRes != null) {
                resultWsMO.append("<h3>Result</h3>");
                resultWsMO.append("<p><b>DATE :</b> " + moServiceRes.getDesc() + " </p>");
                resultWsMO.append("<p><b>ERROR_CODE:</b> " + moServiceRes.getErrCode() + "</p>");
                resultWsMO.append("<p><b>TRANS_ID:</b> " + moServiceRes.getTransId() + "</p>");
                resultWsMO.append("<p><b>DESC:</b> " + moServiceRes.getDesc() + "</p>");
            } else {
                resultWsMO.append("<p style='color: red;'><b>Không có kết quả trả về từ webservice</b></p>");
            }
        } else if ("wsACTIVE".equals(check)) {
            msisdnIdActive = request.getParameter("msisdnIdActive");
            ActiveAirtimeBalReq activeAirtimeBalReq = new ActiveAirtimeBalReq(msisdnIdActive.trim(), MPWsClientConf.getUsername(), MPWsClientConf.getPassword(), SPlusTool.createTransId(MPCons.MP_TRANSID_PREFIX_ACTIVE_BAL));
            activeAirtimeBalRes = (ActiveAirtimeBalRes) wsClient.sendRequestWS(activeAirtimeBalReq, MPWsClientConf.getReqTypeActive());
            if (activeAirtimeBalRes != null) {
                resultWsActive.append("<h3>Result</h3>");
                resultWsActive.append("<p><b>DATE :</b> " + activeAirtimeBalRes.getMpDate() + " </p>");
                resultWsActive.append("<p><b>ERROR_CODE:</b> " + activeAirtimeBalRes.getMpErrcode() + "</p>");
                resultWsActive.append("<p><b>TRANS_ID:</b> " + activeAirtimeBalRes.getMpTransId() + "</p>");
                resultWsActive.append("<p><b>DESC:</b> " + activeAirtimeBalRes.getMpDesc() + "</p>");
            } else {
                resultWsActive.append("<p style='color: red;'><b>Không có kết quả trả về từ webservice</b></p>");
            }
        } else if ("wsCHECK_DEBT_AIRTIME".equals(check)) {
            msisdnIdCheckDebtAirtime = request.getParameter("msisdnIdCheckDebtAirtime");

            CheckDebtAirtimeReq checkDebtAirtimeReq = new CheckDebtAirtimeReq();
            checkDebtAirtimeReq.setSubId(msisdnIdCheckDebtAirtime.trim());
            checkDebtAirtimeReq.setTransId(SPlusTool.createTransId(MPCons.MP_TRANSID_PREFIX_CHECK_DEBT_AT));
            checkDebtAirtimeRes = (CheckDebtAirtimeRes) wsClient.sendRequestWS(checkDebtAirtimeReq, MPWsClientConf.getReqTypeCheckDebtAirtime());
            if (checkDebtAirtimeRes != null) {
                resultWsCheckDebtAirtime.append("<h3>Result</h3>");
                resultWsCheckDebtAirtime.append("<p><b>DATE :</b> " + checkDebtAirtimeRes.getMpDate() + " </p>");
                resultWsCheckDebtAirtime.append("<p><b>ERROR_CODE:</b> " + checkDebtAirtimeRes.getMpErrcode() + "</p>");
                resultWsCheckDebtAirtime.append("<p><b>TRANS_ID:</b> " + checkDebtAirtimeRes.getMpTransId() + "</p>");
                resultWsCheckDebtAirtime.append("<p><b>DESC:</b> " + checkDebtAirtimeRes.getMpDesc() + "</p>");
            } else {
                resultWsCheckDebtAirtime.append("<p style='color: red;'><b>Không có kết quả trả về từ webservice</b></p>");
            }
        } else if ("wsVERIFY_CARD".equals(check)) {
            msisdnIdVerifyCard = request.getParameter("msisdnIdVerifyCard");
            pin = request.getParameter("pin");

            VerifyCardReq verifyCardReq = new VerifyCardReq();
            verifyCardReq.setSubId(msisdnIdVerifyCard);
            verifyCardReq.setTransId(SPlusTool.createTransId(MPCons.MP_TRANSID_PREFIX_VERIFY_CARD));
            verifyCardReq.setPin(pin);
            verifyCardRes = (VerifyCardRes) wsClient.sendRequestWS(verifyCardReq, MPWsClientConf.getReqTypeVerifyCard());
            if (verifyCardRes != null) {
                resultWsVerifyCard.append("<p><b>DATE:</b> " + verifyCardRes.getDate() + " </p>");
                resultWsVerifyCard.append("<p><b>ERROR_CODE:</b> " + verifyCardRes.getErrCode() + " </p>");
                resultWsVerifyCard.append("<p><b>TRANS_ID:</b> " + verifyCardRes.getTrandId() + " </p>");
                resultWsVerifyCard.append("<p><b>DESC:</b> " + verifyCardRes.getDesc() + " </p>");
                resultWsVerifyCard.append("<p><b>SERIAL:</b> " + verifyCardRes.getSerial() + " </p>");
                resultWsVerifyCard.append("<p><b>USED_TIME:</b> " + verifyCardRes.getUsedTime() + " </p>");
                resultWsVerifyCard.append("<p><b>FACE_VALUE:</b> " + verifyCardRes.getFacevalue() + " </p>");
            } else {
                resultWsVerifyCard.append("<p style='color: red;'><b>Không có kết quả trả về từ webservice</b></p>");
            }
        } else if ("wsCHECK_DEBT".equals(check)) {
            msisdnIdDebt = request.getParameter("msisdnIdCheckDebt");
            topupTransIdDebt = request.getParameter("topupTransIdCheckDebt");
            InfoDebtOfSub infoDebtOfSub = new InfoDebtOfSub();
            infoDebtOfSub.setSubId(msisdnIdDebt);
            infoDebtOfSub.setTopupTransId(topupTransIdDebt);
            infoDebtOfSub.setTransId(SPlusTool.createTransId(MPCons.MP_TRANSID_PREFIX_CHEKDEBT));
            CheckDebtResponseWs checkDebtResponse = (CheckDebtResponseWs) wsClient.sendRequestWS(infoDebtOfSub, MPWsClientConf.getReqTypeCheckDebt());
            if (checkDebtResponse != null) {
                resultWsDebt.append("<p><b>DATE:</b> " + checkDebtResponse.getDate() + " </p>");
                resultWsDebt.append("<p><b>ERROR_CODE:</b> " + checkDebtResponse.getErrorCode() + " </p>");
                resultWsDebt.append("<p><b>DESC:</b> " + checkDebtResponse.getDesc() + " </p>");
                resultWsDebt.append("<p><b>TRANS_ID:</b> " + checkDebtResponse.getTransId() + " </p>");
                resultWsDebt.append("<p><b>FEE:</b> " + checkDebtResponse.getFee() + " </p>");
                resultWsDebt.append("<p><b>LOAN:</b> " + checkDebtResponse.getLoan() + " </p>");
                resultWsDebt.append("<p><b>PAYBACK:</b> " + checkDebtResponse.getPayBack() + " </p>");
            } else {
                resultWsDebt.append("<p style='color: red;'><b>Không có kết quả trả về từ webservice</b></p>");
            }

        } else if ("wsDELETE_LOAN".equals(check)) {
            msisdnIdDebt = request.getParameter("msisdnIdCheckDebt");
            topupTransIdDebt = request.getParameter("topupTransIdCheckDebt");
            InfoDebtOfSub infoDebtOfSub = new InfoDebtOfSub();
            infoDebtOfSub.setSubId(msisdnIdDebt);
            infoDebtOfSub.setTopupTransId(topupTransIdDebt);
            infoDebtOfSub.setTransId(SPlusTool.createTransId(MPCons.MP_TRANSID_PREFIX_DELETELOAN));
            CheckDebtResponseWs checkDebtResponse = (CheckDebtResponseWs) wsClient.sendRequestWS(infoDebtOfSub, MPWsClientConf.getReqTypeDeleteLoan());
            if (checkDebtResponse != null) {
                resultWsDebt.append("<p><b>DATE:</b> " + checkDebtResponse.getDate() + " </p>");
                resultWsDebt.append("<p><b>ERROR_CODE:</b> " + checkDebtResponse.getErrorCode() + " </p>");
                resultWsDebt.append("<p><b>DESC:</b> " + checkDebtResponse.getDesc() + " </p>");
                resultWsDebt.append("<p><b>TRANS_ID:</b> " + checkDebtResponse.getTransId() + " </p>");
                resultWsDebt.append("<p><b>FEE:</b> " + checkDebtResponse.getFee() + " </p>");
                resultWsDebt.append("<p><b>LOAN:</b> " + checkDebtResponse.getLoan() + " </p>");
                resultWsDebt.append("<p><b>PAYBACK:</b> " + checkDebtResponse.getPayBack() + " </p>");
            } else {
                resultWsDebt.append("<p style='color: red;'><b>Không có kết quả trả về từ webservice</b></p>");
            }
        } else if ("wsROLLBACK_LOAN".equals(check)) {
            msisdnIdDebt = request.getParameter("msisdnIdCheckDebt");
            topupTransIdDebt = request.getParameter("topupTransIdCheckDebt");
            InfoDebtOfSub infoDebtOfSub = new InfoDebtOfSub();
            infoDebtOfSub.setSubId(msisdnIdDebt);
            infoDebtOfSub.setTopupTransId(topupTransIdDebt);
            infoDebtOfSub.setTransId(SPlusTool.createTransId(MPCons.MP_TRANSID_PREFIX_ROLLBACK_LOAN));
            CheckDebtResponseWs checkDebtResponse = (CheckDebtResponseWs) wsClient.sendRequestWS(infoDebtOfSub, MPWsClientConf.getReqTypeRollbackLoan());
            if (checkDebtResponse != null) {
                resultWsDebt.append("<p><b>DATE:</b> " + checkDebtResponse.getDate() + " </p>");
                resultWsDebt.append("<p><b>ERROR_CODE:</b> " + checkDebtResponse.getErrorCode() + " </p>");
                resultWsDebt.append("<p><b>DESC:</b> " + checkDebtResponse.getDesc() + " </p>");
                resultWsDebt.append("<p><b>TRANS_ID:</b> " + checkDebtResponse.getTransId() + " </p>");
                resultWsDebt.append("<p><b>FEE:</b> " + checkDebtResponse.getFee() + " </p>");
                resultWsDebt.append("<p><b>LOAN:</b> " + checkDebtResponse.getLoan() + " </p>");
                resultWsDebt.append("<p><b>PAYBACK:</b> " + checkDebtResponse.getPayBack() + " </p>");
            } else {
                resultWsDebt.append("<p style='color: red;'><b>Không có kết quả trả về từ webservice</b></p>");
            }
        } else if ("frmWsVOICEIVR".equals(check)) {
//            MPWsClientImpl wsClientTest = (MPWsClientImpl) Class.forName("tdt.vas.viettel.ws.mp.client.v201809.MPWsClientReq").newInstance();
            msisdnIdVoiceIVR = request.getParameter("msisdnIdVoiceIVR");
            inviteId = request.getParameter("inviteId");
            creditInfo = request.getParameter("creditInfo");
            InviteVoiceSplusReq inviteVoiceSplusReq = new InviteVoiceSplusReq();
            inviteVoiceSplusReq.setSubId(msisdnIdVoiceIVR);
            inviteVoiceSplusReq.setTransId("osp-" + MPCons.MP_TRANSID_PREFIX_VOICE_IVR + inviteId);
            CreditInviteInfo creditInviteInfo[];
            String str[] = creditInfo.split(";");
            if (str != null && str.length > 0) {
                creditInviteInfo = new CreditInviteInfo[str.length];
                for (int i = 0; i < str.length; i++) {
                    String arrayCredit[] = str[i].split(":");
                    creditInviteInfo[i] = new CreditInviteInfo(arrayCredit[0], arrayCredit[1], arrayCredit[2]);
                }
                inviteVoiceSplusReq.setCreditinfo(creditInviteInfo);
            }
            System.out.println("start callWSIVR");
            TopupServiceRes callWSIVR = (TopupServiceRes) wsClient.sendRequestWS(inviteVoiceSplusReq, MPWsClientConf.getReqTypeVoiceSplus());
            System.out.println("end callWSIVR");
            if (callWSIVR != null) {
                responseVoiceIVR.append("<p><b>DATE:</b> " + callWSIVR.getMpTopupDate() + " </p>");
                responseVoiceIVR.append("<p><b>ERROR_CODE:</b> " + callWSIVR.getMpTopupErrCode() + " </p>");
                responseVoiceIVR.append("<p><b>DESC:</b> " + callWSIVR.getMpTopupDesc() + " </p>");
                responseVoiceIVR.append("<p><b>TRANS_ID:</b> " + callWSIVR.getMpTopupTransid() + " </p>");
            } else {
                responseVoiceIVR.append("<p style='color: red;'><b>Không có kết quả trả về từ webservice</b></p>");
            }
            
            System.out.println("responseVoiceIVR:"+ responseVoiceIVR);
        }
    %>
    <body>
        <div id="body-wrapper"> <!-- Wrapper for the radial gradient background -->
            <jsp:include page="/admin/include/left.jsp"/>
            <div id="main-content" style="padding: 15px;"> <!-- Main Content Section with everything -->
                <%@ include file="/admin/include/tool.jsp" %>
                <div class="clear"></div>
                <label for="ws" style="display: block;margin-bottom: 5px;font-weight: bold;font-size: 13px;">Chọn WS</label>
                <select id="ws" name="ws" onchange="chooseWS(this)" style="width: 260px;margin-bottom: 15px;height: 30px;border: 1px solid #ccc;border-radius: 2px;">
                    <option value="-1">-- Chọn WS --</option>
                    <option value="1" <%="wsCHECK".equals(check) ? "selected" : ""%>>CHECK WS</option>
                    <option value="2" <%="wsTOPUP".equals(check) ? "selected" : ""%>>TOPUP WS</option>
                    <option value="3" <%="wsCHARGE".equals(check) ? "selected" : ""%>>CHARGE WS</option>
                    <option value="4" <%="wsCHECKSUBS".equals(check) ? "selected" : ""%>>CHECK SUBS WS</option>
                    <option value="5" <%="wsMT".equals(check) ? "selected" : ""%>>MT WS</option>
                    <option value="6" <%="wsMO".equals(check) ? "selected" : ""%>>MO WS</option>
                    <option value="7" <%="wsACTIVE".equals(check) ? "selected" : ""%>>ACTIVE WS</option>
                    <option value="8" <%="wsCHECK_DEBT_AIRTIME".equals(check) ? "selected" : ""%>>CHECK DEBT AIRTIME WS</option>
                    <option value="9" <%="wsVERIFY_CARD".equals(check) ? "selected" : ""%>>VERIFY CARD WS</option>
                    <option value="10" <%="wsCHECK_DEBT".equals(check) ? "selected" : ""%>>CHECK LOAN WS</option>
                    <option value="11" <%="wsDELETE_LOAN".equals(check) ? "selected" : ""%>>DELETE LOAN WS</option>
                    <option value="12" <%="wsROLLBACK_LOAN".equals(check) ? "selected" : ""%>>ROLL BACK LOAN WS</option>
                    <option value="14" <%="wsCHECK_CREDIT_DATA".equals(check) ? "selected" : ""%>>CHECK CREDIT DATA</option>
                    <option value="15" <%="wsCREDIT_DATA".equals(check) ? "selected" : ""%>>CREDIT DATA</option>
                    <option value="16" <%="frmWsVOICEIVR".equals(check) ? "selected" : ""%>>VOICE IVR</option>
                </select>
                <!-- Begin WS CHECK -->
                <div class="clear"></div>
                <div class="content-box hidden" style="padding: 15px;" id="frmWsCHECK">
                    <form method="post" name="frm" style="padding: 15px;">
                        <input type="hidden" name="action" value="wsCHECK">
                        <input type="hidden" name="selected" value="">
                        <h4 style="margin-bottom: 10px;">Form test webservice CHECK</h4>
                        <div class="clear"></div>
                        <label for="msisdnCheck">MSISDN_ID <span style="font-style: italic;font-weight: normal;">(Id thuê bao cần check)</span></label>
                        <input type="text" id="msisdnCheck" class="text-input small-input" name="msisdnCheck" value="<%=msisdnCheck%>"
                               placeholder="Nhập MSISDN_ID" style="margin-bottom: 15px;"/>
                        <div class="clear"></div>
                        <label for="origTransId">ORIG_TRANS_ID <span style="font-style: italic;font-weight: normal;">(Id giao dịch cần check)</span></label>
                        <input type="text" id="origTransId" class="text-input small-input" name="origTransId" value="<%=origTransId%>"
                               placeholder="Nhập ORIG_TRANS_ID" style="margin-bottom: 15px;"/>
                        <div class="clear"></div>
                        <label for="origTransTime">ORIG_TRANS_TIME <span style="font-style: italic;font-weight: normal;">(thời gian của giao dịch cần check (định dạng yyyyMMdd))</span></label>
                        <input type="text" id="origTransTime" class="text-input small-input" name="origTransTime" value="<%=origTransTime%>"
                               placeholder="Nhập ORIG_TRANS_TIME" style="margin-bottom: 15px;"/>
                        <div class="clear"></div>
                        <input type="button" value="Submit" class="button" onclick="submitForm(this)"/>
                        <div class="spinner hidden">
                            <div class="bounce1"></div>
                            <div class="bounce2"></div>
                            <div class="bounce3"></div>
                        </div>
                    </form>
                    <div style="padding: 15px;" class="msg">
                        <%
                            if (!"".equals(resultWsCHECK)) {
                                out.print(resultWsCHECK);
                            }
                        %>
                    </div>
                </div>
                <!-- End WS CHECK -->
                <!-- Begin WS TOPUP -->
                <div class="clear"></div>
                <div class="content-box hidden" style="padding: 15px;" id="frmWsTOPUP">
                    <form method="post" name="frm" style="padding: 15px;">
                        <input type="hidden" name="action" value="wsTOPUP">
                        <input type="hidden" name="selected" value="">
                        <h4 style="margin-bottom: 10px;">Form test webservice TOPUP</h4>
                        <div class="clear"></div>
                        <label for="msisdnIdTopup">MSISDN_ID <span style="font-style: italic;font-weight: normal;">(Id của thuê bao)</span></label>
                        <input type="text" id="msisdnIdTopup" class="text-input small-input" name="msisdnIdTopup" value="<%=msisdnIdTOPUP%>"
                               placeholder="Nhập MSISDN_ID" style="margin-bottom: 15px;"/>
                        <div class="clear"></div>
                        <label for="topupType">Chọn TYPE <span style="font-style: italic;font-weight: normal;">(Loại tài khoản cộng)</span></label>
                        <select name="topupType" id="topupType" style="margin-bottom: 10px;width: 242px;">
                            <option value="-1">-- Chọn TYPE --</option>
                            <option value="1" <%="1".equals(topupType) ? "selected" : ""%>>Tài khoản gốc</option>
                            <option value="2" <%="2".equals(topupType) ? "selected" : ""%>>Tài khoản khuyến mại</option>
                            <option value="3" <%="3".equals(topupType) ? "selected" : ""%>>Tài khoản phút thoại nội mạng</option>
                            <option value="4" <%="4".equals(topupType) ? "selected" : ""%>>Tài khoản phút thoại ngoại mạng</option>
                            <option value="5" <%="5".equals(topupType) ? "selected" : ""%>>Tài khoản SMS nội mạng</option>
                            <option value="6" <%="6".equals(topupType) ? "selected" : ""%>>Tài khoản SMS ngoại mạng</option>
                            <option value="7" <%="7".equals(topupType) ? "selected" : ""%>>Tài khoản Airtime</option>
                            <option value="8" <%="8".equals(topupType) ? "selected" : ""%>>Tài khoản ứng data</option>
                            <option value="9" <%="9".equals(topupType) ? "selected" : ""%>>Tài khoản ứng gốc</option>
                            <option value="10" <%="10".equals(topupType) ? "selected" : ""%>>Tài khoản ứng khuyến mại</option>
                            <option value="11" <%="11".equals(topupType) ? "selected" : ""%>>Tài khoản ứng phút gọi nội mạng</option>
                            <option value="12" <%="12".equals(topupType) ? "selected" : ""%>>Tài khoản ứng phút gọi ngoại mạng</option>
                            <option value="13" <%="13".equals(topupType) ? "selected" : ""%>>Tài khoản SMS nội mạng</option>
                            <option value="14" <%="14".equals(topupType) ? "selected" : ""%>>Tài khoản SMS ngoại mạng</option>
                        </select>
                        <div class="clear"></div>
                        <label for="amountTopup">AMOUNT_TOPUP <span style="font-style: italic;font-weight: normal;">(Số lượng)</span></label>
                        <input type="number" id="amountTopup" class="text-input small-input" name="amountTopup" value="<%=amountTopup%>"
                               placeholder="Nhập AMOUNT_TOPUP" style="margin-bottom: 15px;"/>
                        <div class="clear"></div>
                        <label for="price">PRICE <span style="font-style: italic;font-weight: normal;">(Tiền ứng)</span></label>
                        <input type="number" id="price" class="text-input small-input" name="price" value="<%=price%>"
                               placeholder="Nhập PRICE" style="margin-bottom: 15px;"/>
                        <div class="clear"></div>
                        <label for="feeTopup">FEE <span style="font-style: italic;font-weight: normal;">(Tiền phí)</span></label>
                        <input type="number" id="feeTopup" class="text-input small-input" name="feeTopup" value="<%=feeTopup%>"
                               placeholder="Nhập FEE" style="margin-bottom: 15px;"/>
                        <div class="clear"></div>
                        <input type="button" value="Submit" class="button" onclick="submitForm(this)"/>
                        <div class="spinner hidden">
                            <div class="bounce1"></div>
                            <div class="bounce2"></div>
                            <div class="bounce3"></div>
                        </div>
                    </form>
                    <div style="padding: 15px;" class="msg">
                        <%
                            if (!"".equals(resultWsTOPUP)) {
                                out.print(resultWsTOPUP);
                            }
                        %>
                    </div>
                </div>
                <!-- End WS TOPUP -->

                <!-- Begin WS TOPUP -->
                <div class="clear"></div>
                <div class="content-box hidden" style="padding: 15px;" id="frmWsCREDITDATA">
                    <form method="post" name="frm" style="padding: 15px;">
                        <input type="hidden" name="action" value="wsCREDITDATA">
                        <input type="hidden" name="selected" value="">
                        <h4 style="margin-bottom: 10px;">Form test webservice CREDIT DATA</h4>
                        <div class="clear"></div>
                        <label for="msisdnIdTopupData">MSISDN_ID <span style="font-style: italic;font-weight: normal;">(Id của thuê bao)</span></label>
                        <input type="text" id="msisdnIdTopupData" class="text-input small-input" name="msisdnIdTopupData" value="<%=msisdnIdTopupData%>"
                               placeholder="Nhập MSISDN_ID" style="margin-bottom: 15px;"/>
                        <div class="clear"></div>
                        <label for="amountTopupData">AMOUNT_TOPUP <span style="font-style: italic;font-weight: normal;">(Số lượng)</span></label>
                        <input type="number" id="amountTopupData" class="text-input small-input" name="amountTopupData" value="<%=amountTopupData%>"
                               placeholder="Nhập AMOUNT_TOPUP" style="margin-bottom: 15px;"/>
                        <div class="clear"></div>
                        <label for="price">PRICE <span style="font-style: italic;font-weight: normal;">(Tiền ứng)</span></label>
                        <input type="number" id="priceData" class="text-input small-input" name="priceData" value="<%=priceData%>"
                               placeholder="Nhập PRICE" style="margin-bottom: 15px;"/>
                        <div class="clear"></div>
                        <label for="feeTopup">FEE <span style="font-style: italic;font-weight: normal;">(Tiền phí)</span></label>
                        <input type="number" id="feeTopupData" class="text-input small-input" name="feeTopupData" value="<%=feeTopupData%>"
                               placeholder="Nhập FEE" style="margin-bottom: 15px;"/>
                        <div class="clear"></div>
                        <input type="button" value="Submit" class="button" onclick="submitForm(this)"/>
                        <div class="spinner hidden">
                            <div class="bounce1"></div>
                            <div class="bounce2"></div>
                            <div class="bounce3"></div>
                        </div>
                    </form>
                    <div style="padding: 15px;" class="msg">
                        <%
                            if (!"".equals(resultWsTOPUPDATA)) {
                                out.print(resultWsTOPUPDATA);
                            }
                        %>
                    </div>
                </div>
                <!-- End WS TOPUP -->


                <!-- Begin WS CHARGE -->
                <div class="clear"></div>
                <div class="content-box hidden" style="padding: 15px;" id="frmWsCHARGE">
                    <form method="post" name="frm" style="padding: 15px;">
                        <input type="hidden" name="action" value="wsCHARGE">
                        <input type="hidden" name="selected" value="">
                        <h4 style="margin-bottom: 10px;">Form test webservice CHARGE</h4>
                        <div class="clear"></div>
                        <label for="msisdnIdCharge">MSISDN_ID <span style="font-style: italic;font-weight: normal;">(Id của thuê bao)</span></label>
                        <input type="text" id="msisdnIdCharge" class="text-input small-input" name="msisdnIdCharge" value="<%=msisdnIdCHAGRE%>"
                               placeholder="Nhập MSISDN_ID" style="margin-bottom: 15px;"/>
                        <div class="clear"></div>
                        <label for="chargeType">Chọn TYPE <span style="font-style: italic;font-weight: normal;">(Loại tài khoản trừ)</span></label>
                        <select name="chargeType" id="chargeType" style="margin-bottom: 10px;width: 242px;">
                            <option value="1" <%="1".equals(chargeType) ? "selected" : ""%>>Tài khoản gốc</option>
                            <option value="2" <%="2".equals(chargeType) ? "selected" : ""%>>Tài khoản khuyến mại</option>
                            <option value="3" <%="3".equals(chargeType) ? "selected" : ""%>>Tài khoản phút thoại nội mạng</option>
                            <option value="4" <%="4".equals(chargeType) ? "selected" : ""%>>Tài khoản phút thoại ngoại mạng</option>
                            <option value="5" <%="5".equals(chargeType) ? "selected" : ""%>>Tài khoản SMS nội mạng</option>
                            <option value="6" <%="6".equals(chargeType) ? "selected" : ""%>>Tài khoản SMS ngoại mạng</option>
                            <option value="7" <%="7".equals(chargeType) ? "selected" : ""%>>Tài khoản Airtime</option>
                            <option value="8" <%="8".equals(chargeType) ? "selected" : ""%>>Tài khoản ứng data</option>
                            <option value="9" <%="9".equals(chargeType) ? "selected" : ""%>>Tài khoản ứng gốc</option>
                            <option value="10" <%="10".equals(chargeType) ? "selected" : ""%>>Tài khoản ứng khuyến mại</option>
                            <option value="11" <%="11".equals(chargeType) ? "selected" : ""%>>Tài khoản ứng phút gọi nội mạng</option>
                            <option value="12" <%="12".equals(chargeType) ? "selected" : ""%>>Tài khoản ứng phút gọi ngoại mạng</option>
                            <option value="13" <%="13".equals(chargeType) ? "selected" : ""%>>Tài khoản SMS nội mạng</option>
                            <option value="14" <%="14".equals(chargeType) ? "selected" : ""%>>Tài khoản SMS ngoại mạng</option>
                        </select>
                        <div class="clear"></div>
                        <label for="amountCharge">AMOUNT_CHARGE <span style="font-style: italic;font-weight: normal;">(Số lượng)</span></label>
                        <input type="number" id="amountCharge" class="text-input small-input" name="amountCharge" value="<%=amountCharge%>"
                               placeholder="Nhập AMOUNT_CHARGE" style="margin-bottom: 15px;"/>
                        <div class="clear"></div>
                        <label for="topupTransId">TOPUP TRANS ID <span style="font-style: italic;font-weight: normal;">(id của giao dịch topup trước đó (nếu không có để rỗng))</span></label>
                        <input type="text" id="topupTransId" class="text-input small-input" name="topupTransId" value="<%=topupTransId%>"
                               placeholder="Nhập TOPUP TRANS ID" style="margin-bottom: 15px;"/>
                        <div class="clear"></div>
                        <input type="button" value="Submit" class="button" onclick="submitForm(this)"/>
                        <div class="spinner hidden">
                            <div class="bounce1"></div>
                            <div class="bounce2"></div>
                            <div class="bounce3"></div>
                        </div>
                    </form>
                    <div style="padding: 15px;" class="msg">
                        <%
                            if (!"".equals(resultWsCHARGE)) {
                                out.print(resultWsCHARGE);
                            }
                        %>
                    </div>
                </div>
                <!-- End WS CHARGE -->
                <!-- Begin WS CHECK SUBS -->
                <div class="clear"></div>
                <div class="content-box hidden" style="padding: 15px;" id="frmWsCHECKSUBS">
                    <form method="post" name="frm" style="padding: 15px;">
                        <input type="hidden" name="action" value="wsCHECKSUBS">
                        <input type="hidden" name="selected" value="">
                        <h4 style="margin-bottom: 10px;">Form test webservice CHECK SUBS</h4>
                        <div class="clear"></div>
                        <label for="msisdnIdCheckSubs">MSISDN_ID <span style="font-style: italic;font-weight: normal;">(Id của thuê bao)</span></label>
                        <input type="text" id="msisdnIdCheckSubs" class="text-input small-input" name="msisdnIdCheckSubs" value="<%=msisdnIdCHECKSUBS%>"
                               placeholder="Nhập MSISDN_ID" style="margin-bottom: 15px;"/>
                        <div class="clear"></div>
                        <input type="button" value="Submit" class="button" onclick="submitForm(this)"/>
                        <div class="spinner hidden">
                            <div class="bounce1"></div>
                            <div class="bounce2"></div>
                            <div class="bounce3"></div>
                        </div>
                    </form>
                    <div style="padding: 15px;" class="msg">
                        <%
                            if (!"".equals(resultWsCHECKSUBS)) {
                                out.print(resultWsCHECKSUBS);
                            }
                        %>
                    </div>
                </div>
                <!-- End WS CHECK SUBS -->

                <!-- Begin WS CHECK SUBS -->
                <div class="clear"></div>
                <div class="content-box hidden" style="padding: 15px;" id="frmWsCHECKCREDITDATA">
                    <form method="post" name="frm" style="padding: 15px;">
                        <input type="hidden" name="action" value="wsCHECKCREDITDATA">
                        <input type="hidden" name="selected" value="">
                        <h4 style="margin-bottom: 10px;">Form test webservice CHECK CREDIT DATA</h4>
                        <div class="clear"></div>
                        <label for="msisdnIdCheckSubs">MSISDN_ID <span style="font-style: italic;font-weight: normal;">(Id của thuê bao)</span></label>
                        <input type="text" id="msisdnIdCheckCreditData" class="text-input small-input" name="msisdnIdCheckCreditData" value="<%=msisdnIdCheckCreditData%>"
                               placeholder="Nhập MSISDN_ID" style="margin-bottom: 15px;"/>
                        <div class="clear"></div>
                        <input type="button" value="Submit" class="button" onclick="submitForm(this)"/>
                        <div class="spinner hidden">
                            <div class="bounce1"></div>
                            <div class="bounce2"></div>
                            <div class="bounce3"></div>
                        </div>
                    </form>
                    <div style="padding: 15px;" class="msg">
                        <%
                            if (!"".equals(resultWsCHECKCREDITDATA)) {
                                out.print(resultWsCHECKCREDITDATA);
                            }
                        %>
                    </div>
                </div>
                <!-- End WS CHECK SUBS -->


                <!-- Begin WS MT -->
                <div class="clear"></div>
                <div class="content-box hidden" style="padding: 15px;" id="frmWsMT">
                    <form method="post" name="frm" style="padding: 15px;">
                        <input type="hidden" name="action" value="wsMT">
                        <input type="hidden" name="selected" value="">
                        <h4 style="margin-bottom: 10px;">Form test webservice MT</h4>
                        <div class="clear"></div>
                        <label for="msisdnIdMT">MSISDN_ID <span style="font-style: italic;font-weight: normal;">(Id của thuê bao)</span></label>
                        <input type="text" id="msisdnIdMT" class="text-input small-input" name="msisdnIdMT" value="<%=msisdnIdMT%>"
                               placeholder="Nhập MSISDN_ID" style="margin-bottom: 15px;"/>
                        <div class="clear"></div>
                        <label for="mtType">Chọn TYPE <span style="font-style: italic;font-weight: normal;">(Loại MT)</span></label>
                        <select name="mtType" id="mtType" style="margin-bottom: 10px;width: 242px;">
                            <option value="-1">-- Chọn TYPE --</option>
                            <option value="1" <%="1".equals(mtType) ? "selected" : ""%>>SMS thông thường</option>
                            <option value="2" <%="2".equals(mtType) ? "selected" : ""%>>Tin mời sử dụng dịch vụ Airtime</option>
                        </select>
                        <label for="moTransId">MO TRANS ID <span style="font-style: italic;font-weight: normal;">(Id giao dịch MO trước đó (nếu không có MO để rỗng))</span></label>
                        <input type="text" id="moTransId" class="text-input small-input" name="moTransId" value="<%=moTransId%>"
                               placeholder="Nhập MO TRANS ID" style="margin-bottom: 15px;"/>
                        <label for="shortCodeMT">SHORT_CODE <span style="font-style: italic;font-weight: normal;">(Đầu số gửi tin)</span></label>
                        <input type="number" id="shortCodeMT" class="text-input small-input" name="shortCodeMT" value="<%=shortCodeMT%>"
                               placeholder="Nhập SHORT_CODE" style="margin-bottom: 15px;"/>
                        <div class="clear"></div>
                        <label for="mt">MT <span style="font-style: italic;font-weight: normal;">(Nội dung tin gửi)</span></label>
                        <input type="text" id="mt" class="text-input small-input" name="mt" value="<%=mtMsg%>"
                               placeholder="Nhập MT" style="margin-bottom: 15px;"/>
                        <div class="clear"></div>
                        <input type="button" value="Submit" class="button" onclick="submitForm(this)"/>
                        <div class="spinner hidden">
                            <div class="bounce1"></div>
                            <div class="bounce2"></div>
                            <div class="bounce3"></div>
                        </div>
                    </form>
                    <div style="padding: 15px;" class="msg">
                        <%
                            if (!"".equals(resultWsMT)) {
                                out.print(resultWsMT);
                            }
                        %>
                    </div>
                </div>
                <!-- End WS MT -->
                <!-- Begin WS MO -->
                <div class="clear"></div>
                <div class="content-box hidden" style="padding: 15px;" id="frmWsMO">
                    <form method="post" name="frm" style="padding: 15px;">
                        <input type="hidden" name="action" value="wsMO">
                        <h4 style="margin-bottom: 10px;">Form test webservice MO</h4>
                        <div class="clear"></div>
                        <label for="msisdnIdMO">MSISDN_ID <span style="font-style: italic;font-weight: normal;">(Id của thuê bao)</span></label>
                        <input type="text" id="msisdnIdMO" class="text-input small-input" name="msisdnIdMO" value="<%=msisdnIdMO%>"
                               placeholder="Nhập MSISDN_ID" style="margin-bottom: 15px;"/>
                        <div class="clear"></div>
                        <label for="shortCode">SHORT_CODE <span style="font-style: italic;font-weight: normal;">(Đầu số gửi tin)</span></label>
                        <input type="text" id="shortCode" class="text-input small-input" name="shortCode" value="<%=shortCode%>"
                               placeholder="Nhập SHORT_CODE" style="margin-bottom: 15px;"/>
                        <div class="clear"></div>
                        <label for="mo">MO <span style="font-style: italic;font-weight: normal;">(Nội dung tin nhắn)</span></label>
                        <input type="text" id="mo" class="text-input small-input" name="mo" value="<%=moMsg%>"
                               placeholder="Nhập MO" style="margin-bottom: 15px;"/>
                        <div class="clear"></div>
                        <input type="button" value="Submit" class="button" onclick="submitForm(this)"/>
                        <div class="spinner hidden">
                            <div class="bounce1"></div>
                            <div class="bounce2"></div>
                            <div class="bounce3"></div>
                        </div>
                    </form>
                    <div style="padding: 15px;" class="msg">
                        <%
                            if (!"".equals(resultWsMO)) {
                                out.print(resultWsMO);
                            }
                        %>
                    </div>
                </div>
                <!-- End WS MO -->
                <!-- Begin WS ACTIVE -->
                <div class="clear"></div>
                <div class="content-box hidden" style="padding: 15px;" id="frmWsACTIVE">
                    <form method="post" name="frm" style="padding: 15px;">
                        <input type="hidden" name="action" value="wsACTIVE">
                        <h4 style="margin-bottom: 10px;">Form test webservice ACTIVE</h4>
                        <div class="clear"></div>
                        <label for="msisdnIdActive">MSISDN_ID <span style="font-style: italic;font-weight: normal;">(Id của thuê bao)</span></label>
                        <input type="text" id="msisdnIdActive" class="text-input small-input" name="msisdnIdActive" value="<%=msisdnIdActive%>"
                               placeholder="Nhập MSISDN_ID" style="margin-bottom: 15px;"/>
                        <div class="clear"></div>
                        <input type="button" value="Submit" class="button" onclick="submitForm(this)"/>
                        <div class="spinner hidden">
                            <div class="bounce1"></div>
                            <div class="bounce2"></div>
                            <div class="bounce3"></div>
                        </div>
                    </form>
                    <div style="padding: 15px;" class="msg">
                        <%
                            if (!"".equals(resultWsActive)) {
                                out.print(resultWsActive);
                            }
                        %>
                    </div>
                </div>
                <!-- End WS MO -->
                <!-- Begin WS CHECK DEBT AIRTIME -->
                <div class="clear"></div>
                <div class="content-box hidden" style="padding: 15px;" id="frmWsCHECK_DEBT_AIRTIME">
                    <form method="post" name="frm" style="padding: 15px;">
                        <input type="hidden" name="action" value="wsCHECK_DEBT_AIRTIME">
                        <h4 style="margin-bottom: 10px;">Form test webservice CHECK DEBT AIRTIME</h4>
                        <div class="clear"></div>
                        <label for="msisdnIdCheckDebtAirtime">MSISDN_ID <span style="font-style: italic;font-weight: normal;">(Id của thuê bao)</span></label>
                        <input type="text" id="msisdnIdCheckDebtAirtime" class="text-input small-input" name="msisdnIdCheckDebtAirtime" value="<%=msisdnIdCheckDebtAirtime%>"
                               placeholder="Nhập MSISDN_ID" style="margin-bottom: 15px;"/>
                        <div class="clear"></div>
                        <input type="button" value="Submit" class="button" onclick="submitForm(this)"/>
                        <div class="spinner hidden">
                            <div class="bounce1"></div>
                            <div class="bounce2"></div>
                            <div class="bounce3"></div>
                        </div>
                    </form>
                    <div style="padding: 15px;" class="msg">
                        <%
                            if (!"".equals(resultWsCheckDebtAirtime)) {
                                out.print(resultWsCheckDebtAirtime);
                            }
                        %>
                    </div>
                </div>
                <!-- End WS CHECK DEBT AIRTIME -->
                <!-- Begin WS VERIFY CARD -->
                <div class="clear"></div>
                <div class="content-box hidden" style="padding: 15px;" id="frmWsVERIFY_CARD">
                    <form method="post" name="frm" style="padding: 15px;">
                        <input type="hidden" name="action" value="wsVERIFY_CARD">
                        <h4 style="margin-bottom: 10px;">Form test webservice VERIFY CARD</h4>
                        <div class="clear"></div>
                        <label for="msisdnIdVerifyCard">MSISDN_ID <span style="font-style: italic;font-weight: normal;">(Id của thuê bao)</span></label>
                        <input type="text" id="msisdnIdVerifyCard" class="text-input small-input" name="msisdnIdVerifyCard" value="<%=msisdnIdVerifyCard%>"
                               placeholder="Nhập MSISDN_ID" style="margin-bottom: 15px;"/>
                        <label for="pin">PIN <span style="font-style: italic;font-weight: normal;">(mã pin)</span></label>
                        <input type="text" id="pin" class="text-input small-input" name="pin" value="<%=pin%>"
                               placeholder="Nhập PIN" style="margin-bottom: 15px;"/>
                        <div class="clear"></div>
                        <input type="button" value="Submit" class="button" onclick="submitForm(this)"/>
                        <div class="spinner hidden">
                            <div class="bounce1"></div>
                            <div class="bounce2"></div>
                            <div class="bounce3"></div>
                        </div>
                    </form>
                    <div style="padding: 15px;" class="msg">
                        <%
                            if (!"".equals(resultWsVerifyCard)) {
                                out.print(resultWsVerifyCard);
                            }
                        %>
                    </div>
                </div>
                <!-- End WS VERIFY CARD -->

                <!-- Begin WS CHECK DEBT -->
                <div class="clear"></div>
                <div class="content-box hidden" style="padding: 15px;" id="frmWsCHECKDEBT">
                    <form method="post" name="frm" style="padding: 15px;">
                        <input type="hidden" name="action" id="action">
                        <input type="hidden" name="selected" value="">
                        <h4 style="margin-bottom: 10px;" id="frmWsCHECKDEBT_h4"></h4>
                        <div class="clear"></div>
                        <label for="msisdnIdCheckDebt">MSISDN_ID <span style="font-style: italic;font-weight: normal;">(Id của thuê bao)</span></label>
                        <input type="text" id="msisdnIdCheckDebt" class="text-input small-input" name="msisdnIdCheckDebt" value="<%=msisdnIdDebt%>"
                               placeholder="Nhập MSISDN_ID" style="margin-bottom: 15px;"/>
                        <div class="clear"></div>
                        <label for="topupTransIdCheckDebt">TOPUP TRANS ID <span style="font-style: italic;font-weight: normal;">(id của giao dịch topup trước đó )</span></label>
                        <input type="text" id="topupTransIdCheckDebt" class="text-input small-input" name="topupTransIdCheckDebt" value="<%=topupTransIdDebt%>"
                               placeholder="Nhập TOPUP TRANS ID" style="margin-bottom: 15px;"/>
                        <div class="clear"></div>
                        <input type="button" value="Submit" class="button" onclick="submitForm(this)"/>
                        <div class="spinner hidden">
                            <div class="bounce1"></div>
                            <div class="bounce2"></div>
                            <div class="bounce3"></div>
                        </div>
                    </form>
                    <div style="padding: 15px;" class="msg" id="responseDebt">
                        <%
                            if (!"".equals(resultWsDebt)) {
                                out.print(resultWsDebt);
                            }
                        %>
                    </div>
                </div>
                <!-- End WS CHECK DEBT -->

                <!-- Begin WS VOICE IVR -->
                <div class="clear"></div>
                <div class="content-box hidden" style="padding: 15px;" id="frmWsVOICEIVR">
                    <form method="post" name="frm" style="padding: 15px;">
                        <input type="hidden" name="action" value="frmWsVOICEIVR">
                        <input type="hidden" name="selected" value="">
                         <h4 style="margin-bottom: 10px;">Form test webservice voice IVR</h4>
                        <div class="clear"></div>
                        <label for="msisdnIdVoiceIVR">MSISDN_ID <span style="font-style: italic;font-weight: normal;">(Id của thuê bao)</span></label>
                        <input type="text" id="msisdnIdVoiceIVR" class="text-input small-input" name="msisdnIdVoiceIVR" value="<%=msisdnIdVoiceIVR%>"
                               placeholder="Nhập MSISDN_ID" style="margin-bottom: 15px;"/>
                        <label for="msisdnIdVoiceIVR">MSISDN_ID <span style="font-style: italic;font-weight: normal;">(Id của thuê bao)</span></label>
                        <input type="text" id="inviteId" class="text-input small-input" name="inviteId" value="<%=inviteId%>"
                               placeholder="Nhập inviteId" style="margin-bottom: 15px;"/>
                        <div class="clear"></div>
                        <label for="creditInfo">Credit Info <span style="font-style: italic;font-weight: normal;">(Nhập thông tin gói mời IVR)</span></label>
                        <input type="text" id="creditInfo" class="text-input small-input" name="creditInfo" value="<%=creditInfo%>"
                               placeholder="1600:VOICE_IN:8;1700:VOICE_OUT:8;126:DATA:200" style="margin-bottom: 15px;"/>
                        <div class="clear"></div>
                        <input type="button" value="Submit" class="button" onclick="submitForm(this)"/>
                        <div class="spinner hidden">
                            <div class="bounce1"></div>
                            <div class="bounce2"></div>
                            <div class="bounce3"></div>
                        </div>
                    </form>
                    <div style="padding: 15px;" class="msg" >
                        <%
                            if (!"".equals(responseVoiceIVR)) {
                                out.print(responseVoiceIVR);
                            }
                        %>
                    </div>
                </div>
                <!-- End WS CHECK DEBT -->


                <%@include file="/admin/include/footer.jsp" %>
            </div>
        </div>
        <script>
            $(document).ready(function () {
                var check = "<%=check%>";
                switch (check) {
                    case "wsCHECK" :
                        hiddenAll();
                        $("#frmWsCHECK").removeClass("hidden");
                        break;
                    case "wsTOPUP" :
                        hiddenAll();
                        $("#frmWsTOPUP").removeClass("hidden");
                        break;
                    case "wsCHARGE" :
                        hiddenAll();
                        $("#frmWsCHARGE").removeClass("hidden");
                        break;
                    case "wsCHECKSUBS" :
                        hiddenAll();
                        $("#frmWsCHECKSUBS").removeClass("hidden");
                        break;
                    case "wsMO" :
                        hiddenAll();
                        $("#frmWsMO").removeClass("hidden");
                        break;
                    case "wsMT" :
                        hiddenAll();
                        $("#frmWsMT").removeClass("hidden");
                        break;
                    case "wsACTIVE" :
                        hiddenAll();
                        $("#frmWsACTIVE").removeClass("hidden");
                        break;
                    case "wsCHECK_DEBT_AIRTIME" :
                        hiddenAll();
                        $("#frmWsCHECK_DEBT_AIRTIME").removeClass("hidden");
                        break;
                    case "wsVERIFY_CARD" :
                        hiddenAll();
                        $("#frmWsVERIFY_CARD").removeClass("hidden");
                        break;
                    case "wsCHECK_DEBT" :
                        hiddenAll();
                        $("#frmWsCHECKDEBT").removeClass("hidden");
                        document.getElementById("frmWsCHECKDEBT_h4").innerHTML = "Form test WS check debt";
                        document.getElementById("action").value = "wsCHECK_DEBT";
                        document.getElementById("msisdnIdCheckDebt").value = "";
                        document.getElementById("topupTransIdCheckDebt").value = "";
                        break;
                    case "wsDELETE_LOAN" :
                        hiddenAll();
                        $("#frmWsCHECKDEBT").removeClass("hidden");
                        document.getElementById("frmWsCHECKDEBT_h4").innerHTML = "Form test WS delete loan";
                        document.getElementById("action").value = "wsDELETE_LOAN";
                        document.getElementById("msisdnIdCheckDebt").value = "";
                        document.getElementById("topupTransIdCheckDebt").value = "";
                        break;
                    case "wsROLLBACK_LOAN" :
                        hiddenAll();
                        $("#frmWsCHECKDEBT").removeClass("hidden");
                        document.getElementById("frmWsCHECKDEBT_h4").innerHTML = "Form test WS voice IVR;"
                        document.getElementById("action").value = "wsROLLBACK_LOAN";
                        document.getElementById("msisdnIdCheckDebt").value = "";
                        document.getElementById("topupTransIdCheckDebt").value = "";
                        break;
                    case "frmWsVOICEIVR" :
                        hiddenAll();
                        $("#frmWsVOICEIVR").removeClass("hidden");
                        document.getElementById("msisdnIdVoiceIVR").value = "";
                        document.getElementById("creditInfo").value = "";
                        document.getElementById("inviteId").value = "";
                        break;
                    case "wsCHECKCREDITDATA" :
                        hiddenAll();
                        $("#frmWsCHECKCREDITDATA").removeClass("hidden");
                        break;
                    case "wsCREDITDATA" :
                        hiddenAll();
                        $("#frmWsCREDITDATA").removeClass("hidden");
                        break;
                    default :
                        hiddenAll();
                }
            });
            function chooseWS(e) {
                var typeWS = $(e).val();
                switch (typeWS) {
                    case "1" :
                        hiddenAll();
                        $("#frmWsCHECK").removeClass("hidden");
                        break;
                    case "2" :
                        hiddenAll();
                        $("#frmWsTOPUP").removeClass("hidden");
                        break;
                    case "3" :
                        hiddenAll();
                        $("#frmWsCHARGE").removeClass("hidden");
                        break;
                    case "4" :
                        hiddenAll();
                        $("#frmWsCHECKSUBS").removeClass("hidden");
                        break;
                    case "5" :
                        hiddenAll();
                        $("#frmWsMT").removeClass("hidden");
                        break;
                    case "6" :
                        hiddenAll();
                        $("#frmWsMO").removeClass("hidden");
                        break;
                    case "7" :
                        hiddenAll();
                        $("#frmWsACTIVE").removeClass("hidden");
                        break;
                    case "8" :
                        hiddenAll();
                        $("#frmWsCHECK_DEBT_AIRTIME").removeClass("hidden");
                        break;
                    case "9" :
                        hiddenAll();
                        $("#frmWsVERIFY_CARD").removeClass("hidden");
                        break;
                    case "10" :
                        hiddenAll();
                        $("#frmWsCHECKDEBT").removeClass("hidden");
                        document.getElementById("frmWsCHECKDEBT_h4").innerHTML = "Form test WS check debt";
                        document.getElementById("action").value = "wsCHECK_DEBT";
                        $("#responseDebt").addClass("hidden");
                        break;
                    case "11" :
                        hiddenAll();
                        $("#frmWsCHECKDEBT").removeClass("hidden");
                        document.getElementById("frmWsCHECKDEBT_h4").innerHTML = "Form test WS delete loan";
                        document.getElementById("action").value = "wsDELETE_LOAN";
                        $("#responseDebt").addClass("hidden");
                        break;
                    case "12" :
                        hiddenAll();
                        $("#frmWsCHECKDEBT").removeClass("hidden");
                        document.getElementById("frmWsCHECKDEBT_h4").innerHTML = "Form test WS rollback loan";
                        document.getElementById("action").value = "wsROLLBACK_LOAN";
                        $("#responseDebt").addClass("hidden");
                        break;
                    case "14" :
                        hiddenAll();
                        $("#frmWsCHECKCREDITDATA").removeClass("hidden");
                        break;
                    case "15" :
                        hiddenAll();
                        $("#frmWsCREDITDATA").removeClass("hidden");
                        break;
                    case "16" :
                        hiddenAll();
                        $("#frmWsVOICEIVR").removeClass("hidden");
                        break;
                    default :
                        hiddenAll();
                }
            }

            function hiddenAll() {
                $("#frmWsCHECK").addClass("hidden");
                $("#frmWsTOPUP").addClass("hidden");
                $("#frmWsCHARGE").addClass("hidden");
                $("#frmWsCHECKSUBS").addClass("hidden");
                $("#frmWsMO").addClass("hidden");
                $("#frmWsMT").addClass("hidden");
                $("#frmWsACTIVE").addClass("hidden");
                $("#frmWsCHECK_DEBT_AIRTIME").addClass("hidden");
                $("#frmWsVERIFY_CARD").addClass("hidden");
                $("#frmWsCHECKDEBT").addClass("hidden");
                $("#frmWsCHECKCREDITDATA").addClass("hidden");
                $("#frmWsCREDITDATA").addClass("hidden");
                $("#frmWsVOICEIVR").addClass("hidden");
            }

            function submitForm(e) {
                openLoading();
                $(e).parent("form").submit();
            }

            function openLoading() {
                $(".spinner").removeClass("hidden");
            }
        </script>
    </body>
</html>
