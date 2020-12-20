<%@page import="tdt.util.my.Base64"%>
<%@page import="java.util.List"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@page import="tdt.db.vas.viettel.splus.conf.ResourceType"%>
<jsp:useBean id="resourceTypeDAO" class="tdt.db.vas.viettel.splus.conf.ResourceTypeDAO" scope="session"></jsp:useBean>
<jsp:useBean id="myTool" class="tdt.util.my.MyTool" scope="session" />
<%@page import="java.text.SimpleDateFormat"%>
<%@ include file="../../../admin/include/header.jsp" %>
<%    int crPage = 1;
    int rowsPerPage = 20;
    String rsName = null;
    String rsCode = null;
    String rsUnit = null;
    String description = null;

    //rsName, rsCode, rsUnit, description
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
    rsName = request.getParameter("rsName");
    rsCode = request.getParameter("rsCode");
    rsUnit = request.getParameter("rsUnit");
    description = request.getParameter("description");
    List<ResourceType> lstItems = resourceTypeDAO.getListResourceTypeBO(rsName, rsCode, rsUnit, description, crPage, rowsPerPage);
    int countItem = resourceTypeDAO.countAll(rsName, rsCode, rsUnit, description);
    if (countItem > 0 && lstItems.size() == 0 && crPage > 1) {
        crPage = crPage - 1;
        lstItems = resourceTypeDAO.getListResourceTypeBO(rsName, rsCode, rsUnit, description, crPage, rowsPerPage);
    }
    int totalPage = countItem / rowsPerPage;
    if (countItem % rowsPerPage > 0) {
        totalPage = totalPage + 1;
    }
%>

<table class="table-striped" style="font-size: 12 !important; width: 100%; color: black; ">							
    <thead>
        <tr class="header" bgcolor="c6c6c6" align="center">
            <th>STT</th>
            <th>Tên tài nguyên</th>
            <th>Mã tài nguyên</th>
            <th>Đơn vị</th>
            <th>Mô tả</th>
            <th>Tools</th>
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
                    <a href="javascript:loadData('<%=rsName == null ? "" : rsName%>', '<%=rsCode == null ? "" : rsCode%>','<%=rsUnit == null ? "" : rsUnit%>','<%=description == null ? "" : description%>', 1, '<%=rowsPerPage%>')" title="First Page">&laquo; First</a>
                    <a href="javascript:loadData('<%=rsName == null ? "" : rsName%>', '<%=rsCode == null ? "" : rsCode%>','<%=rsUnit == null ? "" : rsUnit%>','<%=description == null ? "" : description%>', '<%=crPage - 1 > 0 ? (crPage - 1) : 1%>', '<%=rowsPerPage%>')" title="Previous Page">&laquo; Prev</a>
                    Page <%=crPage + "/" + totalPage%>											
                    <select name="page" style="height: 25px;" onchange="loadData('<%=rsName == null ? "" : rsName%>', '<%=rsCode == null ? "" : rsCode%>', '<%=rsUnit == null ? "" : rsUnit%>', '<%=description == null ? "" : description%>', this.options[this.selectedIndex].value, '<%=rowsPerPage%>')">
                        <%for (int i = 1; i <= totalPage; i++) {%>
                        <option value="<%=i%>" <%if (crPage == i) { %> selected="selected" <%}%> ><%=i%></option>
                        <%}%>
                    </select>

                    <a href="javascript:loadData('<%=rsName == null ? "" : rsName%>', '<%=rsCode == null ? "" : rsCode%>','<%=rsUnit == null ? "" : rsUnit%>','<%=description == null ? "" : description%>', '<%=crPage + 1 < totalPage ? crPage + 1 : totalPage%>', '<%=rowsPerPage%>')" title="Next Page">Next &raquo;</a>
                    <a href="javascript:loadData('<%=rsName == null ? "" : rsName%>', '<%=rsCode == null ? "" : rsCode%>','<%=rsUnit == null ? "" : rsUnit%>','<%=description == null ? "" : description%>', '<%=totalPage%>', '<%=rowsPerPage%>')" title="Last Page">Last &raquo;</a>
                </div> 
                <%} %>

                <div class="clear"></div>
            </td>
        </tr>
    </tfoot>						 
    <tbody>
        <%
            int index = 1;
            for (ResourceType item : lstItems) {
        %>
        <tr class="list">
            <td style="width: 30px; text-align: center;"><b><%=(crPage - 1) * rowsPerPage + index%></b></td>
            <td style="text-align: left;"><%=item.getRsName()%></td>
            <td style="text-align: left;"><%=item.getRsCode()%></td>
            <td style="text-align: left;"><%=item.getRsUnit()%></td>
            <td style="text-align: left;"><%=item.getDescription()%></td>
            <td style="text-align: center">
                <%if (curPageIsUpdate) {%>
                <a href="index.jsp?id=<%=item.getId()%>" title="Sửa">
                    <img src="<%=request.getContextPath()%>/admin/login/resources/images/icons/pencil.png" alt="Sửa" />
                </a>
                <%}%>
                &nbsp;
                <a href="index.jsp?id=<%=item.getId()%>&action=openPopup" title="Chi tiết">
                    <img src="<%=request.getContextPath()%>/admin/login/resources/images/icons/information.png" alt="Chi tiết" />
                </a>
                &nbsp;
                <%if (curPageIsDelete) {%>
                <a href="javascript:if(confirm('Bạn có chắc chắn muốn xóa?'))requestDeleteResourType('<%=item.getId()%>');" title="Xóa">
                    <img src="<%=request.getContextPath()%>/admin/login/resources/images/icons/cross.png" alt="Xóa" />
                </a>
                <%} %>
            </td>
        </tr>
        <%
                index = index + 1;
            }%>								
    </tbody>
</table>