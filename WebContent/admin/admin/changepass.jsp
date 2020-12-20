<%@ page language="java" pageEncoding="utf-8"%>
<%@page import="tdt.db.adm.*"%>
<%@page import="java.math.*"%>
<%@page import="java.io.*"%>
<%@page import="tdt.util.Md5"%>
<jsp:useBean id="adminDAO" class="tdt.db.adm.AdminDAO" scope="session" />
<% 
		response.setCharacterEncoding("utf-8");
  		request.setCharacterEncoding("utf-8");
%>
<html >
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>THAY ĐỔI MẬT KHẨU </title>
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
<%//@ include file="../include/header.jsp" %>
 <% 
  	Admin admC  = (Admin)session.getAttribute("datavasosp.adm.control");
  	if(admC == null){
  		response.sendRedirect(request.getContextPath() + "/admin/login/login.jsp");
  		return;
  	}
  	String sAction = request.getParameter("action");
  	if(sAction == null)sAction = "";
  	
  	String error ="";
	if("CHANGEPASS".equals(sAction)){
		String pass = request.getParameter("txtPass");
		String newPass = request.getParameter("txtNewPass");
		newPass = Md5.Hash(newPass).trim();
		pass = Md5.Hash(pass).trim();
		boolean isOK = adminDAO.changePass(admC.getId(),pass,newPass);
		if(isOK) out.println("<script type=\"text/javascript\">alert('Thay đổi mật khẩu thành công');window.location.href='index.jsp';</script>");
		else error ="Mật khẩu cũ không chính xác";
	}
  		
  %>
	<body>
	<div id="body-wrapper"> <!-- Wrapper for the radial gradient background -->
		
		<jsp:include page="../include/left.jsp" />
		<div id="main-content"> <!-- Main Content Section with everything -->
			
			
			
			<!-- Page Head -->
			<h2 align="center">ĐỔI MẬT KHẨU</h2>
			
			<div class="clear"></div> <!-- End .clear -->
			
			<div class="content-box"><!-- Start Content Box -->
				
				<div class="content-box-header">
					
					<h3></h3>
					
					<div class="clear"></div>
					
				</div> <!-- End .content-box-header -->
				
				<div class="content-box-content">
					
					<div class="tab-content default-tab" id="tab1"> <!-- This is the target div. id must match the href of this div's tab -->
						
						<form method="post" name="frmChangePass" >
				  		<table width="60%" cellpadding="4" cellspacing="4" border="1" rules="all">
				  			<tr>
				  				<td colspan="2"><font style="color: red;"><%=error!=null?error:"" %></font> </td>
				  			</tr>
				  			<tr>
				  				<td class="header">
				  					<label>Mật khẩu cũ:</label> 
				  				</td>
				  				<td>
				  					<input type="password" size="25" name="txtPass" class="text-input small-input"/>
				  				</td>
				  			</tr>
				  			<tr>
				  				<td class="header">
				  					<label>Mật khẩu mới:</label> 
				  				</td>
				  				<td>
				  					<input type="password" size="25" name="txtNewPass" class="text-input small-input"/>
				  				</td>
				  			</tr>
				  			<tr>
				  				<td class="header">
				  					<label>Nhắc lại mật khẩu mới:</label> 
				  				</td>
				  				<td>
				  					<input type="password" size="25" name="txtReNewPass" class="text-input small-input" />
				  				</td>
				  			</tr>
				  			<tr>
				  				<td colspan="2" align="center">
				  					<input type="hidden" name="action" value="CHANGEPASS"/>
				  					<input class="button" type="button" value="Đổi mật khẩu" onclick="checkForm();"/>
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
  		if(document.frmChangePass.txtPass.value==''){
  			alert('Bạn chưa nhập mật khẩu cũ');
  			return false;
  		}else if(document.frmChangePass.txtNewPass.value==''){
  			alert('Bạn chưa nhập mật khẩu mới');
  			return false;
  		}else if(document.frmChangePass.txtReNewPass.value==''){
  			alert('Bạn chưa nhập lại mật khẩu mới');
  			return false;
  		}else if(document.frmChangePass.txtReNewPass.value!='' && document.frmChangePass.txtReNewPass.value != document.frmChangePass.txtNewPass.value){
			alert('Mật khẩu nhắc lại không chính xác !');
			return false; 
  		}
  		document.frmChangePass.submit();
  	}
  </script>
</html>
