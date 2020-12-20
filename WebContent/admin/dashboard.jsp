
<%@ page language="java" pageEncoding="utf-8"%>
<%
    session.removeAttribute("CURR_PAGE");
%>
<html >
<head>

    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>Admin's page</title>
    <!--<link rel="stylesheet" href="login/resources/css/reset.css" type="text/css" media="screen" />-->
    <link rel="stylesheet" href="login/resources/css/style.css" type="text/css" media="screen" />
    <link rel="stylesheet" href="login/resources/css/invalid.css" type="text/css" media="screen" />
    <link rel="stylesheet" href="login/resources/css/bootstrap.min.css" type="text/css" media="screen" />
    <script type="text/javascript" src="login/resources/scripts/jquery-1.3.2.min.js"></script>
    <script type="text/javascript" src="login/resources/scripts/simpla.jquery.configuration.js"></script>
    <script type="text/javascript" src="login/resources/scripts/facebox.js"></script>
    <script type="text/javascript" src="login/resources/scripts/bootstrap.min.js"></script>
    <script type="text/javascript" src="login/resources/scripts/jquery.wysiwyg.js"></script>
    <script type="text/javascript" src="login/resources/scripts/jquery.datePicker.js"></script>
    <script type="text/javascript" src="login/resources/scripts/jquery.date.js"></script>
    <script type="text/javascript" src="login/resources/scripts/moment.min.js"></script>
    <script type="text/javascript" src="login/resources/scripts/core.js"></script>
    <script type="text/javascript" src="login/resources/scripts/charts.js"></script>
    <script type="text/javascript" src="login/resources/scripts/kelly.js"></script>
    <script type="text/javascript" src="http://malsup.github.io/jquery.blockUI.js"></script>
    <link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.5.0/css/all.css" >

    <script type="text/javascript">
//        function replaceContentInContainer(target, source) {
//            document.getElementById(target).innerHTML = document.getElementById(source).innerHTML;
//        }
//        function replaceContentInOtherContainer(replace_target, source){
//            alert(document.getElementById(source).innerHTML);
//            document.getElementById(replace_target).innerHTML = document.getElementById(source).innerHTML;
//        }
    </script>
</head>
<%@ include file="include/header.jsp" %>
<body>
<div id="main" style="display: none">
    <div class="main1">
        <div class="loading-main">
            <div class="item item-1"></div>
            <div class="item item-2"></div>
            <div class="item item-3"></div>
            <div class="item item-4"></div>
        </div>
        <p style="color: white;font-size: larger;margin-left: 10px">Đang cập nhật dữ liệu <span id="wait">.</span></p>
    </div>
</div>
<div id="body-wrapper"> <!-- Wrapper for the radial gradient background -->
    <jsp:include page="include/left.jsp" />
    <jsp:include page="include/dashboardNew.jsp" />
</div></body>
</html>
<!-- Sidebar with logo and menu -->