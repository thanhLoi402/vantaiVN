<%@page language="java" pageEncoding="utf-8"%>
<%@page import="tdt.db.adm.*"%>
<%@page import="java.util.*"%>
<jsp:useBean id="adminDAO" class="tdt.db.adm.AdminDAO" scope="session" />
<jsp:useBean id="adminRoleDAO" class="tdt.db.adm.AdminRoleDAO" scope="session" />
<html >
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Danh sách thành viên quản trị</title>
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
	
	Admin admin = null;
	String sAction = request.getParameter("action");
	if(sAction==null)sAction="";
	String txtVar = request.getParameter("txtVar");
	if(txtVar==null){
		txtVar = request.getParameter("txtVar1");
		if(txtVar==null)txtVar="";
	}
	String sValue[] = request.getParameterValues("chkId");
	if(sAction.equals("DEL")){
		if(!curPageIsDelete){
			response.sendRedirect(request.getContextPath()+"/admin/access/");
			return;
		}
		if(sValue!=null && sValue.length>0){
			Admin objAdmin = null;
			for(int i = 0;i<sValue.length;i++){
				objAdmin = adminDAO.getRowById(Integer.parseInt(sValue[i]));
				if(adminDAO.deleteRow(Integer.parseInt(sValue[i]))){
					try{
						String description = "Xóa admin " + objAdmin.getUserName();
						adminRoleDAO.deleteRow(objAdmin.getUserName());
						adminLogDAO.insertRow(session.getAttribute("datavasosp.adm.username").toString(), description, AdminLog.TYPE_DELETE);
					}catch(Exception ex){}
				}
			}
		}
	}
	
	int tong = adminDAO.countAll(txtVar);

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
	
	Collection cAdmin = adminDAO.getAll(txtVar,currentPn,n);
	
 %>
 	<script type="text/javascript">
 		$(function(){
 			$("#btn-delete").click(function(){
 				if($('input[name="chkId"]:checked').length >0){
 					if(confirm('Bạn có muốn xóa những admin đã được lựa chọn ko?')){
	 					frmList.action.value='DEL';
	 					frmList.submit();
 					}
 				}
 			});
 		})
 	</script>
	<body>
	<div id="body-wrapper"> <!-- Wrapper for the radial gradient background -->
		
		<jsp:include page="../include/left.jsp" />
		<div id="main-content"> <!-- Main Content Section with everything -->					
			<!-- Page Head -->
			<%@ include file="../../admin/include/tool.jsp" %>
			<div class="clear"></div> <!-- End .clear -->
			<h2 align="center">DANH SÁCH QUẢN TRỊ VIÊN</h2>
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
									<td width="3%" >
									</td>
									<td>STT</td>
									<td width="15%">
										<h3 style="font-size: 13px;">Username</h3>
									</td>
									<td width="15%">
										<h3 style="font-size: 13px;">Fullname</h3>
									</td>
									<td width="15%">
										<h3 style="font-size: 13px;">Mobile</h3>
									</td>
									<td width="15%">
										<h3 style="font-size: 13px;">Email</h3>
									</td>
									<td width="15%">
										<h3 style="font-size: 13px;">Permision</h3>
									</td>
									<td width="15%">
										<h3 style="font-size: 13px;">Ip-Enable</h3>
									</td>
									<td width="6%" style="text-align: center">
										<h3 style="font-size: 13px;">Status</h3>
									</td>
									<td width="15%">
										<h3 style="font-size: 13px;">Role</h3>
									</td>
									<td width="6%">
										<h3 style="font-size: 13px;">Tool</h3>
									</td>
								</tr>
								<% 
									int index = 0;
									if(cAdmin!=null && cAdmin.size()>0){
									Iterator ite = cAdmin.iterator();
									while(ite.hasNext()){
										admin = (Admin)ite.next();
										if(admin!=null){
										index++;
								%>
								<tr class="list">
									<td>
										<input type="checkbox" name="chkId" value="<%=admin.getId() %>"/>
									</td>
									<td>
										<%=(currentPn-1)*n+index %>
									</td>
									<td>
										<%=admin.getUserName()!=null? admin.getUserName():"" %>
									</td>
									<td>
										<%=admin.getFullName()!=null? admin.getFullName():"" %>
									</td>
									<td>
										<%=admin.getMobile()!=null? admin.getMobile():"" %>
									</td>
									<td>
										<%=admin.getEmail()!=null? admin.getEmail():"" %>
									</td>
									<td>
										<%
											if(admin.getRightRole()==1)
												out.println("Admin");
											else if(admin.getRightRole()==0)
												out.println("Member");
											else if(admin.getRightRole()==2)
												out.println("Partner");
											else if(admin.getRightRole()==3)
												out.println("Telco");
											else if(admin.getRightRole()==4)
												out.println("CSKH");
										%>
									</td>
									<td>
										<%=admin.getIp()!=null? admin.getIp():"(all)" %>
									</td>									
									<td style="text-align: center">
										<%=admin.getStatus()==0?"Active":"Deactive"%>
									</td>
									<td>
										<a href="link/role.jsp?admin=<%=admin.getUserName() %>">Role</a>
									</td>
									<td>
										<a href="add.jsp?id=<%=admin.getId() %>"><img border="0" alt="" src="../login/resources/images/icons/pencil.png"/></a>
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
										<input class="button" id="btn-delete" type="button" value="DELETE"/>
									</td>
									<td>
										<div class="bulk-actions align-left" >
											<span id="spanTagAction" name="spanTagAction">									
											</span>				
										</div>
										<%
										if(pn>1){
											String pageUrl = "index.jsp?txtVar1="+txtVar+"&p=";
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
			<input class="button" type="button" value="NEW..." onclick="window.location.href='add.jsp';"/>
			<div class="clear"></div>
			
			
			<%@include file="../include/footer.jsp" %>
			
		</div> 
	</div></body>
</html>
