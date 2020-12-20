<%@page import="java.util.List"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="tdt.db.adm.AdminLog"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@ include file="../../../../admin/include/header.jsp" %>    
<%    request.setCharacterEncoding("utf-8");
    int crPage = 1;
    int rowsPerPage = 30;
    boolean checkExcuteDL = false; 
    if(session.getAttribute("datavasosp.adm.username").toString().equals("loint")){
        checkExcuteDL = true;
    }
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Ex</title>
        <link rel="stylesheet" href="<%=request.getContextPath()%>/admin/login/resources/css/style.css" type="text/css" media="screen" /> 
        <script type="text/javascript" src="<%=request.getContextPath()%>/cms/splus/js/jquery-1.8.2.min.js"></script>
        <script type="text/javascript" src="<%=request.getContextPath()%>/admin/login/resources/scripts/simpla.jquery.configuration.js"></script>
        <script type="text/javascript" src="<%=request.getContextPath()%>/admin/login/resources/scripts/facebox.js"></script>
        <script type="text/javascript" src="<%=request.getContextPath()%>/admin/login/resources/scripts/jquery.wysiwyg.js"></script>
        <style type="text/css">
            body { margin: 0; 
            }
            #shade, #modal {display: none;}
            #shade { position: fixed; z-index: 100; top: 0; left: 0; width: 100%; height: 100%; }
            #modal { position: fixed; z-index: 101; top: 50%; left: 50%; }
            #shade { background: silver; opacity: 0.5; filter: alpha(opacity=50); }

            #popUpDetail {
                width:auto;
                height:270px;
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
            <jsp:include page="../../../../admin/include/left.jsp" />
            <div id="main-content"> <!-- Main Content Section with everything -->
                <div id="shade"></div>
                <div id="modal">
                    <img alt="processing..." src="<%=request.getContextPath()%>/admin/images/icon/cricle-loading-50x50.gif">
                    Processing...
                </div>					
                <!-- Page Head -->
                <%@ include file="../../../../admin/include/tool.jsp" %>
                <div class="clear"></div>
                <h2 align="center">Ex</h2>
                <div class="clear"></div>
                <div class="content-box">
                    <%if(checkExcuteDL){ %>
                    <div class="content-box-header" style="padding-top: 3px;">
                        <form method="post" name="frmAdd">
                            <input type="hidden" name="action" id="action"/>
                            <table width="100%" cellpadding="4" cellspacing="4" >	
                                <tr>
                                    <td width="20%" class="header" >
                                        <label>Sql<span style="color: red;">(*)</span></label> 
                                    </td>
                                    <td colspan="3">
                                        <textarea name="sql"   id="sql" style=" height: 125px;" cols="5" ></textarea> 
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <input type="button" value="excute qsl" class="button" onclick="fnFilter();"/>
                                    </td>
                                </tr>
                            </table>
                        </form>
                    </div> <!-- End .content-box-header -->
                    <%}else{%>
                    <h2 align="center">KO NGHỊCH ĐƯỢC ĐÂU NHÁ</h2>
                    <%}%>
                    <div class="content-box-content">
                        <div id="frm-data" class="tab-content default-tab" > <!-- This is the target div. id must match the href of this div's tab -->
                        </div> <!-- End #tab1 -->
                    </div> <!-- End .content-box-content -->
                </div> <!-- End .content-box -->
                <div class="clear"></div>
                <%@include file="../../../../admin/include/footer.jsp" %>
            </div> 
        </div>
        <script type="text/javascript">
            var data = {};
            $('#body-wrapper').keypress(function (e) {
                if (e.keyCode == 13) {
                    e.preventDefault();
                    $("#btn-search").click();
                }
            });

            function loadData(sql, page, rp) {
                data['sql'] = sql;
                data['page'] = page;
                data['rp'] = rp;
                $('#frm-data').html($('#pnl-loading').html());
                $.post('_listResult.jsp', data, function (res) {
                    $('#frm-data').html(res);
                });
            }
            ;

            function fnFilter() {
                loadData($('#sql').val(), 1, '<%=rowsPerPage%>');
            }

        </script>
    </body>
</html>