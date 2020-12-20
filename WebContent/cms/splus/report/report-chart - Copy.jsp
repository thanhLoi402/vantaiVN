<%@page language="java" pageEncoding="utf-8" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
        <title>Biểu đồ báo cáo</title>
        <link rel="icon" href="<%=request.getContextPath()%>/images/icon/admin.ico" type="image/x-icon"/>
        <link rel="stylesheet" href="<%=request.getContextPath()%>/admin/login/resources/css/reset.css" type="text/css" media="screen"/>
        <link rel="stylesheet" href="<%=request.getContextPath()%>/admin/login/resources/css/style.css" type="text/css" media="screen"/>
        <link rel="stylesheet" href="<%=request.getContextPath()%>/admin/login/resources/css/font-awesome.min.css" type="text/css" media="screen"/>
        <link rel="stylesheet" href="<%=request.getContextPath()%>/admin/login/resources/css/jquery.datetimepicker.min.css" type="text/css" media="screen"/>
        <script type="text/javascript" src="<%=request.getContextPath()%>/admin/login/resources/scripts/jquery-3.1.1.min.js"></script>
        <script type="text/javascript" src="<%=request.getContextPath()%>/admin/login/resources/scripts/jquery.datetimepicker.full.min.js"></script>
        <script type="text/javascript" src="<%=request.getContextPath()%>/admin/login/resources/scripts/highcharts.js"></script>
        <script type="text/javascript" src="<%=request.getContextPath()%>/admin/login/resources/scripts/exporting.js"></script>
        <%
            SimpleDateFormat sdf1 = new SimpleDateFormat("dd/MM/yyyy");
            SimpleDateFormat sdf2 = new SimpleDateFormat("MM/yyyy");

            int yearStartDV = 2017;

            Calendar cal = Calendar.getInstance();
        %>
        <style>
            .text-input {
                margin-right: 5px;
            }
            .hidden {
                display: none;
            }
            th {
                font-size: 13px;
                background-color: rgba(204, 204, 204, 0.3) !important;
                font-weight: bold;
            }

            table {
                table-layout: fixed;
            }

            table td {
                word-wrap: break-word;
            }

            .content-box-content {
                padding: 15px;
                font-size: 13px;
                border-top: 0;
                display: inline-block;
                width: 98%;
            }

            .content-box {
                border: 1px solid #6d9885;
                border-radius: 3px;
            }

            .text-input {
                border: 1px solid #6d9885 !important;
            }

            .content-box-header {
                min-height: 40px;
                display: table;
                width: 100%;
                vertical-align: middle;
                background: #6d9885;
                margin: 0 !important;
                border-radius: 0;
                text-align: center;
                cursor: pointer;
            }

            .content-box-header h4 {
                display: table-cell;
                vertical-align: middle;
                padding: 5px;
                color: #fff;
                width: 95%;
            }

            .tab-content {
                display: inline-block;
                width: 100%;
            }

            #main-content table thead th {
                font-weight: bold;
                font-size: 13px;
                border-bottom: 1px solid #ddd;
            }
            #main-content table {
                width: 100% !important;
            }
            select {
                width: 150px !important;
                height: 25px !important;
                margin-right: 5px;
                float: left;
                border: 1px solid #6d9885;
                border-radius: 2px;
            }
            .spinner {
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
            span.caret {
                float: right;
                margin: 15px;
                color: #fff;
            }
        </style>
    </head>
    <%@ include file="/admin/include/header.jsp" %>
    <body>
        <div id="body-wrapper"> <!-- Wrapper for the radial gradient background -->
            <jsp:include page="/admin/include/left.jsp"/>
            <div id="main-content"> <!-- Main Content Section with everything -->
                <!-- Page Head -->
                <%@ include file="/admin/include/tool.jsp" %>
                <div class="clear"></div> <!-- End .clear -->
                <h2 align="center">BIỂU ĐỒ BÁO CÁO</h2>
                <div class="clear"></div>
                <div class="content-box"><!-- Start Content Box -->
                    <div class="content-box-header" id="cdrBoxHeader">
                        <h4 style="text-align: left;">Báo cáo thống kê CDR</h4>
                        <span class="caret"><i class="fa fa-caret-down" aria-hidden="true"></i></span>
                    </div> <!-- End .content-box-header -->
                    <div class="content-box-content" id="cdrBoxContent">
                        <div class="tab-content default-tab">
                            <div style="margin-bottom: 5px;float: left;width: 100%;">
                                <select name="selectTypeReport" onchange="chooseTypeReportCDR(this)" id="selectTypeReport">
                                    <option>Chọn loại báo cáo</option>
                                    <option value="1">Ngày</option>
                                    <option value="2">Tuần</option>
                                    <option value="3">Tháng</option>
                                    <option value="4">Quý</option>
                                </select>
                                <input type="text" class="text-input datetimepickerFrom hidden" name="cdrReport" placeholder="Chọn ngày" id="cdrReport" style="height: 25px;border: 1px solid #ccc;border-radius: 2px;width: 150px;padding-left: 5px;float: left;">
                                <select name="selectWeekOfYear" id="selectWeekOfYear" style="width: 230px !important;" class="hidden">
                                    <%
                                        String startDate;
                                        String endDate;
                                        cal = Calendar.getInstance();
                                        int currentWeek = cal.get(Calendar.WEEK_OF_YEAR);
                                        int yearNow = cal.get(Calendar.YEAR);
                                        cal.set(Calendar.YEAR, yearStartDV);
                                        for (int j = 0; j <= (yearNow - yearStartDV); j++) {
                                            for (int i = 1; i <= 52; i++) {
                                                cal.set(Calendar.WEEK_OF_YEAR, i);
                                                cal.setFirstDayOfWeek(Calendar.MONDAY);
                                                cal.set(Calendar.DAY_OF_WEEK, Calendar.MONDAY);
                                                startDate = sdf1.format(cal.getTime());
                                                cal.set(Calendar.DAY_OF_WEEK, 8);
                                                endDate = sdf1.format(cal.getTime());
                                                if (currentWeek == cal.get(Calendar.WEEK_OF_YEAR) && yearNow == cal.get(Calendar.YEAR)) {
                                                    out.print("<option value=\"" + startDate + "-" + endDate + "\" selected=\"selected\">Tuần " + cal.get(Calendar.WEEK_OF_YEAR) + "-" + cal.get(Calendar.YEAR) + " (" + startDate + " - " + endDate + ")</option>");
                                                } else {
                                                    out.print("<option value=\"" + startDate + "-" + endDate + "\">Tuần " + cal.get(Calendar.WEEK_OF_YEAR) + "-" + cal.get(Calendar.YEAR) + " (" + startDate + " - " + endDate + ")</option>");
                                                }
                                            }
                                            cal.add(Calendar.YEAR, 1);
                                        }
                                    %>
                                </select>
                                <select name="selectMonth" id="selectMonth" class="hidden">
                                    <%
                                        String startDateOfMonth;
                                        String endDateOfMonth;
                                        cal = Calendar.getInstance();
                                        int monthNow = cal.get(Calendar.MONTH);
                                        yearNow = cal.get(Calendar.YEAR);
                                        cal.set(Calendar.YEAR, yearStartDV);
                                        for (int j = 0; j <= (yearNow - yearStartDV); j++) {
                                            for (int i = 1; i <= 12; i++) {
                                                cal.set(Calendar.MONTH, i - 1);
                                                cal.set(Calendar.DAY_OF_MONTH, 1);
                                                startDateOfMonth = sdf1.format(cal.getTime());
                                                cal.set(Calendar.DAY_OF_MONTH, cal.getActualMaximum(Calendar.DAY_OF_MONTH));
                                                endDateOfMonth = sdf1.format(cal.getTime());
                                                if (monthNow == cal.get(Calendar.MONTH) && yearNow == cal.get(Calendar.YEAR)) {
                                                    out.print("<option value=\"" + startDateOfMonth + "-" + endDateOfMonth + "\" selected >" + sdf2.format(cal.getTime()) + "</option>");
                                                } else {
                                                    out.print("<option value=\"" + startDateOfMonth + "-" + endDateOfMonth + "\">" + sdf2.format(cal.getTime()) + "</option>");
                                                }
                                            }
                                            cal.add(Calendar.YEAR, 1);
                                        }
                                    %>
                                </select>
                                <select name="selectQuater" id="selectQuater" class="hidden">
                                    <%
                                        String startDateOfQuater;
                                        String endDateOfQuater;
                                        int c = 1;
                                        cal = Calendar.getInstance();
                                        int month = cal.get(Calendar.MONTH) + 1;
                                        yearNow = cal.get(Calendar.YEAR);
                                        cal.set(Calendar.YEAR, yearStartDV);
                                        for (int j = 0; j <= (yearNow - yearStartDV); j++) {
                                            for (int i = 0; i < 12; i = i + 3) {
                                                cal.set(Calendar.MONTH, i);
                                                cal.set(Calendar.DAY_OF_MONTH, 1);
                                                startDateOfQuater = sdf1.format(cal.getTime());
                                                cal.set(Calendar.MONTH, i + 2);
                                                cal.set(Calendar.DAY_OF_MONTH, cal.getActualMaximum(Calendar.DAY_OF_MONTH));
                                                endDateOfQuater = sdf1.format(cal.getTime());
                                                if (month > i && yearNow == cal.get(Calendar.YEAR)) {
                                                    out.print("<option value=\"" + startDateOfQuater + "-" + endDateOfQuater + "\" selected >Quý " + (c++) + "-" + cal.get(Calendar.YEAR) + "</option>");
                                                } else {
                                                    out.print("<option value=\"" + startDateOfQuater + "-" + endDateOfQuater + "\">Quý " + (c++) + "-" + cal.get(Calendar.YEAR) + "</option>");
                                                }
                                            }
                                            c = 1;
                                            cal.add(Calendar.YEAR, 1);
                                        }
                                    %>
                                </select>
                                <input type="button" value="Xem" class="button" onclick="getReport(this, 'CDR')" style="float: left;">
                                <div class="spinner-cdr spinner hidden">
                                    <div class="bounce1"></div>
                                    <div class="bounce2"></div>
                                    <div class="bounce3"></div>
                                </div>
                                <div style="float: right;">
                                    <label for="changeChartTypeCDR"><b>Loại biểu đồ</b></label>
                                    <select name="changeChartType" class="changeChartType" onchange="changeChartType(this, 'CDR')" id="changeChartTypeCDR" style="margin-left: 5px;">
                                        <option value="line">Line</option>
                                        <option value="column">Column</option>
                                    </select>
                                </div>
                            </div>
                            <div id="containerCDR"></div>
                            <span style="color: red;width: 100%;text-align: center;float: left;" id="msgCDR"><b>Không có dữ liệu</b></span>
                        </div> <!-- End #tab1 -->
                    </div> <!-- End .content-box-content -->
                </div> <!-- End .content-box -->
                <div class="clear"></div> <!-- End .clear -->
                <div class="content-box"><!-- Start Content Box -->
                    <div class="content-box-header" id="mtBoxHeader">
                        <h4 style="text-align: left;">Báo cáo MT-Log</h4>
                        <span class="caret"><i class="fa fa-caret-up" aria-hidden="true"></i></span>
                    </div> <!-- End .content-box-header -->
                    <div class="content-box-content" id="mtBoxContent" style="display: none;">
                        <div class="tab-content default-tab" id="tab1">
                            <div style="margin-bottom: 5px;float: left;width: 100%;">
                                <select name="selectTypeReportMT" onchange="chooseTypeReportMT(this)" id="selectTypeReportMT">
                                    <option>Chọn loại báo cáo</option>
                                    <option value="1">Ngày</option>
                                    <option value="2">Tuần</option>
                                    <option value="3">Tháng</option>
                                    <option value="4">Quý</option>
                                </select>
                                <input type="text" class="text-input datetimepickerFrom hidden" name="MTReport" placeholder="Chọn ngày" id="MTReport"
                                       style="height: 25px;border: 1px solid #ccc;border-radius: 2px;width: 150px;padding-left: 5px;float: left;">
                                <select name="selectWeekOfYearMT" id="selectWeekOfYearMT" style="width: 230px !important;" class="hidden">
                                    <%
                                        String startDateMT;
                                        String endDateMT;
                                        cal = Calendar.getInstance();
                                        int currentWeekMT = cal.get(Calendar.WEEK_OF_YEAR);
                                        yearNow = cal.get(Calendar.YEAR);
                                        cal.set(Calendar.YEAR, yearStartDV);
                                        for (int j = 0; j <= (yearNow - yearStartDV); j++) {
                                            for (int i = 1; i <= 52; i++) {
                                                cal.set(Calendar.WEEK_OF_YEAR, i);
                                                cal.setFirstDayOfWeek(Calendar.MONDAY);
                                                cal.set(Calendar.DAY_OF_WEEK, Calendar.MONDAY);
                                                startDateMT = sdf1.format(cal.getTime());
                                                cal.set(Calendar.DAY_OF_WEEK, 8);
                                                endDateMT = sdf1.format(cal.getTime());
                                                if (currentWeekMT == cal.get(Calendar.WEEK_OF_YEAR) && yearNow == cal.get(Calendar.YEAR)) {
                                                    out.print("<option value=\"" + startDateMT + "-" + endDateMT + "\" selected=\"selected\">Tuần " + cal.get(Calendar.WEEK_OF_YEAR) + "-" + cal.get(Calendar.YEAR) + " (" + startDateMT + " - " + endDateMT + ")</option>");
                                                } else {
                                                    out.print("<option value=\"" + startDateMT + "-" + endDateMT + "\">Tuần " + cal.get(Calendar.WEEK_OF_YEAR) + "-" + cal.get(Calendar.YEAR) + " (" + startDateMT + " - " + endDateMT + ")</option>");
                                                }
                                            }
                                            cal.add(Calendar.YEAR, 1);
                                        }
                                    %>
                                </select>
                                <select name="selectMonth" id="selectMonthMT" class="hidden">
                                    <%
                                        String startDateOfMonthMT;
                                        String endDateOfMonthmT;
                                        cal = Calendar.getInstance();
                                        int monthmt = cal.get(Calendar.MONTH);
                                        yearNow = cal.get(Calendar.YEAR);
                                        cal.set(Calendar.YEAR, yearStartDV);
                                        for (int j = 0; j <= (yearNow - yearStartDV); j++) {
                                            for (int i = 1; i <= 12; i++) {
                                                cal.set(Calendar.MONTH, i - 1);
                                                cal.set(Calendar.DAY_OF_MONTH, 1);
                                                startDateOfMonthMT = sdf1.format(cal.getTime());
                                                cal.set(Calendar.DAY_OF_MONTH, cal.getActualMaximum(Calendar.DAY_OF_MONTH));
                                                endDateOfMonthmT = sdf1.format(cal.getTime());
                                                if (monthmt == cal.get(Calendar.MONTH) && yearNow == cal.get(Calendar.YEAR)) {
                                                    out.print("<option value=\"" + startDateOfMonthMT + "-" + endDateOfMonthmT + "\" selected >" + sdf2.format(cal.getTime()) + "</option>");
                                                } else {
                                                    out.print("<option value=\"" + startDateOfMonthMT + "-" + endDateOfMonthmT + "\">" + sdf2.format(cal.getTime()) + "</option>");
                                                }
                                            }
                                            cal.add(Calendar.YEAR, 1);
                                        }
                                    %>
                                </select>
                                <select name="selectQuater" id="selectQuaterMT" class="hidden">
                                    <%
                                        String startDateOfQuaterMT;
                                        String endDateOfQuaterMT;
                                        c = 1;
                                        cal = Calendar.getInstance();
                                        int monthQuaterMt = cal.get(Calendar.MONTH) + 1;
                                        yearNow = cal.get(Calendar.YEAR);
                                        cal.set(Calendar.YEAR, yearStartDV);
                                        for (int j = 0; j <= (yearNow - yearStartDV); j++) {
                                            for (int i = 0; i < 12; i = i + 3) {
                                                cal.set(Calendar.MONTH, i);
                                                cal.set(Calendar.DAY_OF_MONTH, 1);
                                                startDateOfQuaterMT = sdf1.format(cal.getTime());
                                                cal.set(Calendar.MONTH, i + 2);
                                                cal.set(Calendar.DAY_OF_MONTH, cal.getActualMaximum(Calendar.DAY_OF_MONTH));
                                                endDateOfQuaterMT = sdf1.format(cal.getTime());
                                                if (monthQuaterMt > i && yearNow == cal.get(Calendar.YEAR)) {
                                                    out.print("<option value=\"" + startDateOfQuaterMT + "-" + endDateOfQuaterMT + "\" selected >Quý " + (c++) + "-" + cal.get(Calendar.YEAR) + "</option>");
                                                } else {
                                                    out.print("<option value=\"" + startDateOfQuaterMT + "-" + endDateOfQuaterMT + "\">Quý " + (c++) + "-" + cal.get(Calendar.YEAR) + "</option>");
                                                }
                                            }
                                            c = 1;
                                            cal.add(Calendar.YEAR, 1);
                                        }
                                    %>
                                </select>
                                <input type="button" value="Xem" class="button" onclick="getReport(this, 'MT')" style="float: left;">
                                <div class="spinner-mt spinner hidden">
                                    <div class="bounce1"></div>
                                    <div class="bounce2"></div>
                                    <div class="bounce3"></div>
                                </div>
                                <div style="float: right;">
                                    <label for="changeChartTypeMT"><b>Loại biểu đồ</b></label>
                                    <select name="changeChartType" class="changeChartType" onchange="changeChartType(this, 'MT')" id="changeChartTypeMT" style="margin-left: 5px;">
                                        <option value="line">Line</option>
                                        <option value="column">Column</option>
                                    </select>
                                </div>
                            </div>
                            <div id="containerMT"></div>
                            <span style="color: red;width: 100%;text-align: center;float: left;" id="msgMT"><b>Không có dữ liệu</b></span>
                        </div> <!-- End #tab1 -->
                    </div> <!-- End .content-box-content -->
                </div> <!-- End .content-box -->
                <div class="clear"></div>
                <div class="content-box"><!-- Start Content Box -->
                    <div class="content-box-header" id="moBoxHeader">
                        <h4 style="text-align: left;">Báo cáo MO Log</h4>
                        <span class="caret"><i class="fa fa-caret-down" aria-hidden="true"></i></span>
                    </div> <!-- End .content-box-header -->
                    <div class="content-box-content" id="moBoxContent" style="display: none;">
                        <div class="tab-content default-tab">
                            <div style="margin-bottom: 5px;float: left;width: 100%;">
                                <select name="selectTypeReportMO" onchange="chooseTypeReportMO(this)" id="selectTypeReportMO">
                                    <option>Chọn loại báo cáo</option>
                                    <option value="1">Ngày</option>
                                    <option value="2">Tuần</option>
                                    <option value="3">Tháng</option>
                                    <option value="4">Quý</option>
                                </select>
                                <input type="text" class="text-input datetimepickerFrom hidden" name="MOReport" placeholder="Chọn ngày" id="MOReport"
                                       style="height: 25px;border: 1px solid #ccc;border-radius: 2px;width: 150px;padding-left: 5px;float: left;">
                                <select name="selectWeekOfYearMO" id="selectWeekOfYearMO" style="width: 230px !important;" class="hidden">
                                    <%
                                        String startDateMO;
                                        String endDateMO;
                                        cal = Calendar.getInstance();
                                        int currentWeekMO = cal.get(Calendar.WEEK_OF_YEAR);
                                        yearNow = cal.get(Calendar.YEAR);
                                        cal.set(Calendar.YEAR, yearStartDV);
                                        for (int j = 0; j <= (yearNow - yearStartDV); j++) {
                                            for (int i = 1; i <= 52; i++) {
                                                cal.set(Calendar.WEEK_OF_YEAR, i);
                                                cal.setFirstDayOfWeek(Calendar.MONDAY);
                                                cal.set(Calendar.DAY_OF_WEEK, Calendar.MONDAY);
                                                startDateMO = sdf1.format(cal.getTime());
                                                cal.set(Calendar.DAY_OF_WEEK, 8);
                                                endDateMO = sdf1.format(cal.getTime());
                                                if (currentWeekMO == cal.get(Calendar.WEEK_OF_YEAR)  && yearNow == cal.get(Calendar.YEAR)) {
                                                    out.print("<option value=\"" + startDateMO + "-" + endDateMO + "\" selected=\"selected\">Tuần " + cal.get(Calendar.WEEK_OF_YEAR) + "-" + cal.get(Calendar.YEAR) + " (" + startDateMO + " - " + endDateMO + ")</option>");
                                                } else {
                                                    out.print("<option value=\"" + startDateMO + "-" + endDateMO + "\">Tuần " + cal.get(Calendar.WEEK_OF_YEAR) + "-" + cal.get(Calendar.YEAR) + " (" + startDateMO + " - " + endDateMO + ")</option>");
                                                }
                                            }
                                            cal.add(Calendar.YEAR, 1);
                                        }
                                    %>
                                </select>
                                <select name="selectMonth" id="selectMonthMO" class="hidden">
                                    <%
                                        String startDateOfMonthMO;
                                        String endDateOfMonthMO;
                                        cal = Calendar.getInstance();
                                        int monthMo = cal.get(Calendar.MONTH);
                                        yearNow = cal.get(Calendar.YEAR);
                                        cal.set(Calendar.YEAR, yearStartDV);
                                        for (int j = 0; j <= (yearNow - yearStartDV); j++) {
                                            for (int i = 1; i <= 12; i++) {
                                                cal.set(Calendar.MONTH, i - 1);
                                                cal.set(Calendar.DAY_OF_MONTH, 1);
                                                startDateOfMonthMO = sdf1.format(cal.getTime());
                                                cal.set(Calendar.DAY_OF_MONTH, cal.getActualMaximum(Calendar.DAY_OF_MONTH));
                                                endDateOfMonthMO = sdf1.format(cal.getTime());
                                                if (monthMo == cal.get(Calendar.MONTH) && yearNow == cal.get(Calendar.YEAR) ) {
                                                    out.print("<option value=\"" + startDateOfMonthMO + "-" + endDateOfMonthMO + "\" selected >" + sdf2.format(cal.getTime()) +  "</option>");
                                                } else {
                                                    out.print("<option value=\"" + startDateOfMonthMO + "-" + endDateOfMonthMO + "\">" + sdf2.format(cal.getTime()) + "</option>");
                                                }
                                            }
                                            cal.add(Calendar.YEAR, 1);
                                        }
                                    %>
                                </select>
                                <select name="selectQuater" id="selectQuaterMO" class="hidden">
                                    <%
                                        String startDateOfQuaterMO;
                                        String endDateOfQuaterMO;
                                        c = 1;
                                        cal = Calendar.getInstance();
                                        int monthQuaterMO = cal.get(Calendar.MONTH) + 1;
                                        yearNow = cal.get(Calendar.YEAR);
                                        cal.set(Calendar.YEAR, yearStartDV);
                                        for (int j = 0; j <= (yearNow - yearStartDV); j++) {
                                            for (int i = 0; i < 12; i = i + 3) {
                                                cal.set(Calendar.MONTH, i);
                                                cal.set(Calendar.DAY_OF_MONTH, 1);
                                                startDateOfQuaterMO = sdf1.format(cal.getTime());
                                                cal.set(Calendar.MONTH, i + 2);
                                                cal.set(Calendar.DAY_OF_MONTH, cal.getActualMaximum(Calendar.DAY_OF_MONTH));
                                                endDateOfQuaterMO = sdf1.format(cal.getTime());
                                                if (monthQuaterMO > i && yearNow == cal.get(Calendar.YEAR)) {
                                                    out.print("<option value=\"" + startDateOfQuaterMO + "-" + endDateOfQuaterMO + "\" selected >Quý " + (c++) + "-" + cal.get(Calendar.YEAR) + "</option>");
                                                } else {
                                                    out.print("<option value=\"" + startDateOfQuaterMO + "-" + endDateOfQuaterMO + "\">Quý " + (c++) + "-" + cal.get(Calendar.YEAR) + "</option>");
                                                }
                                            }
                                            c=1;
                                            cal.add(Calendar.YEAR, 1);
                                        }
                                    %>
                                </select>
                                <input type="button" value="Xem" class="button" onclick="getReport(this, 'MO')" style="float: left;">
                                <div class="spinner-mo spinner hidden">
                                    <div class="bounce1"></div>
                                    <div class="bounce2"></div>
                                    <div class="bounce3"></div>
                                </div>
                                <div style="float: right;">
                                    <label for="changeChartTypeMO"><b>Loại biểu đồ</b></label>
                                    <select name="changeChartType" class="changeChartType" onchange="changeChartType(this, 'MO')" id="changeChartTypeMO" style="margin-left: 5px;">
                                        <option value="line">Line</option>
                                        <option value="column">Column</option>
                                    </select>
                                </div>
                            </div>
                            <div id="containerMO"></div>
                            <span style="color: red;width: 100%;text-align: center;float: left;" id="msgMO"><b>Không có dữ liệu</b></span>
                        </div> <!-- End #tab1 -->
                    </div> <!-- End .content-box-content -->
                </div> <!-- End .content-box -->
                <div class="clear"></div>
                <div class="content-box"><!-- Start Content Box -->
                    <div class="content-box-header" id="transPaymentBoxHeader">
                        <h4 style="text-align: left;">Báo cáo TOPUP - CHARGE</h4>
                        <span class="caret"><i class="fa fa-caret-down" aria-hidden="true"></i></span>
                    </div> <!-- End .content-box-header -->
                    <div class="content-box-content" id="transPaymentBoxContent" style="display: none;">
                        <div class="tab-content default-tab">
                            <div style="margin-bottom: 5px;float: left;width: 100%;">
                                <select name="selectTypeReportTrans" onchange="chooseTypeReportTrans(this)" id="selectTypeReportTrans">
                                    <option>Chọn loại báo cáo</option>
                                    <option value="1">Ngày</option>
                                    <option value="2">Tuần</option>
                                    <option value="3">Tháng</option>
                                    <option value="4">Quý</option>
                                </select>
                                <input type="text" class="text-input datetimepickerFrom hidden" name="transReport" placeholder="Chọn ngày" id="transReport"
                                       style="height: 25px;border: 1px solid #ccc;border-radius: 2px;width: 150px;padding-left: 5px;float: left;">
                                <select name="selectWeekOfYearTrans" id="selectWeekOfYearTrans" style="width: 230px !important;" class="hidden">
                                    <%
                                        String startDateTrans;
                                        String endDateTrans;
                                        cal = Calendar.getInstance();
                                        int currentWeekTrans = cal.get(Calendar.WEEK_OF_YEAR);
                                        yearNow = cal.get(Calendar.YEAR);
                                        cal.set(Calendar.YEAR, yearStartDV);
                                        for (int j = 0; j <= (yearNow - yearStartDV); j++) {
                                            for (int i = 1; i <= 52; i++) {
                                                cal.set(Calendar.WEEK_OF_YEAR, i);
                                                cal.setFirstDayOfWeek(Calendar.MONDAY);
                                                cal.set(Calendar.DAY_OF_WEEK, Calendar.MONDAY);
                                                startDateTrans = sdf1.format(cal.getTime());
                                                cal.set(Calendar.DAY_OF_WEEK, 8);
                                                endDateTrans = sdf1.format(cal.getTime());
                                                if (currentWeekTrans == cal.get(Calendar.WEEK_OF_YEAR)  && yearNow == cal.get(Calendar.YEAR)) {
                                                    out.print("<option value=\"" + startDateTrans + "-" + endDateTrans + "\" selected=\"selected\">Tuần " + cal.get(Calendar.WEEK_OF_YEAR) + "-" + cal.get(Calendar.YEAR) + " (" + startDateTrans + " - " + endDateTrans + ")</option>");
                                                } else {
                                                    out.print("<option value=\"" + startDateTrans + "-" + endDateTrans + "\">Tuần " + cal.get(Calendar.WEEK_OF_YEAR) + "-" + cal.get(Calendar.YEAR) + " (" + startDateTrans + " - " + endDateTrans + ")</option>");
                                                }
                                            }
                                            cal.add(Calendar.YEAR, 1);
                                        }
                                    %>
                                </select>
                                <select name="selectMonth" id="selectMonthTrans" class="hidden">
                                    <%
                                        String startDateOfMonthTrans;
                                        String endDateOfMonthTrans;
                                        cal = Calendar.getInstance();
                                        int monthTR = cal.get(Calendar.MONTH);
                                        yearNow = cal.get(Calendar.YEAR);
                                        cal.set(Calendar.YEAR, yearStartDV);
                                        for (int j = 0; j <= (yearNow - yearStartDV); j++) {
                                            for (int i = 1; i <= 12; i++) {
                                                cal.set(Calendar.MONTH, i - 1);
                                                cal.set(Calendar.DAY_OF_MONTH, 1);
                                                startDateOfMonthTrans = sdf1.format(cal.getTime());
                                                cal.set(Calendar.DAY_OF_MONTH, cal.getActualMaximum(Calendar.DAY_OF_MONTH));
                                                endDateOfMonthTrans = sdf1.format(cal.getTime());
                                                if (monthTR == cal.get(Calendar.MONTH) && yearNow == cal.get(Calendar.YEAR)) {
                                                    out.print("<option value=\"" + startDateOfMonthTrans + "-" + endDateOfMonthTrans + "\" selected >" + sdf2.format(cal.getTime()) +  "</option>");
                                                } else {
                                                    out.print("<option value=\"" + startDateOfMonthTrans + "-" + endDateOfMonthTrans + "\">" + sdf2.format(cal.getTime()) +  "</option>");
                                                }
                                            }
                                            cal.add(Calendar.YEAR, 1);
                                        }
                                    %>
                                </select>
                                <select name="selectQuater" id="selectQuaterTrans" class="hidden">
                                    <%
                                        String startDateOfQuaterTrans;
                                        String endDateOfQuaterTrans;
                                        c = 1;
                                        cal = Calendar.getInstance();
                                        int monthQuaterTR = cal.get(Calendar.MONTH) + 1;
                                        yearNow = cal.get(Calendar.YEAR);
                                        cal.set(Calendar.YEAR, yearStartDV);
                                        for (int j = 0; j <= (yearNow - yearStartDV); j++) {
                                            for (int i = 0; i < 12; i = i + 3) {
                                                cal.set(Calendar.MONTH, i);
                                                cal.set(Calendar.DAY_OF_MONTH, 1);
                                                startDateOfQuaterTrans = sdf1.format(cal.getTime());
                                                cal.set(Calendar.MONTH, i + 2);
                                                cal.set(Calendar.DAY_OF_MONTH, cal.getActualMaximum(Calendar.DAY_OF_MONTH));
                                                endDateOfQuaterTrans = sdf1.format(cal.getTime());
                                                if (monthQuaterTR > i) {
                                                    out.print("<option value=\"" + startDateOfQuaterTrans + "-" + endDateOfQuaterTrans + "\" selected >Quý " + (c++) + "-" + cal.get(Calendar.YEAR) + "</option>");
                                                } else {
                                                    out.print("<option value=\"" + startDateOfQuaterTrans + "-" + endDateOfQuaterTrans + "\">Quý " + (c++) + "-" + cal.get(Calendar.YEAR) + "</option>");
                                                }
                                            }
                                            c=1; 
                                            cal.add(Calendar.YEAR, 1);
                                        }
                                %>
                                </select>
                                <select name="dataType" id="dataType">
                                    <option value="1">Số lượng giao dịch</option>
                                    <option value="2">Tổng tiền giao dịch</option>
                                </select>
                                <input type="button" value="Xem" class="button" onclick="getReport(this, 'TRANS')" style="float: left;">
                                <div class="spinner-trans spinner hidden">
                                    <div class="bounce1"></div>
                                    <div class="bounce2"></div>
                                    <div class="bounce3"></div>
                                </div>
                                <div style="float: right;">
                                    <label for="changeChartTypeTRANS"><b>Loại biểu đồ</b></label>
                                    <select name="changeChartType" class="changeChartType" onchange="changeChartType(this, 'TRANS')" id="changeChartTypeTRANS" style="margin-left: 5px;">
                                        <option value="line">Line</option>
                                        <option value="column">Column</option>
                                    </select>
                                </div>
                            </div>
                            <div id="containerTransPayment"></div>
                            <span style="color: red;width: 100%;text-align: center;float: left;" id="msgTransPayment"><b>Không có dữ liệu</b></span>
                        </div> <!-- End #tab1 -->
                    </div> <!-- End .content-box-content -->
                </div> <!-- End .content-box -->
                <div class="clear"></div>
                <%@include file="/admin/include/footer.jsp" %>
            </div>
        </div>
        <script>
            jQuery(document).ready(function () {
                jQuery('.datetimepickerFrom').datetimepicker({
                    format: 'd/m/Y',
                    timepicker: false
                });
                /*jQuery('.datetimepickerFrom').datetimepicker({
                 format:'Y/m/d',
                 onShow:function(){
                 this.setOptions({
                 maxDate:jQuery('.datetimepickerTo').val()?jQuery('.datetimepickerTo').val():false
                 })
                 },
                 timepicker:false
                 });
                 jQuery('.datetimepickerTo').datetimepicker({
                 format:'Y/m/d',
                 onShow:function(){
                 this.setOptions({
                 minDate:jQuery('.datetimepickerFrom').val()?jQuery('.datetimepickerFrom').val():false
                 })
                 },
                 timepicker:false
                 });*/

                $("#mtBoxHeader").click(function () {
                    $("#mtBoxContent").slideToggle(400, function () {
                        $("#mtBoxHeader span i").toggleClass('fa-caret-down').toggleClass('fa-caret-up');
                    });
                });
                $("#moBoxHeader").click(function () {
                    $("#moBoxContent").slideToggle(400, function () {
                        $("#moBoxHeader span i").toggleClass('fa-caret-down').toggleClass('fa-caret-up');
                    });
                });
                $("#transPaymentBoxHeader").click(function () {
                    $("#transPaymentBoxContent").slideToggle(400, function () {
                        $("#transPaymentBoxHeader span i").toggleClass('fa-caret-down').toggleClass('fa-caret-up');
                    });
                });
                $("#cdrBoxHeader").click(function () {
                    $("#cdrBoxContent").slideToggle(400, function () {
                        $("#cdrBoxHeader span i").toggleClass('fa-caret-down').toggleClass('fa-caret-up');
                    });
                });
                var currentDate = getCurrtentDate();
                $("#MTReport").val(currentDate);
                $("#MOReport").val(currentDate);
                $("#transReport").val(currentDate);
                $("#cdrReport").val(currentDate);
                //showChartCDR('line');
            });

            function chooseTypeReportCDR(e) {
                var val = $(e).val();
                if (val === "1") {
                    $("#cdrReport").removeClass("hidden");
                    $("#selectWeekOfYear").addClass("hidden");
                    $("#selectMonth").addClass("hidden");
                    $("#selectQuater").addClass("hidden");
                } else if (val === "2") {
                    $("#cdrReport").addClass("hidden");
                    $("#selectWeekOfYear").removeClass("hidden");
                    $("#selectMonth").addClass("hidden");
                    $("#selectQuater").addClass("hidden");
                } else if (val === "3") {
                    $("#cdrReport").addClass("hidden");
                    $("#selectWeekOfYear").addClass("hidden");
                    $("#selectMonth").removeClass("hidden");
                    $("#selectQuater").addClass("hidden");
                } else if (val === "4") {
                    $("#cdrReport").addClass("hidden");
                    $("#selectWeekOfYear").addClass("hidden");
                    $("#selectMonth").addClass("hidden");
                    $("#selectQuater").removeClass("hidden");
                } else {
                    $("#cdrReport").addClass("hidden");
                    $("#selectWeekOfYear").addClass("hidden");
                    $("#selectMonth").addClass("hidden");
                    $("#selectQuater").addClass("hidden");
                }
            }

            function chooseTypeReportMT(e) {
                var val = $(e).val();
                if (val === "1") {
                    $("#MTReport").removeClass("hidden");
                    $("#selectWeekOfYearMT").addClass("hidden");
                    $("#selectMonthMT").addClass("hidden");
                    $("#selectQuaterMT").addClass("hidden");
                } else if (val === "2") {
                    $("#MTReport").addClass("hidden");
                    $("#selectWeekOfYearMT").removeClass("hidden");
                    $("#selectMonthMT").addClass("hidden");
                    $("#selectQuaterMT").addClass("hidden");
                } else if (val === "3") {
                    $("#MTReport").addClass("hidden");
                    $("#selectWeekOfYearMT").addClass("hidden");
                    $("#selectMonthMT").removeClass("hidden");
                    $("#selectQuaterMT").addClass("hidden");
                } else if (val === "4") {
                    $("#MTReport").addClass("hidden");
                    $("#selectWeekOfYearMT").addClass("hidden");
                    $("#selectMonthMT").addClass("hidden");
                    $("#selectQuaterMT").removeClass("hidden");
                } else {
                    $("#MTReport").addClass("hidden");
                    $("#selectWeekOfYearMT").addClass("hidden");
                    $("#selectMonthMT").addClass("hidden");
                    $("#selectQuaterMT").addClass("hidden");
                }
            }

            function chooseTypeReportMO(e) {
                var val = $(e).val();
                if (val === "1") {
                    $("#MOReport").removeClass("hidden");
                    $("#selectWeekOfYearMO").addClass("hidden");
                    $("#selectMonthMO").addClass("hidden");
                    $("#selectQuaterMO").addClass("hidden");
                } else if (val === "2") {
                    $("#MOReport").addClass("hidden");
                    $("#selectWeekOfYearMO").removeClass("hidden");
                    $("#selectMonthMO").addClass("hidden");
                    $("#selectQuaterMO").addClass("hidden");
                } else if (val === "3") {
                    $("#MOReport").addClass("hidden");
                    $("#selectWeekOfYearMO").addClass("hidden");
                    $("#selectMonthMO").removeClass("hidden");
                    $("#selectQuaterMO").addClass("hidden");
                } else if (val === "4") {
                    $("#MOReport").addClass("hidden");
                    $("#selectWeekOfYearMO").addClass("hidden");
                    $("#selectMonthMO").addClass("hidden");
                    $("#selectQuaterMO").removeClass("hidden");
                } else {
                    $("#MOReport").addClass("hidden");
                    $("#selectWeekOfYearMO").addClass("hidden");
                    $("#selectMonthMO").addClass("hidden");
                    $("#selectQuaterMO").addClass("hidden");
                }
            }

            function chooseTypeReportTrans(e) {
                var val = $(e).val();
                if (val === "1") {
                    $("#transReport").removeClass("hidden");
                    $("#selectWeekOfYearTrans").addClass("hidden");
                    $("#selectMonthTrans").addClass("hidden");
                    $("#selectQuaterTrans").addClass("hidden");
                } else if (val === "2") {
                    $("#transReport").addClass("hidden");
                    $("#selectWeekOfYearTrans").removeClass("hidden");
                    $("#selectMonthTrans").addClass("hidden");
                    $("#selectQuaterTrans").addClass("hidden");
                } else if (val === "3") {
                    $("#transReport").addClass("hidden");
                    $("#selectWeekOfYearTrans").addClass("hidden");
                    $("#selectMonthTrans").removeClass("hidden");
                    $("#selectQuaterTrans").addClass("hidden");
                } else if (val === "4") {
                    $("#transReport").addClass("hidden");
                    $("#selectWeekOfYearTrans").addClass("hidden");
                    $("#selectMonthTrans").addClass("hidden");
                    $("#selectQuaterTrans").removeClass("hidden");
                } else {
                    $("#transReport").addClass("hidden");
                    $("#selectWeekOfYearTrans").addClass("hidden");
                    $("#selectMonthTrans").addClass("hidden");
                    $("#selectQuaterTrans").addClass("hidden");
                }
            }

            function changeChartType(e, type) {
                if ($(e).val() === null || $(e).val() === "" || typeof $(e).val() === "undefined")
                    return false;
                switch (type) {
                    case "MT" :
                        showChartMT($(e).val());
                        break;
                    case "MO" :
                        showChartMO($(e).val());
                        break;
                    case "TRANS" :
                        showChartTRANS($(e).val());
                        break;
                    case "CDR" :
                        showChartCDR($(e).val());
                        break;
                    default :
                        break;
                }
            }

            function getReport(e, type) {
                var chartType = $(e).parent().find(".changeChartType").val();
                switch (type) {
                    case "MT" :
                        showChartMT(chartType);
                        break;
                    case "MO" :
                        showChartMO(chartType);
                        break;
                    case "TRANS" :
                        showChartTRANS(chartType);
                        break;
                    case "CDR" :
                        showChartCDR(chartType);
                        break;
                    default :
                        break;
                }
            }

            function showChartMT(type) {
                var selectTypeReport = $("#selectTypeReportMT").val();
                var date = $("#MTReport").val();
                var selectWeekOfYear = $("#selectWeekOfYearMT").val();
                var selectMonth = $("#selectMonthMT").val();
                var selectQuater = $("#selectQuaterMT").val();
                var dateFrom = "";
                var dateTo = "";
                if (selectTypeReport === "1") { //day
                    if (date === null || date === "" || typeof date === "undefined") {
                        console.log("date is undefined");
                        return false;
                    } else {
                        dateFrom = date;
                        dateTo = date;
                    }
                } else if (selectTypeReport === "2") { //week
                    if (selectWeekOfYear === null || selectWeekOfYear === "" || typeof selectWeekOfYear === "undefined") {
                        console.log("selectWeekOfYear is undefined");
                        return false;
                    } else {
                        dateFrom = selectWeekOfYear.split("-")[0];
                        dateTo = selectWeekOfYear.split("-")[1];
                    }
                } else if (selectTypeReport === "3") { //month
                    if (selectMonth === null || selectMonth === "" || typeof selectMonth === "undefined") {
                        console.log("selectMonth is undefined");
                        return false;
                    } else {
                        dateFrom = selectMonth.split("-")[0];
                        dateTo = selectMonth.split("-")[1];
                    }
                } else if (selectTypeReport === "4") {// quater
                    if (selectQuater === null || selectQuater === "" || typeof selectQuater === "undefined") {
                        console.log("selectQuater is undefined");
                        return false;
                    } else {
                        dateFrom = selectQuater.split("-")[0];
                        dateTo = selectQuater.split("-")[1];
                    }
                }
                $(".spinner-mt").removeClass("hidden");
                $.ajax({
                    url: "<%=request.getContextPath()%>/cms/splus/report/get-data-report.jsp",
                    data: {
                        dateFrom: dateFrom,
                        dateTo: dateTo,
                        type: "MT"
                    },
                    dataType: "JSON",
                    type: "POST",
                    success: function (response) {
                        $(".spinner-mt").addClass("hidden");
                        if (response.length > 0) {
                            $("#msgMT").addClass("hidden");
                            $("#containerMT").removeClass("hidden");
                            var data = [];
                            var catgories = [];
                            console.log(JSON.stringify(response));
                            $.each(response[0], function (k, v) {
                                console.log(k);
                                var value = [];
                                if (v.length > 0) {
                                    for (var i = 0; i < v.length; i++) {
                                        $.each(v[i], function (key, val) {
                                            catgories.push(key);
                                            value.push(val);
                                        });
                                    }
                                }
                                var obj = {};
                                obj['name'] = k;
                                obj['data'] = value;
                                data.push(obj);
                            });
                            var title = "";
                            if (dateFrom === dateTo) {
                                title = 'Dữ liệu gửi MT trong ngày ' + dateFrom;
                            } else {
                                title = 'Dữ liệu gửi MT từ ngày ' + catgories[0] + ' đến ngày ' + catgories[catgories.length - 1];
                            }
                            Highcharts.chart('containerMT', {
                                chart: {
                                    type: type
                                },
                                title: {
                                    text: title
                                },
                                xAxis: {
                                    categories: catgories
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
                                series: data
                            });
                        } else {
                            $("#msgMT").removeClass("hidden");
                            $("#containerMT").addClass("hidden");
                        }
                    }
                });
            }

            function showChartMO(type) {
                var selectTypeReport = $("#selectTypeReportMO").val();
                var date = $("#MOReport").val();
                var selectWeekOfYear = $("#selectWeekOfYearMO").val();
                var selectMonth = $("#selectMonthMO").val();
                var selectQuater = $("#selectQuaterMO").val();
                var dateFrom = "";
                var dateTo = "";
                if (selectTypeReport === "1") { //day
                    if (date === null || date === "" || typeof date === "undefined") {
                        console.log("date is undefined");
                        return false;
                    } else {
                        dateFrom = date;
                        dateTo = date;
                    }
                } else if (selectTypeReport === "2") { //week
                    if (selectWeekOfYear === null || selectWeekOfYear === "" || typeof selectWeekOfYear === "undefined") {
                        console.log("selectWeekOfYear is undefined");
                        return false;
                    } else {
                        dateFrom = selectWeekOfYear.split("-")[0];
                        dateTo = selectWeekOfYear.split("-")[1];
                    }
                } else if (selectTypeReport === "3") { //month
                    if (selectMonth === null || selectMonth === "" || typeof selectMonth === "undefined") {
                        console.log("selectMonth is undefined");
                        return false;
                    } else {
                        dateFrom = selectMonth.split("-")[0];
                        dateTo = selectMonth.split("-")[1];
                    }
                } else if (selectTypeReport === "4") {// quater
                    if (selectQuater === null || selectQuater === "" || typeof selectQuater === "undefined") {
                        console.log("selectQuater is undefined");
                        return false;
                    } else {
                        dateFrom = selectQuater.split("-")[0];
                        dateTo = selectQuater.split("-")[1];
                    }
                }
                $(".spinner-mo").removeClass("hidden");
                $.ajax({
                    url: "<%=request.getContextPath()%>/cms/splus/report/get-data-report.jsp",
                    data: {
                        dateFrom: dateFrom,
                        dateTo: dateTo,
                        type: "MO"
                    },
                    dataType: "JSON",
                    type: "POST",
                    success: function (response) {
                        $(".spinner-mo").addClass("hidden");
                        if (response.length > 0) {
                            $("#msgMO").addClass("hidden");
                            $("#containerMO").removeClass("hidden");
                            var data = [];
                            var catgories = [];
                            var value = [];
                            $.each(response[0], function (k, v) {
                                if (v.length > 0) {
                                    for (var i = 0; i < v.length; i++) {
                                        $.each(v[i], function (key, val) {
                                            catgories.push(key);
                                            value.push(val);
                                        });
                                    }
                                }
                                var obj = {};
                                obj['name'] = k;
                                obj['data'] = value;
                                data.push(obj);
                            });
                            var title = "";
                            if (dateFrom === dateTo) {
                                title = 'Dữ liệu gửi MO trong ngày ' + dateFrom;
                            } else {
                                title = 'Dữ liệu gửi MO từ ngày ' + catgories[0] + ' đến ngày ' + catgories[catgories.length - 1];
                            }
                            Highcharts.chart('containerMO', {
                                chart: {
                                    type: type
                                },
                                title: {
                                    text: title
                                },
                                xAxis: {
                                    categories: catgories
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
                                series: data
                            });
                        } else {
                            $("#msgMO").removeClass("hidden");
                            $("#containerMO").addClass("hidden");
                        }
                    }
                });
            }

            function showChartTRANS(type) {
                var selectTypeReport = $("#selectTypeReportTrans").val();
                var date = $("#transReport").val();
                var selectWeekOfYear = $("#selectWeekOfYearTrans").val();
                var selectMonth = $("#selectMonthTrans").val();
                var selectQuater = $("#selectQuaterTrans").val();
                var dataType = $("#dataType").val();
                var dateFrom = "";
                var dateTo = "";
                if (selectTypeReport === "1") { //day
                    if (date === null || date === "" || typeof date === "undefined") {
                        console.log("date is undefined");
                        return false;
                    } else {
                        dateFrom = date;
                        dateTo = date;
                    }
                } else if (selectTypeReport === "2") { //week
                    if (selectWeekOfYear === null || selectWeekOfYear === "" || typeof selectWeekOfYear === "undefined") {
                        console.log("selectWeekOfYear is undefined");
                        return false;
                    } else {
                        dateFrom = selectWeekOfYear.split("-")[0];
                        dateTo = selectWeekOfYear.split("-")[1];
                    }
                } else if (selectTypeReport === "3") { //month
                    if (selectMonth === null || selectMonth === "" || typeof selectMonth === "undefined") {
                        console.log("selectMonth is undefined");
                        return false;
                    } else {
                        dateFrom = selectMonth.split("-")[0];
                        dateTo = selectMonth.split("-")[1];
                    }
                } else if (selectTypeReport === "4") {// quater
                    if (selectQuater === null || selectQuater === "" || typeof selectQuater === "undefined") {
                        console.log("selectQuater is undefined");
                        return false;
                    } else {
                        dateFrom = selectQuater.split("-")[0];
                        dateTo = selectQuater.split("-")[1];
                    }
                }
                $(".spinner-trans").removeClass("hidden");
                $.ajax({
                    url: "<%=request.getContextPath()%>/cms/splus/report/get-data-report.jsp",
                    data: {
                        dateFrom: dateFrom,
                        dateTo: dateTo,
                        dataType: dataType,
                        type: "TRANS"
                    },
                    dataType: "JSON",
                    type: "POST",
                    success: function (response) {
                        $(".spinner-trans").addClass("hidden");
                        console.log("response.length >>" + response.length);
                        if (response.length > 0) {
                            $("#msgTransPayment").addClass("hidden");
                            $("#containerTransPayment").removeClass("hidden");
                            var data = [];
                            var catgories = [];

                            $.each(response[0], function (k, v) {
                                var value = [];
                                if (v.length > 0) {
                                    for (var i = 0; i < v.length; i++) {
                                        $.each(v[i], function (key, val) {
                                            catgories.push(key);
                                            value.push(val);
                                        });
                                    }
                                }
                                var obj = {};
                                obj['name'] = k;
                                obj['data'] = value;
                                data.push(obj);
                            });
                            var title = "";
                            if (dateFrom === dateTo) {
                                title = 'Dữ liệu TOPUP và CHARGE trong ngày ' + dateFrom;
                            } else {
                                title = 'Dữ liệu TOPUP và CHARGE từ ngày ' + catgories[0] + ' đến ngày ' + catgories[catgories.length - 1];
                            }
                            Highcharts.chart('containerTransPayment', {
                                chart: {
                                    type: type
                                },
                                title: {
                                    text: title
                                },
                                xAxis: {
                                    categories: catgories
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
                                series: data
                            });
                        } else {
                            $("#msgTransPayment").removeClass("hidden");
                            $("#containerTransPayment").addClass("hidden");
                        }
                    }
                });
            }

            function showChartCDR(type) {
                var selectTypeReport = $("#selectTypeReport").val();
                var date = $("#cdrReport").val();
                var selectWeekOfYear = $("#selectWeekOfYear").val();
                var selectMonth = $("#selectMonth").val();
                var selectQuater = $("#selectQuater").val();
                var dateFrom = "";
                var dateTo = "";
                if (selectTypeReport === "1") { //day
                    if (date === null || date === "" || typeof date === "undefined") {
                        console.log("date is undefined");
                        return false;
                    } else {
                        dateFrom = date;
                        dateTo = date;
                    }
                } else if (selectTypeReport === "2") { //week
                    if (selectWeekOfYear === null || selectWeekOfYear === "" || typeof selectWeekOfYear === "undefined") {
                        console.log("selectWeekOfYear is undefined");
                        return false;
                    } else {
                        dateFrom = selectWeekOfYear.split("-")[0];
                        dateTo = selectWeekOfYear.split("-")[1];
                    }
                } else if (selectTypeReport === "3") { //month
                    if (selectMonth === null || selectMonth === "" || typeof selectMonth === "undefined") {
                        console.log("selectMonth is undefined");
                        return false;
                    } else {
                        dateFrom = selectMonth.split("-")[0];
                        dateTo = selectMonth.split("-")[1];
                    }
                } else if (selectTypeReport === "4") {// quater
                    if (selectQuater === null || selectQuater === "" || typeof selectQuater === "undefined") {
                        console.log("selectQuater is undefined");
                        return false;
                    } else {
                        dateFrom = selectQuater.split("-")[0];
                        dateTo = selectQuater.split("-")[1];
                    }
                }
                $(".spinner-cdr").removeClass("hidden");
                $.ajax({
                    url: "<%=request.getContextPath()%>/cms/splus/report/get-data-report.jsp",
                    data: {
                        dateFrom: dateFrom,
                        dateTo: dateTo,
                        type: "CDR"
                    },
                    dataType: "JSON",
                    type: "POST",
                    success: function (response) {
                        $(".spinner-cdr").addClass("hidden");
                        if (response.length > 0) {
                            $("#msgCDR").addClass("hidden");
                            $("#containerCDR").removeClass("hidden");
                            var data = [];
                            var catgories = [];
                            var value = [];
                            $.each(response[0], function (k, v) {
                                if (v.length > 0) {
                                    for (var i = 0; i < v.length; i++) {
                                        $.each(v[i], function (key, val) {
                                            catgories.push(key);
                                            value.push(val);
                                        });
                                    }
                                }
                                var obj = {};
                                obj['name'] = k;
                                obj['data'] = value;
                                data.push(obj);
                            });
                            var title = "";
                            if (dateFrom === dateTo) {
                                title = 'Dữ liệu thống kê CDR hết tiền với TYPE = 1 trong ngày ' + dateFrom;
                            } else {
                                title = 'Dữ liệu thống kê CDR hết tiền với TYPE = 1 từ ngày ' + catgories[0] + ' đến ngày ' + catgories[catgories.length - 1];
                            }
                            Highcharts.chart('containerCDR', {
                                chart: {
                                    type: type
                                },
                                title: {
                                    text: title
                                },
                                xAxis: {
                                    categories: catgories
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
                                series: data

                            });
                        } else {
                            $("#msgCDR").removeClass("hidden");
                            $("#containerCDR").addClass("hidden");
                        }
                    }
                });
            }

            function getCurrtentDate() {
                var today = new Date();
                var dd = today.getDate();
                var mm = today.getMonth() + 1; //January is 0!
                var yyyy = today.getFullYear();
                if (dd < 10) {
                    dd = '0' + dd;
                }
                if (mm < 10) {
                    mm = '0' + mm;
                }
        //        return yyyy+'/'+mm+'/'+dd;
                return dd + '/' + mm + '/' + yyyy;
            }

        </script>
    </body>
</html>
