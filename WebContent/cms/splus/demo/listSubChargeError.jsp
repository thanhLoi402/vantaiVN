<%@page import="java.util.List"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<jsp:useBean id="transPaymentDAO" class="tdt.db.viettel.splus.monitor.TransPaymentDAO" scope="session"></jsp:useBean>
<jsp:useBean id="userServiceDAO" class="tdt.db.viettel.splus.monitor.UserServiceDAO" scope="session"></jsp:useBean>
<%@ page import="tdt.db.vas.viettel.splus.user.service.TransPayment" %>
<%@ page import="tdt.db.vas.viettel.splus.user.service.UserService" %>
<%@ page import="java.text.DecimalFormat" %>
<%@ include file="../../../admin/include/header.jsp" %>     
<%    int crPage = 1;
    int rowsPerPage = 20;
    //subsBaseId, levelName, minPoint, maxPoint, levelRate,
    request.setCharacterEncoding("utf-8");
    response.setCharacterEncoding("utf-8");
    try {
        crPage = Integer.parseInt(request.getParameter("page"));
    } catch (Exception ex) {
    }
    try {
        rowsPerPage = Integer.parseInt(request.getParameter("rp"));
    } catch (Exception ex) {
    }
    List<TransPayment> lstItems = transPaymentDAO.getListTransPaymentError();
//    List<UserService> lstItems2 = userServiceDAO.getListUserServiceError();
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Check charge error for topup trans id</title>
        <link rel="stylesheet" href="../../../admin/login/resources/css/style.css" type="text/css" media="screen" /> 
        <script type="text/javascript" src="../js/jquery-1.8.2.min.js"></script>
        <script type="text/javascript" src="../../../admin/login/resources/scripts/simpla.jquery.configuration.js"></script>
        <script type="text/javascript" src="../../../admin/login/resources/scripts/facebox.js"></script>
        <script type="text/javascript" src="../../../admin/login/resources/scripts/jquery.wysiwyg.js"></script>
        <style type="text/css">
            body { margin: 0; 
            }
            #shade, #modal {display: none;}
            #shade { position: fixed; z-index: 100; top: 0; left: 0; width: 100%; height: 100%; }
            #modal { position: fixed; z-index: 101; top: 50%; left: 50%; }
            #shade { background: silver; opacity: 0.5; filter: alpha(opacity=50); }

            #popUpDetail {
                width:auto;
                height:310px;
                opacity: 0.95;
                top:20%;
                left:30%;
                display:none; 
                position:fixed;
                background-color: #E4DFDB;
            }

            .table-striped
            {
                border-collapse: separate !important;
                border-spacing: 1px;
            }

            .table-striped > tfoot > tr:first-child > td
            {
                border-top: 1px solid #C6C6C6; 
            }

            .table-striped > tbody > tr:nth-child(odd) 
            {
                background: #f3f3f3 !important;
            }

            ul
            {
                list-style: outside none none;
            }

            ul li a.shortcut-button
            {
                border-radius: 6px;
            }

            ul li a.shortcut-button span
            {
                border-radius: 7px;
            }
        </style>
    </head>
    <body>
        <div hidden id="pnl-loading">
            <div style="text-align: center;">
                <img alt="loading..." src="<%=request.getContextPath()%>/admin/images/icon/gear-loading-400x300.gif">
                <br/>
                Loading...
            </div>
        </div>
        <div id="body-wrapper"> <!-- Wrapper for the radial gradient background -->
            <jsp:include page="../../../admin/include/left.jsp" />
            <div id="main-content"> <!-- Main Content Section with everything -->
                <div id="shade"></div>
                <div id="modal">
                    <img alt="processing..." src="<%=request.getContextPath()%>/admin/images/icon/cricle-loading-50x50.gif">
                    Processing...
                </div>					
                <!-- Page Head -->
                <%@ include file="../../../admin/include/tool.jsp" %>
                <div class="clear"></div>
                <h2 align="center">Check charge error for topup trans id</h2>
                <div class="clear"></div>
                <div class="content-box">
                    <div class="content-box-header" style="padding-top: 3px;">
                    </div>

                    <div class="content-box-content">
                        <div id="frm-data" class="tab-content default-tab" >
                            <table class="table-striped" style="font-size: 12px !important; width: 100%; color: black; ">
                                <thead>
                                    <tr class="header" bgcolor="c6c6c6" align="center">
                                        <th>STT</th>
                                        <th>msisdnId</th>
                                        <th>Số tiền nợ trong user_service</th>
                                        <th>Số tiền nợ trong SP_trans_payment</th>
                                    </tr>
                                </thead>
                                <tfoot>
                                    <tr>
                                    </tr>
                                </tfoot>
                                <tbody>
                                    <%
                                        int index = 1;
                                        if (lstItems != null && lstItems.size() > 0) {
                                            for (TransPayment item : lstItems) {
                                    %>
                                    <tr class="list">
                                        <td style="width: 30px; text-align: center;"><b><%=(crPage - 1) * rowsPerPage + index%></b></td>
                                        <td style="text-align: center;"><%=item.getMsisdnId()%> </td>
                                        <td style="text-align: center;"><%=item.getDebt()%> </td>
                                        <td style="text-align: left;"><%=item.getErrorMoney()%> </td>
                                    </tr>
                                    <%
                                                index = index + 1;
                                            }
                                        }
                                    %>
                                </tbody>
                            </table>
                        </div>
                                
                    </div>
                </div>
                <div class="clear"></div>
                <%@include file="../../../admin/include/footer.jsp" %>
            </div> 
        </div>
    </body>
</html>