<%@ page language="java" pageEncoding="utf-8"%>
<%@page import="tdt.db.adm.*"%>
<%@page import="java.math.*"%>
<%@page import="java.io.*"%>
<%@page import="tdt.util.Md5"%>
<%@page import="tdt.util.DateProc"%>
<jsp:useBean id="adminDAO" class="tdt.db.adm.AdminDAO" scope="session" />
<jsp:useBean id="adminRoleDAO" class="tdt.db.adm.AdminRoleDAO" scope="session" />
<%@ include file="../include/header.jsp" %>
<% 
		response.setCharacterEncoding("utf-8");
  		request.setCharacterEncoding("utf-8");
  		
  		Admin adm = null,admin = new Admin();
  		String sId = request.getParameter("id");
  		if(sId==null)sId = "";
  		String sAction = request.getParameter("action");
  		if(sAction==null)sAction = "";
  		String sName = request.getParameter("txtUserName");
  		if(sName == null)sName = "";
  		String sPass = request.getParameter("txtPass");
  		if(sPass == null)sPass = "123456";
  		String slcStatus = request.getParameter("txtStatus");
  		if(slcStatus == null)slcStatus = "0";  		
  		String sFullName = request.getParameter("txtFullName");
  		if(sFullName == null)sFullName = "VAS Content "+DateProc.createTimestamp();
  		String sRight = request.getParameter("txtRight"); 
  		if(sRight == null) sRight = "0";  
  		String sMobile = request.getParameter("txtMobile"); 
  		if(sMobile == null) sMobile = ""; 
  		String sEmail = request.getParameter("txtEmail"); 
  		if(sEmail == null) sEmail = ""; 
  		String sIp = request.getParameter("txtIp"); 
  		if(sIp == null) sIp = ""; 
  		
  		String role = request.getParameter("role"); 
  		if(role == null) role = "1"; 
  		
  		String sProjectID = request.getParameter("projectID");
  		if(sProjectID==null) sProjectID = "";
  		
	    if(sId.length()>0){
  			adm = adminDAO.getRowById(Integer.parseInt(sId));
  		}
	    
	    if(adm!=null && adm.getRightRole()!= Admin.RIGHT_TELCO){
	    	response.sendRedirect("cskh.jsp");
	    	return;
	    }
	    
  		admin.setUserName(sName.trim());
  		
  		AdminRole objRole = new AdminRole();
  		objRole.setAdmin(admin.getUserName());
  		objRole.setLink_id(new BigDecimal(13));
  		objRole.setIs_select(0);
  		objRole.setCreated_by(session.getAttribute("datavasosp.adm.username").toString());
		  		
  		//AdminRole objRole2 = new AdminRole();
  		//objRole2.setAdmin(admin.getUserName());
  		//objRole2.setLink_id(new BigDecimal(1));
  		//objRole2.setIs_select(0);
  		//objRole2.setCreated_by(session.getAttribute("datavasosp.adm.username").toString());
  		
  		AdminRole objRole1 = new AdminRole();
  		objRole1.setAdmin(admin.getUserName());
  		objRole1.setLink_id(new BigDecimal(410));
  		objRole1.setIs_select(0);
  		objRole1.setCreated_by(session.getAttribute("datavasosp.adm.username").toString());
  		if(role.equals("0")){
  			objRole1.setIs_insert(0);
  			objRole1.setIs_update(0);
  		}else{
  			objRole1.setIs_insert(1);
  			objRole1.setIs_update(1);
  		}
  		
  		boolean isOK = false;
  		if(sAction.equals("ADD")){
  			if(!curPageIsInsert){
				response.sendRedirect(request.getContextPath()+"/admin/access/");
				return;
			}
  			admin.setStatus(Integer.parseInt(slcStatus));
  			admin.setPassword(sPass);
  			admin.setFullName(sFullName);
  			admin.setRightRole(Integer.parseInt(sRight));
  			admin.setMobile(sMobile);
  			admin.setEmail(sEmail);
  			admin.setIp(sIp);
  			
			isOK = adminDAO.insertRow(admin);
  			if(isOK){ 
  				adminRoleDAO.insertRow(objRole);
  				adminRoleDAO.insertRow(objRole1);
  				//adminRoleDAO.insertRow(objRole2);
  				String description = "Thêm mới user " + sName;
				adminLogDAO.insertRow(session.getAttribute("datavasosp.adm.username").toString(), description, AdminLog.TYPE_INSERT);
  				out.println("<script type=\"text/javascript\">alert('Tạo mới thành công');window.location.href='cskh.jsp';</script>");
  			}else out.println("<script type=\"text/javascript\">alert('Tạo mới không thành công');history.go(-1);</script>");
  		}
  		if(sAction.equals("EDIT")){
  			if(!curPageIsUpdate){
				response.sendRedirect(request.getContextPath()+"/admin/access/");
				return;
			}
  			if(sPass != null && !sPass.startsWith("*")){		
  				admin.setPassword(Md5.Hash(sPass.trim()));
  			}else{
  				admin.setPassword(adm.getPassword());
  			}
  			admin.setId(new BigDecimal(sId));
  			admin.setStatus(Integer.parseInt(slcStatus));
  			admin.setFullName(sFullName);
  			admin.setRightRole(Integer.parseInt(sRight));
  			admin.setMobile(sMobile);
  			admin.setEmail(sEmail);
  			admin.setIp(sIp);
  			isOK = adminDAO.updateRow(admin);
  			if(isOK){ 
  				adminRoleDAO.insertRow(objRole1);
  				String description = "Cập nhật user " + sName;
				adminLogDAO.insertRow(session.getAttribute("datavasosp.adm.username").toString(), description, AdminLog.TYPE_UPDATE);
  				out.println("<script type=\"text/javascript\">alert('Cập nhật thành công');window.location.href='cskh.jsp';</script>");
  			}
  			else out.println("<script type=\"text/javascript\">alert('Cập nhật không thành công');history.go(-1);</script>");
  		}
  		
  %>
