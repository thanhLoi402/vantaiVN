<%@ page language="java" contentType="application/json; charset=UTF-8"
         pageEncoding="UTF-8"%>
<jsp:useBean id="confSubsBaseDAO" class="tdt.db.vas.viettel.splus.conf.ConfSubsBaseDAO" scope="session"></jsp:useBean>
<jsp:useBean id="resourcePackageDAO" class="tdt.db.vas.viettel.splus.conf.ResourcePackageDAO" scope="session"></jsp:useBean>
<%@ include file="../../../admin/include/header.jsp" %>
<%    boolean isDelete = false;
    String strRsType = request.getParameter("rsTypeId");
    String strRsScope = request.getParameter("rsScopeId");
    Long rsTypeId = null;
    Long rsScopeId = null;
    try {
        try {
            rsTypeId = Long.parseLong(strRsType);
        } catch (Exception e) {
        }
        try {
            rsScopeId = Long.parseLong(strRsScope);
        } catch (Exception e) {
        }
        isDelete = confSubsBaseDAO.checkPK(rsTypeId, rsScopeId);
        if (!isDelete) {
            isDelete = resourcePackageDAO.checkPK(rsTypeId, rsScopeId);
        }
    } catch (Exception e) {

    }
%>
{"success" : "true", "isDelete" : <%=isDelete%>}