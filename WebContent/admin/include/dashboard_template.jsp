<%@page import="com.google.gson.JsonArray" %>
<%@page import="tdt.db.viettel.splus.report.ReportDailyStandard" %>
<%@page import="tdt.db.viettel.splus.report.ReportDashboardDAO" %>
<%@ page import="java.text.DecimalFormat" %>
<%@ page import="java.text.Format" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Calendar" %>
<%@ page language="java" pageEncoding="utf-8" %>
<style>
    li{
        background: none !important;
    }
</style>
<script src="https://www.amcharts.com/lib/4/themes/animated.js"></script>
<script>
    function blockUI(element) {
        $('#'+element).css("filter", "blur(2px)");
        $('#'+element).block({
            message: '<div class="lds-dual-ring"></div>',
            css: {backgroundColor: 'none' , border : 'none'} ,
            overlayCSS: { backgroundColor: 'rgb(241, 241, 241,1)' }
        });
    }

    function unBlockUI(element) {
        $('#'+element).unblock();
        $('#'+element).css("filter", "none");
    }

    function formatCurrency(n, separate = "."){
        var s = n.toString();
        var regex = /\B(?=(\d{3})+(?!\d))/g;
        var ret = s.replace(regex, separate);
        return ret;
    }

    function refreshPie(element) {
        blockUI(element);
        $.get("/callProcedures?type=process", function () {
            getDataProcess();
            unBlockUI(element)
        });

    }

    function refreshDetail(element) {
        blockUI(element);
        $.get("/callProcedures?type=detail&element="+element, function () {
            getDataDetail(element);
            unBlockUI(element);
        });
    }


    function refreshDashboard(element) {
        blockUI(element);
        $.get("/callProcedures?type=dashboard", function () {
            getDataDashboard(element);
            unBlockUI(element);
        });
    }
</script>

<%
    Format dateFormat2 = new SimpleDateFormat("dd/MM/yyyy");
%>
<style>
    .panel-body li {
        overflow: hidden;
        text-overflow: ellipsis;
    }
