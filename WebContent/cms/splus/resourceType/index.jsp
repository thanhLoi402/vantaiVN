<%@page import="tdt.db.vas.viettel.splus.conf.ConfSubsBase"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<jsp:useBean id="resourceTypeDAO" class="tdt.db.vas.viettel.splus.conf.ResourceTypeDAO" scope="session"></jsp:useBean>
<%@page import="tdt.db.vas.viettel.splus.conf.ResourceType"%>
<%@page import="tdt.db.adm.AdminLog"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@ include file="../../../admin/include/header.jsp" %>   

<%    request.setCharacterEncoding("utf-8");
    int crPage = 1;
    int rowsPerPage = 30;
    String strErrMsg = "";
    SimpleDateFormat format = new SimpleDateFormat("dd/MM/YYYY hh:mm:ss");
    ResourceType resourceType = new ResourceType();
    ResourceType resourceTypePopup = new ResourceType();
    String sId = request.getParameter("id");
    Long id = 0L;
    if (sId != null && !sId.trim().equals("")) {
        id = Long.parseLong(sId);
    }
    String sAction = request.getParameter("action");
    boolean isOK = false;
    boolean validateData = true;
    boolean showPopup = false;
    if (id != null && id.compareTo(0L) != 0) {
        if (sAction != null && sAction.equals("openPopup")) {
            resourceTypePopup = resourceTypeDAO.getRow(id);
            showPopup = true;
        } else {
            resourceType = resourceTypeDAO.getRow(id);
        }
        if (resourceType == null) {
            resourceType = new ResourceType();
        }
    }
    if (sAction != null && sAction.equals("SAVE")) {
        try {
            if (!curPageIsInsert || !curPageIsUpdate) {
                response.sendRedirect(request.getContextPath() + "/admin/access/");
                return;
            }
            String rsName = request.getParameter("rsName");
            String rsCode = request.getParameter("rsCode");
            String rsUnit = request.getParameter("rsUnit");
            String description = request.getParameter("description");
            if (id != null && id.compareTo(0L) > 0) {
                resourceType.setId(id);
            }
            resourceType.setRsName(rsName);
            resourceType.setRsCode(rsCode);
            resourceType.setRsUnit(rsUnit);
            resourceType.setDescription(description);
            resourceType.setCreatedBy(adm_control.getUserName());
            resourceType.setUpdatedBy(adm_control.getUserName());
            if (!resourceTypeDAO.checkDulicateCode(resourceType.getId(), resourceType.getRsCode())) {
                validateData = false;
                strErrMsg = "Mã trên đã được định nghĩa trên hệ thống";
            }
            if (validateData) {
                if (resourceType.getId() == null || resourceType.getId().compareTo(0L) == 0) {
                    isOK = resourceTypeDAO.insertRow(resourceType);
                } else {
                    isOK = resourceTypeDAO.updateRow(resourceType);
                }
                if (isOK) {
                    String strDescription = resourceType.getId() == null || resourceType.getId().compareTo(0L) == 0 ? "Thêm mới " : "Cập nhật " + "cấu hình gói cước cơ bản " + rsName;
                    adminLogDAO.insertRow(session.getAttribute("datavasosp.adm.username").toString(), strDescription, resourceType.getId() == null || resourceType.getId().compareTo(0L) == 0 ? AdminLog.TYPE_INSERT : AdminLog.TYPE_UPDATE);
                    resourceType = new ResourceType();
                    strErrMsg = "Lưu dữ liệu thành công";
                } else {
                    strErrMsg = "Lưu dữ liệu không thành công";
                }
            }
        } catch (Exception e) {
            strErrMsg = "Lưu dữ liệu không thành công";
        }
        if (isOK) {
            out.println("<script type=\"text/javascript\">alert('" + strErrMsg + "'); window.location.href='index.jsp'; </script>");
        } else {
            out.println("<script type=\"text/javascript\">alert('" + strErrMsg + "');</script>");
        }
    }
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Cấu hình gói dịch vụ</title>
        <link rel="stylesheet" href="../../../admin/login/resources/css/style.css" type="text/css" media="screen" /> 
        <script type="text/javascript" src="../js/jquery-1.8.2.min.js"></script>
        <script type="text/javascript" src="../../../admin/login/resources/scripts/simpla.jquery.configuration.js"></script>
        <script type="text/javascript" src="../../../admin/login/resources/scripts/facebox.js"></script>
        <script type="text/javascript" src="../../../admin/login/resources/scripts/jquery.wysiwyg.js"></script>
        <style type="text/css">
            body { margin: 0; }
            #shade, #modal {display: none;}
            #shade { position: fixed; z-index: 100; top: 0; left: 0; width: 100%; height: 100%; }
            #modal { position: fixed; z-index: 101; top: 50%; left: 50%; }
            #shade { background: silver; opacity: 0.5; filter: alpha(opacity=50); }

            #popUpDetail {
                width:auto;
                height:280px;
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
                <div style="font-family: Arial, Helvetica, sans-serif; border: 1px solid #d5d5d5; padding: 4px; ">Chọn loại cấu hình:  
                    <select name="confType" id="confType"  onchange="choseConfType()" style="width: 315px;"  >
                        <option value="1" >Cấu hình loại tài nguyên</option>
                        <option value="2" >Cấu hình phạm vi tài nguyên</option>
                        <option value="3" >Cấu hình gói dịch vụ</option>
                    </select>
                </div>
                <div class="clear"></div> <!-- End .clear -->
                <h2 align="center">Cấu hình loại tài nguyên</h2>
                <div class="clear"></div> <!-- End .clear -->
                <div class="content-box"><!-- Start Content Box -->
                    <div class="content-box-header" style="padding-top: 3px;">
                        <form method="post" name="frmAdd">
                            <input type="hidden" name="action" id="action"/>
                            <table width="100%" cellpadding="4" cellspacing="4" >	
                                <tr>
                                    <td width="20%" class="header" >
                                        <label>Tên tài nguyên<span style="color: red;">(*)</span></label> 
                                    </td>
                                    <td >
                                        <input style="width: 300px;" value="<%=resourceType.getRsName() != null ? resourceType.getRsName() : ""%>"  name="rsName" maxlength="100" id="rsName" class="text-input" type="text"  /> 
                                    </td>
                                    <td width="20%" class="header">
                                        <label>Mã tài nguyên<span style="color: red;">(*)</span></label> 
                                    </td>
                                    <td>
                                        <input style="width: 300px;" value="<%=resourceType.getRsCode() != null ? resourceType.getRsCode() : ""%>"  name="rsCode" maxlength="20" id="rsCode" class="text-input" type="text"  /> 
                                    </td>
                                </tr>
                                <tr>
                                    <td width="20%" class="header" >
                                        <label>Đơn vị<span style="color: red;">(*)</span></label> 
                                    </td>
                                    <td >
                                        <input style="width: 300px;" value="<%=resourceType.getRsUnit() != null ? resourceType.getRsUnit() : ""%>"  name="rsUnit" maxlength="100" id="rsUnit" class="text-input" type="text"  /> 
                                    </td>
                                    <td width="20%" class="header" >
                                    </td>
                                    <td >
                                    </td>
                                </tr>
                                <tr>
                                    <td width="20%" class="header" >
                                        <label>Mô tả</label> 
                                    </td>
                                    <td colspan="3">
                                        <textarea name="description" id="description" style="min-width: 100%" cols="3" ><%=resourceType.getDescription() != null ? resourceType.getDescription() : ""%></textarea> 
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="4" align="center">
                                        <input class="button" style="width: 80px;" type="button" id="btnSearch" onclick="fnFilter()" value=" Tìm kiếm "/>
                                        <%if (curPageIsInsert || curPageIsUpdate) { %>
                                        <input class="button" style="width: 80px;" type="button" id="buttonId" onclick="submitForm()" value=" Lưu "/>
                                        <%}%>
                                        <!--<input class="button" type="button" value="Quay lại" onclick="clearForm()"/>-->
                                    </td>
                                </tr>
                            </table>
                        </form>
                    </div> <!-- End .content-box-header -->
                    <div id="popUpDetail">
                        <img id="close"
                             src="<%=request.getContextPath()%>/admin/images/3.png"
                             onclick="div_hide()">
                        <table class=""  >
                            <tr>
                                <td align="right" style="width: 200px;" >Tên tài nguyên: </td>
                                <td style="min-width: 200px;" >
                                    <%=resourceTypePopup.getRsName() != null ? resourceTypePopup.getRsName() : ""%>
                                </td>
                            </tr>
                            <tr>
                                <td align="right" >Mã tài nguyên: </td>
                                <td>
                                    <%=resourceTypePopup.getRsCode() != null ? resourceTypePopup.getRsCode() : ""%>
                                </td>
                            </tr>
                            <tr>
                                <td align="right">Đơn vị: </td>
                                <td>
                                    <%=resourceTypePopup.getRsUnit() != null ? resourceTypePopup.getRsUnit() : ""%>
                                </td>
                            </tr>
                            <tr>
                                <td align="right">Mô tả: </td>
                                <td>
                                    <%=resourceTypePopup.getDescription() != null ? resourceTypePopup.getDescription() : ""%>
                                </td>
                            </tr>
                            <tr>
                                <td align="right">User tạo: </td>
                                <td>
                                    <%=resourceTypePopup.getCreatedBy() != null ? resourceTypePopup.getCreatedBy() : ""%>
                                </td>
                            </tr>
                            <tr>
                                <td align="right">Ngày tạo: </td>
                                <td>
                                    <%=resourceTypePopup.getGenDate() != null ? format.format(resourceTypePopup.getGenDate()) : ""%>
                                </td>
                            </tr>
                            <tr>
                                <td align="right">User cập nhật: </td>
                                <td>
                                    <%=resourceTypePopup.getUpdatedBy() != null ? resourceTypePopup.getUpdatedBy() : ""%>
                                </td>
                            </tr>
                            <tr>
                                <td align="right">Ngày cập nhật: </td>
                                <td>
                                    <%=resourceTypePopup.getLastUpdate() != null ? format.format(resourceTypePopup.getLastUpdate()) : ""%>
                                </td>
                            </tr>
                            <tr>
                                <td colspan="2" style="text-align: center;">
                                    <input
                                        class="button" type="button" value="Đóng"
                                        onclick="div_hide()" />
                                </td>
                            </tr>
                        </table>
                        <!-- Popup Div Ends Here -->
                    </div>

                    <div class="content-box-content">
                        <div id="frm-data" class="tab-content default-tab" > <!-- This is the target div. id must match the href of this div's tab -->
                            <div style="text-align: center;">
                                <img alt="loading..." src="<%=request.getContextPath()%>/admin/images/icon/gear-loading-400x300.gif">
                                <br/>
                                Loading...
                            </div>
                        </div> <!-- End #tab1 -->
                    </div> <!-- End .content-box-content -->
                </div> 
                <div class="clear"></div>
                <%@include file="../../../admin/include/footer.jsp" %>
            </div> 
        </div>
        <script type="text/javascript">
            <%if (showPopup) {%>
            document.getElementById('popUpDetail').style.display = "block";
            <%} else {%>
            document.getElementById('popUpDetail').style.display = "none";
            <%}%>
            var data = {};
            $('#body-wrapper').keypress(function (e) {
                if (e.keyCode == 13) {
                    e.preventDefault();
                    $("#btn-search").click();
                }
            });
            
            document.getElementById("confType").value = 1;
            
            function choseConfType() {
                if (document.getElementById("confType").value == 1) {
                    window.location.href='index.jsp'
                } else if (document.getElementById("confType").value == 2) {
                    window.location.href='../resourceScope/index.jsp'
                }else{
                    window.location.href='../resourcePackage/index.jsp'
                }
            }
            
            
            function loadData(rsName, rsCode, rsUnit, description, page, rp) {
                //var data = {};
                data['rsName'] = rsName;
                data['rsCode'] = rsCode;
                data['rsUnit'] = rsUnit;
                data['description'] = description;
                data['page'] = page;
                data['rp'] = rp;
                var timer = setTimeout(timeoutFumction, 8000);
                $('#frm-data').html($('#pnl-loading').html());
                $.post('_listResourType.jsp', data, function (res) {
                    $('#frm-data').html(res);
                    clearTimeout(timer);
                });
            }
            ;

            function fnFilter() {
                loadData($('#rsName').val(), $('#rsCode').val(), $('#rsUnit').val(), $('#description').val(), 1, '<%=rowsPerPage%>');
            }
            <%if (curPageIsDelete) { %>
            function requestDeleteResourType(id) {
                var datar = {};
                datar['id'] = id;
                datar['rsTypeId'] = id;
                $.ajax({
                    method: "POST",
                    url: "_getSubsBaseAndPackage.jsp",
                    data: datar,
                    dataType: 'json',
                    timeout: 8000,
                    beforeSend: function () {
                    },
                    success: function (respData) {
                        if (respData.isDelete) {
                            $.ajax({
                                method: "POST",
                                url: "_deleteResourType.jsp",
                                data: datar,
                                dataType: 'json',
                                timeout: 8000,
                                beforeSend: function () {
                                    $('#shade').show();
                                    $('#modal').show();
                                },
                                success: function (respData) {
                                    if (respData.isDelete) {
                                        alert('Xóa bản ghi thành công!.');
                                        loadData(data.rsName, data.rsCode, data.rsUnit, data.description, data.page, data.rp);
                                    } else {
                                        alert('Xóa dữ liệu không thành công!.');
                                    }
                                    $('#shade').hide();
                                    $('#modal').hide();
                                },
                                complete: function () {
                                    $('#shade').hide();
                                    $('#modal').hide();
                                },
                                error: function (x, t, m) {
                                    if (t == "timeout") {
                                        alert('Xóa dữ liệu không thành công!. Xin hãy thử lại sau.');
                                    }
                                }
                            });
                        } else {
                            alert('Bản ghi có liên kết dữ liệu, không thể xóa');
                        }
                    },
                    complete: function () {
                    },
                    error: function (x, t, m) {
                        if (t == "timeout") {
                            alert('Hệ thống lỗi, thực hiện lại');
                        }
                    }
                });
            }
            ;
            <%}%>

            $(function () {
                loadData('', '', '', '', '<%=crPage%>', '<%=rowsPerPage%>');
            });

            function submitForm() {
                if (validateForm()) {
                    document.frmAdd.action.value = 'SAVE';
                    document.frmAdd.submit();
                    $('#buttonId').hide();
                }
            }
            ;
            function validateForm() {
                var rsName = document.getElementById("rsName").value;
                if (rsName == null || rsName.trim() == '') {
                    alert('Bạn chưa nhập tên tài nguyên!');
                    $('#rsName').focus();
                    return;
                }
                var rsCode = document.getElementById("rsCode").value;
                if (rsCode == null || rsCode.trim() == '') {
                    alert('Bạn chưa nhập mã tài nguyên!');
                    $('#rsCode').focus();
                    return;
                }
                var rsUnit = document.getElementById("rsUnit").value;
                if (rsUnit == null || rsUnit.trim() == '') {
                    alert('Bạn chưa nhập đơn vị tài nguyên!');
                    $('#rsUnit').focus();
                    return;
                }
                var description = document.getElementById("description").value;
                if (description != null && description.trim() != '') {
                    if (document.getElementById("description").value.length > 100) {
                        alert('Mô tả không được vượt quá 100 ký tự!');
                        $('#description').focus();
                        return false;
                    }
                }
                return true;
            }
            ;
            function clearForm() {
                document.getElementById("action").value = "";
                document.getElementById("creditId").value = "0";
                document.getElementById("refPoint").value = "";
                document.getElementById("minValue").value = "";
                document.getElementById("maxValue").value = "";
            }
            ;

            function div_hide() {
                document.getElementById('popUpDetail').style.display = "none";
                window.location.href='index.jsp';
            }

            function isNumber(n) {
                return !isNaN(parseFloat(n));
            }
        </script>
    </body>
</html>