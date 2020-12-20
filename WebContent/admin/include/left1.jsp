<%@ page language="java" pageEncoding="utf-8"%>
<%@page import="tdt.db.adm.Admin"%>
<%@page import="tdt.db.adm.AdminLinkDAO"%>
<%@page import="tdt.db.adm.AdminLink"%>
<%@page import="java.util.Vector"%>
<%@page import="java.util.Collection"%>
<%@page import="java.util.Iterator"%>
<%@page import="tdt.db.adm.AdminRole"%>
<%@page import="java.math.BigDecimal"%>
<jsp:useBean id="adminLinkDAO1" class="tdt.db.adm.AdminLinkDAO" scope="session" />
<%
	//String currFolder = request.getRequestURI();
	//currFolder = currFolder.substring(0, currFolder.length()-1);
	//try{
	//	currFolder = currFolder.substring(currFolder.lastIndexOf("/")+1);
	//}catch(Exception ex){
	//	currFolder = "";
	//}
	
	String realUrl =  request.getRequestURL().toString()+"?"+request.getQueryString();
	int iMenu=0;
%>
<div id="tdtHiddenMenu" style="display:none; margin: 0 0 0 9px; position: fixed;">
	<a href="">		
		<span style="font-size: 30px; color:#FF7300 ;">&raquo;</span>		
	</a>
</div>
<div id="sidebar" style="position: fixed;">
		<div id="sidebar-wrapper"> <!-- Sidebar with logo and menu -->
			
			<div id="tdtMenu" style="text-align: right;padding-right: 10px;">
				<a href="#maximum" ><span style="font-size: 30px;">&laquo;</span></a>
			</div>
			
			
			<%
			Admin adm  = null;
			try{
				adm  = (Admin)session.getAttribute("datavasosp.adm.control"); 
			}catch(Exception ex){}			
			%>
			<%-- 
			<h1 id="sidebar-title"><a href="#">ADMIN</a></h1>
			<br/>
		    <a href="<%=request.getContextPath() %>/admin/" style="text-decoration: none;">
				<font style="padding-left: 60px;font-size: 30;" >
				QUẢN TRỊ
				</font>
			</a>
			--%>
			<!-- Logo (221px wide) -->
			<!-- <a href="#"><img id="logo" src="login/resources/images/logo.png" alt="Simpla Admin logo" /></a> -->
			<!-- Sidebar Profile links -->
			<div id="profile-links">
				Xin chào, <font style="color: red;font-size: 13px;font-family: tahoma; padding-top: 10px;"><%=adm.getUserName() %></font> 
				<font style="font-size: 12px; padding-top: 10px; font-weight: bold;">
					<%=adm.getFullName()!=null?"<br/>"+adm.getFullName():"" %>
				</font>
			</div>        
			<div id="profile-links">
				<a href="<%=request.getContextPath() %>/admin/admin/changepass.jsp" title="Đăng xuất">Đổi mật khẩu</a> | 				
				<a href="<%=request.getContextPath() %>/admin/login/logoff.jsp" title="Đăng xuất">Đăng xuất</a>
			</div>        
			
			<ul id="main-nav">  <!-- Accordion Menu -->
				<%
				if(false){ 
				%>
				<li>
					<a href="<%=request.getContextPath() %>/admin/admin/" class="nav-top-item no-submenu <%=realUrl.indexOf("/admin/admin/")!=-1?"current":"" %>">
						Quản trị người dùng
					</a>
				</li> 
				<%} %>				
			
				<%
				
				AdminLink rootLink = null;				
				BigDecimal currentParent = null;
				BigDecimal currentId = null;
				Collection cAdminPermission = (Collection) session.getAttribute("datavasosp.adm.role");				
				Vector<AdminLink> cAdminLink = (Vector<AdminLink>) session.getAttribute("datavasosp.adm.menu");
				if(cAdminLink!=null && cAdminLink.size()>0){						
					for(int i=0;i<cAdminLink.size();i++){
						rootLink = cAdminLink.get(i);
						if(request.getRequestURL().toString().contains(rootLink.getUri())){
							currentParent = rootLink.getParent_id();
							currentId = rootLink.getId();
							break;
						}
					}
				}
				
				System.out.println(request.getRequestURL().toString());
				
				AdminLink objLink = null;
				AdminRole objAdminRolePermission = null;
				//boolean isSelected = false;
				boolean isShow = false;
				AdminLink objRoot = null;
				int totalMainMenu = 0;
				
				if(cAdminLink!=null && cAdminLink.size()>0){						
					for(int  i=0;i<cAdminLink.size();i++){
						objLink = cAdminLink.get(i);
						if(objLink!=null){	
							if(cAdminPermission!=null && cAdminPermission.size()>0){
								for(Iterator itAdminPermission = cAdminPermission.iterator(); itAdminPermission.hasNext();){
									objAdminRolePermission = (AdminRole) itAdminPermission.next();
									if(objAdminRolePermission!=null && objAdminRolePermission.getLink_id().toString().equals(objLink.getId().toString()) && objAdminRolePermission.getIs_select()==0){
										isShow = true;
										break;
									}
								}								
							}
							
							if(isShow){						
								if(objLink.getLevel()==0){
									totalMainMenu++;
									if(i>0 && totalMainMenu>1){
										out.println("</li></ul>");
									}
									out.println("<li><a id='menu"+objLink.getId()+"' href='"+objLink.getUri()+"' class='nav-top-item "+(currentParent!=null && objLink.getId().toString().equals(currentParent.toString())?"current":"")+"'>"+objLink.getName()+"</a>");
									out.println("<ul>");
								}else if(objLink.getLevel()==1){
									out.println("<li><a id='menu"+objLink.getId()+"' "+(currentId!=null && objLink.getId().toString().equals(currentId.toString())?"class='current'":"")+" href='"+objLink.getUri()+"'>"+objLink.getName()+"</a></li>");
								}
							}
							
							isShow = false;
				}}}
				 %>
			</ul>			
		</div>
		</div> <!-- End #sidebar -->