<html >
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title><%=adm==null?"Tạo user":"Cập nhật thông tin user" %></title>
<link rel="stylesheet" href="../login/resources/css/reset.css" type="text/css" media="screen" />
<link rel="stylesheet" href="../login/resources/css/style.css" type="text/css" media="screen" />
<link rel="stylesheet" href="../login/resources/css/invalid.css" type="text/css" media="screen" />	
<script type="text/javascript" src="../login/resources/scripts/jquery-1.3.2.min.js"></script>
<script type="text/javascript" src="../login/resources/scripts/simpla.jquery.configuration.js"></script>
<script type="text/javascript" src="../login/resources/scripts/facebox.js"></script>
<script type="text/javascript" src="../login/resources/scripts/jquery.wysiwyg.js"></script>
<script type="text/javascript" src="../login/resources/scripts/jquery.datePicker.js"></script>
<script type="text/javascript" src="../login/resources/scripts/jquery.date.js"></script>
</head>

 
	<body>
	<div id="body-wrapper"> <!-- Wrapper for the radial gradient background -->
		
		<jsp:include page="../include/left.jsp" />
		<div id="main-content"> <!-- Main Content Section with everything -->
			
			
			
			<!-- Page Head -->
			<h2 align="center"><%=sId.length()>0? "CẬP NHẬT THÔNG TIN USER":"TẠO MỚI THÔNG TIN USER" %></h2>
			
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
				  		<input type="hidden" name="txtRight" value="<%=Admin.RIGHT_TELCO%>">
				  		<table width="60%" cellpadding="4" cellspacing="4" border="1" rules="all">
				  			<tr>
				  				<td class="header">
				  					<label>Tên truy cập :</label> 
				  				</td>
				  				<td>
				  					<input type="text" class="text-input small-input" size="25" name="txtUserName" 
				  					value="<%=adm!=null && adm.getUserName()!=null? adm.getUserName():"" %>"/>
				  					(*)
				  				</td>
				  			</tr>
				  			<tr>
				  				<td class="header">
				  					<label>Mật khẩu :</label> 
				  				</td>
				  				<td>
				  					<input type="password" size="25" class="text-input small-input"  name="txtPass"
				  					value="<%=adm==null || adm.getPassword()==null? "":"***********" %>"/>
				  					(*)
				  				</td>
				  			</tr>
				  			<tr>
				  				<td class="header">
				  					<label>Xác nhận MK :</label> 
				  				</td>
				  				<td>
				  					<input type="password" size="25" class="text-input small-input"  name="txtRepass"
				  					value=""/>
				  					(*)
				  				</td>
				  			</tr>
				  			<tr>
				  				<td class="header">
				  					<label>Trạng thái :</label> 
				  				</td>
				  				<td class="list">
				  					<select name="txtStatus" class="small-input">
				  						<option value="0" <%=adm!=null && adm.getStatus()==0? "selected":"" %>>
				  							Hoạt động
				  						</option>
				  						<option value="1" <%=adm!=null && adm.getStatus()==1? "selected":"" %>>
				  							Khóa
				  						</option>
				  					</select>
				  				</td>
				  			</tr>
				  			
				  			<tr>
				  				<td class="header">
				  					<label>Họ tên :</label> 
				  				</td>
				  				<td>
				  					<input type="text" class="text-input small-input" size="25" name="txtFullName" 
				  					value="<%=adm!=null && adm.getFullName()!=null? adm.getFullName():"" %>"/>
				  					(*)
				  				</td>
				  			</tr>
				  			<tr>
				  				<td class="header">
				  					<label>SĐT :</label> 
				  				</td>
				  				<td>
				  					<input type="text" size="25" class="text-input small-input"  name="txtMobile" 
				  					value="<%=adm==null || adm.getMobile()==null? "": adm.getMobile() %>"/>
				  				</td>
				  			</tr>
				  			
				  			<tr>
				  				<td class="header">
				  					<label>E-mail :</label> 
				  				</td>
				  				<td>
				  					<input type="text" class="text-input small-input" size="25" name="txtEmail" 
				  					value="<%=adm!=null && adm.getEmail()!=null? adm.getEmail():"" %>"/>
				  				</td>
				  			</tr>
				  			<tr>
				  				<td class="header">
				  					<label>IP :</label> 
				  				</td>
				  				<td>
				  					<input type="text" class="text-input small-input" size="25" name="txtIp"  
				  					value="<%=adm==null || adm.getIp()==null? "": adm.getIp() %>"/>
				  					(Nhập ip nếu muốn giới hạn người dùng chỉ được phép truy cập từ ip đó)
				  				</td>				  				
				  			</tr>
				  			<tr>
				  				<td class="header">
				  					<label>Quyền CSKH:</label> 
				  				</td>
				  				<td>
				  					<%
				  						boolean isChecked = false;
				  						if(adm!=null){
				  							objRole = adminRoleDAO.getRole(adm.getUserName(), new BigDecimal(410));
				  							if(objRole!=null && objRole.getIs_insert()==0 && objRole.getIs_update()==0)
				  								isChecked = true;
				  						}
				  					%>
				  					<input type="radio" name="role" <%if(!isChecked){ %>checked="checked" <%} %> value="1"> Chỉ được xem
				  					<input type="radio" name="role" <%if(isChecked){ %>checked="checked" <%} %>  value="0"> Tác động
				  				</td>		
				  			</tr>			  			
				  			<tr>
				  				<td></td>
				  				<td>
				  					<i>* Chú ý: sau khi tạo account xong, vui lòng truy cập menu CSKH-MBF Roles để cấp quyền cho account</i>
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
	<script type="text/javascript">
    
  	function checkForm(){
  		if(document.frmAdd.txtUserName.value==''){
  			alert('Bạn chưa nhập tên truy cập');
  			return false;
  		}
  		<%if(sId.trim().length()==0){ %>
  		var pass = document.frmAdd.txtPass.value;
  		var newpass = document.frmAdd.txtRepass.value;
  		if(pass==''){
  			alert('Bạn chưa nhập mật khẩu');
  			return false;
  		}
  		if(pass != newpass){
  			alert('Xác nhận mật khẩu không chính xác');
  			return false;
  		}
  		<%}%>
  		if(document.frmAdd.txtFullName.value==''){
  			alert('Bạn chưa nhập Họ tên');
  			return false;
  		}
		//alert('<%=sId.length()>0? "EDIT":"ADD"%>');
  		document.frmAdd.action.value='<%=sId.length()>0? "EDIT":"ADD"%>';
  		document.frmAdd.submit();
  	}
  </script>
</html>
