<%@ page language="java" pageEncoding="utf-8"%>
<%
    System.out.println("request.getContextPath():"+ request.getContextPath());
    response.sendRedirect(request.getContextPath()+"/admin/index.jsp");
%>
