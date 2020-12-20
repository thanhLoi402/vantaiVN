<%@page language="java" pageEncoding="utf-8"%>
<%@page import="tdt.db.adm.*"%>
<%@page import="java.util.*"%>
<jsp:useBean id="adminDAO" class="tdt.db.adm.AdminDAO" scope="session" /><html >
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Access denied</title>
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
<%//@ include file="../include/header.jsp" %>
	<body>
	<div id="body-wrapper"> <!-- Wrapper for the radial gradient background -->
		
		<jsp:include page="../include/left.jsp" />
		<div id="main-content"> <!-- Main Content Section with everything -->					
			<!-- Page Head -->
			<div class="clear"></div> <!-- End .clear -->
			
			<div class="clear"></div> <!-- End .clear -->
			
			<div class="content-box"><!-- Start Content Box -->
				<div class="content-box-header" style="padding-top: 3px;">						
				<div class="clear"></div>					
				</div> <!-- End .content-box-header -->				
				<div class="content-box-content">					
					<div class="tab-content default-tab" id="denied"> <!-- This is the target div. id must match the href of this div's tab -->
						<center>
							<%
							if(session.getAttribute("datavasosp.adm.access.") == null
								|| "denied".equalsIgnoreCase(session.getAttribute("datavasosp.adm.access.").toString())){							
							%>
							<img src="../images/denied.jpg" />
							<%} %>
						</center>
					</div> <!-- End #tab1 -->					
				</div> <!-- End .content-box-content -->
				
			</div> <!-- End .content-box -->
			<div style="height: 200px;"></div>
			<div class="clear"></div>
			
			
			<%@include file="../include/footer.jsp" %>
			
		</div> 
	</div></body>
</html>