</style>
<div id="main-content" class="dashboard-template">
    <!-- Main Content Section with everything -->

    <!-- Page Head -->

    <div class="clear"></div>
    <!-- End .clear -->

    <div class="row dashboard-line1 " style="margin-top: 20px">
        <div class="col-xs-5ths">
            <div class="card pull-up" id="cdr" style="">
                <div class="card-header">
                    <h4 class="card-title float-left">
                        <span class="badge badge-pill badge-info " style="background-color: #28afd0">CDR</span>
                        <i class="fas fa-sync-alt spin" onclick="refreshDetail('cdr')"></i>
                    </h4>
                </div>
                <div class="card-content">
                    <div class="card-body">
                        <div class="text-center">
                            <p class="cdr-color" data-toggle="tooltip" title="CDR tại thời điểm tra cứu / CDR ngày hôm trước cùng thời điểm !">
                                <span id="cdr1"></span> /
                                <span id="cdr2"></span>
                            </p>
                            <ul>
                                <li>
                                    <p style="font-size: 11px"><i>File CDR nhận gần nhất - Thời gian nhận file</i></p>
                                    <marquee scrollamount="7" onmouseover="this.stop();" onmouseout="this.start();"
                                             direction="">
                                        <strong><span id="cdr3"></span>
                                        </strong> <span class="badge badge-pill" id="cdrLastTimeRec">không có dữ liệu</span>
                                    </marquee>


                                </li>
                                <li>
                                    <p style="font-size: 11px"><i>File CDR đã xử lý gần nhất - Thời gian xử lý file</i>
                                    </p>
                                    <marquee scrollamount="7" onmouseover="this.stop();" onmouseout="this.start();"
                                             direction="">
                                        <strong><span id="cdr4"></span>
                                        </strong> <span class="badge badge-pill" id="cdrLastTimePro">không có dữ liệu</span>
                                    </marquee>
                                </li>
                            </ul>

                        </div>
                    </div>

                </div>
                <div class="card-footer border-top-grey">
                    <span class="float-left gen-date" id="cdr-gendate"></span>
                </div>
            </div>
        </div>
        <div class="col-xs-5ths">
            <div class="card pull-up" id="mtInvite" style="">
                <div class="card-header">

                    <h4 class="card-title float-left">
                        <span class="badge badge-pill badge-info " style="background-color: #0FB365">MT INVITE</span>
                        <i class="fas fa-sync-alt spin" onclick="refreshDetail('mtInvite')"></i>
                    </h4>
                </div>
                <div class="card-content">
                    <div class="card-body">
                        <div class="text-center">
                            <p class="mt-color" data-toggle="tooltip" title="MT tại thời điểm tra cứu / MT ngày hôm trước cùng thời điểm !"><span id="mtInvite1"></span> /
                                <span id="mtInvite2"></span>
                            </p>
                            <ul>
                                <li title="Tên ID invite gửi gần nhất - Thời gian gửi MT">
                                    <p style="font-size: 11px"><i>Tên ID invite gửi gần nhất - Thời gian gửi MT</i></p>
                                    <marquee scrollamount="7" onmouseover="this.stop();" onmouseout="this.start();"
                                             direction="">
                                        <strong><span id="mtInvite3"></span>
                                        </strong> <span class="badge badge-pill" id="mtLastTime">không có dữ liệu</span>
                                    </marquee>
                                </li>
                                <li title="Tổng MT queue (tại thời điểm tra cứu)">
                                    <p style="font-size: 11px"><i>Tổng MT queue (tại thời điểm tra cứu)</i></p>
                                    <strong><span id="mtInvite4"></span>
                                    </strong> <span class="badge badge-pill">Tổng MT queue</span>
                                </li>
                            </ul>
                        </div>
                    </div>

                </div>
                <div class="card-footer border-top-grey">
                    <span class="float-left gen-date" id="mtInvite-gendate"></span>
                </div>
            </div>
        </div>
        <div class="col-xs-5ths">
            <div class="card pull-up" id="mo" style="">
                <div class="card-header">
                    <h4 class="card-title float-left">
                        <span class="badge badge-pill badge-info " style="background-color: #8E24AA">MO</span>
                        <i class="fas fa-sync-alt spin" onclick="refreshDetail('mo')"></i>
                    </h4>
                </div>
                <div class="card-content">
                    <div class="card-body">
                        <div class="text-center">
                            <p class="mo-color" data-toggle="tooltip" title="MO tại thời điểm tra cứu / MO ngày hôm trước cùng thời điểm !"><span id="mo1"></span> /<br>
                                <span id="mo2"></span>
                            </p>
                            <ul>
                                <li title="Tên request ID nhận gần nhất - Thời gian nhận MO">
                                    <p style="font-size: 11px"><i>Tên request ID nhận gần nhất - Thời gian nhận MO</i>
                                    </p>
                                    <marquee scrollamount="7" onmouseover="this.stop();" onmouseout="this.start();"
                                             direction="">
                                        <strong><span id="mo3"></span>
                                        </strong> <span class="badge badge-pill" id="moLastTimeRec">không có dữ liệu</span>
                                    </marquee>
                                </li>
                                <li title="Tên request ID xử lý gần nhất - Thời gian xử lý MO">
                                    <p style="font-size: 11px"><i>Tên request ID xử lý gần nhất - Thời gian xử lý MO</i>
                                    </p>
                                    <marquee scrollamount="7" onmouseover="this.stop();" onmouseout="this.start();"
                                             direction="">
                                        <strong><span id="mo4"></span>
                                        </strong> <span class="badge badge-pill" id="moLastTimePro">không có dữ liệu</span>
                                    </marquee>
                                </li>
                            </ul>
                        </div>
                    </div>
                </div>
                <div class="card-footer border-top-grey">
                    <span class="float-left gen-date" id="mo-gendate"></span>
                </div>
            </div>
        </div>
        <div class="col-xs-5ths">
            <div class="card pull-up" id="topup" >
                <div class="card-header">
                    <h4 class="card-title float-left">
                        <span class="badge badge-pill badge-info " style="background-color: #546E7A">TOP UP</span>
                        <i class="fas fa-sync-alt spin" onclick="refreshDetail('topup')"></i>
                    </h4>
                </div>
                <div class="card-content" style="min-height: 203px">
                    <div class="card-body">
                        <div class="text-center">
                            <p class="topup-color" data-toggle="tooltip" title="TOPUP tại thời điểm tra cứu / TOPUP ngày hôm trước cùng thời điểm !"><span id="topup1"></span>
                                /<br>
                                <span id="topup2"></span>
                            </p>
                            <ul>
                                <li title="MPTransID đã top up mới nhất - Thời gian thực hiện top up mới nhất">
                                    <p style="font-size: 11px"><i>MPTransID đã top up mới nhất - Thời gian thực hiện top
                                        up mới nhất</i></p>
                                    <marquee scrollamount="7" onmouseover="this.stop();" onmouseout="this.start();"
                                             direction="">
                                        <strong><span id="topup3"></span>
                                        </strong> <span class="badge badge-pill" id="topupLastTimePro">không có dữ liệu</span>
                                    </marquee>
                                </li>
                            </ul>
                        </div>
                    </div>
                </div>
                <div class="card-footer border-top-grey">
                    <span class="float-left gen-date" id="topup-gendate"></span>
                </div>
            </div>
        </div>
        <div class="col-xs-5ths">
            <div class="card pull-up" id="charge" style="">
                <div class="card-header">
                    <h4 class="card-title float-left">
                        <span class="badge badge-pill badge-info " style="background-color: #FF6F00">CHARGE</span>
                        <i class="fas fa-sync-alt spin" onclick="refreshDetail('charge')"></i>
                    </h4>
                </div>
                <div class="card-content">
                    <div class="card-body">
                        <div class="text-center">
                            <p class="charge-color" data-toggle="tooltip" title="CHARGE tại thời điểm tra cứu / TOPUP ngày hôm trước cùng thời điểm !" ><span id="charge1"></span>
                                /<br>
                                <span id="charge2"></span>
                            </p>
                            <ul>
                                <li title="File CDR top up nhận gần nhất - Thời gian nhận file">
                                    <p style="font-size: 11px"><i>File CDR top up nhận gần nhất - Thời gian nhận
                                        file</i></p>
                                    <marquee scrollamount="7" onmouseover="this.stop();" onmouseout="this.start();"
                                             direction="">
                                        <strong><span id="charge3"></span>
                                        </strong>   <span class="badge badge-pill" id="chargeLastTimeRec">không có dữ liệu</span>
                                    </marquee>
                                </li>
                                <li title="File CDR top up đã xử lý gần nhất - Thời gian xử lý file">
                                    <p style="font-size: 11px"><i>File CDR top up đã xử lý gần nhất - Thời gian xử lý
                                        file</i></p>
                                    <marquee scrollamount="7" onmouseover="this.stop();" onmouseout="this.start();"
                                             direction="">
                                        <strong><span id="charge4"></span>
                                        </strong>  <span class="badge badge-pill" id="chargeLastTimePro">không có dữ liệu</span>
                                    </marquee>
                                </li>
                            </ul>
                        </div>
                    </div>
                </div>
                <div class="card-footer border-top-grey">
                    <span class="float-left gen-date" id="charge-gendate"></span>
                </div>
            </div>
        </div>
    </div>

    <div class="row" style="margin-top: 20px;">
        <div class="col-md-9">
            <div class="card pull-up" id="middle">
                <div class="card-content">

                    <div class="card-body">
                        <i class="fas fa-sync-alt spin" onclick="refreshDashboard('middle')"></i>
                        <div class="row">
                            <div class="col-md-3 chart-col-4"
                                 style="font-weight: bolder; font-size: 1.5rem; color: #168DEE">
                                <p class="text-center">(TỔNG ỨNG/ TỔNG HOÀN ỨNG)</p>
                                <p class="text-center" style="font-weight: bold; font-size: 3rem; color: #168DEE">
                                    <span id="tongung" class="my-numbers">0</span>
                                    <br>/<br>
                                    <span id="tonghoanung" class="my-numbers">0</span>
                                </p>
                            </div>
                            <div class="col-md-9 chart-col-4">
                                <div id="chartdiv1"></div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="card-footer border-top-grey">
                    <span class="float-left gen-date" id="middle-gendate"></span>
                </div>
            </div>

            <div class="card pull-up" id="cardPie" style="margin-top: 20px">
                <div class="card-header">
                    <h4 class="card-title float-left">
                        <span style="font-weight: bolder; font-size: 1.5rem; color: #313131">THỜI GIAN XỬ LÝ CÁC TIẾN TRÌNH</span>
                        <i class="fas fa-sync-alt spin" onclick="refreshPie('cardPie')"></i>

                    </h4>

                </div>
                <div class="card-content" >
                    <div class="card-body">
                        <div class="row">
                            <div class="col-md-9">
                                <div class="row">
                                    <div class="col-md-4"></div>
                                    <div class="col-md-4">
                                        <p class="data-text-month">
                                            Ngày <%=dateFormat2.format(Calendar.getInstance().getTime())%>
                                        </p>
                                    </div>
                                    <div class="col-md-4">
                                        <%
                                            Calendar cal1 = Calendar.getInstance();
                                            cal1.add(Calendar.DAY_OF_MONTH, -1);
                                        %>
                                        <p class="data-text-month">Ngày <%=dateFormat2.format(cal1.getTime())%>
                                        </p>
                                    </div>
                                </div>
                                <div class="row" style="height: 200px;">
                                    <div class="col-md-4">
                                        <div style="display: flex;justify-content: center;align-items: center;height: 100%">
                                            <%--<div style="display: table-cell; vertical-align: middle; ">--%>
                                                <div class="data-text-month">
                                                    Thời gian nhận CDR - Tạo MT invite
                                                </div>
                                            <%--</div>--%>
                                        </div>
                                    </div>
                                    <div class="col-md-4">
                                        <div id="chartpie1" style="font-size: 1.3rem;font-weight: 500;"></div>
                                    </div>
                                    <div class="col-md-4">
                                        <div id="chartpie3" style="font-size: 1.3rem;font-weight: 500;"></div>
                                    </div>
                                </div>
                                <%--<div class="row" style="height: 200px;">--%>
                                    <%--<div class="col-md-4">--%>
                                        <%--<div style="display: flex;justify-content: center;align-items: center;height: 100%">--%>
                                            <%--&lt;%&ndash;<div style="display: table-cell; vertical-align: middle; ">&ndash;%&gt;--%>
                                            <%--<div class="data-text-month">--%>
                                                <%--Thời gian tạo MT invite - Gửi thành công--%>
                                            <%--</div>--%>
                                            <%--&lt;%&ndash;</div>&ndash;%&gt;--%>
                                        <%--</div>--%>
                                    <%--</div>--%>
                                    <%--<div class="col-md-4">--%>
                                        <%--<div id="chartpie2" style="font-size: 1.3rem;font-weight: 500;"></div>--%>
                                    <%--</div>--%>
                                    <%--<div class="col-md-4">--%>
                                        <%--<div id="chartpie4" style="font-size: 1.3rem;font-weight: 500;"></div>--%>
                                    <%--</div>--%>
                                <%--</div>--%>
                            </div>
                            <div class="col-md-3" style="display: flex;justify-content: center;align-items: center;padding-top: 50px">
                                <div style=" overflow: hidden;font-size: 1.3rem;font-weight: 500;">
                                    <%--<div style="display: table-cell; vertical-align: middle;">--%>
                                        <div id="legenddiv" class="chartdiv"></div>
                                    <%--</div>--%>
                                </div>
                            </div>
                        </div>

                    </div>
                </div>
                <div class="card-footer border-top-grey">
                    <span class="float-left gen-date" id="cardPie-gendate"></span>
                </div>

            </div>

        </div>
        <div class="col-md-3">
            <div class="card pull-up" >
                <div class="card-header">
                    <ul class="nav nav-pills nav-justified" style="padding-top: 0">
                        <li class="active"><a data-toggle="pill" href="#tab1">Số lượt</a></li>
                        <li><a data-toggle="pill" href="#tab2">Số tiền</a></li>
                        <li><a data-toggle="pill" href="#tab3">Số thuê bao</a></li>
                    </ul>
                </div>
                <div class="card-content">
                    <div class="tab-content">
                        <div class="dashboard-line1 tab-pane fade in active" id="tab1">
                            <div class="card no-shadow" id="right11" >
                                <div class="card-header">
                                    <h4 class="card-title float-left">
                                        <span style="font-weight: bolder; font-size: 1.5rem; color: #313131">Số lượt mời ứng kênh SMS </span>

                                    </h4>
                                </div>
                                <div class="card-content">
                                    <div class="card-body text-center">
                                        <p class="text-center"
                                           style="font-weight: bold; font-size: 3rem; color: #168DEE"><span id="right11text">0</span>
                                        </p>
                                    </div>
                                </div>
                            </div>
                            <div class="card no-shadow" id="right12" >
                                <div class="card-header">
                                    <h4 class="card-title float-left">
                                        <span style="font-weight: bolder; font-size: 1.5rem; color: #313131">Số lượt ứng</span>
                                    </h4>
                                </div>
                                <div class="card-content">
                                    <div class="card-body text-center">
                                        <p class="text-center"
                                           style="font-weight: bold; font-size: 3rem; color: #168DEE"><span id="right12text">0</span>
                                        </p>
                                    </div>
                                </div>

                            </div>
                            <div class="card no-shadow" id="right13" >
                                <div class="card-header">
                                    <h4 class="card-title float-left">
                                        <span style="font-weight: bolder; font-size: 1.5rem; color: #313131">Số lượt hoàn ứng thành công</span>
                                    </h4>
                                </div>
                                <div class="card-content">
                                    <div class="card-body text-center">
                                        <p style="font-weight: bold; font-size: 3rem; color: #168DEE"><span id="right13text">0</span>
                                        </p>

                                    </div>
                                </div>

                            </div>
                            <div class="card no-shadow" id="right14" >
                                <div class="card-header">
                                    <h4 class="card-title float-left">
                                        <span style="font-weight: bolder; font-size: 1.5rem; color: #313131">Số lượt hoàn ứng không thành công</span>
                                    </h4>
                                </div>
                                <div class="card-content">
                                    <div class="card-body text-center">
                                        <p style="font-weight: bold; font-size: 3rem; color: #168DEE"><span id="right14text">0</span>
                                        </p>

                                    </div>
                                </div>

                            </div>
                            <div class="card no-shadow" style="padding-bottom: 0">
                                <div class="card-footer border-top-grey">
                                    <span class="float-left gen-date" id="last-update-tab-1"></span>
                                    <i class="fas fa-sync-alt spin" onclick="refreshDashboard('tab1')"></i>
                                </div>
                            </div>

                        </div>
                        <div class="dashboard-line1 tab-pane fade in " id="tab2">
                            <div class="card no-shadow" id="right21" >
                                <div class="card-header">
                                    <h4 class="card-title float-left">
                                        <span style="font-weight: bolder; font-size: 1.5rem; color: #313131">Số tiền đã ứng</span>
                                    </h4>
                                </div>
                                <div class="card-content">
                                    <div class="card-body text-center">
                                        <p class="text-center"
                                           style="font-weight: bold; font-size: 3rem; color: #168DEE"><span id="right21text">0</span>
                                        </p>
                                    </div>
                                </div>
                            </div>
                            <div class="card no-shadow" id="right22" >
                                <div class="card-header">
                                    <h4 class="card-title float-left">
                                        <span style="font-weight: bolder; font-size: 1.5rem; color: #313131">Số tiền hoàn ứng</span>
                                    </h4>
                                </div>
                                <div class="card-content">
                                    <div class="card-body text-center">
                                        <p class="text-center"
                                           style="font-weight: bold; font-size: 3rem; color: #168DEE"><span id="right22text">0</span>
                                        </p>

                                    </div>
                                </div>

                            </div>
                            <div class="card no-shadow" id="right23" >
                                <div class="card-header">
                                    <h4 class="card-title float-left">
                                        <span style="font-weight: bolder; font-size: 1.5rem; color: #313131">Tổng nợ xấu</span>
                                    </h4>
                                </div>
                                <div class="card-content">
                                    <div class="card-body text-center">
                                        <p style="font-weight: bold; font-size: 3rem; color: #168DEE"><span id="right23text">0</span>
                                        </p>
                                        <p style="font-size: 1.1rem;">(Tính đến ngày ngày <%=dateFormat2.format(cal1.getTime())%>)</p>
                                    </div>
                                </div>

                            </div>
                            <div class="card no-shadow" id="right24" >
                                <div class="card-header">
                                    <h4 class="card-title float-left">
                                        <span style="font-weight: bolder; font-size: 1.5rem; color: #313131">Tiền chưa hoàn ứng</span>
                                    </h4>
                                </div>
                                <div class="card-content">
                                    <div class="card-body text-center">
                                        <p style="font-weight: bold; font-size: 3rem; color: #168DEE"><span id="right24text">0</span>
                                        </p>
                                    </div>
                                </div>

                            </div>
                            <div class="card no-shadow" style="padding-bottom: 0">
                                <div class="card-footer border-top-grey">
                                    <span class="float-left gen-date" id="last-update-tab-2"></span>
                                    <i class="fas fa-sync-alt spin" onclick="refreshDashboard('tab2')"></i>
                                </div>
                            </div>
                        </div>
                        <div class="dashboard-line1 tab-pane fade in " id="tab3">
                            <div class="card no-shadow" id="right31" >
                                <div class="card-header">
                                    <h4 class="card-title float-left">
                                        <span style="font-weight: bolder; font-size: 1.5rem; color: #313131">Số thuê bao sử dụng DV</span>
                                    </h4>
                                </div>
                                <div class="card-content">
                                    <div class="card-body text-center">
                                        <p class="text-center"
                                           style="font-weight: bold; font-size: 3rem; color: #168DEE"><span id="right31text">0</span>
                                        </p>
                                        <p style="font-size: 1.1rem;">(Số liệu tổng từ khi chạy dịch vụ)</p>
                                    </div>
                                </div>
                            </div>
                            <div class="card no-shadow" id="right32" >
                                <div class="card-header">
                                    <h4 class="card-title float-left">
                                        <span style="font-weight: bolder; font-size: 1.5rem; color: #313131">Số thuê bao đang nợ dv</span>
                                    </h4>
                                </div>
                                <div class="card-content">
                                    <div class="card-body text-center">
                                        <p class="text-center"
                                           style="font-weight: bold; font-size: 3rem; color: #168DEE"><span id="right32text">0</span>
                                        </p>

                                    </div>
                                </div>

                            </div>
                            <div class="card no-shadow" id="right33" >
                                <div class="card-header">
                                    <h4 class="card-title float-left">
                                        <span style="font-weight: bolder; font-size: 1.5rem; color: #313131">Số thuê bao nợ xấu</span>
                                    </h4>
                                </div>
                                <div class="card-content">
                                    <div class="card-body text-center">
                                        <p style="font-weight: bold; font-size: 3rem; color: #168DEE"><span id="right33text">0</span>
                                        </p>
                                    </div>
                                </div>
                            </div>
                            <div class="card no-shadow" id="right34" >
                                <div class="card-header">
                                    <h4 class="card-title float-left">
                                        <span style="font-weight: bolder; font-size: 1.5rem; color: #313131">Số thuê bao sắp thành nợ xấu</span>
                                    </h4>
                                </div>
                                <div class="card-content">
                                    <div class="card-body text-center">
                                        <p style="font-weight: bold; font-size: 3rem; color: #168DEE"><span id="right34text">0</span>
                                        </p>
                                    </div>
                                </div>
                            </div>
                            <div class="card no-shadow" style="padding-bottom: 0">
                                <div class="card-footer border-top-grey">
                                    <span class="float-left gen-date" id="last-update-tab-3"></span>
                                    <i class="fas fa-sync-alt spin" onclick="refreshDashboard('tab3')"></i>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>


        </div>

    </div>
    <div class="clear"></div>

    <%@include file="footer.jsp" %>

