<%@page import="org.json.JSONObject"%>
<%@page import="org.json.JSONArray"%>
<%@page import="tdt.util.my.Base64"%>
<%@page import="java.util.List"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<jsp:useBean id="myTool" class="tdt.util.my.MyTool" scope="session" />
<jsp:useBean id="daoExcuteSql" class="tdt.db.service.DaoExcuteSql" scope="session"></jsp:useBean>
<%@page import="java.text.SimpleDateFormat"%>
<%@ include file="../../../../admin/include/header.jsp" %>
<%    int crPage = 1;
    int rowsPerPage = 20;
    String sql = request.getParameter("sql");

    request.setCharacterEncoding("utf-8");
    response.setCharacterEncoding("utf-8");

    try {
        crPage = Integer.parseInt(request.getParameter("page"));
    } catch (Exception ex) {
    }
    try {
        rowsPerPage = Integer.parseInt(request.getParameter("rp"));
    } catch (Exception ex) {
    }
    sql = sql.trim().replace("'", "&");
    String arrayString[] = sql.substring(6, sql.indexOf("from")).split(",");
    for (int i = 0; i < arrayString.length; i++) {
        if (arrayString[i] != null && arrayString[i].trim().indexOf("as") > 0) {
            arrayString[i] = arrayString[i].substring(arrayString[i].indexOf("as") + 2, arrayString[i].length());
        }
    }
    int totalPage = 0;
    int countItem = 0;
    JSONArray lstItems = new JSONArray();
    try {
        lstItems = daoExcuteSql.findAll(sql, crPage, rowsPerPage);
        countItem = daoExcuteSql.countAll(sql);
        if (countItem > 0 && lstItems.length() == 0 && crPage > 1) {
            crPage = crPage - 1;
            lstItems = daoExcuteSql.findAll(sql, crPage, rowsPerPage);
        }
        totalPage = countItem / rowsPerPage;
        if (countItem % rowsPerPage > 0) {
            totalPage = totalPage + 1;
        }
    } catch (Exception ex) {
        ex.printStackTrace();
    }
%>

<table class="table-striped" style="font-size: 12 !important; width: 100%; color: black; ">							
    <thead>
        <tr class="header" bgcolor="c6c6c6" align="center">
            <th>STT</th>
                <%
                    for (int i = 0; i < arrayString.length; i++) {
                %>
            <th><%=arrayString[i]%></th>
                <%
                    }
                %>
        </tr>
    </thead>						 
    <tfoot>
        <tr>
            <td colspan="6">
                <div class="bulk-actions align-left" >
                    <span id="spanTagAction" name="spanTagAction"><%=countItem > 0 ? " Tổng số : " + countItem : "Không tìm thấy kết quả "%></span>				
                </div>
                <%
                    if (totalPage > 1) {
                %>
                <div class="pagination">
                    <a href="javascript:loadData('<%=sql%>', 1, '<%=rowsPerPage%>')" title="First Page">&laquo; First</a>
                    <a href="javascript:loadData('<%=sql%>', '<%=crPage - 1 > 0 ? (crPage - 1) : 1%>', '<%=rowsPerPage%>')" title="Previous Page">&laquo; Prev</a>
                    Page <%=crPage + "/" + totalPage%>											
                    <select name="page" style="height: 25px;" onchange="loadData('<%=sql%>', this.options[this.selectedIndex].value, '<%=rowsPerPage%>')">
                        <%for (int i = 1; i <= totalPage; i++) {%>
                        <option value="<%=i%>" <%if (crPage == i) { %> selected="selected" <%}%> ><%=i%></option>
                        <%}%>
                    </select>
                    <a href="javascript:loadData('<%=sql%>','<%=crPage + 1 < totalPage ? crPage + 1 : totalPage%>', '<%=rowsPerPage%>')" title="Next Page">Next &raquo;</a>
                    <a href="javascript:loadData('<%=sql%>','<%=totalPage%>', '<%=rowsPerPage%>')" title="Last Page">Last &raquo;</a>
                </div> 
                <%} %>
                <div class="clear"></div>
            </td>
        </tr>
    </tfoot>						 
    <tbody>
        <%
            int index = 1;
            for (int j = 0; j < lstItems.length(); j++) {
                JSONObject item = lstItems.getJSONObject(j);
                
                if(item.has("ERROR")){
                    out.println("<script type=\"text/javascript\">alert('" + item.get("ERROR") + "'); </script>");
                }else{
        %>
        <tr class="list">
            <td style="width: 30px; text-align: center;"><b><%=(crPage - 1) * rowsPerPage + index%></b></td>

            <%
                for (int i = 0; i < arrayString.length; i++) {
            %>
            <td style="text-align: center;"><%=item.get(arrayString[i].trim())%></td>
            <%
                }
            %>
        </tr>
        <%
                index = index + 1;
            }}%>								
    </tbody>
</table>