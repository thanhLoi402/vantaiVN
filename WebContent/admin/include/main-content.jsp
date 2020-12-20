<%@page import="tdt.db.adm.Admin" %>
<%@page import="tdt.util.DateProc" %>
<%@page import="tdt.db.adm.AdminAccessLog" %>
<%@page import="tdt.listener.SessionCounterListener" %>
<%@ page import="com.google.gson.JsonArray" %>
<%@ page import="tdt.util.DateTime" %>
<%@ page import="java.text.DecimalFormat" %>
<%@ page import="java.text.Format" %>
<%@ page language="java" pageEncoding="utf-8" %>
<%
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

    <%@include file="footer.jsp" %>

</div>
<!-- End #main-content -->