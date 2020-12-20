<%@page import="org.json.JSONObject"%>
<%@page import="org.json.JSONArray"%>
<%@page import="com.google.gson.JsonArray" %>
<%@page import="tdt.db.viettel.splus.report.ReportDailyStandard" %>
<%@page import="tdt.db.viettel.splus.report.DataDashBoardDAO" %>
<%@ page import="java.text.DecimalFormat" %>
<%@ page import="java.text.Format" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Calendar" %>
<%@ page language="java" pageEncoding="utf-8" %>
<style>
    li{
        background: none !important;
    }

    span{
        font-size: 1.1vw !important;
    }
    p{
        font-size: 1.1vw !important;
    }
</style>
<link rel="stylesheet" href="<%=request.getContextPath()%>/admin/login/resources/css/jquery.datetimepicker.min.css" type="text/css" media="screen"/>
<script type="text/javascript" src="<%=request.getContextPath()%>/admin/login/resources/scripts/jquery.datetimepicker.full.min.js"></script>
<script src="<%=request.getContextPath()%>/admin/include/core.js"></script>
<script src="<%=request.getContextPath()%>/admin/include/charts.js"></script>
<script src="<%=request.getContextPath()%>/admin/include/animated.js"></script>
<script src="<%=request.getContextPath()%>/admin/login/resources/scripts/highcharts.js"></script>
<%

    String staDate = request.getParameter("staDate");
    String timeReport = "";
    Format dateFormat2 = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");
    SimpleDateFormat dateFormatddMMyyyyHH24miss = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");
    SimpleDateFormat dateFormatddMMyyyy = new SimpleDateFormat("dd/MM/yyyy");
    Format dateFormatddMMyyyyhh = new SimpleDateFormat("dd/MM/yyyy HH");
    SimpleDateFormat simpleDateFormatyyyyMMddhh24 = new SimpleDateFormat("yyyyMMdd HH");
    SimpleDateFormat simpleDateFormatyyyyMMddhh24m = new SimpleDateFormat("yyyyMMdd HH:m");
    SimpleDateFormat simpleDateFormatmm = new SimpleDateFormat("mm");
    Calendar calendar = Calendar.getInstance();
    calendar.add(Calendar.HOUR, -1);

    DataDashBoardDAO dataDashBoardDAO = new DataDashBoardDAO();
    Date dateReport;
    boolean istoDate = true;
    try {
        if (staDate != null && !staDate.trim().equals(dateFormatddMMyyyy.format(new Date()))) {
            dateReport = dateFormatddMMyyyyHH24miss.parse(staDate + " 23:59:59");
            timeReport = staDate + " 23:59:59";
            istoDate = false;
        } else {
            dateReport = new Date();
            staDate = dateFormatddMMyyyy.format(new Date());
            timeReport = dateFormatddMMyyyyHH24miss.format(new Date());
        }
    } catch (Exception e) {
        dateReport = new Date();
    }
    Calendar calendarNow = Calendar.getInstance();
    String yyyyMMddhh24 = simpleDateFormatyyyyMMddhh24.format(calendarNow.getTime());
    String yyyyMMddhh24m = simpleDateFormatyyyyMMddhh24m.format(calendarNow.getTime());
    int minuteNow = Integer.parseInt(simpleDateFormatmm.format(calendarNow.getTime()));
    JSONObject jSONObjectTopup = new JSONObject();
    Hashtable<String, Double> hashtableDataInBeforHour = new Hashtable<>();
    Hashtable<String, Double> hashtableDataInBeforHourMO = new Hashtable<>();
    Hashtable<String, Double> hashtableDataAccumulation = new Hashtable<>();
    Hashtable<String, Double> hashtableDataAccumulation2 = new Hashtable<>();
    Hashtable<String, Double> hashtableDataAccumulation3 = new Hashtable<>();
    JSONArray jSONArrayInviteGroupByCode = new JSONArray();
    JSONArray jSONArrayMOGroupByCode = new JSONArray();
    JSONArray jSONArrayTopupGroupByCode = new JSONArray();
    JSONArray jSONArrayChargeGroupByCode = new JSONArray();
    Double percentActionCdr = null;

    String[] arrayDataNameInHour = {"TOTAL_MT_INVITE", "TOTAL_MO", "TOTAL_MONEY_TOPUP", "TOTAL_MONEY_CHARGE"};
    // Riêng MO ko check dataCode
    String[] arrayDataNameInHourMO = {"TOTAL_MO"};
    String[] arrayDataNameAccumulation = {"TOTAL_THRESHOLD", "TOTAL_CHECK_MONEY", "TOTAL_NO_MONEY_AFTER", "TOTAL_DATA", "TOTAL_CDR_TOPUP", "TOTAL_CDR_TOPUP_USSD"};
    // MT, Topup, charge
    String[] arrayDataNameAccumulation2 = {"TOTAL_MT_INVITE", "TOTAL_TOPUP", "TOTAL_MONEY_TOPUP", "TOTAL_MONEY_CHARGE"};
    HashMap<String, String> hashMapDataCodeInvite = new HashMap<String, String>();
    hashMapDataCodeInvite.put("0", "Invite thành công");
    hashMapDataCodeInvite.put("-17", "-17");
    hashMapDataCodeInvite.put("-18", "-18");

    HashMap<String, String> hashMapDataCodeMo = new HashMap<String, String>();
    hashMapDataCodeMo.put("UT_CD_ERROR_CHECK_AIRTIIME_-13", "TB nợ Airtime");
    hashMapDataCodeMo.put("CONFIRM_ERROR_CHECK_AIRTIIME_-13", "TB nợ Airtime");
    hashMapDataCodeMo.put("UT_BD_EROR_MAXDEBT", "TB còn tiền");
    hashMapDataCodeMo.put("UT_CD_NOT_CONFIRMCHECK_ALL_CONDITION_ERROR_18", "TB còn tiền");
    hashMapDataCodeMo.put("CONFIRM_CHECK_ALL_CONDITION_ERROR_18", "TB còn tiền");
    hashMapDataCodeMo.put("UT_CD_NOT_CONFIRMCHECK_ALL_CONDITION_ERROR_7", "TB nguy cơ nợ xấu");
    hashMapDataCodeMo.put("CONFIRM_CHECK_ALL_CONDITION_ERROR_7", "TB nguy cơ nợ xấu");
    hashMapDataCodeMo.put("UT_CD_HAD_CONFIRM_ERROR_CHECKALLCONDITION_7", "TB nguy cơ nợ xấu");
    hashMapDataCodeMo.put("UT_CD_NOT_CONFIRMCHECK_ALL_CONDITION_ERROR_17", "TB bị chặn");
    hashMapDataCodeMo.put("CONFIRM_CHECK_ALL_CONDITION_ERROR_17", "TB bị chặn");
    hashMapDataCodeMo.put("UT_CD_NOT_CONFIRMCHECK_ALL_CONDITION_ERROR_16", "TB không có ĐTD");
    hashMapDataCodeMo.put("CONFIRM_CHECK_ALL_CONDITION_ERROR_16", "TB không có ĐTD");
    hashMapDataCodeMo.put("CONFIRM_ERROR_CHECK_AIRTIIME_-18", "TB còn tiền");
    hashMapDataCodeMo.put("UT_CD_ERROR_CHECK_AIRTIIME_-18", "TB còn tiền");

    HashMap<String, String> hashMapDataCodeTopup = new HashMap<String, String>();
    hashMapDataCodeTopup.put("0", "Topup thành công");
    hashMapDataCodeTopup.put("-13", "-13");
    hashMapDataCodeTopup.put("-18", "-18");

    Calendar calendarGetMonth = Calendar.getInstance();
    HashMap<String, String> hashMapDataCodeCharge = new HashMap<String, String>();
    hashMapDataCodeCharge.put("CHARGE_OF_TOPUP_TIME_0_N", "Tháng " + (calendarGetMonth.get(Calendar.MONTH) + 1));
    calendarGetMonth.add(Calendar.MONTH, -1);
    hashMapDataCodeCharge.put("CHARGE_OF_TOPUP_TIME_0_N-1", "Tháng " + (calendarGetMonth.get(Calendar.MONTH) + 1));
    calendarGetMonth.add(Calendar.MONTH, -1);
    hashMapDataCodeCharge.put("CHARGE_OF_TOPUP_TIME_0_N-2", "Tháng " + (calendarGetMonth.get(Calendar.MONTH) + 1));
    hashMapDataCodeCharge.put("CHARGE_OF_TOPUP_BAD", "Không đối soát");

    if (minuteNow < 5) {
        if (DataDashBoardDAO.hashtableBuffer.get("TOPUP_" + yyyyMMddhh24 + "_5") != null) {
            System.out.println("==============1====================");
            jSONObjectTopup = (JSONObject) DataDashBoardDAO.hashtableBuffer.get("TOPUP_" + yyyyMMddhh24 + "_5");
        } else {
            System.out.println("==============2====================");
            jSONObjectTopup = dataDashBoardDAO.getMoneyTopup(dateReport);
            if (jSONObjectTopup != null) {
                DataDashBoardDAO.hashtableBuffer.put("TOPUP_" + yyyyMMddhh24 + "_5", jSONObjectTopup);
            }
        }

        if (DataDashBoardDAO.hashtableBuffer.get("DATA_SERVICE_" + yyyyMMddhh24 + "_5") != null) {
            hashtableDataInBeforHour = (Hashtable<String, Double>) DataDashBoardDAO.hashtableBuffer.get("DATA_SERVICE_" + yyyyMMddhh24 + "_5");
        } else {
            hashtableDataInBeforHour = dataDashBoardDAO.getDataByDataName(arrayDataNameInHour, "=", "0", dateReport, istoDate);
            if (hashtableDataInBeforHour != null) {
                DataDashBoardDAO.hashtableBuffer.put("DATA_SERVICE_" + yyyyMMddhh24 + "_5", hashtableDataInBeforHour);
            }
        }

        if (DataDashBoardDAO.hashtableBuffer.get("DATA_MO_" + yyyyMMddhh24 + "_5") != null) {
            hashtableDataInBeforHourMO = (Hashtable<String, Double>) DataDashBoardDAO.hashtableBuffer.get("DATA_MO_" + yyyyMMddhh24 + "_5");
        } else {
            hashtableDataInBeforHourMO = dataDashBoardDAO.getDataByDataName(arrayDataNameInHourMO, "=", null, dateReport, istoDate);
            if (hashtableDataInBeforHourMO != null) {
                DataDashBoardDAO.hashtableBuffer.put("DATA_MO_" + yyyyMMddhh24 + "_5", hashtableDataInBeforHourMO);
            }
        }
        if (DataDashBoardDAO.hashtableBuffer.get("DATA_ACCUMULATION_" + yyyyMMddhh24 + "_5") != null) {
            hashtableDataAccumulation = (Hashtable<String, Double>) DataDashBoardDAO.hashtableBuffer.get("DATA_ACCUMULATION_" + yyyyMMddhh24 + "_5");
        } else {
            hashtableDataAccumulation = dataDashBoardDAO.getDataByDataName(arrayDataNameAccumulation, "<=", null, dateReport, istoDate);
            if (hashtableDataAccumulation != null) {
                DataDashBoardDAO.hashtableBuffer.put("DATA_ACCUMULATION_" + yyyyMMddhh24 + "_5", hashtableDataAccumulation);
            }
        }
        if (DataDashBoardDAO.hashtableBuffer.get("DATA_ACCUMULATION_SERVICE_" + yyyyMMddhh24 + "_5") != null) {
            hashtableDataAccumulation2 = (Hashtable<String, Double>) DataDashBoardDAO.hashtableBuffer.get("DATA_ACCUMULATION_SERVICE_" + yyyyMMddhh24 + "_5");
        } else {
            hashtableDataAccumulation2 = dataDashBoardDAO.getDataByDataName(arrayDataNameAccumulation2, "<=", "0", dateReport, istoDate);
            if (hashtableDataAccumulation2 != null) {
                DataDashBoardDAO.hashtableBuffer.put("DATA_ACCUMULATION_SERVICE_" + yyyyMMddhh24 + "_5", hashtableDataAccumulation2);
            }
        }

        if (DataDashBoardDAO.hashtableBuffer.get("DATA_ACCUMULATION_MO_" + yyyyMMddhh24 + "_5") != null) {
            hashtableDataAccumulation3 = (Hashtable<String, Double>) DataDashBoardDAO.hashtableBuffer.get("DATA_ACCUMULATION_MO_" + yyyyMMddhh24 + "_5");
        } else {
            hashtableDataAccumulation3 = dataDashBoardDAO.getDataByDataNameMO(dateReport);
            if (hashtableDataAccumulation3 != null) {
                DataDashBoardDAO.hashtableBuffer.put("DATA_ACCUMULATION_MO_" + yyyyMMddhh24 + "_5", hashtableDataAccumulation3);
            }
        }

        if (DataDashBoardDAO.hashtableBuffer.get("DATA_INVITE_" + yyyyMMddhh24 + "_5") != null) {
            jSONArrayInviteGroupByCode = (JSONArray) DataDashBoardDAO.hashtableBuffer.get("DATA_INVITE_" + yyyyMMddhh24 + "_5");
        } else {
            jSONArrayInviteGroupByCode = dataDashBoardDAO.getDataGroupByDataCode(hashMapDataCodeInvite, "TOTAL_MT_INVITE", null, dateReport);
            if (jSONArrayInviteGroupByCode != null) {
                DataDashBoardDAO.hashtableBuffer.put("DATA_INVITE_" + yyyyMMddhh24 + "_5", jSONArrayInviteGroupByCode);
            }
        }

        if (DataDashBoardDAO.hashtableBuffer.get("DATA_GROUP_MO_" + yyyyMMddhh24 + "_5") != null) {
            jSONArrayMOGroupByCode = (JSONArray) DataDashBoardDAO.hashtableBuffer.get("DATA_GROUP_MO_" + yyyyMMddhh24 + "_5");
        } else {
            jSONArrayMOGroupByCode = dataDashBoardDAO.getDataGroupByDataCode(hashMapDataCodeMo, "TOTAL_MO", "'UT_BD_SUCCESS_FW_TOPUP' , 'CONFIRM_SUCCESS_FW_TOPUP'", dateReport);
            if (jSONArrayMOGroupByCode != null) {
                DataDashBoardDAO.hashtableBuffer.put("DATA_GROUP_MO_" + yyyyMMddhh24 + "_5", jSONArrayMOGroupByCode);
            }
        }

        if (DataDashBoardDAO.hashtableBuffer.get("DATA_GROUP_TOPUP_" + yyyyMMddhh24 + "_5") != null) {
            jSONArrayTopupGroupByCode = (JSONArray) DataDashBoardDAO.hashtableBuffer.get("DATA_GROUP_TOPUP_" + yyyyMMddhh24 + "_5");
        } else {
            jSONArrayTopupGroupByCode = dataDashBoardDAO.getDataGroupByDataCode(hashMapDataCodeTopup, "TOTAL_MONEY_TOPUP", null, dateReport);
            if (jSONArrayTopupGroupByCode != null) {
                DataDashBoardDAO.hashtableBuffer.put("DATA_GROUP_TOPUP_" + yyyyMMddhh24 + "_5", jSONArrayTopupGroupByCode);
            }
        }

        if (DataDashBoardDAO.hashtableBuffer.get("DATA_GROUP_CHARGE_" + yyyyMMddhh24 + "_5") != null) {
            jSONArrayChargeGroupByCode = (JSONArray) DataDashBoardDAO.hashtableBuffer.get("DATA_GROUP_CHARGE_" + yyyyMMddhh24 + "_5");
        } else {
            jSONArrayChargeGroupByCode = dataDashBoardDAO.getDataChargeGroupByDataCode(hashMapDataCodeCharge, "TOTAL_MONEY_CHARGE", dateReport);
            if (jSONArrayChargeGroupByCode != null) {
                DataDashBoardDAO.hashtableBuffer.put("DATA_GROUP_CHARGE_" + yyyyMMddhh24 + "_5", jSONArrayChargeGroupByCode);
            }
        }

        if (DataDashBoardDAO.hashtableBuffer.get("DATA_ACTION_CDR_" + yyyyMMddhh24 + "_5") != null) {
            percentActionCdr = (Double) DataDashBoardDAO.hashtableBuffer.get("DATA_ACTION_CDR_" + yyyyMMddhh24 + "_5");
        } else {
            percentActionCdr = dataDashBoardDAO.getPercentActionCdr(dateReport);
            if (percentActionCdr != null) {
                DataDashBoardDAO.hashtableBuffer.put("DATA_ACTION_CDR_" + yyyyMMddhh24 + "_5", percentActionCdr);
            }
        }

    } else {
        if (DataDashBoardDAO.hashtableBuffer.get("TOPUP_" + yyyyMMddhh24) != null) {
            System.out.println("==============111111====================");
            jSONObjectTopup = (JSONObject) DataDashBoardDAO.hashtableBuffer.get("TOPUP_" + yyyyMMddhh24);
        } else {
            System.out.println("==============22222====================");
            jSONObjectTopup = dataDashBoardDAO.getMoneyTopup(dateReport);
            if (jSONObjectTopup != null) {
                DataDashBoardDAO.hashtableBuffer.put("TOPUP_" + yyyyMMddhh24, jSONObjectTopup);
            }
        }

        if (DataDashBoardDAO.hashtableBuffer.get("DATA_SERVICE_" + yyyyMMddhh24) != null) {
            hashtableDataInBeforHour = (Hashtable<String, Double>) DataDashBoardDAO.hashtableBuffer.get("DATA_SERVICE_" + yyyyMMddhh24);
        } else {
            hashtableDataInBeforHour = dataDashBoardDAO.getDataByDataName(arrayDataNameInHour, "=", "0", dateReport, istoDate);
            if (hashtableDataInBeforHour != null) {
                DataDashBoardDAO.hashtableBuffer.put("DATA_SERVICE_" + yyyyMMddhh24, hashtableDataInBeforHour);
            }
        }

        if (DataDashBoardDAO.hashtableBuffer.get("DATA_MO_" + yyyyMMddhh24) != null) {
            hashtableDataInBeforHourMO = (Hashtable<String, Double>) DataDashBoardDAO.hashtableBuffer.get("DATA_MO_" + yyyyMMddhh24);
        } else {
            hashtableDataInBeforHourMO = dataDashBoardDAO.getDataByDataName(arrayDataNameInHourMO, "=", null, dateReport, istoDate);
            if (hashtableDataInBeforHourMO != null) {
                DataDashBoardDAO.hashtableBuffer.put("DATA_MO_" + yyyyMMddhh24, hashtableDataInBeforHourMO);
            }
        }

        if (DataDashBoardDAO.hashtableBuffer.get("DATA_ACCUMULATION_" + yyyyMMddhh24) != null) {
            hashtableDataAccumulation = (Hashtable<String, Double>) DataDashBoardDAO.hashtableBuffer.get("DATA_ACCUMULATION_" + yyyyMMddhh24);
        } else {
            hashtableDataAccumulation = dataDashBoardDAO.getDataByDataName(arrayDataNameAccumulation, "<=", null, dateReport, istoDate);
            if (hashtableDataAccumulation != null) {
                DataDashBoardDAO.hashtableBuffer.put("DATA_ACCUMULATION_" + yyyyMMddhh24, hashtableDataAccumulation);
            }
        }

        if (DataDashBoardDAO.hashtableBuffer.get("DATA_ACCUMULATION_SERVICE_" + yyyyMMddhh24) != null) {
            System.out.println("==============111111====================hashtableDataAccumulation2");
            hashtableDataAccumulation2 = (Hashtable<String, Double>) DataDashBoardDAO.hashtableBuffer.get("DATA_ACCUMULATION_SERVICE_" + yyyyMMddhh24);
        } else {
            System.out.println("==============222222====================hashtableDataAccumulation2");
            hashtableDataAccumulation2 = dataDashBoardDAO.getDataByDataName(arrayDataNameAccumulation2, "<=", "0", dateReport, istoDate);
            if (hashtableDataAccumulation2 != null) {
                DataDashBoardDAO.hashtableBuffer.put("DATA_ACCUMULATION_SERVICE_" + yyyyMMddhh24, hashtableDataAccumulation2);
            }
        }
        System.out.println("hashtableDataAccumulation2:" + hashtableDataAccumulation2.size() + "---" + hashtableDataAccumulation2.get("TOTAL_MT_INVITE"));
        if (DataDashBoardDAO.hashtableBuffer.get("DATA_ACCUMULATION_MO_" + yyyyMMddhh24) != null) {
            System.out.println("==============111111====================hashtableDataAccumulation3");
            hashtableDataAccumulation3 = (Hashtable<String, Double>) DataDashBoardDAO.hashtableBuffer.get("DATA_ACCUMULATION_MO_" + yyyyMMddhh24);
        } else {
            System.out.println("==============222222====================hashtableDataAccumulation3");
            hashtableDataAccumulation3 = dataDashBoardDAO.getDataByDataNameMO(dateReport);
            if (hashtableDataAccumulation3 != null) {
                DataDashBoardDAO.hashtableBuffer.put("DATA_ACCUMULATION_MO_" + yyyyMMddhh24, hashtableDataAccumulation3);
            }
        }

        if (DataDashBoardDAO.hashtableBuffer.get("DATA_INVITE_" + yyyyMMddhh24) != null) {
            jSONArrayInviteGroupByCode = (JSONArray) DataDashBoardDAO.hashtableBuffer.get("DATA_INVITE_" + yyyyMMddhh24);
        } else {
            jSONArrayInviteGroupByCode = dataDashBoardDAO.getDataGroupByDataCode(hashMapDataCodeInvite, "TOTAL_MT_INVITE", null, dateReport);
            if (jSONArrayInviteGroupByCode != null) {
                DataDashBoardDAO.hashtableBuffer.put("DATA_INVITE_" + yyyyMMddhh24, jSONArrayInviteGroupByCode);
            }
        }

        if (DataDashBoardDAO.hashtableBuffer.get("DATA_GROUP_MO_" + yyyyMMddhh24) != null) {
            jSONArrayMOGroupByCode = (JSONArray) DataDashBoardDAO.hashtableBuffer.get("DATA_GROUP_MO_" + yyyyMMddhh24);
        } else {
            jSONArrayMOGroupByCode = dataDashBoardDAO.getDataGroupByDataCode(hashMapDataCodeMo, "TOTAL_MO", "'UT_BD_SUCCESS_FW_TOPUP' , 'CONFIRM_SUCCESS_FW_TOPUP'", dateReport);
            if (jSONArrayMOGroupByCode != null) {
                DataDashBoardDAO.hashtableBuffer.put("DATA_GROUP_MO_" + yyyyMMddhh24, jSONArrayMOGroupByCode);
            }
        }

        if (DataDashBoardDAO.hashtableBuffer.get("DATA_GROUP_TOPUP_" + yyyyMMddhh24) != null) {
            jSONArrayTopupGroupByCode = (JSONArray) DataDashBoardDAO.hashtableBuffer.get("DATA_GROUP_TOPUP_" + yyyyMMddhh24);
        } else {
            jSONArrayTopupGroupByCode = dataDashBoardDAO.getDataGroupByDataCode(hashMapDataCodeTopup, "TOTAL_MONEY_TOPUP", null, dateReport);
            if (jSONArrayTopupGroupByCode != null) {
                DataDashBoardDAO.hashtableBuffer.put("DATA_GROUP_TOPUP_" + yyyyMMddhh24, jSONArrayTopupGroupByCode);
            }
        }

        if (DataDashBoardDAO.hashtableBuffer.get("DATA_GROUP_CHARGE_" + yyyyMMddhh24) != null) {
            jSONArrayChargeGroupByCode = (JSONArray) DataDashBoardDAO.hashtableBuffer.get("DATA_GROUP_CHARGE_" + yyyyMMddhh24);
        } else {
            jSONArrayChargeGroupByCode = dataDashBoardDAO.getDataChargeGroupByDataCode(hashMapDataCodeCharge, "TOTAL_MONEY_CHARGE", dateReport);
            if (jSONArrayChargeGroupByCode != null) {
                DataDashBoardDAO.hashtableBuffer.put("DATA_GROUP_CHARGE_" + yyyyMMddhh24, jSONArrayChargeGroupByCode);
            }
        }

        if (DataDashBoardDAO.hashtableBuffer.get("DATA_ACTION_CDR_" + yyyyMMddhh24) != null) {
            percentActionCdr = (Double) DataDashBoardDAO.hashtableBuffer.get("DATA_ACTION_CDR_" + yyyyMMddhh24);
        } else {
            percentActionCdr = dataDashBoardDAO.getPercentActionCdr(dateReport);
            if (percentActionCdr != null) {
                DataDashBoardDAO.hashtableBuffer.put("DATA_ACTION_CDR_" + yyyyMMddhh24, percentActionCdr);
            }
        }

    }
    System.out.println("jSONObjectTopup:" + jSONObjectTopup);

