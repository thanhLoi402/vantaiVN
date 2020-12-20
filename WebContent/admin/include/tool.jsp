<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@page import="tdt.db.adm.AdminLink"%>
<%@page import="java.math.BigDecimal"%>
<%@page import="tdt.db.adm.AdminLinkDAO"%>
<%@page import="tdt.db.adm.AdminRole"%>
<ul class="shortcut-buttons-set" style="float: right;">	
    <% if (false) { //Test%>
    <a href="#" class="label label-default">Default</a>
    <a href="#" class="label label-danger">Danger</a>
    <a href="#" class="label label-success">Success</a>
    <a href="#" class="label label-warning">Warning</a>
    <a href="#" class="label label-blue">Blue</a>
    <% } %>
    <%
        int indexTop = 0;
        String linkShowTop = "";
        AdminLink objLinkMenuTop = null;
        AdminRole objAdminMenuTopRight = null;
        BigDecimal currentLinkID = null;
        BigDecimal currentParentID = null;
        Vector<AdminLink> cAdminLinkAll = (Vector<AdminLink>) session.getAttribute("datavasosp.adm.menuAll");
        Vector<AdminRole> cAdminLinkRight = (Vector<AdminRole>) session.getAttribute("datavasosp.adm.role");
        if (cAdminLinkAll != null && cAdminLinkAll.size() > 0) {
            for (int i = 0; i < cAdminLinkAll.size(); i++) {
                objLinkMenuTop = cAdminLinkAll.get(i);
                if (objLinkMenuTop == null) {
                    continue;
                }
                linkShowTop = objLinkMenuTop.getUri();
                if (linkShowTop.indexOf("/admin/") != -1) {
                    indexTop = linkShowTop.indexOf("/admin/");
                } else if (linkShowTop.indexOf("/cms/") != -1) {
                    indexTop = linkShowTop.indexOf("/cms/");
                }
                if (indexTop != -1) {
                    linkShowTop = request.getContextPath() + linkShowTop.substring(indexTop);
                }

                if (request.getRequestURL().toString().contains(linkShowTop)) {
                    currentLinkID = objLinkMenuTop.getId();
                    currentParentID = objLinkMenuTop.getParent_id();
                    break;
                }
            }
        }

        if (currentLinkID != null) {
            int[] result = AdminLinkDAO.getCurrentMenuId(currentLinkID, cAdminLinkAll);
            out.println("<script>document.getElementById('menu" + result[0] + "').className='nav-top-item current';</script>");
            out.println("<script>document.getElementById('menu" + result[1] + "').className='current';</script>");
        }

        // lay ve ID cua trang hien tai
        // show tat ca cac menu con dc set Display
        // check quyen	
        int totalMenuTop = 0;
        boolean isShowMenuTop = false;
        if (cAdminLinkAll != null && cAdminLinkAll.size() > 0) {
            for (int i = 0; i < cAdminLinkAll.size(); i++) {
                objLinkMenuTop = cAdminLinkAll.get(i);
                if (objLinkMenuTop != null) {
                    linkShowTop = objLinkMenuTop.getUri();
                    if (linkShowTop.indexOf("/admin/") != -1) {
                        indexTop = linkShowTop.indexOf("/admin/");
                    } else if (linkShowTop.indexOf("/cms/") != -1) {
                        indexTop = linkShowTop.indexOf("/cms/");
                    }
                    if (indexTop != -1) {
                        linkShowTop = request.getContextPath() + linkShowTop.substring(indexTop);
                    }
                    for (int j = 0; j < cAdminLinkRight.size(); j++) {
                        isShowMenuTop = false;
                        objAdminMenuTopRight = cAdminLinkRight.get(j);
                        if (objAdminMenuTopRight != null && objAdminMenuTopRight.getLink_id().toString().equals(objLinkMenuTop.getId().toString())) {
                            isShowMenuTop = true;
                            break;
                        }
                    }
                    if (isShowMenuTop && currentLinkID != null && objLinkMenuTop != null && objLinkMenuTop.getParent_id().toString().equals(currentLinkID.toString()) && objLinkMenuTop.getDisplay_top() == 0 && (objLinkMenuTop.getStatus() == 0 || objLinkMenuTop.getStatus() == 9)) {
                        totalMenuTop++;
    %>			
    <%--			
    <li><a class="shortcut-button" href="<%=linkShowTop %>"><span>
            <img src="<%=request.getContextPath() %>/admin/login/resources/images/icons/list2.png" alt="icon" height="20px" /><br/>
            <%=objLinkMenuTop.getName() %>
    </span></a>
    </li>
    --%>
    <div style="float:left; padding:5px 5px 15px 0px;">
        <a href="<%=linkShowTop%>" class="label label-success" style="font-size: 13px;">
            <span ><%=objLinkMenuTop.getName()%></span>
        </a>
    </div>
    <%}
                }
            }
        }

        // khong co menu con
        if (totalMenuTop == 0) {
            if (cAdminLinkAll != null && cAdminLinkAll.size() > 0) {
                for (int i = 0; i < cAdminLinkAll.size(); i++) {
                    objLinkMenuTop = cAdminLinkAll.get(i);
                    if (objLinkMenuTop != null) {
                        linkShowTop = objLinkMenuTop.getUri();
                        if (linkShowTop.indexOf("/admin/") != -1) {
                            indexTop = linkShowTop.indexOf("/admin/");
                        } else if (linkShowTop.indexOf("/cms/") != -1) {
                            indexTop = linkShowTop.indexOf("/cms/");
                        }
                        if (indexTop != -1) {
                            linkShowTop = request.getContextPath() + linkShowTop.substring(indexTop);
                        }
                        for (int j = 0; j < cAdminLinkRight.size(); j++) {
                            isShowMenuTop = false;
                            objAdminMenuTopRight = cAdminLinkRight.get(j);
                            if (objAdminMenuTopRight != null && objAdminMenuTopRight.getLink_id().toString().equals(objLinkMenuTop.getId().toString())) {
                                isShowMenuTop = true;
                                break;
                            }
                        }
                        if (isShowMenuTop && currentLinkID != null && currentParentID != null && objLinkMenuTop != null && objLinkMenuTop.getParent_id().toString().equals(currentParentID.toString()) && objLinkMenuTop.getDisplay_top() == 0 && (objLinkMenuTop.getStatus() == 0 || objLinkMenuTop.getStatus() == 9)) {
                            totalMenuTop++;
    %>	
    <%--		
    <li><a class="shortcut-button" href="<%=linkShowTop %>"><span>
            <img src="<%=request.getContextPath() %>/admin/login/resources/images/icons/list1.png" alt="icon" height="20px" /><br/>
            <%=objLinkMenuTop.getName() %>
    </span></a></li>
    --%>
    <div style="float:left; padding:5px 5px 15px 0px;">
        <a href="<%=linkShowTop%>" class="label label-success" style="font-size: 13px; ">
            <span ><%=objLinkMenuTop.getName()%></span>
        </a>
    </div>
    <%}
                    }
                }
            }

                    }%>
</ul>

<br/>
<%//out.println("currentID:"+currentLinkID); %>

<!-- End .shortcut-buttons-set -->

<script type="text/javascript">
    function exportTableToExcel(tableID, filename) {
        var downloadLink;
        var dataType = 'application/vnd.ms-excel';
        
        var tableSelect = document.getElementById(tableID);
        var tableHTML = tableSelect.outerHTML.replace(/ /g, '%20');

// Specify file name
        filename = filename ? filename + '.xls' : 'excel_data.xls';

// Create download link element
        downloadLink = document.createElement("a");

        document.body.appendChild(downloadLink);

        if (navigator.msSaveOrOpenBlob) {
            var blob = new Blob(['\ufeff', tableHTML], {
                type: dataType
            });
            navigator.msSaveOrOpenBlob(blob, filename);
        } else {
            // Create a link to the file
            downloadLink.href = 'data:' + dataType + ', ' + tableHTML;

            // Setting the file name
            downloadLink.download = filename;

            //triggering the function
            downloadLink.click();
    }
    }
</script>
