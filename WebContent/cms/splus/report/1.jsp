<%@ page import="tdt.db.viettel.splus.report.ReportDaily" %>
<%@ page import="java.text.DecimalFormat" %>
<jsp:useBean id="reportDailyDAO" class="tdt.db.viettel.splus.report.ReportDailyDAO" scope="session"></jsp:useBean>
<jsp:useBean id="reportDaily" class="tdt.db.viettel.splus.report.ReportDaily" scope="session"></jsp:useBean>
<%@page language="java" pageEncoding="utf-8" %>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>REPORT DAILY</title>
    <link rel="icon" href="<%=request.getContextPath() %>/images/icon/admin.ico" type="image/x-icon"/>
    <link rel="stylesheet" href="<%=request.getContextPath() %>/admin/login/resources/css/reset.css" type="text/css" media="screen"/>
    <link rel="stylesheet" href="<%=request.getContextPath() %>/admin/login/resources/css/style.css" type="text/css" media="screen"/>
    <link rel="stylesheet" href="<%=request.getContextPath() %>/admin/login/resources/css/invalid.css" type="text/css" media="screen"/>
    <link rel="stylesheet" href="<%=request.getContextPath() %>/admin/login/resources/css/jquery.datetimepicker.min.css" type="text/css" media="screen"/>
    <script type="text/javascript" src="<%=request.getContextPath() %>/admin/login/resources/scripts/jquery-3.1.1.min.js"></script>
    <script type="text/javascript" src="<%=request.getContextPath() %>/admin/login/resources/scripts/jquery.datetimepicker.full.min.js"></script>
    <style>
        .text-input {
            margin-right: 5px;
        }
        select {
            width: 157px;
            margin-top: 5px;
            margin-right: 5px;
        }
        table {
            table-layout: fixed;
        }
        table td {
            word-wrap: break-word;
        }
        table th {
            font-weight: bold;
            background-color: #eae8e8;
        }
    </style>
</head>
<%@ include file="/admin/include/header.jsp" %>
<%
    response.setCharacterEncoding("utf-8");
    request.setCharacterEncoding("utf-8");

    String reportTimeFrom = request.getParameter("reportTimeFrom");
    if(reportTimeFrom == null) {
        reportTimeFrom = request.getParameter("reportTimeFrom1");
        if(reportTimeFrom == null)
            reportTimeFrom = "";
    }
    String reportTimeTo = request.getParameter("reportTimeTo");
    if(reportTimeTo == null) {
        reportTimeTo = request.getParameter("reportTimeTo1");
        if(reportTimeTo == null)
            reportTimeTo = "";
    }
    int tong = reportDailyDAO.countAll(reportTimeFrom.trim(), reportTimeTo.trim());
    int n = 50;
    int pn = tong / n;
    if (tong % n > 0)
        pn = pn + 1;
    int currentPn = 1;
    try {
        //trong truong hop tim kiem, thi so trang sẽ duoc reset la trang 1
        if(request.getParameter("p1") != null) {
            currentPn = Integer.parseInt(request.getParameter("p1"));
        }
        else {
            currentPn = Integer.parseInt(request.getParameter("p"));
        }
    } catch (Exception ex) {
    }
    Collection total = reportDailyDAO.findAll(reportTimeFrom.trim(), reportTimeTo.trim(), currentPn, n);
    DecimalFormat mf2 = new DecimalFormat("###.##");