//    System.out.println("jSONArrayInviteGroupByCode:" + jSONArrayInviteGroupByCode.toString());
    HashMap<String, Date> hashMapMaxTimeCdr = null;
    Date maxInviteDate = null;
    Date maxMoDate = null;
    HashMap<String, Date> hashMapMaxTimeTransPaymentLog = null;
    int n = minuteNow / 5;

    if (istoDate) {
        if (DataDashBoardDAO.hashtableBuffer.get("DATA_MAX_TIME_CDR_" + yyyyMMddhh24m+ "" + n) != null) {
            hashMapMaxTimeCdr = (HashMap<String, Date>) DataDashBoardDAO.hashtableBuffer.get("DATA_MAX_TIME_CDR_" + yyyyMMddhh24m+ "" + n);
        } else {
            hashMapMaxTimeCdr = dataDashBoardDAO.getMaxTimeForCdr();
            if (hashMapMaxTimeCdr != null) {
                DataDashBoardDAO.hashtableBuffer.put("DATA_MAX_TIME_CDR_"  + yyyyMMddhh24m+ ""+ n, hashMapMaxTimeCdr);
            }
        }

        if (DataDashBoardDAO.hashtableBuffer.get("DATA_MAX_TIME_INVITE_" + n) != null) {
            maxInviteDate = (Date) DataDashBoardDAO.hashtableBuffer.get("DATA_MAX_TIME_INVITE_" + yyyyMMddhh24m+ "" + n);
        } else {
            maxInviteDate = dataDashBoardDAO.getMaxDateInvite();
            if (maxInviteDate != null) {
                DataDashBoardDAO.hashtableBuffer.put("DATA_MAX_TIME_INVITE_" + yyyyMMddhh24m+ "" + n, maxInviteDate);
            }
        }

        if (DataDashBoardDAO.hashtableBuffer.get("DATA_MAX_TIME_MO_" + yyyyMMddhh24m+ "" + n) != null) {
            maxMoDate = (Date) DataDashBoardDAO.hashtableBuffer.get("DATA_MAX_TIME_MO_" + yyyyMMddhh24m+ "" + n);
        } else {
            maxMoDate = dataDashBoardDAO.getMaxDateMo();
            if (maxMoDate != null) {
                DataDashBoardDAO.hashtableBuffer.put("DATA_MAX_TIME_MO_" + yyyyMMddhh24m+ "" + n, maxMoDate);
            }
        }

        if (DataDashBoardDAO.hashtableBuffer.get("DATA_MAX_TIME_TRANSPAYMENT_" + yyyyMMddhh24m+ "" + n) != null) {
            hashMapMaxTimeTransPaymentLog = (HashMap<String, Date>) DataDashBoardDAO.hashtableBuffer.get("DATA_MAX_TIME_TRANSPAYMENT_" + yyyyMMddhh24m+ "" + n);
        } else {
            hashMapMaxTimeTransPaymentLog = dataDashBoardDAO.getMaxTimeForTransPaymentLog();
            if (hashMapMaxTimeTransPaymentLog != null) {
                DataDashBoardDAO.hashtableBuffer.put("DATA_MAX_TIME_TRANSPAYMENT_" + yyyyMMddhh24m+ "" + n, hashMapMaxTimeTransPaymentLog);
            }
        }
    }

