<%@page language="java" pageEncoding="utf-8"%>
<%@page import="tdt.db.adm.*"%>
<%@page import="java.util.*"%>
<%@page import="java.math.BigDecimal"%>
<%@page import="tdt.util.DateProc"%>
<jsp:useBean id="adminLinkDAO" class="tdt.db.adm.AdminLinkDAO" scope="session" />
<%@ include file="../../include/header.jsp" %>
<html >
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Danh sách link uri</title>
<link rel="icon" href="<%=request.getContextPath() %>/images/icon/admin.ico" type="image/x-icon" />
<link rel="stylesheet" href="../../login/resources/css/reset.css" type="text/css" media="screen" />
<link rel="stylesheet" href="../../login/resources/css/style.css" type="text/css" media="screen" />
<link rel="stylesheet" href="../../login/resources/css/invalid.css" type="text/css" media="screen" />	
<script type="text/javascript" src="../../login/resources/scripts/jquery-1.3.2.min.js"></script>
<script type="text/javascript" src="../../login/resources/scripts/simpla.jquery.configuration.js"></script>
<script type="text/javascript" src="../../login/resources/scripts/facebox.js"></script>
<script type="text/javascript" src="../../login/resources/scripts/jquery.wysiwyg.js"></script>
</head>

<%	
	response.setCharacterEncoding("utf-8");
	request.setCharacterEncoding("utf-8");
	
	
	String sAction = request.getParameter("action");
	if(sAction==null)sAction="";
	if(sAction.equals("DELETE")){
		if(!curPageIsDelete){
			response.sendRedirect(request.getContextPath()+"/admin/access/");
			return;
		}
		String id = request.getParameter("id");
		try{
			AdminLink objLink = adminLinkDAO.getRow(new BigDecimal(id));
			if(adminLinkDAO.deleteRow(new BigDecimal(id))){
				String description = "Xóa link quản trị " + objLink.getName();
				adminLogDAO.insertRow(session.getAttribute("datavasosp.adm.username").toString(), description, AdminLog.TYPE_DELETE);
			}
		}catch(Exception ex){}
	}
	
	Vector<AdminLink> cAdminLink = adminLinkDAO.getTreeView2(new BigDecimal(0), -1); 
 %>
 	<script type="text/javascript">
 		function showMenu(id){
 			id = id+ "";
 			id = id.replace(" ",".");
 			var pId = id.replace(".","-");
 			if($(".menu"+id).css('display') == 'none'){
 				$("#p"+id).text("(hide)");
 				$("#p"+pId).text("(hide)");
 				$(".menu"+id).css("display","table-row");
 			}else{
 				$("#p"+id).text("(show)");
 				$("#p"+pId).text("(show)");
 				$(".menu"+id).css("display","none");
 			}
 		}
 	</script>
	<body>
	<div id="body-wrapper"> <!-- Wrapper for the radial gradient background -->
		
		<jsp:include page="../../include/left.jsp" />
		<div id="main-content"> <!-- Main Content Section with everything -->					
			<!-- Page Head -->
			<%@ include file="../../../admin/include/tool.jsp" %>
			<div class="clear"></div> <!-- End .clear -->
			<h2 align="center"></h2>
			<div class="clear"></div> <!-- End .clear -->
			
			<div class="content-box"><!-- Start Content Box -->
				<form method="post" name="frmList">
				<input type="hidden" name="action"/>
				<input type="hidden" name="id"/>
				<div class="content-box-header" style="padding-top: 3px;">					
					<h3 align="left">Danh sách link URI
						<img src="<%=request.getContextPath() %>/admin/login/resources/images/icons/arr.png" height="15px"/></h3>							
						<span style="float: right;padding-right: 20px;"><input class="button" type="button" value="NEW..." onclick="window.location.href='add.jsp';"/></span>
					<div class="clear"></div>					
				</div>
				
				<div class="content-box-content">
					
					<div class="tab-content default-tab" id="tab1"> <!-- This is the target div. id must match the href of this div's tab -->
														
							<table>							
								<thead>
									<tr>
									   <th>STT</th>
									   <th>Status</th>
									   <th>Name</th>
									   <th>Top</th>
									   <th>Function</th>	
									   <th>Tools</th>						   
									</tr>
								</thead>						 
								<tbody>
									<%
									String colorHidden = "";
									boolean isRootAndShow = true;
									int status = 0;		
									
									String[] arrColor = new String[] {"#0000EE", "red", "green", "#9900CC", "#001100"};		
									BigDecimal parentId = null;
									int totalParent = 0;
									String color = "";
									String function = "";
									int pos1 = 0, pos2 = 0, pos3 = 0, pos4 = 0, pos5 = 0;
									int level = 0;
									String link = "";
									BigDecimal pId = null;
									BigDecimal p2Id = null;
									if(cAdminLink!=null && cAdminLink.size()>0){
										AdminLink objLink = null;
										for(int i=0;i<cAdminLink.size();i++){
											objLink = cAdminLink.get(i);
											if(objLink!=null){	
												function = "";									
												parentId = objLink.getParent_id();
												if(parentId.toString().equals("0")){
													totalParent++;
													color = arrColor[totalParent%arrColor.length];
													pId = objLink.getId();
												}
												level = objLink.getLink_level();
												
												link = objLink.getUri();
												if(link.indexOf("admin")!=-1){
													link = request.getContextPath()+ "/" + link.substring(link.indexOf("admin"));
												}else if(link.indexOf("cms")!=-1){link = request.getContextPath()+ "/" + link.substring(link.indexOf("cms"));}
												
												if(objLink.getParent_id().toString().equals(pId.toString())){
													p2Id = objLink.getId();
												}
																		
									%>
									<tr style="background-color: white;" <%if(!objLink.getParent_id().toString().equals("0")){ %> class="menu<%=pId %><%=objLink.getLink_level()>2?(" "+p2Id):"" %>" <%} %>>
									   	<td>
									   		<b><%=i+1%></b>
									   	</td>
									   	<td>
									   		<%if(objLink.getStatus()==9)
									   			out.println("All");
									   		  else if(objLink.getStatus()==0)
									   		  	out.println("Server");
									   		  else if(objLink.getStatus()==2)
									   		  	out.println("Client");
									   		  else if(objLink.getStatus()==1)
									   		  	out.println("Deactive");
									   		%>
									   	</td>
										<td>
										<%
											if(level==1){
												pos1++;
												pos2 = 0;
												out.println("<span style='padding-left:50px;'></span>"+pos1 + ". ");
											}else if(objLink.getLink_level()==2){
												pos2++;
												pos3 = 0;
												out.println("<span style='padding-left:100px;'></span>"+pos2 + ". ");
											}else if(level==3){
												pos3++;
												pos4 = 0;
												out.println("<span style='padding-left:150px;'></span>"+pos3 + ". ");
											}else if(level==4){
												pos4++;
												pos5 = 0;
												out.println("<span style='padding-left:200px;'></span>"+pos4 + ". ");
											}else if(level==5){
												pos5++;
												out.println("<span style='padding-left:250px;'></span>"+pos5 + ". ");
											}
										%>
										<a style="cursor:pointer; color: <%=color %>; <%if(objLink.getParent_id().toString().equals("0")){ %> font-weight:bold;<%} %>" href="<%=objLink.getStatus()==2?"":link%>"><%=objLink.getName()%></a>
										<%if(objLink.getParent_id().toString().equals("0")){ %><a style="cursor:pointer;" id="p<%=pId %>" onclick="showMenu(<%=pId %>)">(hide)</a> <%} %>
										
										<%if(objLink.getLink_level()==2){ %>
										<a style="cursor:pointer;" id="p<%=pId+ "-" + p2Id %>" onclick="showMenu('<%=pId + " " + p2Id %>')">(hide)</a>
										<%} %>
										</td>
										
										<td>
											<%=objLink.getDisplay_top()==0?"YES":"" %>
										</td>
										<td>
											<%
												if(objLink.getIs_select()==0)
													function+= " SELECT -";
												if(objLink.getIs_insert()==0)
													function+= " INSERT -";
												if(objLink.getIs_update()==0)
													function+= " UPDATE -";
												if(objLink.getIs_delete()==0)
													function+= " DELETE -";
													
												out.println(function.endsWith("-")?function.substring(0,function.length()-1): function);
											%>
										</td>
										<td>
											 <a href="add.jsp?id=<%=objLink.getId() %>" title="Edit">
											 	<img src="<%=request.getContextPath() %>/admin/login/resources/images/icons/pencil.png" alt="Edit" />
											 </a>
											 <a style="cursor: pointer;" onclick="if(confirm('Bạn có muốn xóa link này không?')){frmList.action.value='DELETE';frmList.id.value='<%=objLink.getId() %>';frmList.submit(); }">
											 	<img src="<%=request.getContextPath() %>/admin/login/resources/images/icons/cross.png" alt="Delete" />
											 </a> 
										</td>
									</tr>
									<%	}}
									} %>								
								</tbody>
							</table>
							<table cellpadding="4" cellspacing="4" border="0"  width="80%">
								<tr>
									<td>
									</td>
									<td>
									</td>
								</tr>
							</table>
						
						
					</div> <!-- End #tab1 -->
					
				</div> <!-- End .content-box-content -->
				</form>
			</div> <!-- End .content-box -->
			<input class="button" type="button" value="NEW..." onclick="window.location.href='add.jsp';"/>
			<div class="clear"></div>
			
			
			<%@include file="../../include/footer.jsp" %>
			
		</div> 
	</div></body>
</html>
