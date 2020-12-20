<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@page import="java.math.BigDecimal"%>
<%@ include file="/admin/include/header.jsp" %>

<%	
	request.setCharacterEncoding("UTF-8");
	response.setCharacterEncoding("UTF-8");
 %>
<html >
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
	<title>Splus Viettel</title>
	<link rel="icon" href="<%=request.getContextPath() %>/images/icon/admin.ico" type="image/x-icon" />
	<link rel="stylesheet" href="<%=request.getContextPath() %>/admin/login/resources/css/reset.css" type="text/css" media="screen" />
	<link rel="stylesheet" href="<%=request.getContextPath() %>/admin/login/resources/css/style.css" type="text/css" media="screen" />
	<link rel="stylesheet" href="<%=request.getContextPath() %>/admin/login/resources/css/invalid.css" type="text/css" media="screen" />	
	<script type="text/javascript" src="<%=request.getContextPath() %>/admin/login/resources/scripts/jquery-1.3.2.min.js"></script>
	<script type="text/javascript" src="<%=request.getContextPath() %>/admin/login/resources/scripts/simpla.jquery.configuration.js"></script>
	<script type="text/javascript" src="<%=request.getContextPath() %>/admin/login/resources/scripts/facebox.js"></script>
	<script type="text/javascript" src="<%=request.getContextPath() %>/admin/login/resources/scripts/jquery.wysiwyg.js"></script>
	<script type="text/javascript" src="<%=request.getContextPath() %>/admin/login/resources/scripts/jquery.datePicker.js"></script>
	<script type="text/javascript" src="<%=request.getContextPath() %>/admin/login/resources/scripts/jquery.date.js"></script>
	<script type="text/javascript" src="<%=request.getContextPath() %>/admin/include/tool.js"></script>
	<link rel="stylesheet" href="<%=request.getContextPath() %>/admin/include/calendar_orange.css" title="calendar" />
	<script language="javascript" src="<%=request.getContextPath() %>/admin/include/calendar.js"></script>
	<script type="text/javascript">
		function detail(idInput){
			jQuery.facebox({ ajax: 'detail.jsp?id='+idInput })			
		}
	</script>
</head>

<body>
	<div id="body-wrapper"><!-- Wrapper for the radial gradient background -->		
		<jsp:include page="/admin/include/left.jsp" />
		<div id="main-content"> <!-- Main Content Section with everything -->					
			<!-- Page Head -->
			<%@ include file="../../admin/include/tool.jsp" %>			
			<div class="clear"></div>
			<div class="clear"></div> <!-- End .clear -->	
			<div class="content-box"><!-- Start Content Box -->
				<form method="post" name="frmListCat" id="frmListCat">
				<input type="hidden" name="action"/>
				<input type="hidden" name="id"/>				
				<div class="content-box-header" style="padding: 3px;">									
					<h3>Trang quản trị nội dung splus Viettel <img src="<%=request.getContextPath() %>/admin/login/resources/images/icons/arr.png" height="15px"/></h3>
				</div> <!-- End .content-box-header -->
				
				<div class="content-box-content" style="height: 300px;">					
					<br/><br/>
					<div class="notification attention png_bg">
						
						<a href="#" class="close"><img
								src="<%=request.getContextPath() %>/admin/login/resources/images/icons/cross_grey_small.png"
								title="Close this notification" alt="close" />
						</a>
						
						<div>
							Chọn các mục bên menu phía trên để quản lý nội dung!
						</div>
					</div>
							
				</div> <!-- End .content-box-content -->
				</form>
			</div> <!-- End .content-box -->
			<div class="clear"></div>	
			
			
			<%@include file="/admin/include/footer.jsp" %>
			
		</div> 
	</div>
</body>
</html>
