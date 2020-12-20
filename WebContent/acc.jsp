<%@page import="tdt.db.adm.AdminRoleDAO"%>
<%@page import="tdt.db.adm.AdminExcelSheetReader"%>
<%@page import="tdt.db.pool.DBPoolXData"%>
<%@page import="java.io.FileInputStream"%>
<%@page import="java.io.InputStream"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Insert title here</title>
</head>
<body>
<%
//InputStream is = new FileInputStream(DBPoolXData.class.getResource("DS_account_CSKH2.xls").getFile());
System.out.println("ok");
//AdminExcelSheetReader ar=new AdminExcelSheetReader();
AdminRoleDAO admr=new AdminRoleDAO();
//System.out.println(ar.getListFromExcelFile(is));
System.out.println(admr.InsertRole());
%>
</body>
</html>