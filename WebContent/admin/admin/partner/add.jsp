<%@page import="tdt.db.service.vas.partner.Partner"%>
<%@page import="tdt.util.StringTool"%>
<%@ page language="java" pageEncoding="utf-8"%>
<%@page import="tdt.db.adm.*"%>
<%@page import="java.math.*"%>
<%@page import="java.io.*"%>
<%@page import="tdt.util.Md5"%>
<%@page import="tdt.util.DateProc"%>
<jsp:useBean id="adminDAO" class="tdt.db.adm.AdminDAO" scope="session" />
<jsp:useBean id="partnerDAO" class="tdt.db.service.vas.partner.PartnerDAO" scope="session" />
<jsp:useBean id="partnerOwnerDAO" class="tdt.db.service.vas.partner.PartnerOwnerDAO" scope="session" />
<%@ include file="../../include/header.jsp" %>
<%
	response.setCharacterEncoding("utf-8");
  		request.setCharacterEncoding("utf-8");

  		String sId = request.getParameter("id");
  		if(sId==null)sId = "";
  		String sAction = request.getParameter("action");
  		if(sAction==null)sAction = "";

		String name = request.getParameter("name");
		if(name==null)name = "";
		String username = request.getParameter("username");
		if(username==null)username = "";
		username = username.trim().toLowerCase();
		String contact = request.getParameter("contactName");
		if(contact==null)contact = "";
		String owner = request.getParameter("owner");
		if(owner==null)owner = "";
		String mobile = request.getParameter("mobile");
		if(mobile==null)mobile = "";
		String email = request.getParameter("email");
		if(email==null)email = "";
		String status = request.getParameter("status");
		if(status==null)status = "0";
		String contractCode = request.getParameter("contactCode");
		if(contractCode==null)contractCode = "";
		String contractExpire = request.getParameter("contractExpire");
		if(contractExpire==null)contractExpire = DateProc.getDateString(DateProc.createTimestamp());
		String contentProviderUrl = request.getParameter("contentProviderUrl");
		if(contentProviderUrl==null)contentProviderUrl = "";
		String note = request.getParameter("note");
		if(note==null)note = "";
  		
  		Partner objPartner = null;
  		
  		
	    if(sId.length()>0){
  			try{
  				objPartner = partnerDAO.getRow(new BigDecimal(sId));
  			}catch(Exception ex){}
  		}
  		boolean isOK = false;
  		if(sAction.equals("ADD")){
  			if(!curPageIsInsert){
		response.sendRedirect(request.getContextPath()+"/admin/access/");
		return;
	}
  			objPartner = new Partner();
  			objPartner.setName(name);
  			objPartner.setUser(username);
  			objPartner.setContactName(contact);
  			objPartner.setMobile(mobile);
  			objPartner.setEmail(email);
  			objPartner.setContractCode(contractCode);
  			objPartner.setContractExpire(DateProc.buildTimestamp(Integer.parseInt(contractExpire.substring(6,10)),Integer.parseInt(contractExpire.substring(3,5)),Integer.parseInt(contractExpire.substring(0,2))));
  			objPartner.setNote(note);
  			objPartner.setContentProviderUrl(contentProviderUrl);
  			objPartner.setStatus(Integer.parseInt(status));
  			objPartner.setOwnerId(new BigDecimal(owner));
  			objPartner.setCreatedBy(session.getAttribute("datavasosp.adm.username").toString());
	isOK = partnerDAO.insertRow(objPartner);
  			if(isOK){ 
  				String description = "Thêm mới kênh kinh doanh " + username;
		adminLogDAO.insertRow(session.getAttribute("datavasosp.adm.username").toString(), description, AdminLog.TYPE_INSERT);
  				out.println("<script type=\"text/javascript\">alert('Tạo mới thành công');window.location.href='index.jsp';</script>");
  			}else out.println("<script type=\"text/javascript\">alert('Tạo mới không thành công');history.go(-1);</script>");
  		}
  		if(sAction.equals("EDIT")){
  			if(!curPageIsUpdate){
		response.sendRedirect(request.getContextPath()+"/admin/access/");
		return;
	}
  			objPartner = new Partner();
  			objPartner.setName(name);
  			objPartner.setUser(username);
  			objPartner.setContactName(contact);
  			objPartner.setMobile(mobile);
  			objPartner.setEmail(email);
  			objPartner.setContractCode(contractCode);
  			objPartner.setContractExpire(DateProc.buildTimestamp(Integer.parseInt(contractExpire.substring(6,10)),Integer.parseInt(contractExpire.substring(3,5)),Integer.parseInt(contractExpire.substring(0,2))));
  			objPartner.setNote(note);
  			objPartner.setContentProviderUrl(contentProviderUrl);
  			objPartner.setStatus(Integer.parseInt(status));
	objPartner.setId(new BigDecimal(sId));
	objPartner.setOwnerId(new BigDecimal(owner));
	objPartner.setCreatedBy(session.getAttribute("datavasosp.adm.username").toString());
  			isOK = partnerDAO.updateRow(objPartner);
  			if(isOK) out.println("<script type=\"text/javascript\">alert('Cập nhật thành công');window.location.href='index.jsp';</script>");
  			else out.println("<script type=\"text/javascript\">alert('Cập nhật không thành công');history.go(-1);</script>");
  		}
  		
  		Hashtable<BigDecimal, String> hashtable = partnerOwnerDAO.findHashtable();
