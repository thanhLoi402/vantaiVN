<%@page language="java" pageEncoding="utf-8"%>
<%@page import="java.util.*"%>
<jsp:useBean id="admDAO" class="tdt.db.adm.AdminDAO" scope="session"/>
<jsp:useBean id="adminRoleDAO" class="tdt.db.adm.AdminRoleDAO" scope="session" />
<jsp:useBean id="adminLinkDAO" class="tdt.db.adm.AdminLinkDAO" scope="session" />
<%@ include file="../../include/header_new.jsp" %>
<%
	if(session.getAttribute("datavasosp.adm.control")!=null){
		Admin adm = (Admin)session.getAttribute("datavasosp.adm.control");
		
		session.setAttribute("datavasosp.adm.control", adm);
		session.setAttribute("datavasosp.adm.id", adm.getId());
		session.setAttribute("datavasosp.adm.username", adm.getUserName());
		session.setAttribute("datavasosp.adm.type", adm.getRightRole());
		Collection cAdminRole = adminRoleDAO.findAllObjHaskey(adm.getUserName(), "", 1, 1000);
		session.setAttribute("datavasosp.adm.role", cAdminRole);
		session.setAttribute("datavasosp.adm.menu", adminLinkDAO.getTreeView2Level("0,9"));
		session.setAttribute("datavasosp.adm.menuAll", adminLinkDAO.findAll());
	}
	String URIRedirect;
	if(session.getAttribute("currentURI") != null) {
		URIRedirect = session.getAttribute("currentURI").toString();
	}
	else {
		URIRedirect = "/admin/";
	}
	response.sendRedirect(request.getContextPath() + URIRedirect);
%>