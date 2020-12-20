<%@page import="tdt.db.adm.Admin" %>
<%@page import="tdt.util.DateProc" %>
<%@page import="tdt.db.adm.AdminAccessLog" %>
<%@page import="tdt.listener.SessionCounterListener" %>
<%@ page import="tdt.db.viettel.splus.report.ReportDailyStandard" %>
<%@ page import="tdt.db.viettel.splus.report.ReportDashboardDAO" %>
<%@ page import="com.google.gson.JsonArray" %>
<%@ page import="tdt.util.DateTime" %>
<%@ page import="java.text.DecimalFormat" %>
<%@ page import="tdt.db.viettel.splus.report.ReportSPMT" %>
<%@ page import="tdt.db.viettel.splus.report.ReportDailyDashboardDetail" %>
<%@ page import="java.text.Format" %>
<%@ page language="java" pageEncoding="utf-8" %>
<%

    //ReportDashboardDAO standardDAO = new ReportDashboardDAO();

//    standardDAO.callProcedure();
//    DecimalFormat formatter = new DecimalFormat("#,###,###");
//    ReportDashboardDAO standardDAO = new ReportDashboardDAO();
//
//    standardDAO.callProcedure();
//
//    Calendar cal = Calendar.getInstance();
//    int month = cal.get(Calendar.MONTH) + 1;
//    int year = cal.get(Calendar.YEAR);
//    cal.add(Calendar.MONTH, -1);
//    int month1 = cal.get(Calendar.MONTH) + 1;
//    int year1 = cal.get(Calendar.YEAR);
//    cal.add(Calendar.MONTH, -1);
//    int month2 = cal.get(Calendar.MONTH) + 1;
//    int year2 = cal.get(Calendar.YEAR);
//
//    Format dateFormat = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");
//    Format dateFormat2 = new SimpleDateFormat("dd/MM/yyyy");
//
//
//    //Thống kê biểu đồ cột
//    JsonArray array1 = standardDAO.convertToJsonTopupReup(standardDAO.listTopupReup(month, year));
//    JsonArray array2 = standardDAO.convertToJsonTopupReup(standardDAO.listTopupReup(month1, year1));
//    JsonArray array3 = standardDAO.convertToJsonTopupReup(standardDAO.listTopupReup(month2, year2));
//    ReportDailyStandard reportDailyStandard = standardDAO.getReportDailyStandard();
//    ReportDailyStandard reportDailyRight = standardDAO.getReportDaily();

    //gọi thủ tục đẻ insert dữ liệu


    //Thông kê biểu đồ PIE
//    List<ReportSPMT> listSPMT = standardDAO.getMtLog();
//    List<ReportSPMT> listCdrLog = standardDAO.getCdrLog();
//    JsonArray arraySPMT2 = standardDAO.convertToJsonMtLog(listSPMT.get(0));
//    JsonArray arraySPMT4 = standardDAO.convertToJsonMtLog(listSPMT.get(1));
//    JsonArray arraySPMT1 = standardDAO.convertToJsonMtLog(listCdrLog.get(0));
//    JsonArray arraySPMT3 = standardDAO.convertToJsonMtLog(listCdrLog.get(1));


