<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@page import="tdt.util.DateProc"%>
<%@page import="tdt.util.security.AES"%>
<%@page import="java.math.BigDecimal"%>
<%@page import="tdt.db.adm.AdminLog"%>
<%@ include file="../include/header.jsp" %>
<%	
	request.setCharacterEncoding("UTF-8");
	response.setCharacterEncoding("UTF-8");
	
	
	
	String sAdmin = request.getParameter("admin");
	if(sAdmin==null)
		sAdmin = "";
		
	String sType = request.getParameter("type");
	if(sType==null)
		sType = "";	
	
	int tong = adminLogDAO.countAllObjHaskey(sAdmin, sType);

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
	
	Collection cAdminLog = adminLogDAO.findAllObjHaskey(sAdmin, sType, currentPn, n);
 %>
<html >
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
	<title>Admin Log history</title>
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
	<script type="text/javascript" src="../include/tool.js"></script>
</head>

<body>
	<div id="body-wrapper"><!-- Wrapper for the radial gradient background -->		
		<jsp:include page="../include/left.jsp" />
		<div id="main-content"> <!-- Main Content Section with everything -->					
			<!-- Page Head -->
			<noscript> <!-- Show a notification if the user has disabled javascript -->
				<div class="notification error png_bg">
					<div>
						Javascript is disabled or is not supported by your browser. Please <a href="http://browsehappy.com/" title="Upgrade to a better browser">upgrade</a> your browser or <a href="http://www.google.com/support/bin/answer.py?answer=23852" title="Enable Javascript in your browser">enable</a> Javascript to navigate the interface properly.
					</div>
				</div>
			</noscript>
			<%@ include file="../../admin/include/tool.jsp" %>
			<div class="clear"></div>
			<h2 align="center">QUẢN LÝ ADMIN LOG</h2>
			<div class="clear"></div> <!-- End .clear -->			
			<div class="content-box"><!-- Start Content Box -->
				<form method="post" name="frmListCat" id="frmListCat">
				<input type="hidden" name="action"/>
				<input type="hidden" name="id"/>				
				<div class="content-box-header" style="padding: 3px;">
					<h3><img src="<%=request.getContextPath() %>/admin/login/resources/images/icons/arr.png" height="15px"/></h3>									
					&nbsp;&nbsp;&nbsp;Từ khóa&nbsp; <input type="text" class="text-input" name="admin" style="width: 150px;" value="<%=sAdmin %>"/>
					&nbsp;&nbsp;
					<select name="type">
						<option value="">--Type--</option>
						<option value="<%=AdminLog.TYPE_INSERT%>" <%if(sType.equals(String.valueOf(AdminLog.TYPE_INSERT))){ %> selected="selected" <%} %>>INSERT</option>
						<option value="<%=AdminLog.TYPE_UPDATE%>" <%if(sType.equals(String.valueOf(AdminLog.TYPE_UPDATE))){ %> selected="selected" <%} %>>UPDATE</option>
						<option value="<%=AdminLog.TYPE_DELETE%>" <%if(sType.equals(String.valueOf(AdminLog.TYPE_DELETE))){ %> selected="selected" <%} %>>DELETE</option>
					</select>	
					&nbsp;&nbsp;
					<input type="button" value="TÌM" class="button" onclick="frmListCat.submit();"/>
				</div> <!-- End .content-box-header -->
				
				<div class="content-box-content">					
					<div class="tab-content default-tab" id="tab1"> <!-- This is the target div. id must match the href of this div's tab -->						
											
						
						<table>							
							<thead>
								<tr>
								   <th>STT</th>
								   <th>Admin</th>
								   <th>Type</th>
								   <th>Description</th>
								   <th>Gen date</th>
								</tr>
							</thead>						 
							<tfoot>
								<tr>
									<td colspan="6">
										<div class="bulk-actions align-left" >
										</div>
										<%
										if(pn>1){
											String pageUrl = "admin-logs.jsp?admin="+sAdmin+"&type="+sType+"&p=";
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
							</tfoot>						 
							<tbody>
								<%
								String colorHidden = "";
								boolean isRootAndShow = true;
								int status = 0;				
								
								
								if(cAdminLog!=null && !cAdminLog.isEmpty()){
									AdminLog adminLog = null;
									int i=1;
									for(Iterator<AdminLog> it= cAdminLog.iterator(); it.hasNext(); i++){
										adminLog = it.next();
										if(adminLog==null) continue;
								%>
								<tr style="color: <%=colorHidden %>; ">
								   	<td><b><%=(currentPn-1)*n + i %></b></td>
									<td><%=adminLog.getAdmin() %></td>
									<td><%=adminLog.getType()==AdminLog.TYPE_UPDATE?"UPDATE":adminLog.getType()==AdminLog.TYPE_INSERT?"INSERT":"DELETE" %></td>
									<td><%=adminLog.getDescription() %></td>
									<td><%=DateProc.getDateTime24hString(adminLog.getGen_date()) %></td>
								</tr>
								<%	}
								} %>								
							</tbody>
						</table>
					</div> <!-- End #tab1 -->					
				</div> <!-- End .content-box-content -->
				</form>
			</div> <!-- End .content-box -->
			<div class="clear"></div>	
			
			
			<%@include file="../include/footer.jsp" %>
			
		</div> 
	</div>
</body>
</html>