// Còn thằng charge bỏ qua
%>
<div id="main-content" class="dashboard-template">
    <!-- Main Content Section with everything -->

    <!-- Page Head -->

    <div class="clear"></div>
    <!-- End .clear -->


    <!--Sản lượng topup theo giờ-->
    <div class="row dashboard-line1 " style="margin-top: 20px; height: 600px;">
        <form method="post" name="frmList">
            <input type="text" class="text-input datetimepickerFrom" name="staDate" placeholder="Chọn ngày" id="staDate" value="<%=staDate%>" onchange="frmList.submit();"
                   style="height: 25px;border: 1px solid #ccc;border-radius: 2px;width: 150px;padding-left: 5px;float: left;">
        </form>
        <div class="col-md-12">
            <div class="card-body">
                <div class="row">
                    <div class="row">
                        <div class="col-md-6"><span style="font-size: 1.1vw; font-weight: bold;">SẢN LƯỢNG THEO GIỜ</span></div>
                        <div class="col-md-6" style="text-align: right;"><span style="font-size: 20px; font-weight: bold;"><%=timeReport%></span></div>
                    </div>
                    <div class="row">
                        <div class="col-md-12 chart-col-4">
                            <div id="chartdivLineTopup"></div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <!--End sản lượng topup theo giờ-->

        <!--Tổng invite, Mo, topup, charget giờ trước-->
        <div class="row dashboard-line1 " style="margin-top: 20px">
            <div class="col-md-3"  data-toggle="tooltip" title="Tổng invite thành công trong khung giờ <%=dateFormatddMMyyyyhh.format(calendar.getTime())%>">
                <div class="col-md-12">
                    <div class="card pull-up" style="text-align: center;">
                        <div class="row" style="padding: 10 0 0 0;">
                            <span style="font-weight: bolder; font-size: 1.1vw;  color: #313131;">INVITE</span>
                            <p class="cdr-color" >
                                <span id="totalInvite"><%=hashtableDataInBeforHour.get("TOTAL_MT_INVITE") != null ? (String.format("%,.0f", hashtableDataInBeforHour.get("TOTAL_MT_INVITE"))) : "N/A"%></span>
                                <span id="totalInviteAvg" style="color: <%=(hashtableDataInBeforHour.get("TOTAL_MT_INVITE_AVG") != null && hashtableDataInBeforHour.get("TOTAL_MT_INVITE_AVG").compareTo(0D) > 0) ? "#2DE204" : "red"%>">
                                    (<%=((hashtableDataInBeforHour.get("TOTAL_MT_INVITE_AVG") != null && hashtableDataInBeforHour.get("TOTAL_MT_INVITE_AVG").compareTo(0D) > 0) ? "+" : "") + String.format("%,.2f", hashtableDataInBeforHour.get("TOTAL_MT_INVITE_AVG")) + "%"%>)
                                </span>
                            </p>
                            <div class="card-footer border-top-grey">
                                <span class="float-left gen-date" id="middle-gendate"><%=(istoDate && maxInviteDate != null) ? dateFormat2.format(maxInviteDate) : "N/A"%></span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-md-3" data-toggle="tooltip" title="Tổng MO đến hệ thống trong khung giờ <%=dateFormatddMMyyyyhh.format(calendar.getTime())%>">
                <div class="col-md-12">
                    <div class="card pull-up" style="text-align: center;">
                        <div class="row" style="padding: 10 0 0 0;">
                            <span style="font-weight: bolder; font-size: 28px; color: #313131;">MO</span>
                            <p class="cdr-color" >
                                <span id="totalMo"><%=hashtableDataInBeforHourMO.get("TOTAL_MO") != null ? (String.format("%,.0f", hashtableDataInBeforHourMO.get("TOTAL_MO"))) : "N/A"%></span>
                                <span id="totalMoAvg" style="color: <%=(hashtableDataInBeforHourMO.get("TOTAL_MO_AVG") != null && hashtableDataInBeforHourMO.get("TOTAL_MO_AVG").compareTo(0D) > 0) ? "#2DE204" : "red"%>">
                                    (<%=((hashtableDataInBeforHourMO.get("TOTAL_MO_AVG") != null && hashtableDataInBeforHourMO.get("TOTAL_MO_AVG").compareTo(0D) > 0) ? "+" : "") + String.format("%,.2f", hashtableDataInBeforHourMO.get("TOTAL_MO_AVG")) + "%"%>)
                                </span>
                            </p>
                            <div class="card-footer border-top-grey">
                                <span class="float-left gen-date" id="middle-gendate"><%=(istoDate && maxMoDate != null) ? dateFormat2.format(maxMoDate) : "N/A"%></span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-md-3" data-toggle="tooltip" title="Tổng tiền topup thành công trong khung giờ <%=dateFormatddMMyyyyhh.format(calendar.getTime())%>">
                <div class="col-md-12">
                    <div class="card pull-up" style="text-align: center;">
                        <div class="row" style="padding: 10 0 0 0;">
                            <span style="font-weight: bolder; font-size: 28px; color: #313131;">TOPUP</span>
                            <p class="cdr-color" >
                                <span id="totalTopup"><%=hashtableDataInBeforHour.get("TOTAL_MONEY_TOPUP") != null ? (String.format("%,.0f", hashtableDataInBeforHour.get("TOTAL_MONEY_TOPUP"))) : "N/A"%></span>
                                <span id="totalTopupAvg" style="color: <%=(hashtableDataInBeforHour.get("TOTAL_MONEY_TOPUP_AVG") != null && hashtableDataInBeforHour.get("TOTAL_MONEY_TOPUP_AVG").compareTo(0D) > 0) ? "#2DE204" : "red"%>">
                                    (<%=((hashtableDataInBeforHour.get("TOTAL_MONEY_TOPUP_AVG") != null && hashtableDataInBeforHour.get("TOTAL_MONEY_TOPUP_AVG").compareTo(0D) > 0) ? "+" : "") + String.format("%,.2f", hashtableDataInBeforHour.get("TOTAL_MONEY_TOPUP_AVG")) + "%"%>)
                                </span>
                            </p>
                            <div class="card-footer border-top-grey">
                                <span class="float-left gen-date" id="middle-gendate"><%=(istoDate && hashMapMaxTimeTransPaymentLog != null && hashMapMaxTimeTransPaymentLog.containsKey("0")) ? dateFormat2.format((Date) hashMapMaxTimeTransPaymentLog.get("0")) : "N/A"%></span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-md-3" data-toggle="tooltip" title="Tổng tiền charge thành công trong khung giờ <%=dateFormatddMMyyyyhh.format(calendar.getTime())%>" >
                <div class="col-md-12">
                    <div class="card pull-up" style="text-align: center;">
                        <div class="row" style="padding: 10 0 0 0;">
                            <span style="font-weight: bolder; font-size: 28px; color: #313131;">CHARGE</span>
                            <p class="cdr-color" >
                                <span id="totalCharge" ><%=hashtableDataInBeforHour.get("TOTAL_MONEY_CHARGE") != null ? (String.format("%,.0f", hashtableDataInBeforHour.get("TOTAL_MONEY_CHARGE"))) : "N/A"%></span>
                                <span id="totalChargeAvg" style="color: <%=(hashtableDataInBeforHour.get("TOTAL_MONEY_CHARGE_AVG") != null && hashtableDataInBeforHour.get("TOTAL_MONEY_CHARGE_AVG").compareTo(0D) > 0) ? "#2DE204" : "red"%>">
                                    (<%=((hashtableDataInBeforHour.get("TOTAL_MONEY_CHARGE_AVG") != null && hashtableDataInBeforHour.get("TOTAL_MONEY_CHARGE_AVG").compareTo(0D) > 0) ? "+" : "") + String.format("%,.2f", hashtableDataInBeforHour.get("TOTAL_MONEY_CHARGE_AVG")) + "%"%>)
                                </span>
                            </p>
                            <div class="card-footer border-top-grey">
                                <span class="float-left gen-date" id="middle-gendate"><%=(istoDate && hashMapMaxTimeTransPaymentLog != null && hashMapMaxTimeTransPaymentLog.containsKey("1")) ? dateFormat2.format((Date) hashMapMaxTimeTransPaymentLog.get("1")) : "N/A"%></span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <!--End sản lượng giờ trước-->

        <!--Tổng cdr lỹ kế trong ngày-->
        <div class="row dashboard-line1 " style="margin-top: 20px">
            <!--<p class="text-left" style="font-size: 36px; font-weight: bold; margin-left: 1%; color: <%=percentActionCdr != null && percentActionCdr.compareTo(97D) > 0 ? "#2DE204" : "red"%>" >CDR (Tỷ lệ xử lý </p>-->
            <p class="cdr-color" >
                <span class="text-left" style="font-size: 36px; font-weight: bold; margin-left: 1%;" >CDR (Tỷ lệ xử lý</span>
                <span class="text-left" style="font-size: 36px; font-weight: bold; color: <%=percentActionCdr != null && percentActionCdr.compareTo(97D) > 0 ? "#2DE204" : "red"%>" ><%=String.format("%,.3f", percentActionCdr)%>%</span>
                <span class="text-left" style="font-size: 36px; font-weight: bold; " >)</span>
            </p>
            <div class="col-md-2" data-toggle="tooltip" title="Tổng CDR threshold nhận được trong khung giờ <%=dateFormatddMMyyyyhh.format(calendar.getTime())%>">
                <div class="col-md-12">
                    <div class="card pull-up" style="text-align: center;">
                        <div class="row" style="padding: 10 0 0 0;">
                            <span style="font-weight: bolder; font-size: 28px; color: #313131;">THREHOLD</span>
                            <p class="cdr-color" >
                                <span id="cdrThreshold"><%=(hashtableDataAccumulation.get("TOTAL_THRESHOLD") != null ? (String.format("%,.0f", hashtableDataAccumulation.get("TOTAL_THRESHOLD"))) : "N/A")%></span>
                            </p>
                            <p class="cdr-color">
                                <span id="cdrThresholdAvg" style="color: <%=(hashtableDataAccumulation.get("TOTAL_THRESHOLD_AVG") != null && hashtableDataAccumulation.get("TOTAL_THRESHOLD_AVG").compareTo(0D) > 0) ? "#2DE204" : "red"%>">
                                    (<%=((hashtableDataAccumulation.get("TOTAL_THRESHOLD_AVG") != null && hashtableDataAccumulation.get("TOTAL_THRESHOLD_AVG").compareTo(0D) > 0) ? "+" : "") + String.format("%,.2f", hashtableDataAccumulation.get("TOTAL_THRESHOLD_AVG")) + "%"%>)
                                </span>
                            </p>
                            <div class="card-footer border-top-grey">
                                <span class="float-left gen-date" id="middle-gendate"><%=(istoDate && hashMapMaxTimeCdr != null && hashMapMaxTimeCdr.containsKey("THRESHOLD")) ? dateFormat2.format((Date) hashMapMaxTimeCdr.get("THRESHOLD")) : "N/A"%></span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-md-2" data-toggle="tooltip" title="Tổng CDR check money nhận được trong khung giờ <%=dateFormatddMMyyyyhh.format(calendar.getTime())%>">
                <div class="col-md-12">
                    <div class="card pull-up" style="text-align: center;">
                        <div class="row" style="padding: 10 0 0 0;">
                            <span style="font-weight: bolder; font-size: 28px; color: #313131;">CHECK_MONEY</span>
                            <p class="cdr-color" >
                                <span id="cdrCheckMoney"><%=(hashtableDataAccumulation.get("TOTAL_CHECK_MONEY") != null ? (String.format("%,.0f", hashtableDataAccumulation.get("TOTAL_CHECK_MONEY"))) : "N/A")%></span>
                            </p>
                            <p class="cdr-color">
                                <span id="cdrCheckMoneyAvg" style="color: <%=(hashtableDataAccumulation.get("TOTAL_CHECK_MONEY_AVG") != null && hashtableDataAccumulation.get("TOTAL_CHECK_MONEY_AVG").compareTo(0D) > 0) ? "#2DE204" : "red"%>">
                                    (<%=((hashtableDataAccumulation.get("TOTAL_CHECK_MONEY_AVG") != null && hashtableDataAccumulation.get("TOTAL_CHECK_MONEY_AVG").compareTo(0D) > 0) ? "+" : "") + String.format("%,.2f", hashtableDataAccumulation.get("TOTAL_CHECK_MONEY_AVG")) + "%"%>)
                                </span>
                            </p>
                            <div class="card-footer border-top-grey">
                                <span class="float-left gen-date" id="middle-gendate"><%=(istoDate && hashMapMaxTimeCdr != null && hashMapMaxTimeCdr.containsKey("CHECK_MONEY")) ? dateFormat2.format((Date) hashMapMaxTimeCdr.get("CHECK_MONEY")) : "N/A"%></span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-md-2" data-toggle="tooltip" title="Tổng CDR NO Money nhận được trong khung giờ <%=dateFormatddMMyyyyhh.format(calendar.getTime())%>">
                <div class="col-md-12">
                    <div class="card pull-up" style="text-align: center;">
                        <div class="row" style="padding: 10 0 0 0;">
                            <span style="font-weight: bolder; font-size: 28px; color: #313131;">NO_MONEY</span>
                            <p class="cdr-color" >
                                <span id="cdrNoMoey"><%=(hashtableDataAccumulation.get("TOTAL_NO_MONEY_AFTER") != null ? (String.format("%,.0f", hashtableDataAccumulation.get("TOTAL_NO_MONEY_AFTER"))) : "N/A")%></span>
                            </p>
                            <p class="cdr-color">
                                <span id="cdrNoMoeyAvg" style="color: <%=(hashtableDataAccumulation.get("TOTAL_NO_MONEY_AFTER_AVG") != null && hashtableDataAccumulation.get("TOTAL_NO_MONEY_AFTER_AVG").compareTo(0D) > 0) ? "#2DE204" : "red"%>">
                                    (<%=((hashtableDataAccumulation.get("TOTAL_NO_MONEY_AFTER_AVG") != null && hashtableDataAccumulation.get("TOTAL_NO_MONEY_AFTER_AVG").compareTo(0D) > 0) ? "+" : "") + String.format("%,.2f", hashtableDataAccumulation.get("TOTAL_NO_MONEY_AFTER_AVG")) + "%"%>)
                                </span>
                            </p>
                            <div class="card-footer border-top-grey">
                                <span class="float-left gen-date" id="middle-gendate"><%=(istoDate && hashMapMaxTimeCdr != null && hashMapMaxTimeCdr.containsKey("NO_MONEY_AFTER")) ? dateFormat2.format((Date) hashMapMaxTimeCdr.get("NO_MONEY_AFTER")) : "N/A"%></span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-md-2" data-toggle="tooltip" title="Tổng CDR data nhận được trong khung giờ <%=dateFormatddMMyyyyhh.format(calendar.getTime())%>" >
                <div class="col-md-12">
                    <div class="card pull-up" style="text-align: center;">
                        <div class="row" style="padding: 10 0 0 0;">
                            <span style="font-weight: bolder; font-size: 28px; color: #313131;">NO_DATA</span>
                            <p class="cdr-color" >
                                <span id="cdrNoData"><%=(hashtableDataAccumulation.get("TOTAL_DATA") != null ? (String.format("%,.0f", hashtableDataAccumulation.get("TOTAL_DATA"))) : "N/A")%></span>
                            </p>
                            <p class="cdr-color">
                                <span id="cdrNoDataAvg"  style="color: <%=(hashtableDataAccumulation.get("TOTAL_DATA_AVG") != null && hashtableDataAccumulation.get("TOTAL_DATA_AVG").compareTo(0D) > 0) ? "#2DE204" : "red"%>">
                                    (<%=((hashtableDataAccumulation.get("TOTAL_DATA_AVG") != null && hashtableDataAccumulation.get("TOTAL_DATA_AVG").compareTo(0D) > 0) ? "+" : "") + String.format("%,.2f", hashtableDataAccumulation.get("TOTAL_DATA_AVG")) + "%"%>)
                                </span>
                            </p>
                            <div class="card-footer border-top-grey">
                                <span class="float-left gen-date" id="middle-gendate"><%=(istoDate && hashMapMaxTimeCdr != null && hashMapMaxTimeCdr.containsKey("DATA")) ? dateFormat2.format((Date) hashMapMaxTimeCdr.get("DATA")) : "N/A"%></span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-md-2" data-toggle="tooltip" title="Tổng CDR TOPUP nhận được trong khung giờ <%=dateFormatddMMyyyyhh.format(calendar.getTime())%>" >
                <div class="col-md-12">
                    <div class="card pull-up" style="text-align: center;">
                        <div class="row" style="padding: 10 0 0 0;">
                            <span style="font-weight: bolder; font-size: 28px; color: #313131;">TOPUP</span>
                            <p class="cdr-color" >
                                <span id="cdrTopup"><%=(hashtableDataAccumulation.get("TOTAL_CDR_TOPUP") != null ? (String.format("%,.0f", hashtableDataAccumulation.get("TOTAL_CDR_TOPUP"))) : "N/A")%></span>
                            </p>
                            <p class="cdr-color">
                                <span id="cdrTopupAvg" style="color: <%=(hashtableDataAccumulation.get("TOTAL_CDR_TOPUP_AVG") != null && hashtableDataAccumulation.get("TOTAL_CDR_TOPUP_AVG").compareTo(0D) > 0) ? "#2DE204" : "red"%>">
                                    (<%=((hashtableDataAccumulation.get("TOTAL_CDR_TOPUP_AVG") != null && hashtableDataAccumulation.get("TOTAL_CDR_TOPUP_AVG").compareTo(0D) > 0) ? "+" : "") + String.format("%,.2f", hashtableDataAccumulation.get("TOTAL_CDR_TOPUP_AVG")) + "%"%>)
                                </span>
                            </p>
                            <div class="card-footer border-top-grey">
                                <span class="float-left gen-date" id="middle-gendate"><%=(istoDate && hashMapMaxTimeCdr != null && hashMapMaxTimeCdr.containsKey("TOPUP")) ? dateFormat2.format((Date) hashMapMaxTimeCdr.get("TOPUP")) : "N/A"%></span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-md-2"data-toggle="tooltip" title="Tổng CDR TOPUP USSD nhận được trong khung giờ <%=dateFormatddMMyyyyhh.format(calendar.getTime())%>">
                <div class="col-md-12">
                    <div class="card pull-up" style="text-align: center;">
                        <div class="row" style="padding: 10 0 0 0;">
                            <span style="font-weight: bolder; font-size: 28px; color: #313131;">TOPUP_USSD</span>
                            <p class="cdr-color" >
                                <span id="cdrTopupUssd"><%=(hashtableDataAccumulation.get("TOTAL_CDR_TOPUP_USSD") != null ? (String.format("%,.0f", hashtableDataAccumulation.get("TOTAL_CDR_TOPUP_USSD"))) : "N/A")%></span>
                            </p>
                            <p class="cdr-color">
                                <span id="cdrTopupUssdAvg" style="color: <%=(hashtableDataAccumulation.get("TOTAL_CDR_TOPUP_USSD_AVG") != null && hashtableDataAccumulation.get("TOTAL_CDR_TOPUP_USSD_AVG").compareTo(0D) > 0) ? "#2DE204" : "red"%>">
                                    (<%=((hashtableDataAccumulation.get("TOTAL_CDR_TOPUP_USSD_AVG") != null && hashtableDataAccumulation.get("TOTAL_CDR_TOPUP_USSD_AVG").compareTo(0D) > 0) ? "+" : "") + String.format("%,.2f", hashtableDataAccumulation.get("TOTAL_CDR_TOPUP_USSD_AVG")) + "%"%>)
                                </span>
                            </p>
                            <div class="card-footer border-top-grey">
                                <span class="float-left gen-date" id="middle-gendate"><%=(istoDate && hashMapMaxTimeCdr != null && hashMapMaxTimeCdr.containsKey("TOPUP_USSD")) ? dateFormat2.format((Date) hashMapMaxTimeCdr.get("TOPUP_USSD")) : "N/A"%></span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <!--End cdr lỹ kế trong ngày-->


        <!--Sản lượng lũy kế trong ngày-->
        <div class="row dashboard-line1 " style="margin-top: 20px">
            <div class="col-md-6">
                <div class="card-body">
                    <div class="card pull-up" style="text-align: center;">
                        <div class="row">
                            <div class="row">
                                <div class="col-md-4"><span style="font-size: 20px; font-weight: bold;">INVITE</span></div>
                                <div class="col-md-8" style="text-align: right;">
                                    <span style="font-size: 20px; font-weight: bold;" id="totalInviteSuccess"><%=(hashtableDataAccumulation2.get("TOTAL_MT_INVITE") != null ? (String.format("%,.0f", hashtableDataAccumulation2.get("TOTAL_MT_INVITE"))) : "N/A")%></span>
                                    <span id="totalInviteSuccessAvg"  style=" font-size: 20px; font-weight: bold; margin-right: 10%; color: <%=(hashtableDataAccumulation2.get("TOTAL_MT_INVITE_AVG") != null && hashtableDataAccumulation2.get("TOTAL_MT_INVITE_AVG").compareTo(0D) > 0) ? "#2DE204" : "red"%>">
                                        (<%=((hashtableDataAccumulation2.get("TOTAL_MT_INVITE_AVG") != null && hashtableDataAccumulation2.get("TOTAL_MT_INVITE_AVG").compareTo(0D) > 0) ? "+" : "") + String.format("%,.2f", hashtableDataAccumulation2.get("TOTAL_MT_INVITE_AVG")) + "%"%>)
                                    </span>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-md-12 chart-col-4">
                                    <div id="chartdivPieInvite" style="height: 50%;"></div>
                                </div>
                            </div>

                        </div>
                    </div>
                </div>
            </div>
            <div class="col-md-6">
                <div class="card-body">
                    <div class="card pull-up" style="text-align: center;">
                        <div class="row">
                            <div class="row">
                                <div class="col-md-4"><span style="font-size: 20px; font-weight: bold;">MO</span></div>
                                <div class="col-md-8" style="text-align: right;">
                                    <span style="font-size: 20px; font-weight: bold;" id="totalMoneyTopupSucess"><%=(hashtableDataAccumulation3.get("TOTAL_MO") != null ? (String.format("%,.0f", hashtableDataAccumulation3.get("TOTAL_MO"))) : "N/A")%></span>
                                    <span id="totalMoneyTopupSucessAvg"  style=" font-size: 20px; font-weight: bold; color: <%=(hashtableDataAccumulation3.get("TOTAL_MO_AVG") != null && hashtableDataAccumulation3.get("TOTAL_MO_AVG").compareTo(0D) > 0) ? "#2DE204" : "red"%>">
                                        (<%=((hashtableDataAccumulation3.get("TOTAL_MO_AVG") != null && hashtableDataAccumulation3.get("TOTAL_MO_AVG").compareTo(0D) > 0) ? "+" : "") + String.format("%,.2f", hashtableDataAccumulation3.get("TOTAL_MO_AVG")) + "%"%>)
                                    </span>/
                                    <span style="font-size: 20px; font-weight: bold;" id="totalTopupSucess"><%=(hashtableDataAccumulation3.get("TOTAL_MO_12345") != null ? (String.format("%,.0f", hashtableDataAccumulation3.get("TOTAL_MO_12345"))) : "N/A")%></span>
                                    <span id="totalTopupSucessAvg"  style="font-size: 20px; font-weight: bold; margin-right: 10%; color: <%=(hashtableDataAccumulation3.get("TOTAL_MO_12345_AVG") != null && hashtableDataAccumulation3.get("TOTAL_MO_12345_AVG").compareTo(0D) > 0) ? "#2DE204" : "red"%>">
                                        (<%=((hashtableDataAccumulation3.get("TOTAL_MO_12345_AVG") != null && hashtableDataAccumulation3.get("TOTAL_MO_12345_AVG").compareTo(0D) > 0) ? "+" : "") + String.format("%,.2f", hashtableDataAccumulation3.get("TOTAL_MO_12345_AVG")) + "%"%>)
                                    </span>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-md-12 chart-col-4">
                                    <div id="chartdivPieMO" style="height: 50%;" ></div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="row dashboard-line1 " style="margin-top: 20px">
            <div class="col-md-6">
                <div class="card-body">
                    <div class="card pull-up" style="text-align: center;">
                        <div class="row">
                            <div class="row">
                                <div class="col-md-4"><span style="font-size: 20px; font-weight: bold;">TOPUP</span></div>
                                <div class="col-md-8" style="text-align: right;">
                                    <span style="font-size: 20px; font-weight: bold;" id="totalMoneyTopupSucess"><%=(hashtableDataAccumulation2.get("TOTAL_TOPUP") != null ? (String.format("%,.0f", hashtableDataAccumulation2.get("TOTAL_TOPUP"))) : "N/A")%></span>
                                    <span id="totalMoneyTopupSucessAvg"  style=" font-size: 20px; font-weight: bold; color: <%=(hashtableDataAccumulation2.get("TOTAL_TOPUP_AVG") != null && hashtableDataAccumulation2.get("TOTAL_TOPUP_AVG").compareTo(0D) > 0) ? "#2DE204" : "red"%>">
                                        (<%=((hashtableDataAccumulation2.get("TOTAL_TOPUP_AVG") != null && hashtableDataAccumulation2.get("TOTAL_TOPUP_AVG").compareTo(0D) > 0) ? "+" : "") + String.format("%,.2f", hashtableDataAccumulation2.get("TOTAL_TOPUP_AVG")) + "%"%>)
                                    </span>/
                                    <span style="font-size: 20px; font-weight: bold;" id="totalTopupSucess"><%=(hashtableDataAccumulation2.get("TOTAL_MONEY_TOPUP") != null ? (String.format("%,.0f", hashtableDataAccumulation2.get("TOTAL_MONEY_TOPUP"))) : "N/A")%></span>
                                    <span id="totalTopupSucessAvg"  style=" font-size: 20px; font-weight: bold; margin-right: 10%; color: <%=(hashtableDataAccumulation2.get("TOTAL_MONEY_TOPUP_AVG") != null && hashtableDataAccumulation2.get("TOTAL_MONEY_TOPUP_AVG").compareTo(0D) > 0) ? "#2DE204" : "red"%>">
                                        (<%=((hashtableDataAccumulation2.get("TOTAL_MONEY_TOPUP_AVG") != null && hashtableDataAccumulation2.get("TOTAL_MONEY_TOPUP_AVG").compareTo(0D) > 0) ? "+" : "") + String.format("%,.2f", hashtableDataAccumulation2.get("TOTAL_MONEY_TOPUP_AVG")) + "%"%>)
                                    </span>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-md-12 chart-col-4">
                                    <div id="chartdivPieTopup" style="height: 50%;"></div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-md-6">
                <div class="card-body">
                    <div class="card pull-up" style="text-align: center;">
                        <div class="row">
                            <div class="row">
                                <div class="col-md-4"><span style="font-size: 20px; font-weight: bold;">CHARGE</span></div>
                                <div class="col-md-8" style="text-align: right;">
                                    <span style="font-size: 20px; font-weight: bold;" id="totalMoneyChargeSucess"><%=(hashtableDataAccumulation2.get("TOTAL_MONEY_CHARGE") != null ? (String.format("%,.0f", hashtableDataAccumulation2.get("TOTAL_MONEY_CHARGE"))) : "N/A")%></span>
                                    <span id="totalMoneyChargeSucessAvg"  style=" font-size: 20px; font-weight: bold; margin-right: 10%; color: <%=(hashtableDataAccumulation2.get("TOTAL_MONEY_CHARGE_AVG") != null && hashtableDataAccumulation2.get("TOTAL_MONEY_CHARGE_AVG").compareTo(0D) > 0) ? "#2DE204" : "red"%>">
                                        (<%=((hashtableDataAccumulation2.get("TOTAL_MONEY_CHARGE_AVG") != null && hashtableDataAccumulation2.get("TOTAL_MONEY_CHARGE_AVG").compareTo(0D) > 0) ? "+" : "") + String.format("%,.2f", hashtableDataAccumulation2.get("TOTAL_MONEY_CHARGE_AVG")) + "%"%>)
                                    </span>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-md-12 chart-col-4">
                                    <div id="chartdivPieCharge" style="height: 50%;"></div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <!--End sản lượng topup theo giờ-->


    </div>
    <div class="clear"></div>

    <%@include file="footer.jsp" %>

