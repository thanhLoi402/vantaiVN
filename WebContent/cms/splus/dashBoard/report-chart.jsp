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
        <script src="https://www.amcharts.com/lib/4/core.js"></script>
        <script src="https://www.amcharts.com/lib/4/charts.js"></script>
        <script src="https://www.amcharts.com/lib/4/themes/animated.js"></script>

        <%
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
                <div class="clear"></div>
                <%@include file="/admin/include/footer.jsp" %>
            </div>
        </div>
        <script>
            jQuery(document).ready(function () {

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
                                title = 'Dữ liệu thống kê CDR trong ngày ' + dateFrom;
                            } else {
                                title = 'Dữ liệu thống kê CDR từ ngày ' + catgories[0] + ' đến ngày ' + catgories[catgories.length - 1];
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