//    //Thống kê CDR,MT-INVITE,MO,TOPUP,CHARGE
//    List<ReportDailyDashboardDetail> dashboardDetailList = standardDAO.listDashboardDetail();
//    ReportDailyDashboardDetail cdr = dashboardDetailList.get(0);
//    ReportDailyDashboardDetail mtInvite = dashboardDetailList.get(1);
//    ReportDailyDashboardDetail mo = dashboardDetailList.get(2);
//    ReportDailyDashboardDetail topup = dashboardDetailList.get(3);
//    ReportDailyDashboardDetail charge = dashboardDetailList.get(4);
%>
<div id="main-content">
    <!-- Main Content Section with everything -->

    <!-- Page Head -->
    <h2 align="center" style="color: #19aa06; padding-top: 10px;">
        THỐNG KÊ TỔNG QUAN
    </h2>

    <div class="clear"></div>
    <!-- End .clear -->

    <div class="content-box">
        <!-- Start Content Box -->

        <div class="content-box-header">

            <h3></h3>

            <ul class="content-box-tabs">

            </ul>

            <div class="clear"></div>

        </div>
        <!-- End .content-box-header -->

        <div class="content-box-content">

            <div class="tab-content default-tab" id="tab1" align="center">
                <!-- This is the target div. id must match the href of this div's tab -->

                <div class="notification attention png_bg">
                    <a href="#" class="close"><img
                            src="login/resources/images/icons/cross_grey_small.png"
                            title="Close this notification" alt="close"/>
                    </a>
                    <div>
                        Chọn các mục bên menu trái để quản lý nội dung!
                    </div>
                </div>
                <center>
                    <%
                        Admin adm_control = (Admin) session.getAttribute("datavasosp.adm.control");
                        if (adm_control != null && adm_control.getRightRole() == Admin.RIGHT_ADMIN) {
                    %>
                    <table>
                        <tr>
                            <td colspan="5" style="font-weight: bold;text-align: center;">Danh sách Admin đang online
                            </td>
                        </tr>
                        <tr>
                            <td style="font-weight: bold;">STT</td>
                            <td style="font-weight: bold;">Username</td>
                            <td style="font-weight: bold;">IP</td>
                            <td style="font-weight: bold;">Browser</td>
                            <td style="font-weight: bold;">Login time</td>
                        </tr>
                        <%
                            Vector<AdminAccessLog> listAdmin = SessionCounterListener.getListAdminOnline();
                            if (listAdmin != null && listAdmin.size() > 0) {
                                AdminAccessLog adminAccessLog = null;
                                for (int i = 0; i < listAdmin.size(); i++) {
                                    adminAccessLog = listAdmin.get(i);
                                    if (adminAccessLog != null) {
                                        out.println("<tr>");
                                        out.println("<td>" + (i + 1) + "</td>");
                                        out.println("<td>" + adminAccessLog.getUsrname() + "</td>");
                                        out.println("<td>" + adminAccessLog.getIp() + "</td>");
                                        out.println("<td>" + adminAccessLog.getBrowser() + "</td>");
                                        out.println("<td>" + DateProc.getDateTime24hString(adminAccessLog.getLoginTime()) + "</td>");
                                        out.println("</tr>");
                                    }
                                }
                            }
                        %>
                    </table>
                    <%} else { %>
                    <img height="250px" src="<%=request.getContextPath()%>/admin/images/wildspirit.png">
                    <%} %>
                </center>

            </div>
            <!-- End #tab1 -->

            <div class="tab-content" id="tab2">

            </div>
            <!-- End #tab2 -->

        </div>
        <%--<!-- End .content-box-content -->--%>

    <%--</div>--%>
    <!-- End .content-box -->
    <%--<div class="row dashboard-line1 ">--%>
        <%--<div class="col-xs-5ths">--%>
            <%--<div class="panel panel-default " style="height: 300px;">--%>
                <%--<div class="panel-heading"><strong>CDR</strong></div>--%>
                <%--<div class="panel-body">--%>
                    <%--<div class="text-center">--%>
                        <%--<p class="data-number"><%=formatter.format(cdr.getTotalToday())%> /--%>
                            <%--<%=formatter.format(cdr.getTotalLastday())%>--%>
                        <%--</p>--%>
                        <%--<ul>--%>
                            <%--<li title="File CDR nhận gần nhất - Thời gian nhận file">--%>
                                <%--<strong><%=cdr.getInfoNameReceive()%>--%>
                                <%--</strong> - <%=cdr.getLastTimeReceive()%>--%>
                            <%--</li>--%>
                            <%--<li title="File CDR đã xử lý gần nhất - Thời gian xử lý file">--%>
                                <%--<strong><%=cdr.getInfoNameProcess()%>--%>
                                <%--</strong> - <%=cdr.getLastTimeProcess()%>--%>
                            <%--</li>--%>
                        <%--</ul>--%>
                    <%--</div>--%>
                <%--</div>--%>
            <%--</div>--%>
        <%--</div>--%>
        <%--<div class="col-xs-5ths">--%>
            <%--<div class="panel panel-default " style="height: 300px;">--%>
                <%--<div class="panel-heading"><strong>MT INVITE</strong></div>--%>
                <%--<div class="panel-body">--%>
                    <%--<div class="text-center">--%>
                        <%--<p class="data-number"><%=formatter.format(mtInvite.getTotalToday())%> /--%>
                            <%--<%=formatter.format(mtInvite.getTotalLastday())%>--%>
                        <%--</p>--%>

                        <%--<ul>--%>
                            <%--<li title="Tên ID invite gửi gần nhất - Thời gian gửi MT">--%>
                                <%--<strong><%=mtInvite.getInfoNameProcess()%>--%>
                                <%--</strong> - <%=mtInvite.getLastTimeProcess()%>--%>
                            <%--</li>--%>
                            <%--<li title="Tổng MT queue (tại thời điểm tra cứu)"><strong><%=mtInvite.getTotalMtQueue()%>--%>
                            <%--</strong>--%>
                            <%--</li>--%>

                        <%--</ul>--%>
                    <%--</div>--%>
                <%--</div>--%>
            <%--</div>--%>
        <%--</div>--%>
        <%--<div class="col-xs-5ths">--%>
            <%--<div class="panel panel-default " style="height: 300px;">--%>
                <%--<div class="panel-heading"><strong>MO</strong></div>--%>
                <%--<div class="panel-body">--%>
                    <%--<div class="text-center">--%>
                        <%--<p class="data-number"><%=formatter.format(mo.getTotalToday())%> /--%>
                            <%--<%=formatter.format(mo.getTotalLastday())%>--%>
                        <%--</p>--%>

                        <%--<ul>--%>
                            <%--<li title="Tên request ID nhận gần nhất - Thời gian nhận MO">--%>
                                <%--<strong><%=mo.getInfoNameReceive()%>--%>
                                <%--</strong> - <%=mo.getLastTimeReceive()%>--%>
                            <%--</li>--%>
                            <%--<li title="Tên request ID xử lý gần nhất - Thời gian xử lý MO">--%>
                                <%--<strong><%=mo.getInfoNameProcess()%>--%>
                                <%--</strong> - <%=mo.getLastTimeProcess()%>--%>
                            <%--</li>--%>
                        <%--</ul>--%>
                    <%--</div>--%>
                <%--</div>--%>
            <%--</div>--%>
        <%--</div>--%>
        <%--<div class="col-xs-5ths">--%>
            <%--<div class="panel panel-default " style="height: 300px;">--%>
                <%--<div class="panel-heading"><strong>TOP UP</strong></div>--%>
                <%--<div class="panel-body">--%>
                    <%--<div class="text-center">--%>
                        <%--<p class="data-number"><%=formatter.format(topup.getTotalToday())%> /--%>
                            <%--<%=formatter.format(topup.getTotalLastday())%>--%>
                        <%--</p>--%>

                        <%--<ul>--%>
                            <%--<li title="MPTransID đã top up mới nhất - Thời gian thực hiện top up mới nhất">--%>
                                <%--<strong><%=topup.getInfoNameProcess()%>--%>
                                <%--</strong> - <%=topup.getLastTimeProcess()%>--%>
                            <%--</li>--%>
                        <%--</ul>--%>
                    <%--</div>--%>
                <%--</div>--%>
            <%--</div>--%>
        <%--</div>--%>
        <%--<div class="col-xs-5ths">--%>
            <%--<div class="panel panel-default " style="height: 300px;">--%>
                <%--<div class="panel-heading"><strong>CHARGE</strong></div>--%>
                <%--<div class="panel-body">--%>
                    <%--<div class="text-center">--%>
                        <%--<p class="data-number"><%=formatter.format(charge.getTotalToday())%> /--%>
                            <%--<%=formatter.format(charge.getTotalLastday())%>--%>
                        <%--</p>--%>

                        <%--<ul>--%>
                            <%--<li title="File CDR top up nhận gần nhất - Thời gian nhận file">--%>
                                <%--<strong><%=charge.getInfoNameReceive()%>--%>
                                <%--</strong> - <%=charge.getLastTimeReceive()%>--%>
                            <%--</li>--%>
                            <%--<li title="File CDR top up đã xử lý gần nhất - Thời gian xử lý file">--%>
                                <%--<strong><%=charge.getInfoNameProcess()%>--%>
                                <%--</strong> - <%=charge.getLastTimeProcess()%>--%>
                            <%--</li>--%>
                        <%--</ul>--%>
                    <%--</div>--%>
                <%--</div>--%>
            <%--</div>--%>
        <%--</div>--%>
    <%--</div>--%>

    <%--<div class="row" style="padding-left: 15px;">--%>
        <%--<div class="col-md-9">--%>
            <%--<div class="row">--%>
                <%--<div class="panel panel-default dashboard-line1 text-center">--%>
                    <%--<div class="row panel-body">--%>
                        <%--<div class="col-md-3 chart-col-4">--%>
                            <%--<p class="data-text" style="font-size: 18px">(TỔNG ỨNG/ TỔNG HOÀN ỨNG)</p>--%>
                            <%--<%if (reportDailyStandard.getSumTopup() != null && reportDailyStandard.getSumRepay() != null) {%>--%>
                            <%--<p class="data-number"><%=formatter.format(reportDailyStandard.getSumTopup())%>--%>
                                <%--<br>/<br><%=formatter.format(reportDailyStandard.getSumRepay())%>--%>
                            <%--</p>--%>
                            <%--<%} else {%>--%>
                            <%--<span style="color: red; font-weight: bold;">Không có dữ liệu</span>--%>
                            <%--<%}%>--%>
                        <%--</div>--%>
                        <%--<div class="col-md-3 chart-col-4">--%>
                            <%--<p class="data-text-month">Tháng <%= month%>--%>
                            <%--</p>--%>
                            <%--<div id="chartdiv1"></div>--%>
                        <%--</div>--%>
                        <%--<div class="col-md-3 chart-col-4">--%>
                            <%--<p class="data-text-month">Tháng <%= month1%>--%>
                            <%--</p>--%>
                            <%--<div id="chartdiv2"></div>--%>
                        <%--</div>--%>
                        <%--<div class="col-md-3 ">--%>
                            <%--<p class="data-text-month">Tháng <%= month2%>--%>
                            <%--</p>--%>
                            <%--<div id="chartdiv3"></div>--%>
                        <%--</div>--%>
                    <%--</div>--%>
                <%--</div>--%>

            <%--</div>--%>
            <%--<div class="row">--%>
                <%--<div class="panel panel-default dashboard-line1 " style="height: 600px">--%>
                    <%--<div class="panel-heading"><strong>THỜI GIAN XỬ LÝ CÁC TIẾN TRÌNH</strong></div>--%>
                    <%--<div class="panel-body text-center">--%>
                        <%--<div class="row">--%>
                            <%--<div class="col-md-3"></div>--%>
                            <%--<div class="col-md-3">--%>
                                <%--<p class="data-text-month">Ngày <%=dateFormat2.format(Calendar.getInstance().getTime())%></p>--%>
                            <%--</div>--%>
                            <%--<div class="col-md-3">--%>

                                <%--<%Calendar cal1 = Calendar.getInstance();--%>
                                    <%--cal1.add(Calendar.DAY_OF_MONTH,-1);--%>
                                <%--%>--%>
                                <%--<p class="data-text-month">Ngày <%=dateFormat2.format(cal1.getTime())%></p>--%>
                            <%--</div>--%>
                            <%--<div class="col-md-4"></div>--%>
                        <%--</div>--%>
                        <%--<div class="row">--%>
                            <%--<div class="col-md-3">--%>
                                <%--<div style="display: table; height: 40%; overflow: hidden;">--%>
                                    <%--<div style="display: table-cell; vertical-align: middle;">--%>
                                        <%--<div class="data-text-month">--%>
                                            <%--Thời gian nhận CDR - Tạo MT invite--%>
                                        <%--</div>--%>
                                    <%--</div>--%>
                                <%--</div>--%>
                                <%--<div style="display: table; height: 40%; overflow: hidden;">--%>
                                    <%--<div style="display: table-cell; vertical-align: middle;">--%>
                                        <%--<div class="data-text-month">--%>
                                            <%--Thời gian tạo MT invite - Gửi thành công--%>
                                        <%--</div>--%>
                                    <%--</div>--%>
                                <%--</div>--%>

                            <%--</div>--%>
                            <%--<div class="col-md-3">--%>
                                <%--<div id="chartpie1" style="width: 100%; height: 40%; "></div>--%>
                                <%--<div id="chartpie2" style="width: 100%; height: 40%; "></div>--%>
                            <%--</div>--%>
                            <%--<div class="col-md-3">--%>
                                <%--<div id="chartpie3" style="width: 100%; height: 40%; "></div>--%>
                                <%--<div id="chartpie4" style="width: 100%; height: 40%; "></div>--%>
                            <%--</div>--%>
                            <%--<div class="col-md-2">--%>
                                <%--<div style="display: table; height: 80%; overflow: hidden;">--%>
                                    <%--<div style="display: table-cell; vertical-align: middle;">--%>
                                        <%--<div id="legenddiv" class="chartdiv"></div>--%>
                                    <%--</div>--%>
                                <%--</div>--%>

                            <%--</div>--%>
                        <%--</div>--%>
                    <%--</div>--%>
                <%--</div>--%>
            <%--</div>--%>
        <%--</div>--%>
        <%--<div class="col-md-3 dashboard-line1">--%>
            <%--<div class="panel panel-default ">--%>
                <%--<div class="panel-heading"><strong>SỐ LƯỢT MỜI ỨNG </strong></div>--%>
                <%--<div class="panel-body text-center">--%>

                    <%--<%if (reportDailyRight.getSumTotalInvitedSuc() != null) {%>--%>
                    <%--<p class="data-number text-center"--%>
                       <%--style="font-size: xx-large"><%=reportDailyRight.getSumTotalInvitedSuc()%>--%>
                    <%--</p>--%>

                    <%--<%} else {%>--%>
                    <%--<span style="color: red; font-weight: bold;">Không có dữ liệu</span>--%>
                    <%--<%}%>--%>
                <%--</div>--%>
            <%--</div>--%>
            <%--<div class="panel panel-default ">--%>
                <%--<div class="panel-heading"><strong>SỐ LƯỢT ỨNG</strong></div>--%>
                <%--<div class="panel-body text-center">--%>

                    <%--<%if (reportDailyRight.getSumTotalTopup() != null) {%>--%>
                    <%--<p class="data-number text-center"--%>
                       <%--style="font-size: xx-large"><%=reportDailyRight.getSumTotalTopup()%>--%>
                    <%--</p>--%>

                    <%--<%} else {%>--%>
                    <%--<span style="color: red; font-weight: bold;">Không có dữ liệu</span>--%>
                    <%--<%}%>--%>
                <%--</div>--%>
            <%--</div>--%>
            <%--<div class="panel panel-default ">--%>
                <%--<div class="panel-heading"><strong>SỐ THUÊ BAO PHÁT TRIỂN</strong></div>--%>
                <%--<div class="panel-body text-center">--%>

                    <%--<%if (reportDailyRight.getMaxTotalSubsService() != null) {%>--%>
                    <%--<p class="data-number " style="font-size: xx-large"><%=reportDailyRight.getMaxTotalSubsService()%>--%>
                    <%--</p>--%>
                    <%--<p class="data-text-month">(Số liệu tổng từ khi chạy dịch vụ)</p>--%>

                    <%--<%} else {%>--%>
                    <%--<span style="color: red; font-weight: bold;">Không có dữ liệu</span>--%>
                    <%--<%}%>--%>
                <%--</div>--%>
            <%--</div>--%>
        <%--</div>--%>
    <%--</div>--%>
    <%--<div class="clear"></div>--%>
    <!-- Start Notifications -->
    <!--
            <div class="notification attention png_bg">
                <a href="#" class="close"><img src="resources/images/icons/cross_grey_small.png" title="Close this notification" alt="close" /></a>
                <div>
                    Attention notification. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Proin vulputate, sapien quis fermentum luctus, libero.
                </div>
            </div>

            <div class="notification information png_bg">
                <a href="#" class="close"><img src="resources/images/icons/cross_grey_small.png" title="Close this notification" alt="close" /></a>
                <div>
                    Information notification. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Proin vulputate, sapien quis fermentum luctus, libero.
                </div>
            </div>

            <div class="notification success png_bg">
                <a href="#" class="close"><img src="resources/images/icons/cross_grey_small.png" title="Close this notification" alt="close" /></a>
                <div>
                    Success notification. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Proin vulputate, sapien quis fermentum luctus, libero.
                </div>
            </div>

            <div class="notification error png_bg">
                <a href="#" class="close"><img src="resources/images/icons/cross_grey_small.png" title="Close this notification" alt="close" /></a>
                <div>
                    Error notification. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Proin vulputate, sapien quis fermentum luctus, libero.
                </div>
            </div>
            -->
    <!-- End Notifications -->

    <%@include file="footer.jsp" %>

