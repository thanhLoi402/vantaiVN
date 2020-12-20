<%@page import="tdt.util.DateProc"%>
<%@page language="java" pageEncoding="utf-8"%>
<%@page import="tdt.db.adm.*"%>
<%@page import="java.util.*"%>
<jsp:useBean id="adminAcessLogDAO" class="tdt.db.adm.AdminAccessLogDAO" scope="session" />
<html >
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Thông tin truy cập </title>
<link rel="icon" href="<%=request.getContextPath() %>/images/icon/admin.ico" type="image/x-icon" />
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
<%@ include file="../include/header.jsp" %>
<%	
	response.setCharacterEncoding("utf-8");
	request.setCharacterEncoding("utf-8");
	
	AdminAccessLog admin = null;
	String sAction = request.getParameter("action");
	if(sAction==null)sAction="";
	String txtVar = request.getParameter("txtVar");
	if(txtVar==null){
		txtVar = request.getParameter("txtVar1");
		if(txtVar==null)txtVar="";
	}
	
	int tong = adminAcessLogDAO.countAll(txtVar);

	int n = 30;
	int pn = tong / n;
	if (tong % n > 0)
		pn = pn + 1;
	//int dd = pn * n - 1;
	int currentPn = 1;
	//String ps = request.getParameter("p");
	//if (ps == null) ps = "1";
	//rs = partnerDAO.findAllObjHasKey(name , Integer.parseInt(ps), n);
	try{
		currentPn = Integer.parseInt(request.getParameter("p"));
	}catch(Exception ex){}
	
	Collection cAdmin = adminAcessLogDAO.findAll(txtVar, currentPn, n);
	
 %>
	<body>
	<div id="body-wrapper"> <!-- Wrapper for the radial gradient background -->
		
		<jsp:include page="../include/left.jsp" />
		<div id="main-content"> <!-- Main Content Section with everything -->					
			<!-- Page Head -->
			<%@ include file="../../admin/include/tool.jsp" %>
			<div class="clear"></div> <!-- End .clear -->
			<h2 align="center">THÔNG TIN TRUY CẬP</h2>
			<div class="clear"></div> <!-- End .clear -->
			
			<div class="content-box"><!-- Start Content Box -->
				<form method="post" name="frmList">
				<input type="hidden" name="action"/>
				<div class="content-box-header" style="padding-top: 3px;">						
					<input type="text" class="text-input small-input" name="txtVar" value="<%=txtVar %>"/>
					<input type="button" value="TÌM" class="button" onclick="frmList.submit();"/>
					<h3><img src="<%=request.getContextPath() %>/admin/login/resources/images/icons/arr.png" height="15px"/></h3>	
					<span style="float: right;padding-right: 20px;"><input class="button" type="button" value="NEW..." onclick="window.location.href='add.jsp';"/></span>	
					<div class="clear"></div>
					
				</div> <!-- End .content-box-header -->
				
				<div class="content-box-content">
					
					<div class="tab-content default-tab" id="tab1"> <!-- This is the target div. id must match the href of this div's tab -->
						
						
							
							<table cellpadding="4" cellspacing="4" border="1" rules="all" width="80%">
								<tr class="header" bgcolor="c6c6c6" align="center">
									<td>STT</td>
									<td>
										<h3 style="font-size: 13px;">Username</h3>
									</td>
									<td>
										<h3 style="font-size: 13px;">IP</h3>
									</td>
									<td>
										<h3 style="font-size: 13px;">Browser</h3>
									</td>
									<td>
										<h3 style="font-size: 13px;">Login Time</h3>
									</td>
									<td>
										<h3 style="font-size: 13px;">Logout Time</h3>
									</td>
								</tr>
								<% 
									int index = 0;
									if(cAdmin!=null && cAdmin.size()>0){
									Iterator ite = cAdmin.iterator();
									while(ite.hasNext()){
										admin = (AdminAccessLog) ite.next();
										if(admin!=null){
										index++;
								%>
								<tr class="list">
									<td>
										<%=(currentPn-1)*n+index %>
									</td>
									<td>
										<%=admin.getUsrname()!=null? admin.getUsrname():"" %>
									</td>
									<td>
										<%=admin.getIp()!=null? admin.getIp():"" %>
									</td>
									<td>
										<%=admin.getBrowser()!=null? admin.getBrowser():"" %>
									</td>
									<td>
										<%=DateProc.getDateTime24hString(admin.getLoginTime()) %>
									</td>
									<td>
										<%=DateProc.getDateTime24hString(admin.getLogoutTime()) %>
									</td>
								</tr>
								
								<% 
										}
									}
									}
								%>
							</table>
							<table cellpadding="4" cellspacing="4" border="0"  width="80%">
								<tr>
									<td>										
									</td>
									<td>
										<div class="bulk-actions align-left" >
											<span id="spanTagAction" name="spanTagAction">									
											</span>				
										</div>
										<%
										if(pn>1){
											String pageUrl = "access-logs.jsp?txtVar1="+txtVar+"&p=";
										%>
										<div class="pagination">
											<a href="<%=pageUrl %>1" title="First Page">&laquo; First</a>
											<a href="<%=pageUrl %><%=currentPn-1>0?(currentPn-1):1 %>" title="Previous Page">&laquo; Prev</a>
											Page <%=currentPn + "/" + pn %>											
											<select name="page" style="height: 25px;" ONCHANGE="location = this.options[this.selectedIndex].value;">
												<%for(int i=1;i<=pn;i++){ %>
													<option value="<%=pageUrl+i %>" <%if(currentPn==i){ %> selected="selected" <%} %> ><%=i %></option>
												<%} %>
											</select>
											
											<a href="<%=pageUrl %><%=currentPn+1<pn?currentPn+1:pn %>" title="Next Page">Next &raquo;</a>
											<a href="<%=pageUrl %><%=pn %>" title="Last Page">Last &raquo;</a>
										</div> 
										<%} %>
										 
										<div class="clear"></div>
									
									
									</td>
								</tr>
							</table>
						
						
					</div> <!-- End #tab1 -->
					
				</div> <!-- End .content-box-content -->
				</form>
			</div> <!-- End .content-box -->
			<div class="clear"></div>
			
			
			<%@include file="../include/footer.jsp" %>
			
		</div> 
	</div></body>
</html>