%>
<body>
<div id="body-wrapper"> <!-- Wrapper for the radial gradient background -->
    <jsp:include page="/admin/include/left.jsp"/>
    <div id="main-content"> <!-- Main Content Section with everything -->
        <!-- Page Head -->
        <%@ include file="/admin/include/tool.jsp" %>
        <div class="clear"></div> <!-- End .clear -->
        <h2 align="center">REPORT DAILY</h2>
        <div class="clear"></div> <!-- End .clear -->
        <div class="content-box"><!-- Start Content Box -->
            <form method="post" name="frmList">
                <input type="hidden" name="action"/>
                <div class="content-box-header" style="padding: 5px;">
                    <input type="hidden" name="p1" value="1">
                    <input type="text" class="text-input" name="reportTimeFrom" value="<%=reportTimeFrom%>" placeholder="Thời gian báo cáo từ" id="datetimepickerFrom">
                    <input type="text" class="text-input" name="reportTimeTo" value="<%=reportTimeTo%>" placeholder="Thời gian báo cáo đến" id="datetimepickerTo">
                    <input type="button" value="TÌM" class="button" onclick="frmList.submit();"/>
                    <div class="clear"></div>
                </div> <!-- End .content-box-header -->

                <div class="content-box-content">
                    <div class="tab-content default-tab" id="tab1">
                        <table cellpadding="4" cellspacing="4" border="1" rules="all" width="80%">
                            <tr class="header" bgcolor="c6c6c6" align="center">
                                <th style="width: 30px;">STT</th>
                                <%--<th style="width: 10%;">Số TB được mời / Tổng số TB hết tiền</th>--%>
                                <th style="width: 10%;">Thời gian báo cáo</th>
                                <th style="width: 20%;">Số lượt TOPUP thành công / <br /> Tổng số lượt request TOPUP (%)</th>
                                <th style="width: 20%;">Tổng số tiền TOPUP thành công / <br /> Tổng số tiền request TOPUP</th>
                                <th style="width: 20%;">Số lượt CHARGE thành công / <br /> Tổng số lượt request CHARGE (%)</th>
                                <th style="width: 20%;">Tổng số tiền CHARGE thành công / <br /> Tổng số tiền request CHARGE</th>
                                <th style="width: 10%;">Ngày tạo</th>
                                <th style="width: 10%;">Ngày cập nhật</th>
                            </tr>
                            <%
                                int index = 0;
                                if (total != null && total.size() > 0) {
                                    Iterator ite = total.iterator();
                                    while (ite.hasNext()) {
                                        reportDaily = (ReportDaily) ite.next();
                                        if (reportDaily != null) {
                                            index++;
                            %>
                            <tr class="list">
                                <td><%=(currentPn - 1) * n + index %></td>
                                <td><%=reportDaily.getReportTime() %></td>
                                <td>
                                    <%
                                        try {
                                            if (reportDaily.getSubTopupSuc() != null && reportDaily.getSubTopupSuc() != 0
                                                    && reportDaily.getSubTopupReq() != null && reportDaily.getSubTopupReq() != 0) {
                                                out.print(mf2.format(Double.valueOf(reportDaily.getSubTopupSuc() * 100) / reportDaily.getSubTopupReq()));
                                            }
                                            else {
                                                out.print("0");
                                            }
                                        } catch (Exception e) {
                                            e.printStackTrace();
                                        }
                                    %>
                                </td>
                                <td><%
                                    if(reportDaily.getTotalMoneyTopupSuc() != null && reportDaily.getTotalMoneyTopupReq() != null) {
                                        out.print(String.format("%,.0f", Double.valueOf(reportDaily.getTotalMoneyTopupSuc()))+" / "
                                                +String.format("%,.0f", Double.valueOf(reportDaily.getTotalMoneyTopupReq())));
                                    }
                                    else {
                                        out.print("0");
                                    }

                                %></td>
                                <td>
                                    <%
                                        try {
                                            if (reportDaily.getTotalChargeSuc() != null && reportDaily.getTotalChargeSuc() != 0
                                                    && reportDaily.getTotalChargeReq() != null && reportDaily.getTotalChargeReq() != 0) {
                                                out.print(mf2.format(Double.valueOf(reportDaily.getTotalChargeSuc() * 100) / reportDaily.getTotalChargeReq()));
                                            }
                                            else {
                                                out.print("0");
                                            }
                                        } catch (Exception e) {
                                            e.printStackTrace();
                                        }
                                    %>
                                </td>
                                <td>
                                    <%
                                        if(reportDaily.getTotalMoneyChargeSuc() != null && reportDaily.getTotalMoneyChargeReq() != null) {
                                            out.print(String.format("%,.0f", Double.valueOf(reportDaily.getTotalMoneyChargeSuc()))+" / "
                                                    +String.format("%,.0f", Double.valueOf(reportDaily.getTotalMoneyChargeReq())));
                                        }
                                    %>
                                </td>
                                <td><%=reportDaily.getGenDate() != null ? reportDaily.getGenDate() : "" %></td>
                                <td><%=reportDaily.getLastUpdate() != null ? reportDaily.getLastUpdate() : "" %></td>
                            </tr>
                            <%
                                    }
                                }
                            } else {
                            %>
                            <tr>
                                <td colspan="8" style="text-align: center;">
                                    <span style="color: red; font-weight: bold;">Không có dữ liệu</span>
                                </td>
                            </tr>
                            <%
                                }
                            %>
                        </table>
                        <table cellpadding="4" cellspacing="4" border="0" width="80%">
                            <tr>
                                <td><span style="font-size: 12px;padding-top: 15px;">Tổng số bản ghi: <%=tong%></span></td>
                                <td>
                                    <div class="bulk-actions align-left">
                                        <span id="spanTagAction"></span>
                                    </div>
                                    <%
                                        if (pn > 1) {
                                            String pageUrl = "1.jsp?reportTimeFrom1="+reportTimeFrom+"&reportTimeTo1="+reportTimeTo+"&p=";
                                    %>
                                    <div class="pagination">
                                        <a href="<%=pageUrl %>1" title="First Page">&laquo; First</a>
                                        <a href="<%=pageUrl %><%=currentPn-1 > 0 ? (currentPn - 1) : 1 %>"
                                           title="Previous Page">&laquo; Prev</a>
                                        Page <%=currentPn + "/" + pn %>
                                        <input type="text" value="<%=currentPn%>" onkeyup="if (event.keyCode == 13) changePage(this, '<%=pn%>', '<%=pageUrl%>')"
                                               style="width: 50px;text-align: center;" title="">
                                        <a href="<%=pageUrl %><%=currentPn+1 < pn ? currentPn + 1 : pn %>"
                                           title="Next Page">Next &raquo;</a>
                                        <a href="<%=pageUrl %><%=pn %>" title="Last Page">Last &raquo;</a>
                                    </div>
                                    <%} %>
                                    <div class="clear"></div>
                                </td>
                            </tr>
                        </table>
                    </div> <!-- End #tab1 -->
                </div> <!-- End .content-box-content -->
            </form>
        </div> <!-- End .content-box -->
        <div class="clear"></div>
        <%@include file="/admin/include/footer.jsp" %>
    </div>
</div>
<script>
    jQuery(document).ready(function () {
        jQuery('#datetimepickerFrom').datetimepicker({
            format:'Y-m-d H:i',
            step : 60
        });
        jQuery('#datetimepickerTo').datetimepicker({
            format:'Y-m-d H:i',
            step : 60
        });
    });
    function changePage(e, pageNumber, pageURL) {
        var page = $(e).val();
        if(isNaN(page) || Number(page) <= 0 || Number(page) > Number(pageNumber)) {
            return;
        }
        window.location.href = pageURL + page;
    }
</script>
</body>
</html>
