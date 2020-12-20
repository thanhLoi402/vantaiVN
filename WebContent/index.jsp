<%@ page language="java" pageEncoding="utf-8"%>
<%
    System.out.println("request.getContextPath():"+ request.getContextPath());
    if(request.getContextPath()!=null && request.getContextPath().contains("splus.ivas.vn")){
	response.sendRedirect(request.getContextPath()+"/admin/index.jsp");
    }else{
	response.sendRedirect(request.getContextPath()+"/home.html");
    }
%>
