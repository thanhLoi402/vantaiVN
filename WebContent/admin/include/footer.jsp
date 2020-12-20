<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.net.InetAddress"%>
<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%SimpleDateFormat sdf = new SimpleDateFormat("yyyy");%>
<div id="footer">
	<span style="text-align: right;">
	<small> <!-- Remove this notice or replace it with whatever you want -->
			&#169; Copyright <%=sdf.format(new Date()) %> <a href="#" style="color: #09B9F1; font-weight: bold;">###</a> | <a href="#">Top</a> 
			| <%=InetAddress.getLocalHost().getHostName() %>
			| <% 
				String ip = InetAddress.getLocalHost().getHostAddress();
				out.println(ip);
			%>
			|
			<%
				String serverNameInHeader = request.getHeader("my-server");
				if(serverNameInHeader!=null) out.println(" | "+serverNameInHeader);
			%>
	</small>
	</span>
</div><!-- End #footer -->