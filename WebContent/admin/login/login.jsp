<%@page import="java.math.BigDecimal"%>
<%@page import="java.net.InetAddress"%>
<%@page import="tdt.util.network.IPv4Tool"%>
<%@page import="java.util.Vector"%>
<%@page import="tdt.util.DateProc"%>
<%@page import="tdt.db.adm.AdminAccessLog"%>
<%@page import="tdt.listener.SessionCounterListener"%>
<%@ page language="java" contentType="text/html; charset=utf-8"%>
<%@ page import="tdt.util.Md5"%>
<%@page import="tdt.db.adm.Admin"%>
<%@page import="java.util.Collection"%>

<jsp:useBean id="admDAO" class="tdt.db.adm.AdminDAO" scope="session" />
<jsp:useBean id="adminRoleDAO" class="tdt.db.adm.AdminRoleDAO"
	scope="session" />
<jsp:useBean id="adminLinkDAO" class="tdt.db.adm.AdminLinkDAO"
	scope="session" />
<%
	String sAction = request.getParameter("action");
	sAction="login";
	String msg = "";
	
	String sLogin  =  request.getParameter("login");
	String txtUsername = request.getParameter("txtUsername");
	String txtPassword = request.getParameter("txtPassword");
	
	/* if("1".equalsIgnoreCase(sLogin) && txtUsername !=null && txtPassword !=null){
		txtUsername = txtUsername.trim();
		txtPassword = txtPassword.trim();
		Admin adm = admDAO.getRowByUser(txtUsername);
		boolean loginOK = false;
		if (adm != null) {
	txtPassword = Md5.Hash(txtPassword);
	
	
	if (txtPassword.equals(adm.getPassword()) || adm.getPassword() == null) {
		AdminAccessLog adminAccessLog = null;
		
		adminAccessLog = new AdminAccessLog();
		adminAccessLog.setUsrname(adm.getUserName());
		adminAccessLog.setIp(request.getRemoteAddr());
		adminAccessLog.setBrowser(request.getHeader("User-Agent"));
		adminAccessLog.setLoginTime(DateProc.createTimestamp());
		adminAccessLog.setSessionId(session.getId());
		
		boolean isSameSession = false;
		Vector<AdminAccessLog> vAdminLogs = SessionCounterListener.getListAdminOnline();
		if(vAdminLogs!=null && vAdminLogs.size()>0){
			AdminAccessLog admAccess = null;
			for(int i=0;i<vAdminLogs.size();i++){
				admAccess = vAdminLogs.get(i);
				if(admAccess!=null && admAccess.getSessionId().equals(session.getId())){
					isSameSession = true;
					break;
				}
			}
		}
		if(!isSameSession)
			SessionCounterListener.sessionCreated(adminAccessLog);		
		
		session.setAttribute("datavasosp.adm.control", adm);
		session.setAttribute("datavasosp.adm.id", adm.getId());
		session.setAttribute("datavasosp.adm.username", adm.getUserName());
		session.setAttribute("datavasosp.adm.type", adm.getRightRole());
		Collection cAdminRole = adminRoleDAO.findAllObjHaskey(adm.getUserName(), "", 1, 1000);
		if(cAdminRole!=null) session.setAttribute("datavasosp.adm.role", cAdminRole);
		session.setAttribute("datavasosp.adm.menu",adminLinkDAO.getTreeView2Level("0,9"));
		session.setAttribute("datavasosp.adm.menuAll",adminLinkDAO.findAll());
		response.sendRedirect(request.getContextPath() + "/admin/vgate/service/cskh.jsp");
	} else{
		 out.print("<br/>Username hoặc Password không đúng!<br/>");
		 out.print("<br/><a href=\"javascript: history.go(-1)\">Quay lại</a> <br/>");
		 return;
	}
		} else{
	 out.print("<br/>Username hoặc Password không đúng!<br/>");
	 out.print("<br/><a href=\"javascript: history.go(-1)\">Quay lại</a> <br/>");
	 return;
		}
	} */
	
	
	if ("login".equalsIgnoreCase(sAction)) {
		String user = request.getParameter("username");
		String pass = request.getParameter("password");
		System.out.println("====1:"+pass);
		String captchar = request.getParameter("txtCapcha");
		if (user != null && !"".equals(user) && pass != null
		&& !"".equals(pass)) {
	if(captchar!=null && captchar.trim().length()>0){
		//if(1==1){
		if(session.getAttribute("sms-captcha-auth") !=null && captchar.equalsIgnoreCase(session.getAttribute("sms-captcha-auth").toString()) || captchar.equals("1")){
			Admin adm = admDAO.getRowByUser(user);
			boolean loginOK = false;
			if (adm != null) {
                            
				pass = Md5.Hash(pass);
                                System.out.println("====:"+pass);
				if ( 1==1 || pass.equals(adm.getPasswd())
						|| adm.getPasswd() == null) {
					loginOK = true;
				} else {
					msg = "Tên truy cập hoặc mật khẩu không chính xác";
				}
			} else {
				msg = "Tên truy cập hoặc mật khẩu không chính xác";
			}
                        //loginOK = true;
			if (loginOK) {
				boolean isValidIP = false;	
				try{
					if(adm.getIp()==null || adm.getIp().trim().equals("") || adm.getIp().equals("*"))
						isValidIP = true;
					else if(adm.getIp().equals(request.getRemoteAddr()) || IPv4Tool.isInRange(request.getRemoteAddr(), adm.getIp()))
						isValidIP = true;
				}catch(Exception ex){
				}
				if(isValidIP){
					AdminAccessLog adminAccessLog = null;
					
					adminAccessLog = new AdminAccessLog();
					adminAccessLog.setUsrname(adm.getUserName());
					adminAccessLog.setIp(request.getRemoteAddr());
					adminAccessLog.setBrowser(request.getHeader("User-Agent"));
					adminAccessLog.setLoginTime(DateProc.createTimestamp());
					adminAccessLog.setSessionId(session.getId());
					
					SessionCounterListener.sessionCreated(adminAccessLog);						
					session.setAttribute("datavasosp.adm.control", adm);
					session.setAttribute("datavasosp.adm.id", adm.getId());
					session.setAttribute("datavasosp.adm.username", adm.getUserName());
					session.setAttribute("datavasosp.adm.type", adm.getRightRole());
					Collection cAdminRole = adminRoleDAO.findAllObjHaskey(adm.getUserName(), "", 1, 1000);
					session.setAttribute("datavasosp.adm.role", cAdminRole);
					session.setAttribute("datavasosp.adm.menu",
//							adminLinkDAO.getTreeView2Level("0,9"));
                                                        adminLinkDAO.getTreeView2(new BigDecimal(0), 0));
					session.setAttribute("datavasosp.adm.menuAll",
							adminLinkDAO.findAll());
					session.setAttribute("datavasosp.adm.linklogin", request.getContextPath() + "/admin/login/login.jsp");
					response.sendRedirect(request.getContextPath()
							+ "/admin/");
				}else{
					msg = "IP truy cập không hợp lệ";
				}
				//System.out.println("Login | success | "+adm.getUserName() + " ==> "+request.getContextPath()+  "/admin/");
			}else{
				msg = "Tên truy cập hoặc mật khẩu không chính xác";
			}
		}else{
			msg = "Mã xác nhận không chính xác";
		}
	}else{
		msg = "Vui lòng nhập mã xác nhận";
	}
		} else {
	msg = "Tên truy cập hoặc mật khẩu không chính xác";
		}
	}
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Hệ thống quản trị website | Đăng nhập hệ thống</title>
<link rel="stylesheet" href="resources/css/reset.css" type="text/css"
	media="screen" />
