<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@ include file="../../../admin/include/header.jsp" %>     

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>DS các mã lỗi trong ngày</title>
        <link rel="stylesheet" href="../../../admin/login/resources/css/style.css" type="text/css" media="screen" /> 
        <script type="text/javascript" src="<%=request.getContextPath()%>/admin/login/resources/scripts/jquery-3.1.1.min.js"></script>
        <script type="text/javascript" src="../../../admin/login/resources/scripts/simpla.jquery.configuration.js"></script>
        <script type="text/javascript" src="../js/jquery-1.8.2.min.js"></script>
        <script type="text/javascript" src="../../../admin/login/resources/scripts/facebox.js"></script>
        <script type="text/javascript" src="../../../admin/login/resources/scripts/jquery.wysiwyg.js"></script>
        <link rel="stylesheet" href="<%=request.getContextPath()%>/admin/login/resources/css/jquery.datetimepicker.min.css" type="text/css" media="screen"/>
        <script type="text/javascript" src="<%=request.getContextPath()%>/admin/login/resources/scripts/jquery.datetimepicker.full.min.js"></script>
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
                <div class="content-box-content" >
                    <div class="content-box-header" style="padding: 15px;">
                        <label style="float: left;margin: 5px;">Ngày<span style="color: red;">(*)</span></label>
                        <input type="text" class="text-input datetimepickerFrom" name="staDateTopup" placeholder="Chọn ngày" id="staDateTopup"
                               style="height: 25px;border: 1px solid #ccc;border-radius: 2px;width: 150px;padding-left: 5px;float: left;">
                        <input style="    margin: 2px 10px !important;" type="button" value="load list rep topup" class="button" onclick="loadListRep('TOPUP')"/>
                    </div> <!-- End .content-box-header -->
                    <div id="frm-data-Topup" class="tab-content default-tab" >
                        <div hidden id="pnl-loading-topup">
                            <div style="text-align: center;">
                                <img alt="loading..." src="<%=request.getContextPath()%>/admin/images/icon/gear-loading-400x300.gif"> <br/> Loading...
                            </div>
                        </div>
                    </div>
                    <div class="clear"></div>
                    <div class="content-box-header" style="padding: 15px;">
                        <label style="float: left;margin: 5px;">Ngày<span style="color: red;">(*)</span></label>
                        <input type="text" class="text-input datetimepickerFrom" name="staDateCharge" placeholder="Chọn ngày" id="staDateCharge"
                               style="height: 25px;border: 1px solid #ccc;border-radius: 2px;width: 150px;padding-left: 5px;float: left;" >
                        <input  style="    margin: 2px 10px !important;"  type="button" value="load list rep charge" class="button" onclick="loadListRep('CHARGE')"/>
                    </div>

                    <div id="frm-data1-Charge" class="tab-content default-tab" >
                        <div hidden id="pnl-loading-charge">
                            <div style="text-align: center;">
                                <img alt="loading..." src="<%=request.getContextPath()%>/admin/images/icon/gear-loading-400x300.gif"> <br/> Loading...
                            </div>
                        </div>
                    </div>


                    <div class="clear"></div>
                    <div class="content-box-header" style="padding: 15px;">
                        <label style="float: left;margin: 5px;">Ngày<span style="color: red;">(*)</span></label>
                        <input type="text" class="text-input datetimepickerFrom" name="staDateMT" placeholder="Chọn ngày" id="staDateMT"
                               style="height: 25px;border: 1px solid #ccc;border-radius: 2px;width: 150px;padding-left: 5px;float: left;" >
                        <input  style="    margin: 2px 10px !important;" type="button" value="load list rep sentMt" class="button" onclick="loadListRep('MT')"/>
                    </div>
                    <div id="frm-data-mt" class="tab-content default-tab" >
                        <div hidden id="pnl-loading-mt">
                            <div style="text-align: center;">
                                <img alt="loading..." src="<%=request.getContextPath()%>/admin/images/icon/gear-loading-400x300.gif"> <br/> Loading...
                            </div>
                        </div>
                    </div>


                    <div class="clear"></div>
                    <div class="content-box-header" style="padding: 15px;">
                        <label style="float: left;margin: 5px;">Ngày<span style="color: red;">(*)</span></label>
                        <input type="text" class="text-input datetimepickerFrom" name="staDateCDR" placeholder="Chọn ngày" id="staDateCDR"
                               style="height: 25px;border: 1px solid #ccc;border-radius: 2px;width: 150px;padding-left: 5px;float: left;" >
                        <input  style="    margin: 2px 10px !important;" type="button" value="load list rep action cdr" class="button" onclick="loadListRep('CDR')"/>
                    </div>
                    <div id="frm-data-cdr" class="tab-content default-tab" >
                        <div hidden id="pnl-loading-cdr">
                            <div style="text-align: center;">
                                <img alt="loading..." src="<%=request.getContextPath()%>/admin/images/icon/gear-loading-400x300.gif"> <br/> Loading...
                            </div>
                        </div>
                    </div>
                            
                    <div class="clear"></div>
                    <div class="content-box-header" style="padding: 15px;">
                        <label style="float: left;margin: 5px;">Ngày<span style="color: red;">(*)</span></label>
                        <input type="text" class="text-input datetimepickerFrom" name="staDateMO" placeholder="Chọn ngày" id="staDateMO"
                               style="height: 25px;border: 1px solid #ccc;border-radius: 2px;width: 150px;padding-left: 5px;float: left;" >
                        <input  style="    margin: 2px 10px !important;" type="button" value="load list result MO" class="button" onclick="loadListRep('MO')"/>
                    </div>
                    <div id="frm-data-MO" class="tab-content default-tab" >
                        <div hidden id="pnl-loading-cdr">
                            <div style="text-align: center;">
                                <img alt="loading..." src="<%=request.getContextPath()%>/admin/images/icon/gear-loading-400x300.gif"> <br/> Loading...
                            </div>
                        </div>
                    </div>
                </div>
                <div class="clear"></div>
                <%@include file="../../../admin/include/footer.jsp" %>
            </div> 
        </div>
        <script type="text/javascript">
            jQuery(document).ready(function () {
                jQuery('#staDateTopup').datetimepicker({
                    format: 'd/m/Y',
                    timepicker: false
                });
                jQuery('#staDateCharge').datetimepicker({
                    format: 'd/m/Y',
                    timepicker: false
                });
                jQuery('#staDateMT').datetimepicker({
                    format: 'd/m/Y',
                    timepicker: false
                });
                jQuery('#staDateCDR').datetimepicker({
                    format: 'd/m/Y',
                    timepicker: false
                });
                jQuery('#staDateMO').datetimepicker({
                    format: 'd/m/Y',
                    timepicker: false
                });
            });
            var data = {};
            function loadListRep(actionData) {
                data['actionData'] = actionData;
                if (actionData == 'TOPUP') {
                    $('#pnl-loading-topup').show();
                    data['staDate'] = $('input[name=staDateTopup]').val().trim();
                    $('#frm-data-Topup').load('<%=request.getContextPath()%>/cms/splus/demo/loadListRep.jsp', data, function () {
                        $('#pnl-loading-topup').hide();
                    });
                } else if (actionData == 'CHARGE') {
                    $('#pnl-loading-charge').show();
                    data['staDate'] = $('input[name=staDateCharge]').val().trim();
                    $('#frm-data1-Charge').load('<%=request.getContextPath()%>/cms/splus/demo/loadListRep.jsp', data, function () {
                        $('#pnl-loading-charge').hide();
                    });
                } else if (actionData == 'MT') {
                    $('#pnl-loading-mt').show();
                    data['staDate'] = $('input[name=staDateMT]').val().trim();
                    $('#frm-data-mt').load('<%=request.getContextPath()%>/cms/splus/demo/loadListRep.jsp', data, function () {
                        $('#pnl-loading-mt').hide();
                    });
                } else if (actionData == 'CDR') {
                    $('#pnl-loading-cdr').show();
                    data['staDate'] = $('input[name=staDateCDR]').val().trim();
                    $('#frm-data-cdr').load('<%=request.getContextPath()%>/cms/splus/demo/loadListRep.jsp', data, function () {
                        $('#pnl-loading-cdr').hide();
                    });
                } else if (actionData == 'MO') {
                    $('#pnl-loading-cdr').show();
                    data['staDate'] = $('input[name=staDateMO]').val().trim();
                    $('#frm-data-MO').load('<%=request.getContextPath()%>/cms/splus/demo/loadListRep.jsp', data, function () {
                        $('#pnl-loading-cdr').hide();
                    });
                }
            }

        </script>

    </body>
</html>