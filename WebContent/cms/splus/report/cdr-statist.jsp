<%@ page import="tdt.db.vas.viettel.splus.statistic.Statist" %>
<%@page language="java" pageEncoding="utf-8" %>
<jsp:useBean id="statistDAO" class="tdt.db.vas.viettel.splus.statistic.StatistDAO" scope="session"></jsp:useBean>
<jsp:useBean id="statist" class="tdt.db.vas.viettel.splus.statistic.Statist" scope="session"></jsp:useBean>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>Thống kê dịch vụ</title>
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

    String staTime = request.getParameter("staTime");
    if(staTime == null) {
        staTime = request.getParameter("staTime1");
        if(staTime == null)
            staTime = "";
    }
    String endTime = request.getParameter("endTime");
    if(endTime == null) {
        endTime = request.getParameter("endTime1");
        if(endTime == null)
            endTime = "";
    }
    String cdrName = request.getParameter("cdrName");
    if(cdrName == null) {
        cdrName = request.getParameter("cdrName1");
        if(cdrName == null)
            cdrName = "";
    }
    if("-1".equals(cdrName)) {
        cdrName = "";
    }

    String cdrType = request.getParameter("cdrType");
    if(cdrType == null) {
        cdrType = request.getParameter("cdrType1");
        if(cdrType == null)
            cdrType = "";
    }

    String genDateFrom = request.getParameter("genDateFrom");
    if(genDateFrom == null) {
        genDateFrom = request.getParameter("genDateFrom1");
        if(genDateFrom == null)
            genDateFrom = "";
    }
    String genDateTo = request.getParameter("genDateTo");
    if(genDateTo == null) {
        genDateTo = request.getParameter("genDateTo1");
        if(genDateTo == null)
            genDateTo = "";
    }

    int tong = statistDAO.countAllStatistCDR(staTime, endTime, cdrName, cdrType, null, genDateFrom, genDateTo);
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
    } catch (Exception ex) {}
    Collection<Statist> total = null;
    try {
        total = statistDAO.findAllStatistCDR(staTime, endTime, cdrName, cdrType, null, genDateFrom, genDateTo, currentPn, n);
    } catch (Exception e) {
        e.printStackTrace();
    }
%>
<body>
<div id="body-wrapper"> <!-- Wrapper for the radial gradient background -->
    <jsp:include page="/admin/include/left.jsp"/>
    <div id="main-content"> <!-- Main Content Section with everything -->
        <!-- Page Head -->
        <%@ include file="/admin/include/tool.jsp" %>
        <div class="clear"></div> <!-- End .clear -->
        <h2 align="center">THỐNG KÊ</h2>
        <div class="clear"></div> <!-- End .clear -->
        <div class="content-box"><!-- Start Content Box -->
            <form method="post" name="frmList">
                <input type="hidden" name="action"/>
                <div class="content-box-header" style="padding: 5px;">
                    <input type="hidden" name="p1" value="1">
                    <input type="text" class="text-input datetimepicker" name="staTime" value="<%=staTime%>" placeholder="Thời điểm bắt đầu">
                    <input type="text" class="text-input datetimepicker" name="endTime" value="<%=endTime%>" placeholder="Thời điểm kết thúc">
                    <select name="cdrName">
                        <option value="-1">Loại file CDR</option>
                        <option value="TOPUP" <%="TOPUP".equals(cdrName) ? "selected" : ""%>>TOPUP</option>
                        <option value="THRESHOLD" <%="THRESHOLD".equals(cdrName) ? "selected" : ""%>>THRESHOLD</option>
                        <option value="CALLBASE" <%="CALLBASE".equals(cdrName) ? "selected" : ""%>>CALLBASE</option>
                    </select>
                    <input type="number" class="text-input" name="cdrType" value="<%=cdrType%>" placeholder="Ngưỡng CDR">
                    <input type="text" class="text-input genDate" name="genDateFrom" value="<%=genDateFrom%>" placeholder="Ngày tạo từ">
                    <input type="text" class="text-input genDate" name="genDateTo" value="<%=genDateTo%>" placeholder="Ngày tạo đến">
                    <input type="button" value="TÌM" class="button" onclick="frmList.submit();"/>
                    <div class="clear"></div>
                </div> <!-- End .content-box-header -->

                <div class="content-box-content">
                    <div class="tab-content default-tab" id="tab1">
                        <table cellpadding="4" cellspacing="4" border="1" rules="all" width="80%">
                            <tr class="header" bgcolor="c6c6c6" align="center">
                                <th style="width: 50px;">STT</th>
                                <th style="width: 20%;">Thời gian bắt đầu thống kê</th>
                                <th style="width: 20%;">Thời gian kết thúc thống kê</th>
                                <th style="width: 25%;">Loại file CDR</th>
                                <th style="width: 20%;">Ngưỡng</th>
                                <th style="width: 20%;">Số thuê bao thuộc ngưỡng</th>
                                <th style="width: 20%;">Ngày tạo</th>
                            </tr>
                            <%
                                int index = 0;
                                if (total != null && total.size() > 0) {
                                    Iterator ite = total.iterator();
                                    while (ite.hasNext()) {
                                        statist = (Statist) ite.next();
                                        if (statist != null) {
                                            index++;
                            %>
                            <tr class="list">
                                <td><%=(currentPn - 1) * n + index %></td>
                                <td><%=statist.getStaTime() != null ? statist.getStaTime() : "" %></td>
                                <td><%=statist.getEndTime() != null ? statist.getEndTime() : "" %></td>
                                <td><%=statist.getCdrName() != null ? statist.getCdrName() : "" %></td>
                                <td><%=statist.getCdrType() != null ? statist.getCdrType() : "" %></td>
                                <td><%=statist.getCountMsisdn() != null ? statist.getCountMsisdn() : "" %></td>
                                <td><%=statist.getGenDate() != null ? statist.getGenDate() : "" %></td>
                            </tr>
                            <%
                                    }
                                }
                            } else {
                            %>
                            <tr>
                                <td colspan="7" style="text-align: center;">
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
                                            String pageUrl = "cdr-statist.jsp?staTime1="+staTime+"&endTime1="+endTime
                                                    +"&cdrName1="+cdrName+"&cdrType1="+cdrType+"&genDateFrom1="+genDateFrom
                                                    +"&genDateTo1="+genDateTo+"&p=";
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
        jQuery('.datetimepicker').datetimepicker({
            formatTime:'H:i',
            formatDate:'d.m.Y',
            step : 60
        });
        jQuery('.genDate').datetimepicker({
            timepicker : false,
            format:'Y-m-d'
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
