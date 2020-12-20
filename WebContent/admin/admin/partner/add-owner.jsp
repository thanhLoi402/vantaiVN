<%@page import="tdt.db.service.vas.partner.PartnerOwner"%>
<%@page import="tdt.util.StringTool"%>
<%@ page language="java" pageEncoding="utf-8"%>
<%@page import="tdt.db.adm.*"%>
<%@page import="java.math.*"%>
<%@page import="java.io.*"%>
<%@page import="tdt.util.Md5"%>
<%@page import="tdt.util.DateProc"%>
<jsp:useBean id="adminDAO" class="tdt.db.adm.AdminDAO" scope="session" />
<jsp:useBean id="partnerOwnerDAO" class="tdt.db.service.vas.partner.PartnerOwnerDAO" scope="session" />
<%@ include file="../../include/header.jsp" %>
<% 
		response.setCharacterEncoding("utf-8");
  		request.setCharacterEncoding("utf-8");

  		String sId = request.getParameter("id");
  		if(sId==null)sId = "";
  		String sAction = request.getParameter("action");
  		if(sAction==null)sAction = "";

		String cpName = request.getParameter("cpName");
		if(cpName==null)cpName = "";
		String username = request.getParameter("username");
		if(username==null)username = "";
		String status = request.getParameter("status");
		if(status==null)status = "0";
  		
  		PartnerOwner objPartner = null;
  		
  		
	    if(sId.length()>0){
  			try{
  				objPartner = partnerOwnerDAO.getRow(new BigDecimal(sId));
  			}catch(Exception ex){}
  		}
  		boolean isOK = false;
  		System.out.println("==>"+sAction);
  		if(sAction.equals("ADD")){
  			if(!curPageIsInsert){
				response.sendRedirect(request.getContextPath()+"/admin/access/");
				return;
			}
  			objPartner = new PartnerOwner();
  			objPartner.setCpName(cpName);
  			objPartner.setUsrname(username.trim().toLowerCase());
  			objPartner.setPwd(Md5.Hash("123456"));
  			objPartner.setStatus(Integer.parseInt(status));
  			objPartner.setCreatedBy(session.getAttribute("datavasosp.adm.username").toString());
			isOK = partnerOwnerDAO.insertRow(objPartner);
  			if(isOK){ 
  				String description = "Thêm mới đối tác " + username;
				adminLogDAO.insertRow(session.getAttribute("datavasosp.adm.username").toString(), description, AdminLog.TYPE_INSERT);
  				out.println("<script type=\"text/javascript\">alert('Tạo mới thành công');window.location.href='owner.jsp';</script>");
  			}else out.println("<script type=\"text/javascript\">alert('Tạo mới không thành công');history.go(-1);</script>");
  		}
  		if(sAction.equals("EDIT")){
  			if(!curPageIsUpdate){
				response.sendRedirect(request.getContextPath()+"/admin/access/");
				return;
			}
  			objPartner = new PartnerOwner();
  			objPartner.setCpName(cpName);
  			objPartner.setUsrname(username.trim().toLowerCase());
  			objPartner.setStatus(Integer.parseInt(status));
  			objPartner.setUpdatedBy(session.getAttribute("datavasosp.adm.username").toString());
  			objPartner.setStatus(Integer.parseInt(status));
			objPartner.setId(new BigDecimal(sId));
  			isOK = partnerOwnerDAO.updateRow(objPartner);
  			if(isOK){ 
  				String description = "Cập nhật đối tác " + username;
				adminLogDAO.insertRow(session.getAttribute("datavasosp.adm.username").toString(), description, AdminLog.TYPE_INSERT);
  				out.println("<script type=\"text/javascript\">alert('Cập nhật thành công');window.location.href='owner.jsp';</script>");
  			}else out.println("<script type=\"text/javascript\">alert('Cập nhật không thành công');history.go(-1);</script>");
  		}
  		
  %>
