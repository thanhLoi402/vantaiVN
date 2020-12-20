<%
	String sLinkLogin = session.getAttribute("datavasosp.adm.linklogin")+"";
	if(sLinkLogin == null || "".equalsIgnoreCase(sLinkLogin) || "null".equalsIgnoreCase(sLinkLogin)){
		 sLinkLogin = request.getContextPath() + "/admin/login/login.jsp";
	}
	//////////////////////////////////////
	session.invalidate();
	//////////////////////////////////////
  	//response.sendRedirect("login.jsp");
  	response.sendRedirect(sLinkLogin);
%>
