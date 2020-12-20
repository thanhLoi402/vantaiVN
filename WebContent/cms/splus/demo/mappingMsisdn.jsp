<%@page import="tdt.db.vas.viettel.splus.conf.MappingMsisdnId"%>
<%@page import="tdt.db.vas.viettel.splus.conf.MappingMsisdnIdDAO"%>
<%@ page import="tdt.db.vas.viettel.splus.cdr.CdrTopupQueue" %>
<%@ page import="tdt.db.vas.viettel.splus.cdr.CdrTopupQueueDAO" %>
<%@ page import="java.sql.Timestamp" %>
<%@page language="java" pageEncoding="utf-8" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
        <title>Mapping msisdn</title>
        <link rel="icon" href="<%=request.getContextPath()%>/images/icon/admin.ico" type="image/x-icon"/>
        <link rel="stylesheet" href="<%=request.getContextPath()%>/admin/login/resources/css/reset.css" type="text/css" media="screen"/>
        <link rel="stylesheet" href="<%=request.getContextPath()%>/admin/login/resources/css/style.css" type="text/css" media="screen"/>
        <link rel="stylesheet" href="<%=request.getContextPath()%>/admin/login/resources/css/invalid.css" type="text/css" media="screen"/>
        <link rel="stylesheet" href="<%=request.getContextPath()%>/admin/login/resources/css/jquery.datetimepicker.min.css" type="text/css" media="screen"/>
        <script type="text/javascript" src="<%=request.getContextPath()%>/admin/login/resources/scripts/jquery-3.1.1.min.js"></script>
        <script type="text/javascript" src="<%=request.getContextPath()%>/admin/login/resources/scripts/jquery.datetimepicker.full.min.js"></script>
        <style>
            .text-input {
                margin-right: 5px;
            }
            select {
                width: 157px;
                margin-top: 5px;
                margin-right: 5px;
            }
        </style>
    </head>
    <%@ include file="/admin/include/header.jsp" %>
    <%    response.setCharacterEncoding("utf-8");
        request.setCharacterEncoding("utf-8");
        String resultInsertTopup = "";
        
        String sAction = request.getParameter("action");
        System.out.println("sAction:"+ sAction);
        if(sAction==null) sAction="";
        
        String msisdnIdOsp = request.getParameter("msisdnIdOsp");
        if (msisdnIdOsp == null) {
            msisdnIdOsp = "";
        } else {
            msisdnIdOsp = msisdnIdOsp.trim();
        }
        String msisdnIdVT = request.getParameter("msisdnIdVT");
        if (msisdnIdVT == null) {
            msisdnIdVT = "";
        } else {
            msisdnIdVT = msisdnIdVT.trim();
        }
        MappingMsisdnIdDAO mappingMsisdnIdDAO = new MappingMsisdnIdDAO();
        if ((sAction.equals("SEARCH")) && (!"".equals(msisdnIdOsp) || !"".equals(msisdnIdVT))) {
            try {
                MappingMsisdnId mappingMsisdnId = null;
                
                if (!"".equals(msisdnIdOsp)) {
                    mappingMsisdnId = mappingMsisdnIdDAO.getMappingMsisdnFromOspIdWithPartition(msisdnIdOsp);
                } else if (!"".equals(msisdnIdVT)) {
                    mappingMsisdnId = mappingMsisdnIdDAO.getMappingMsisdnFromVTIdWithPartition(msisdnIdVT);
                } else {
                    out.println("<script type=\"text/javascript\">alert('DL không được để trống');</script>");
                }

                if (mappingMsisdnId != null && mappingMsisdnId.getMsisdnIdOsp() != null && mappingMsisdnId.getMsisdnIdVT() != null) {
                    msisdnIdVT = mappingMsisdnId.getMsisdnIdVT();
                    msisdnIdOsp = mappingMsisdnId.getMsisdnIdOsp();
                } else {
                    out.println("<script type=\"text/javascript\">alert('Không tìm được mã trên hệ thống');</script>");
                }
            } catch (Exception e) {
                out.println("<script type=\"text/javascript\">alert('Có lỗi: " + e.getMessage() + "');</script>");
                e.printStackTrace();
            }
        }else if(sAction.equals("DELETE_VT")){
            if(mappingMsisdnIdDAO.deleteMappingVT(msisdnIdVT)){
                out.println("<script type=\"text/javascript\">alert('Xóa mappingVT thành công');</script>");
            }else{
                out.println("<script type=\"text/javascript\">alert('Xóa mappingVT thất bại');</script>");
            }
        
        }else if(sAction.equals("DELETE")){
            if(mappingMsisdnIdDAO.deleteMapping(msisdnIdOsp)){
                out.println("<script type=\"text/javascript\">alert('Xóa mapping thành công');</script>");
            }else{
                out.println("<script type=\"text/javascript\">alert('Xóa mapping thất bại');</script>");
            }
        
        }
    %>
    <body>
        <div id="body-wrapper"> <!-- Wrapper for the radial gradient background -->
            <jsp:include page="/admin/include/left.jsp"/>
            <div id="main-content" style="padding: 15px;"> <!-- Main Content Section with everything -->
                <%@ include file="/admin/include/tool.jsp" %>
                <div class="clear"></div>
                <!-- Page Head -->
                <div class="content-box" style="padding: 15px;"><!-- Start Content Box -->
                    <span align="center" style="font-size: 15px;margin: 15px; font-weight: bold">MAPPING MSISDN</span>
                    <form method="post" name="frmList" style="padding: 15px;">
                        <input type="hidden" name="action"/>
                        <label for="msisdnId">MSISDN_OSP</label>
                        <input type="text" id="msisdnIdOsp" class="text-input small-input" name="msisdnIdOsp" value="<%=msisdnIdOsp%>" placeholder="Nhập MSISDN_ID_OSP" style="margin-bottom: 15px;"/>
                        <div class="clear"></div>
                        <label for="msisdnIdVT">MSISDN_VT</label>
                        <input type="text" id="msisdnIdVT" class="text-input small-input" name="msisdnIdVT" value="<%=msisdnIdVT%>" placeholder="Nhập MSISDN_ID_VT" style="margin-bottom: 15px;"/>
                        <div class="clear"></div>
                        <input type="button" value="Submit" class="button" onclick="searchMapping();" />
                        <input type="button" value="DELETEMappingVT" class="button" onclick="deleteMappingVT();"/>
                        <input type="button" value="DELETEMapping" class="button" onclick="deleteMapping();"/>
                    </form>
                </div> <!-- End .content-box -->
                <%@include file="/admin/include/footer.jsp" %>
            </div>
        </div>
    </body>
    <script type="text/javascript">
    
  	function deleteMappingVT(){
  		document.frmList.action.value='<%="DELETE_VT"%>';
  		document.frmList.submit();
  	}
  	function deleteMapping(){
  		document.frmList.action.value='<%="DELETE"%>';
  		document.frmList.submit();
  	}
  	function searchMapping(){
  		document.frmList.action.value='<%="SEARCH"%>';
  		document.frmList.submit();
  	}
  </script>
</html>