</div>

<script type="text/javascript">

    jQuery(document).ready(function () {
        jQuery('#staDate').datetimepicker({
            format: 'd/m/Y',
            timepicker: false
        });
    });

    var arrayColor = ["#9CE3E6", "#128EC4", "#84E077", "#037F09", "#CEAECC", "#D90720"];

    var categoriesJS = [];
    var valueDay = [];
    var valueMonth = [];
    var jsonTotalYesterDay = [];

    <%    JSONObject jsonTotalDay = (JSONObject) jSONObjectTopup.get("totalDay");
        JSONObject jsonTotalMonth = (JSONObject) jSONObjectTopup.get("totalMonth");
        JSONObject jsonTotalYesterDay = (JSONObject) jSONObjectTopup.get("totalYesterDay");
        String time = "";
        for (int i = 0; i < 24; i++) {
            if (i < 10) {
                time = "0" + i;
            } else {
                time = "" + i;
            }
    %>
    categoriesJS.push(<%=time%>);
    valueDay.push(<%=jsonTotalDay.get(time)%>);
    valueMonth.push(<%=jsonTotalMonth.get(time)%>);
    jsonTotalYesterDay.push(<%=jsonTotalYesterDay.get(time)%>);
    <%
        }%>
    console.log(valueDay);
    var dataLineTopup = [];
    var objInDay = {};
    objInDay['name'] = "Sản lượng ngày hiện tại";
    objInDay['data'] = valueDay;

    var objInMonth = {};
    objInMonth['name'] = "Sản lượng trung bình tháng trước";
    objInMonth['data'] = valueMonth;

    var objInYesterday = {};
    objInYesterday['name'] = "Sản lượng ngày hôm qua";
    objInYesterday['data'] = jsonTotalYesterDay;

    dataLineTopup.push(objInDay);
    dataLineTopup.push(objInMonth);
    dataLineTopup.push(objInYesterday);

    Highcharts.chart('chartdivLineTopup', {
        chart: {
            type: "line"
        },
        title: {
            text: "SẢN LƯỢNG THEO GIỜ"
        },
        xAxis: {
            categories: categoriesJS
        },
        yAxis: {
            title: {
                text: 'Giá trị'
            }
        },
        legend: {
            layout: 'horizontal',
            align: 'center',
            verticalAlign: 'bottom'
        },
        series: dataLineTopup
    });



    am4core.ready(function () {
// Themes begin
        am4core.useTheme(am4themes_animated);
// Themes end
// 
        /*
         //=======================chartLine==========================================================
         // Create chart instance
         var chartLine = am4core.create("chartdivLineTopup", am4charts.XYChart);
         // Increase contrast by taking evey second color
         chartLine.colors.step = 1;
         // Add data
         let categoryAxis = chartLine.xAxes.push(new am4charts.CategoryAxis());
         categoryAxis.dataFields.category = "hour";
         categoryAxis.title.text = "Hour";
         // Create axes
         //var dateAxis = chart.xAxes.push(new am4charts.DateAxis());
         //dateAxis.renderer.minGridDistance = 50;
         // Create series
         function createAxisAndSeries(field, name, opposite, bullet, color) {
         var valueAxis = chartLine.yAxes.push(new am4charts.ValueAxis());
         
         var series = chartLine.series.push(new am4charts.LineSeries());
         series.dataFields.valueY = field;
         series.dataFields.categoryX = "hour";
         series.strokeWidth = 1;
         series.yAxis = valueAxis;
         series.name = name;
         series.fill = am4core.color(color);
         series.stroke = am4core.color(color);
         series.tooltipText = "{name}: [bold]{valueY}[/]";
         series.tensionX = 0.9;
         
         var interfaceColors = new am4core.InterfaceColorSet();
         
         switch (bullet) {
         case "triangle":
         var bullet = series.bullets.push(new am4charts.Bullet());
         bullet.width = 12;
         bullet.height = 12;
         bullet.horizontalCenter = "middle";
         bullet.verticalCenter = "middle";
         
         var triangle = bullet.createChild(am4core.Triangle);
         triangle.stroke = interfaceColors.getFor("background");
         triangle.strokeWidth = 2;
         triangle.direction = "top";
         triangle.width = 12;
         triangle.height = 12;
         break;
         case "rectangle":
         var bullet = series.bullets.push(new am4charts.Bullet());
         bullet.width = 10;
         bullet.height = 10;
         bullet.horizontalCenter = "middle";
         bullet.verticalCenter = "middle";
         
         var rectangle = bullet.createChild(am4core.Rectangle);
         rectangle.stroke = interfaceColors.getFor("background");
         rectangle.strokeWidth = 2;
         rectangle.width = 10;
         rectangle.height = 10;
         break;
         default:
         var bullet = series.bullets.push(new am4charts.CircleBullet());
         bullet.circle.stroke = interfaceColors.getFor("background");
         bullet.circle.strokeWidth = 2;
         break;
         }
         
         valueAxis.renderer.line.strokeOpacity = 1;
         valueAxis.renderer.line.strokeWidth = 2;
         valueAxis.renderer.line.stroke = series.stroke;
         valueAxis.renderer.labels.template.fill = series.stroke;
         valueAxis.renderer.opposite = opposite;
         valueAxis.renderer.grid.template.disabled = true;
         //  valueAxis.renderer.grid.template.stroke = am4core.color(color);
         //  valueAxis.renderer.labels.template.fill = am4core.color(color);
         //  valueAxis.renderer.line.stroke = am4core.color(color);
         
         }
         createAxisAndSeries("totalDay", "Sản lượng ngày hiện tại", false, "circle", "#F50A0A");
         createAxisAndSeries("totalMonth", "Sản lượng trung bình tháng trước", true, "triangle", "#1DADF0");
         //createAxisAndSeries("views", "Views", true, "triangle");
         // Add legend
         chartLine.legend = new am4charts.Legend();
         // Add cursor
         chartLine.cursor = new am4charts.XYCursor();
         // generate some random data, quite different range
         function generateChartData() {
         var chartData = [];
         
         for (var i = 0; i < 24; i++) {
         
         chartData.push({
         abc: i,
         topup: 20 * i,
         charge: (10 + i) * i,
         });
         }
         return chartData;
         }
         
         
         //=================================================================================
         
         */




        var chartPieInvite = am4core.create("chartdivPieInvite", am4charts.PieChart);

// Add data

        chartPieInvite.data = <%=jSONArrayInviteGroupByCode%>;
        /*
         chartPieInvite.data = [{
         "country": "Lithuania",
         "litres": 501.9,
         "color": arrayColor[0]
         }, {
         "country": "Czechia",
         "litres": 301.9,
         "color": arrayColor[1]
         }, {
         "country": "Ireland",
         "litres": 201.1,
         "color": arrayColor[2]
         }];
         */
// Add and configure Series
        var pieSeries = chartPieInvite.series.push(new am4charts.PieSeries());
        pieSeries.dataFields.value = "totalValue";
        pieSeries.dataFields.category = "dataCode";
        pieSeries.slices.template.propertyFields.fill = "color";
// Let's cut a hole in our Pie chart the size of 40% the radius
        chartPieInvite.innerRadius = am4core.percent(50);
// Disable ticks and labels
        pieSeries.labels.template.disabled = true;
        pieSeries.ticks.template.disabled = true;
// Disable tooltips
        pieSeries.slices.template.tooltipText = "";
// Add a legend
        chartPieInvite.legend = new am4charts.Legend();
        chartPieInvite.legend.position = "right";


        var chartPieMo = am4core.create("chartdivPieMO", am4charts.PieChart);

// Add data
        chartPieMo.data = <%=jSONArrayMOGroupByCode%>;
        /*
         chartPieMo.data = [{
         "country": "Lithuania",
         "litres": 501.9,
         "color": chartPieMo.colors.getIndex(0)
         }, {
         "country": "Czechia",
         "litres": 301.9,
         "color": chartPieMo.colors.getIndex(0)
         }, {
         "country": "Ireland",
         "litres": 201.1,
         "color": chartPieMo.colors.getIndex(2)
         }];
         */
// Add and configure Series
        var pieSeries = chartPieMo.series.push(new am4charts.PieSeries());
        pieSeries.dataFields.value = "totalValue";
        pieSeries.dataFields.category = "dataCode";
        pieSeries.slices.template.propertyFields.fill = "color";
// Let's cut a hole in our Pie chart the size of 40% the radius
        chartPieMo.innerRadius = am4core.percent(50);
// Disable ticks and labels
        pieSeries.labels.template.disabled = true;
        pieSeries.ticks.template.disabled = true;
// Disable tooltips
        pieSeries.slices.template.tooltipText = "";
// Add a legend
        chartPieMo.legend = new am4charts.Legend();
        chartPieMo.legend.position = "right";


        var chartPieTopup = am4core.create("chartdivPieTopup", am4charts.PieChart);

// Add data

        chartPieTopup.data = <%=jSONArrayTopupGroupByCode%>;
        /*
         chartPieTopup.data = [{
         "country": "Lithuania",
         "litres": 501.9,
         "color": chartPieTopup.colors.getIndex(0)
         }, {
         "country": "Czechia",
         "litres": 301.9,
         "color": chartPieTopup.colors.getIndex(0)
         }, {
         "country": "Ireland",
         "litres": 201.1,
         "color": chartPieTopup.colors.getIndex(2)
         }];
         */
// Add and configure Series
        var pieSeries = chartPieTopup.series.push(new am4charts.PieSeries());
        pieSeries.dataFields.value = "totalValue";
        pieSeries.dataFields.category = "dataCode";
        pieSeries.slices.template.propertyFields.fill = "color";
// Let's cut a hole in our Pie chart the size of 40% the radius
        chartPieTopup.innerRadius = am4core.percent(50);
// Disable ticks and labels
        pieSeries.labels.template.disabled = true;
        pieSeries.ticks.template.disabled = true;
// Disable tooltips
        pieSeries.slices.template.tooltipText = "";
// Add a legend
        chartPieTopup.legend = new am4charts.Legend();
        chartPieTopup.legend.position = "right";



        var chartPieCharge = am4core.create("chartdivPieCharge", am4charts.PieChart);

// Add data
        chartPieCharge.data = <%=jSONArrayChargeGroupByCode%>;
        /*
         chartPieCharge.data = [{
         "country": "Lithuania",
         "litres": 501.9,
         "color": chartPieCharge.colors.getIndex(0)
         }, {
         "country": "Czechia",
         "litres": 301.9,
         "color": chartPieCharge.colors.getIndex(0)
         }, {
         "country": "Ireland",
         "litres": 201.1,
         "color": chartPieCharge.colors.getIndex(2)
         }];
         */
// Add and configure Series
        var pieSeries = chartPieCharge.series.push(new am4charts.PieSeries());
        pieSeries.dataFields.value = "totalValue";
        pieSeries.dataFields.category = "dataCode";
        pieSeries.slices.template.propertyFields.fill = "color";
// Let's cut a hole in our Pie chart the size of 40% the radius
        chartPieCharge.innerRadius = am4core.percent(50);
// Disable ticks and labels
        pieSeries.labels.template.disabled = true;
        pieSeries.ticks.template.disabled = true;
// Disable tooltips
        pieSeries.slices.template.tooltipText = "";
// Add a legend
        chartPieCharge.legend = new am4charts.Legend();
        chartPieCharge.legend.position = "right";


    }); // end am4core.ready()

</script>
<!-- End #main-content -->