%>
<html >
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
		<title><%=objPartner==null?"Tạo mới kênh kinh doanh":"Cập nhật thông tin kênh kinh doanh" %></title>
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
		  		if(document.frmAdd.name.value==''){
		  			alert('Bạn chưa nhập tên');
		  			return false;
		  		}
		  		if(document.frmAdd.username.value==''){
		  			alert('Bạn chưa nhập tên truy cập cho kênh kinh doanh');
		  			return false;
		  		}
		  		if(document.frmAdd.contactName.value==''){
		  			alert('Bạn chưa nhập tên liên hệ');
		  			return false;
		  		}
		  		if(document.frmAdd.owner.value==''){
		  			alert('Bạn chưa chọn đối tác');
		  			return false;
		  		}
		  		if(document.frmAdd.mobile.value==''){
		  			alert('Bạn chưa nhập số điện thoại');
		  			return false;
		  		}
		  		if(document.frmAdd.email.value==''){
		  			alert('Bạn chưa nhập địa chỉ email');
		  			return false;
		  		}
		  		if(document.frmAdd.contactCode.value==''){
		  			alert('Bạn chưa nhập mã hợp đồng');
		  			return false;
		  		}
		  		if(document.frmAdd.contactExpire.value==''){
		  			alert('Bạn chưa nhập thời hạn hợp đồng');
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
			<h2 align="center"><%=sId.length()>0? "CẬP NHẬT THÔNG TIN KÊNH KINH DOANH":"TẠO MỚI THÔNG TIN KÊNH KINH DOANH" %></h2>
			
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
				  					<label>Tên kênh kinh doanh :</label> 
				  				</td>
				  				<td>
				  					<input type="text" class="text-input small-input" size="25" name="name" 
				  					value="<%=objPartner!=null && objPartner.getName()!=null? objPartner.getName():"" %>"/>
				  					(*)
				  				</td>
				  			</tr>
				  			<tr>
				  				<td class="header">
				  					<label>Tên truy cập :</label> 
				  				</td>
				  				<td>
				  					<input type="text" class="text-input small-input" size="25" name="username" 
				  					value="<%=objPartner!=null && objPartner.getUser()!=null? objPartner.getUser():"" %>"/>
				  					(*)
				  				</td>
				  			</tr>
				  			<tr>
				  				<td class="header">
				  					<label>Tên liên hệ :</label> 
				  				</td>
				  				<td>
				  					<input type="text" class="text-input small-input" size="25" name="contactName" 
				  					value="<%=objPartner!=null && objPartner.getContactName()!=null? objPartner.getContactName():"" %>"/>
				  					(*)
				  				</td>
				  			</tr>
				  			<tr>
				  				<td class="header">
				  					<label>Đối tác :</label> 
				  				</td>
				  				<td>
				  					<select name="owner">
										<option value="">Đối tác</option>
										<%
											if(hashtable !=null && hashtable.size()>0){
												Set s = hashtable.entrySet();
										        Iterator i=s.iterator();
										        Map.Entry m = null;
										        while(i.hasNext()){	
										        	m = (Map.Entry)i.next();
										        	if(m!=null){
										%>
											<option <%=objPartner!=null && objPartner.getOwnerId()!=null && objPartner.getOwnerId().toString().equals(m.getKey().toString())?"selected":"" %> <%=m.getKey().toString().equals("")?"selected":"" %> value="<%=m.getKey()%>"><%=m.getValue() %></option>
										<%        		
										        	}
										        }
											}
										%>
									</select>
				  				</td>
				  			</tr>
				  			<tr>
				  				<td class="header">
				  					<label>SĐT :</label> 
				  				</td>
				  				<td>
				  					<input type="text" class="text-input small-input" size="25" name="mobile" 
				  					value="<%=objPartner!=null && objPartner.getMobile()!=null? objPartner.getMobile():"" %>"/>
				  					(*)
				  				</td>
				  			</tr>
				  			<tr>
				  				<td class="header">
				  					<label>Email :</label> 
				  				</td>
				  				<td>
				  					<input type="text" class="text-input small-input" size="25" name="email" 
				  					value="<%=objPartner!=null && objPartner.getEmail()!=null? objPartner.getEmail():"" %>"/>
				  					(*)
				  				</td>
				  			</tr>
							<tr>
				  				<td class="header">
				  					<label>Mã hợp đồng :</label> 
				  				</td>
				  				<td>
				  					<input type="text" class="text-input small-input" size="25" name="contactCode" 
				  					value="<%=objPartner!=null && objPartner.getContractCode()!=null? objPartner.getContractCode():"" %>"/>
				  					(*)
				  				</td>
				  			</tr>
							<tr>
				  				<td class="header">
				  					<label>Thời gian hết hạn :</label> 
				  				</td>
				  				<td>
				  					<input type="text" class="text-input small-input" size="25" name="contactExpire"  id="contactExpire"
				  					value="<%=objPartner!=null && objPartner.getContractExpire()!=null? DateProc.getDateString(objPartner.getContractExpire()):"" %>"/>
				  					<img src='../../images/icon-lich.gif' onmouseover="fnInitCalendar(this, 'contactExpire', 'style=calendar_orange.css,close=true')" /> (*)
				  				</td>
				  			</tr>
				  			<tr>
				  				<td class="header">
				  					<label>Chú thích :</label> 
				  				</td>
				  				<td>
				  					<textarea rows="5" cols="15" name="note"></textarea>
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
				  					<input class="button" type="button" value="<%=sId.length()>0? "EDIT":"ADD" %>" onclick="checkForm();"/>
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