</div>
<script type="text/javascript">


    am4core.useTheme(am4themes_animated);
    moment.locale('vi');

    function initXYChart(array) {

        let data = array;
        let chart = am4core.create("chartdiv1", am4charts.XYChart);

        chart.data = data.reverse();
        chart.legend = new am4charts.Legend();
        chart.legend.position = "right";

        let categoryAxis = chart.yAxes.push(new am4charts.CategoryAxis());
        categoryAxis.dataFields.category = "year";
        categoryAxis.renderer.grid.template.opacity = 0;

        let valueAxis = chart.xAxes.push(new am4charts.ValueAxis());
        valueAxis.min = 0;
        valueAxis.renderer.grid.template.opacity = 0;
        valueAxis.renderer.ticks.template.strokeOpacity = 0.5;
        valueAxis.renderer.ticks.template.stroke = am4core.color("#495C43");
        valueAxis.renderer.ticks.template.length = 10;
        valueAxis.renderer.line.strokeOpacity = 0.5;
        valueAxis.renderer.baseGrid.disabled = true;
        valueAxis.renderer.minGridDistance = 200;

        let series1 = chart.series.push(new am4charts.ColumnSeries());
        series1.dataFields.valueX = "hoanung";
        series1.dataFields.valueY = "percent";
        series1.dataFields.categoryY = "year";
        series1.stacked = true;
        series1.name = "Hoàn ứng";
        series1.columns.template.tooltipText = "{valueX}";

        let labelBullet1 = series1.bullets.push(new am4charts.LabelBullet());
        labelBullet1.locationX = 0.5;
        labelBullet1.label.text = "{valueY}%";
        labelBullet1.label.fill = am4core.color("#fff");

        let series2 = chart.series.push(new am4charts.ColumnSeries());
        series2.dataFields.valueX = "hieu";
        series2.dataFields.valueY = "tienung";
        series2.dataFields.categoryY = "year";
        series2.stacked = true;
        series2.name = "Tiền ứng";
        series2.columns.template.tooltipText = "{valueY}";

        let labelBullet2 = series2.bullets.push(new am4charts.LabelBullet());
        labelBullet2.locationX = 0.5;
        labelBullet2.label.fill = am4core.color("#fff");


    }


    function initPie(id,data) {
        let colorSet = new am4core.ColorSet();
        colorSet.list = ["#1C9DD1","#05D150","#FBC02D","#FF4B52",  ].map(function(color) {
            return new am4core.color(color);
        });

        let chartpie = am4core.create(id, am4charts.PieChart);

        chartpie.data = data;

        let pieSeries = chartpie.series.push(new am4charts.PieSeries());
        pieSeries.dataFields.value = "value";

        pieSeries.dataFields.category = "category";
        pieSeries.slices.template.stroke = am4core.color("#fff");
        pieSeries.slices.template.strokeWidth = 1;
        pieSeries.slices.template.strokeOpacity = 1;
        pieSeries.labels.template.disabled = true;
        pieSeries.ticks.template.disabled = true;
        pieSeries.hiddenState.properties.opacity = 1;
        pieSeries.hiddenState.properties.endAngle = -90;
        pieSeries.hiddenState.properties.startAngle = -90;
        pieSeries.slices.template.tooltipText = "[bold]{category}[/] : {value.percent.formatNumber('#.00')}% ({value})";
        pieSeries.colors = colorSet;
        pieSeries.slices.template.events.on("hit", function (ev) {
            let series = ev.target.dataItem.component;
            series.slices.each(function (item) {
                if (item.isActive && item != ev.target) {
                    item.isActive = false;
                }
            })
        });

        if (id === "chartpie1") {
            chartpie.legend = new am4charts.Legend();
            chartpie.legend.valueLabels.template.text = "      ";
            chartpie.legend.events.disable();
            let legendContainer = am4core.create("legenddiv", am4core.Container);
            legendContainer.width = am4core.percent(100);
            legendContainer.height = am4core.percent(100);
            chartpie.legend.parent = legendContainer;


            chartpie.events.on("datavalidated", resizeLegend);
            chartpie.events.on("maxsizechanged", resizeLegend);
            function resizeLegend() {
                document.getElementById("legenddiv").style.height = chartpie.legend.contentHeight + "px";
            }
        }


    }






    setTimeout(()=>{

        $('[data-toggle="tooltip"]').tooltip();
    },0);



    function getDataProcess() {
        $.post("/callProcedures?type=process", function (response) {

            let data = JSON.parse(response);
            if (data){

                $('#cardPie-gendate').text(moment().calendar());
                if (data.length>0) initPie("chartpie1",data[0]);
                if (data.length>1) initPie("chartpie3",data[1]);
            }

            // if (data.length>2) initPie("chartpie2",data[2]);
            // if (data.length>3) initPie("chartpie4",data[3]);
        })
    }

    function getDataDetail(element) {
        $.post("/callProcedures?type=detail&element="+element, function (response) {
            let data = JSON.parse(response);
            console.log(data);
            if (data!=null){
                switch (element){
                    case "cdr": setDataCdr(data); break;
                    case "mtInvite": setDataMtinvite(data); break;
                    case "mo": setDataMo(data); break;
                    case "topup": setDataTopup(data); break;
                    case "charge": setDataCharge(data); break;
                    case "all":
                        if (data[0]) setDataCdr(data[0]);
                        if (data[1]) setDataMtinvite(data[1]);
                        if (data[2]) setDataMo(data[2]);
                        if (data[3]) setDataTopup(data[3]);
                        if (data[4]) setDataCharge(data[4]);
                        break;
                    default: break;
                }
            }

        })
    }

    function setDataCdr(data){
        $('#cdr1').text(formatCurrency(data.totalToday));
        $('#cdr2').text(formatCurrency(data.totalLastday));
        $('#cdr3').text(data.infoNameReceive);
        $('#cdr4').text(data.infoNameProcess);
        $('#cdrLastTimePro').text(moment(data.lastTimeProcess, "DD-MM-YYYY HH:mm:ss").fromNow());
        $('#cdrLastTimeRec').text(moment(data.lastTimeReceive, "DD-MM-YYYY HH:mm:ss").fromNow());
        $('#cdr-gendate').text(moment(data.genDate, "DD-MM-YYYY HH:mm:ss").calendar());
    }
    function setDataMtinvite(data){
        $('#mtInvite1').text(formatCurrency(data.totalToday));
        $('#mtInvite2').text(formatCurrency(data.totalLastday));
        $('#mtInvite3').text(data.infoNameProcess);
        $('#mtInvite4').text(data.infoNameReceive);
        $('#mtLastTime').text(moment(data.lastTimeProcess, "DD-MM-YYYY HH:mm:ss").fromNow());
        $('#mtInvite-gendate').text(moment(data.genDate, "DD-MM-YYYY HH:mm:ss").calendar());
    }
    function setDataMo(data){
        $('#mo1').text(formatCurrency(data.totalToday));
        $('#mo2').text(formatCurrency(data.totalLastday));
        $('#mo3').text(data.infoNameReceive);
        $('#mo4').text(data.infoNameProcess);
        $('#moLastTimePro').text(moment(data.lastTimeProcess, "DD-MM-YYYY HH:mm:ss").fromNow());
        $('#moLastTimeRec').text(moment(data.lastTimeReceive, "DD-MM-YYYY HH:mm:ss").fromNow());
        $('#mo-gendate').text(moment(data.genDate, "DD-MM-YYYY HH:mm:ss").calendar());
    }
    function setDataTopup(data){
        $('#topup1').text(formatCurrency(data.totalToday));
        $('#topup2').text(formatCurrency(data.totalLastday));
        $('#topup3').text(data.infoNameProcess);
        $('#topupLastTimePro').text(moment(data.lastTimeProcess, "DD-MM-YYYY HH:mm:ss").fromNow());
        $('#topup-gendate').text(moment(data.genDate, "DD-MM-YYYY HH:mm:ss").calendar());
    }
    function setDataCharge(data){
        $('#charge1').text(formatCurrency(data.totalToday));
        $('#charge2').text(formatCurrency(data.totalLastday));
        $('#charge3').text(data.infoNameReceive);
        $('#charge4').text(data.infoNameProcess);
        $('#chargeLastTimePro').text(moment(data.lastTimeProcess, "DD-MM-YYYY HH:mm:ss").fromNow());
        $('#chargeLastTimeRec').text(moment(data.lastTimeReceive, "DD-MM-YYYY HH:mm:ss").fromNow());
        $('#charge-gendate').text(moment(data.genDate, "DD-MM-YYYY HH:mm:ss").calendar());
    }


    function getDataDashboard(element) {
        console.log("element:"+ element);
        $.post("/callProcedures?type=dashboard&element="+element, function (response) {
            // let data = JSON.parse(response);
            console.log("dashboard:"+element);
            let data = JSON.parse(response)
            console.log(response);
            if (data){
                switch (element){
                    case "middle":
                        $('#tongung').text(formatCurrency(data[0].totalMoneyTopupToday));
                        $('#tonghoanung').text(formatCurrency(data[0].totalMoneyRepayToday));
                        $('#middle-gendate').text(moment(data[0].lastUpdateStr, "DD-MM-YYYY HH:mm:ss").calendar());
                        if (data[1] && data[1].elements) initXYChart(data[1].elements);
                        break;
                    case "tab1":
                        $('#right11text').text((formatCurrency(data.totalInvitedSuc)));
                        $('#right12text').text((formatCurrency(data.totalTopup)));
                        $('#right13text').text((formatCurrency(data.totalRepaySuc)));
                        $('#right14text').text((formatCurrency(data.totalRepayFal)));
                        $('#last-update-tab-1').text(moment(data.lastUpdateStr, "DD-MM-YYYY HH:mm:ss").calendar());
                        break;
                    case "tab2":
                        $('#right21text').text((formatCurrency(data.totalMoneyTopup)));
                        $('#right22text').text((formatCurrency(data.totalMoneyRepay)));
                        $('#right23text').text((formatCurrency(data.totalMoneyBadDebt)));
                        $('#right24text').text((formatCurrency(data.totalMoneyNotRepay)));
                        $('#last-update-tab-2').text(moment(data.lastUpdateStr, "DD-MM-YYYY HH:mm:ss").calendar());
                        break;
                    case "tab3":
                        $('#right31text').text((formatCurrency(data.totalSubsService)));
                        $('#right32text').text((formatCurrency(data.totalSubsDebt)));
                        $('#right33text').text((formatCurrency(data.totalSubsBadDebt)));
                        $('#right34text').text((formatCurrency(data.totalSubsBeBadDebt)));
                        $('#last-update-tab-3').text(moment(data.lastUpdateStr, "DD-MM-YYYY HH:mm:ss").calendar());
                        break;

                    default: break;
                }
            }
        })
    }

    getDataDashboard('middle');
    getDataDashboard('tab1');
    getDataDashboard('tab2');
    getDataDashboard('tab3');
    getDataDetail('all');
    getDataProcess();


</script>
<!-- End #main-content -->