<html >
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
		<title><%=objPartner==null?"Tạo mới đối tác":"Cập nhật thông tin đối tác" %></title>
		<link rel="stylesheet" href="../../login/resources/css/reset.css" type="text/css" media="screen" />
		<link rel="stylesheet" href="../../login/resources/css/style.css" type="text/css" media="screen" />
		<link rel="stylesheet" href="../../login/resources/css/invalid.css" type="text/css" media="screen" />	
		<script type="text/javascript" src="../../login/resources/scripts/jquery-1.3.2.min.js"></script>
		<script type="text/javascript" src="../../login/resources/scripts/simpla.jquery.configuration.js"></script>
		<script type="text/javascript" src="../../login/resources/scripts/facebox.js"></script>
		<script type="text/javascript" src="../../login/resources/scripts/jquery.wysiwyg.js"></script>
		<script type="text/javascript" src="../../login/resources/scripts/jquery.datePicker.js"></script>
		<script type="text/javascript" src="../../login/resources/scripts/jquery.date.js"></script>
		<link rel="stylesheet" href="../../include/calendar_orange.css" title="calendar" />
		<script language="javascript" src="../../include/calendar.js"></script>
		<script type="text/javascript">    
		  	function checkForm(){
		  		if(document.frmAdd.cpName.value==''){
		  			alert('Bạn chưa nhập tên');
		  			return false;
		  		}
		  		if(document.frmAdd.username.value==''){
		  			alert('Bạn chưa nhập tên truy cập cho đối tác');
		  			return false;
		  		}
				//alert('<%=sId.length()>0? "EDIT":"ADD"%>');
		  		document.frmAdd.action.value='<%=sId.length()>0? "EDIT":"ADD"%>';
		  		document.frmAdd.submit();
		  	}
		  </script>
	</head>

 
	<body>
	<div id="body-wrapper"> <!-- Wrapper for the radial gradient background -->
		
		<jsp:include page="../../include/left.jsp" />
		<div id="main-content"> <!-- Main Content Section with everything -->
			<%@ include file="../../../admin/include/tool.jsp" %>
			
			<div class="clear">
			<!-- Page Head -->
			<h2 align="center"><%=sId.length()>0? "CẬP NHẬT THÔNG TIN ĐỐI TÁC":"TẠO MỚI THÔNG TIN ĐỐI TÁC" %></h2>
			
			<div class="clear"></div> <!-- End .clear -->
			
			<div class="content-box"><!-- Start Content Box -->
				
				<div class="content-box-header">
					
					<h3></h3>
					
					<div class="clear"></div>
					
				</div> <!-- End .content-box-header -->
				
				<div class="content-box-content">
					
					<div class="tab-content default-tab" id="tab1"> <!-- This is the target div. id must match the href of this div's tab -->
						
						<form method="post" name="frmAdd" >
				  		<input type="hidden" name="action"/>
				  		<input type="hidden" name="id" value="<%=sId %>"/>
				  		<input type="hidden" name="path"/>
				  		<table width="100%" cellpadding="4" cellspacing="4" border="1" rules="all">
				  			<tr>
				  				<td width="20%" class="header">
				  					<label>Tên đối tác :</label> 
				  				</td>
				  				<td>
				  					<input type="text" class="text-input small-input" size="25" name="cpName" 
				  					value="<%=objPartner!=null && objPartner.getCpName()!=null? objPartner.getCpName():"" %>"/>
				  					(*)
				  				</td>
				  			</tr>
				  			<tr>
				  				<td class="header">
				  					<label>Tên truy cập :</label> 
				  				</td>
				  				<td>
				  					<input type="text" class="text-input small-input" size="25" name="username" 
				  					value="<%=objPartner!=null && objPartner.getUsrname()!=null? objPartner.getUsrname():"" %>"/>
				  					(*)
				  				</td>
				  			</tr>
				  			<tr>
				  				<td class="header">
				  					<label>Trạng thái :</label> 
				  				</td>
				  				<td class="list">
				  					<select name="status" class="small-input">
				  						<option value="0" <%=objPartner!=null && objPartner.getStatus()==0? "selected":"" %>>
				  							Active
				  						</option>
				  						<option value="1" <%=objPartner!=null && objPartner.getStatus()==1? "selected":"" %>>
				  							Deactive
				  						</option>
				  					</select>
				  				</td>
				  			</tr>			  			
				  			
				  			<tr>
				  				<td colspan="2" align="center">
				  					<input class="button" type="button" value="<%=sId.length()>0? "CẬP NHẬT":"THÊM MỚI" %>" onclick="checkForm();"/>
				  				</td>
				  			</tr>
				  		</table>
				  		</form>
						
					</div> <!-- End #tab1 -->
					
				</div> <!-- End .content-box-content -->
				
			</div> <!-- End .content-box -->
			
			<div class="clear"></div>
			
			
			<div id="footer">
				<small> <!-- Remove this notice or replace it with whatever you want -->
						
				</small>
			</div><!-- End #footer -->
			
		</div> 
	</div>
	</body>
</html>
