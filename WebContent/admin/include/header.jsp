<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date"%>
<%@page import="tdt.db.adm.Admin"%>
<%@page import="java.util.Collection"%>
<%@page import="java.util.Iterator"%>
<%@page import="tdt.db.adm.AdminRole"%>
<jsp:useBean id="adminLogDAO" class="tdt.db.adm.AdminLogDAO" scope="session" />
<%
    if(session.getAttribute("datavasosp.adm.username")!=null && request.getRequestURL()!=null){
        System.out.println(new SimpleDateFormat("yyyyMMdd HH:mm:ss").format(new Date()) + "  user:"+ session.getAttribute("datavasosp.adm.username").toString() + " request link "+ request.getRequestURL());
    }
	if(request.getRequestURL().toString().endsWith("/")){
		response.sendRedirect(request.getRequestURL().toString()+"index.jsp");
		return;
	}
	//if(request.getRequestURL().toString().contains("210.211.99.68")){
	//	response.sendRedirect("http://vas.osp.vn");
	//	return;
	//}	
	
	if(session.getAttribute("datavasosp.adm.control")==null){
		response.sendRedirect(request.getContextPath()+"/admin/login/login.jsp");
		return;
	}
	Admin adm_control  = (Admin)session.getAttribute("datavasosp.adm.control");
	String realUrlHeader =  request.getRequestURL().toString()+"?"+request.getQueryString();

	//if(realUrlHeader.indexOf("/admin/admin/")!=-1
	//	&& adm_control.getRightRole() != 1){
	//	session.setAttribute("datavasosp.adm.access.", "denied");
	//	response.sendRedirect(request.getContextPath()+"/admin/access/");
	//	return;
	//}		

	
	boolean curPageIsSelect = false;
	boolean curPageIsInsert = false;
	boolean curPageIsUpdate = false;
	boolean curPageIsDelete = false;
	
	String currentURL = request.getRequestURL().toString();
	if(currentURL.indexOf(":")!=-1){
   		currentURL  = currentURL.substring(0, currentURL.lastIndexOf(":"))+ currentURL.substring(currentURL.lastIndexOf(":")).substring(currentURL.substring(currentURL.lastIndexOf(":")).indexOf("/"));
    }
    String linkRole = "";
    
    
    if(session.getAttribute("datavasosp.adm.role")!=null){
    	Collection cAdminPermission = (Collection) session.getAttribute("datavasosp.adm.role");
    	if(cAdminPermission!=null && cAdminPermission.size()>0){
			AdminRole adminRolePermission = null;
			for(Iterator itAdminPermission = cAdminPermission.iterator(); itAdminPermission.hasNext();){
				adminRolePermission = (AdminRole) itAdminPermission.next();
				if(adminRolePermission!=null){
					linkRole = adminRolePermission.getLink_uri();
					if(linkRole!=null && linkRole.indexOf(":")!=-1){
						linkRole  = linkRole.substring(0, linkRole.lastIndexOf(":"))+ linkRole.substring(linkRole.lastIndexOf(":")).substring(linkRole.substring(linkRole.lastIndexOf(":")).indexOf("/"));
	    			}
			//		System.out.println("linkRole: "+linkRole);
			//		System.out.println("isRole: "+currentURL.contains(linkRole));
					if(linkRole != null && currentURL.contains(linkRole)){
						if(adminRolePermission.getIs_select() == 0)
							curPageIsSelect = true;
						if(adminRolePermission.getIs_insert() == 0)
							curPageIsInsert = true;
						if(adminRolePermission.getIs_update() == 0)
							curPageIsUpdate = true;
						if(adminRolePermission.getIs_delete() == 0)
							curPageIsDelete = true;
						break;
					}
				}
			}
    	}
	}
//	System.out.println("name: "+adm_control.getUserName()+"se: "+curPageIsSelect+"in:"+curPageIsInsert+"up:"+curPageIsUpdate+"de:"+curPageIsDelete);
	if(adm_control.getUserName().equals("admin")){
		curPageIsSelect = true;
		curPageIsInsert = true;
		curPageIsUpdate = true;
		curPageIsDelete = true;
	}
	
	//System.out.println(request.getRequestURL().toString());
	//if(!request.getRequestURL().toString().equals("http://210.211.99.68:80/admin/index.jsp")){
	if(!request.getRequestURL().toString().contains("/admin/index.jsp")){	
		if(!curPageIsSelect){
			response.sendRedirect(request.getContextPath()+"/admin/access/");
			return;
		}
	}
	
	
	int adminRightRole = 0;
	try{
		adminRightRole = Integer.parseInt(session.getAttribute("datavasosp.adm.type").toString());
	}catch(Exception ex){}
	
		boolean adminIsPartner = false;
	boolean adminIsTelco = false;
	
	if(adminRightRole == Admin.RIGHT_PARTNER)
		adminIsPartner = true;
	
	if(adminRightRole == Admin.RIGHT_TELCO)
		adminIsTelco = true;
	
	String adminCpId = "";
	try{
		adminCpId = session.getAttribute("datavasosp.adm.cpid").toString();
	}catch(Exception ex){}
	
%>