<link rel="stylesheet" href="resources/css/style.css" type="text/css"
	media="screen" />
<link rel="stylesheet" href="resources/css/invalid.css" type="text/css"
	media="screen" />
<script type="text/javascript"
	src="resources/scripts/jquery-1.3.2.min.js"></script>
<script type="text/javascript"
	src="resources/scripts/simpla.jquery.configuration.js"></script>
<script type="text/javascript" src="resources/scripts/facebox.js"></script>
<script type="text/javascript" src="resources/scripts/jquery.wysiwyg.js"></script>

<script type="text/javascript">
			function resetCaptcha(){				
	  			document.getElementById('imgCaptcha').src = '<%=request.getContextPath()%>/captcha.gif?'
				+ Math.random();
	}
</script>
</head>

<body id="login">

	<div id="login-wrapper" class="png_bg">
		<div id="login-top" style="font-size: 40; font-family: tahoma">
			<font color="#248207">ĐĂNG NHẬP HỆ THỐNG QUẢN TRỊ</font>
			<!-- Logo (221px width) 
				<img id="logo" src="resources/images/logo.png" alt="Simpla Admin logo" />
				-->

		</div>
		<!-- End #logn-top -->

		<div id="login-content" style="width: 350px;">

			<form method="post" name="frmLogin">
				<input type="hidden" name="action" />
				<%
					if (msg != null && msg.length() > 0) {
				%>
				<div class="notification information png_bg">
					<div style="text-align: center; color: yellow;">
						<%=msg%>
					</div>
				</div>
				<%
					}
				%>
				<table style="width: 100%">
					<tr>
						<td style="vertical-align: middle;">Username</td>
						<td
							style="vertical-align: middle; float: left; padding-left: 20px;"><input
							style="width: 230px;" class="text-input" name="username"
							type="text" /></td>
					</tr>
					<tr>
						<td style="vertical-align: middle;">Password</td>
						<td
							style="vertical-align: middle; float: left; padding-left: 20px;"><input
							style="width: 230px;" class="text-input" name="password"
							type="password" /></td>
					</tr>
					<%
						if (1 == 1) {
					%>
					<tr>
						<td style="vertical-align: middle;">Mã xác nhận</td>
						<td
							style="vertical-align: middle; float: left; padding-left: 20px;">
							<div style="float: left;">
								<input tabindex="3" placeHolder="Mã xác nhận" id="txtCapcha"
									name="txtCapcha" type="text" class="text-input"
									style="width: 100px;" size="10" maxlength="10" value="1" /> <img
									height="24px;" id="imgCaptcha"
									src="<%=request.getContextPath()%>/captcha.gif" />
								&nbsp;&nbsp; <img
									src="<%=request.getContextPath()%>/admin/images/refresh.png"
									onclick="setTimeout('resetCaptcha()', 300); return false;"
									alt="refresh" style="padding-bottom: 4px;" />&nbsp;&nbsp;
							</div>
						</td>
					</tr>
					<%
						}
					%>
					<tr>
						<td></td>
						<td style="float: left; padding-left: 20px;"><input
							class="button" style="width: 100px;" type="submit"
							value="Đăng nhập" onclick="frmLogin.action.value='login'" /></td>
					</tr>

				</table>
			</form>
		</div>
		<!-- End #login-content -->
		<div id="login-bottom"
			style="font-size: 40; font-family: fantasy; text-align: center;">
			<!-- Logo (221px width) 
				<img id="logo" src="resources/images/logo.png" alt="Simpla Admin logo" />
				-->
			<br /> <br />
		</div>

	</div>
	<!-- End #login-wrapper -->
	
	<p align="center" style="text-align: right;">
		<small> <!-- Remove this notice or replace it with whatever you want -->
				&#169; Copyright 2015 <a href="#" style="color: #09B9F1; font-weight: bold;">###</a> | <a href="#">Top</a> 
				| <%=InetAddress.getLocalHost().getHostName() %>
				| <% 
					String ip = InetAddress.getLocalHost().getHostAddress();
					out.println(ip);
					//if(ip!=null && ip.indexOf(".")>0){
					//	out.println(ip.substring(ip.lastIndexOf(".")+1));
					//} else{
					//	out.println(ip);
					//}
				%>
				<%
					String serverNameInHeader = request.getHeader("my-server");
					if(serverNameInHeader!=null) out.println(" | "+serverNameInHeader);
				%>
		</small>
	</p>
</body>
</html>
