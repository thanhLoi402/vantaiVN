<%@page import="tdt.db.adm.Admin"%>
<%
	Admin adm_control  = (Admin)session.getAttribute("datavasosp.adm.control");
	if(adm_control==null){
		response.sendRedirect(request.getContextPath()+"/admin/login/login.jsp");
		return;
	}
	
		
	
%>