</div>
<%--<script type="text/javascript">--%>
    <%--AmCharts.makeChart("chartdiv1",--%>
        <%--{--%>
            <%--"type": "serial",--%>
            <%--"categoryField": "category",--%>
            <%--"rotate": true,--%>
            <%--// "autoMarginOffset": 40,--%>
            <%--"marginRight": 40,--%>
            <%--"marginTop": 40,--%>
            <%--"startDuration": 1,--%>
            <%--"fontSize": 13,--%>
            <%--"theme": "light",--%>
            <%--"categoryAxis": {--%>
                <%--"gridPosition": "start"--%>
            <%--},--%>
            <%--"graphs": [--%>
                <%--{--%>
                    <%--"balloonText": "[[category]]:[[value]]",--%>
                    <%--"fillAlphas": 1,--%>
                    <%--"labelText": "",--%>
                    <%--"title": "graph 1",--%>
                    <%--"type": "column",--%>
                    <%--"valueField": "value"--%>
                <%--}--%>
            <%--],--%>
            <%--"dataProvider": <%=array1%>--%>
        <%--}--%>
    <%--);--%>
    <%--AmCharts.makeChart("chartdiv2",--%>
        <%--{--%>
            <%--"type": "serial",--%>
            <%--"categoryField": "category",--%>
            <%--"rotate": true,--%>
            <%--// "autoMarginOffset": 40,--%>
            <%--"marginRight": 40,--%>
            <%--"marginTop": 40,--%>
            <%--"startDuration": 1,--%>
            <%--"fontSize": 13,--%>
            <%--"theme": "light",--%>
            <%--"categoryAxis": {--%>
                <%--"gridPosition": "start"--%>
            <%--},--%>
            <%--"graphs": [--%>
                <%--{--%>
                    <%--"balloonText": "[[category]]:[[value]]",--%>
                    <%--"fillAlphas": 1,--%>
                    <%--"labelText": "",--%>
                    <%--"title": "graph 1",--%>
                    <%--"type": "column",--%>
                    <%--"valueField": "value"--%>
                <%--}--%>
            <%--],--%>
            <%--"dataProvider": <%=array2%>--%>
        <%--}--%>
    <%--);--%>
    <%--AmCharts.makeChart("chartdiv3",--%>
        <%--{--%>
            <%--"type": "serial",--%>
            <%--"categoryField": "category",--%>
            <%--"rotate": true,--%>
            <%--// "autoMarginOffset": 40,--%>
            <%--"marginRight": 40,--%>
            <%--"marginTop": 40,--%>
            <%--"startDuration": 1,--%>
            <%--"fontSize": 13,--%>
            <%--"theme": "light",--%>
            <%--"categoryAxis": {--%>
                <%--"gridPosition": "start"--%>
            <%--},--%>
            <%--"graphs": [--%>
                <%--{--%>
                    <%--"balloonText": "[[category]]:[[value]]",--%>
                    <%--"fillAlphas": 1,--%>
                    <%--"labelText": "",--%>
                    <%--"title": "graph 1",--%>
                    <%--"type": "column",--%>
                    <%--"valueField": "value"--%>
                <%--}--%>
            <%--],--%>
            <%--"dataProvider": <%=array3%>--%>
        <%--}--%>
    <%--);--%>
    <%--&lt;%&ndash;AmCharts.makeChart("chartpie1",&ndash;%&gt;--%>
        <%--&lt;%&ndash;{&ndash;%&gt;--%>
            <%--&lt;%&ndash;"type": "pie",&ndash;%&gt;--%>
            <%--&lt;%&ndash;"balloonText": "[[title]]<br><span style='font-size:14px'><b>[[value]]</b> ([[percents]]%)</span>",&ndash;%&gt;--%>
            <%--&lt;%&ndash;"labelText": "",&ndash;%&gt;--%>
            <%--&lt;%&ndash;"titleField": "category",&ndash;%&gt;--%>
            <%--&lt;%&ndash;"valueField": "value",&ndash;%&gt;--%>
            <%--&lt;%&ndash;"theme": "light",&ndash;%&gt;--%>
            <%--&lt;%&ndash;"allLabels": [],&ndash;%&gt;--%>
            <%--&lt;%&ndash;"balloon": {},&ndash;%&gt;--%>
            <%--&lt;%&ndash;"titles": [],&ndash;%&gt;--%>
            <%--&lt;%&ndash;"dataProvider": <%=arraySPMT1%>&ndash;%&gt;--%>
        <%--&lt;%&ndash;}&ndash;%&gt;--%>
    <%--&lt;%&ndash;);&ndash;%&gt;--%>
    <%--&lt;%&ndash;AmCharts.makeChart("chartpie2",&ndash;%&gt;--%>
        <%--&lt;%&ndash;{&ndash;%&gt;--%>
            <%--&lt;%&ndash;"type": "pie",&ndash;%&gt;--%>
            <%--&lt;%&ndash;"balloonText": "[[title]]<br><span style='font-size:14px'><b>[[value]]</b> ([[percents]]%)</span>",&ndash;%&gt;--%>
            <%--&lt;%&ndash;"labelText": "",&ndash;%&gt;--%>
            <%--&lt;%&ndash;"titleField": "category",&ndash;%&gt;--%>
            <%--&lt;%&ndash;"valueField": "value",&ndash;%&gt;--%>
            <%--&lt;%&ndash;"theme": "light",&ndash;%&gt;--%>
            <%--&lt;%&ndash;"allLabels": [],&ndash;%&gt;--%>
            <%--&lt;%&ndash;"balloon": {},&ndash;%&gt;--%>
            <%--&lt;%&ndash;"titles": [],&ndash;%&gt;--%>
            <%--&lt;%&ndash;"dataProvider": <%=arraySPMT2%>&ndash;%&gt;--%>
        <%--&lt;%&ndash;}&ndash;%&gt;--%>
    <%--&lt;%&ndash;);&ndash;%&gt;--%>
    <%--&lt;%&ndash;AmCharts.makeChart("chartpie3",&ndash;%&gt;--%>
        <%--&lt;%&ndash;{&ndash;%&gt;--%>
            <%--&lt;%&ndash;"type": "pie",&ndash;%&gt;--%>
            <%--&lt;%&ndash;"balloonText": "[[title]]<br><span style='font-size:14px'><b>[[value]]</b> ([[percents]]%)</span>",&ndash;%&gt;--%>
            <%--&lt;%&ndash;"labelText": "",&ndash;%&gt;--%>
            <%--&lt;%&ndash;"titleField": "category",&ndash;%&gt;--%>
            <%--&lt;%&ndash;"valueField": "value",&ndash;%&gt;--%>
            <%--&lt;%&ndash;"theme": "light",&ndash;%&gt;--%>
            <%--&lt;%&ndash;"allLabels": [],&ndash;%&gt;--%>
            <%--&lt;%&ndash;"balloon": {},&ndash;%&gt;--%>
            <%--&lt;%&ndash;"titles": [],&ndash;%&gt;--%>
            <%--&lt;%&ndash;"dataProvider": <%=arraySPMT3%>&ndash;%&gt;--%>
        <%--&lt;%&ndash;}&ndash;%&gt;--%>
    <%--&lt;%&ndash;);&ndash;%&gt;--%>
    <%--&lt;%&ndash;AmCharts.makeChart("chartpie4",&ndash;%&gt;--%>
        <%--&lt;%&ndash;{&ndash;%&gt;--%>
            <%--&lt;%&ndash;"type": "pie",&ndash;%&gt;--%>
            <%--&lt;%&ndash;"balloonText": "[[title]]<br><span style='font-size:14px'><b>[[value]]</b> ([[percents]]%)</span>",&ndash;%&gt;--%>
            <%--&lt;%&ndash;"labelText": "",&ndash;%&gt;--%>
            <%--&lt;%&ndash;"titleField": "category",&ndash;%&gt;--%>
            <%--&lt;%&ndash;"valueField": "value",&ndash;%&gt;--%>
            <%--&lt;%&ndash;"theme": "light",&ndash;%&gt;--%>
            <%--&lt;%&ndash;"allLabels": [],&ndash;%&gt;--%>
            <%--&lt;%&ndash;"balloon": {},&ndash;%&gt;--%>
            <%--&lt;%&ndash;"titles": [],&ndash;%&gt;--%>

            <%--&lt;%&ndash;"dataProvider": <%=arraySPMT4%>,&ndash;%&gt;--%>
            <%--&lt;%&ndash;"fontSize": 15,&ndash;%&gt;--%>
            <%--&lt;%&ndash;"legend": {&ndash;%&gt;--%>
                <%--&lt;%&ndash;"divId": "legenddiv",&ndash;%&gt;--%>
                <%--&lt;%&ndash;"markerSize": 25,&ndash;%&gt;--%>
                <%--&lt;%&ndash;"valueText": ""&ndash;%&gt;--%>
            <%--&lt;%&ndash;},&ndash;%&gt;--%>
        <%--&lt;%&ndash;}&ndash;%&gt;--%>
    <%--&lt;%&ndash;);&ndash;%&gt;--%>
    <%--var suspendHovers = false;--%>
    <%--for (var i = 0; i < AmCharts.charts.length; i++) {--%>
        <%--var chart = AmCharts.charts[i];--%>

        <%--if (chart.type == "pie") {--%>
            <%--// roll over--%>
            <%--chart.addListener("rollOverSlice", function (event) {--%>
                <%--replicateAction(event.chart, "rollOverSlice", event.dataItem.index);--%>
            <%--});--%>

            <%--// roll out--%>
            <%--chart.addListener("rollOutSlice", function (event) {--%>
                <%--replicateAction(event.chart, "rollOutSlice", event.dataItem.index);--%>
            <%--});--%>

            <%--// click slice--%>
            <%--chart.addListener("clickSlice", function (event) {--%>
                <%--replicateAction(event.chart, "clickSlice", event.dataItem.index);--%>
            <%--});--%>

            <%--// legend events (hide/show)--%>
            <%--if (chart.legend !== undefined) {--%>
                <%--chart.addListener("init", function () {--%>
                    <%--chart.legend.addListener("hideItem", function (event) {--%>
                        <%--replicateAction(event.chart, "hideSlice", event.dataItem.index);--%>
                    <%--});--%>
                    <%--chart.legend.addListener("showItem", function (event) {--%>
                        <%--replicateAction(event.chart, "showSlice", event.dataItem.index);--%>
                    <%--});--%>
                <%--})--%>
            <%--}--%>
        <%--}--%>

    <%--}--%>


    <%--function replicateAction(chart, action, index) {--%>
        <%--if (suspendHovers)--%>
            <%--return;--%>
        <%--suspendHovers = true;--%>
        <%--for (var x = 0; x < AmCharts.charts.length; x++) {--%>
            <%--if (AmCharts.charts[x] == chart || AmCharts.charts[x].type == "serial")--%>
                <%--continue;--%>
            <%--AmCharts.charts[x][action](index);--%>
        <%--}--%>
        <%--suspendHovers = false;--%>
    <%--}--%>

<%--</script>--%>
<!-- End #main-content -->