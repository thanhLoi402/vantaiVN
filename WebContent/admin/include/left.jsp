<%@ page language="java" pageEncoding="utf-8"%>
<%@page import="tdt.db.adm.Admin"%>
<%@page import="tdt.db.adm.AdminLink"%>
<%@page import="java.util.Vector"%>
<%@page import="java.util.Collection"%>
<%@page import="java.util.Iterator"%>
<%@page import="tdt.db.adm.AdminRole"%>
<jsp:useBean id="adminLinkDAO1" class="tdt.db.adm.AdminLinkDAO" scope="session" />
<%
    String realUrl = request.getRequestURL().toString() + "?" + request.getQueryString();
%>
<div id="tdtHiddenMenu" style="display:none; margin: 0 0 0 9px; position: fixed;">
    <a href="">		
        <span style="font-size: 30px; color:#FF7300 ;">&raquo;</span>		
    </a>
</div>
<div id="sidebar" style="position: fixed;">
    <div id="sidebar-wrapper"> <!-- Sidebar with logo and menu -->

        <div id="tdtMenu" style="text-align: right;padding-right: 10px;">
            <a href="#maximum" ><span style="font-size: 30px;">&laquo;</span></a>
        </div>
        <%
            Admin adm = null;
            try {
                adm = (Admin) session.getAttribute("datavasosp.adm.control");
            } catch (Exception ex) {
            }
        %>
        <!-- Sidebar Profile links -->
        <div id="profile-links">
            Xin chào, <font style="color: #21ff00;font-size: 13px;font-family: tahoma; padding-top: 10px;"><%=adm.getUserName()%></font> 
            <font style="font-size: 12px; padding-top: 10px; font-weight: bold;">
            <%=adm.getFullName() != null ? "<br/>" + adm.getFullName() : ""%>
            </font>
        </div>        
        <div id="profile-links">
            <a href="<%=request.getContextPath()%>/admin/admin/changepass.jsp" title="Đăng xuất">Đổi mật khẩu</a> | 				
            <a href="<%=request.getContextPath()%>/admin/login/logoff.jsp" title="Đăng xuất">Đăng xuất</a>
        </div>        

        <ul id="main-nav">  <!-- Accordion Menu -->
            <%
                if (false) {
            %>
            <li>
                <a href="<%=request.getContextPath()%>/admin/admin/" class="nav-top-item no-submenu <%=realUrl.indexOf("/admin/admin/") != -1 ? "current" : ""%>">
                    Quản trị người dùng
                </a>
            </li> 
            <%} %>				

            <%
                Vector<AdminLink> cAdminLinkAll = (Vector<AdminLink>) session.getAttribute("datavasosp.adm.menuAll");
                Collection cAdminPermission = (Collection) session.getAttribute("datavasosp.adm.role");
                Vector<AdminLink> cAdminLink = (Vector<AdminLink>) session.getAttribute("datavasosp.adm.menu");
                AdminLink objLink;
                AdminRole objAdminRolePermission;
                AdminLink objSubLink;
                boolean isSelected;
                boolean isShow = false;
                AdminLink objRoot;
                int totalMainMenu = 0;
                int index = -1;
                String linkShow;
                if (cAdminLink != null && cAdminLink.size() > 0) {
                    for (int i = 0; i < cAdminLink.size(); i++) {
                        objLink = cAdminLink.get(i);
                        if (objLink != null) {
                            if (cAdminPermission != null && cAdminPermission.size() > 0) {
                                for (Iterator itAdminPermission = cAdminPermission.iterator(); itAdminPermission.hasNext();) {
                                    objAdminRolePermission = (AdminRole) itAdminPermission.next();
                                    if (objAdminRolePermission != null && objAdminRolePermission.getLink_id().toString().equals(objLink.getId().toString()) && objAdminRolePermission.getIs_select() == 0) {
                                        isShow = true;
                                        break;
                                    }
                                }
                            }
                            if (isShow) {
                                linkShow = objLink.getUri();

                                if (linkShow.startsWith("http://")) {
                                    // link full, xu ly lay link tu /admin/
                                    if (linkShow.indexOf("/admin/") != -1) {
                                        index = linkShow.indexOf("/admin/");
                                    } else if (linkShow.indexOf("/cms/") != -1) {
                                        index = linkShow.indexOf("/cms/");
                                    }
                                    if (index != -1) {
                                        linkShow = request.getContextPath() + linkShow.substring(index);
                                    }
                                } else {

                                    if (linkShow.startsWith("admin/") || linkShow.startsWith("cms/")) {
                                        linkShow = request.getContextPath() + "/" + linkShow;
                                    }
                                    if (linkShow.startsWith("/admin/") || linkShow.startsWith("/cms/")) {
                                        linkShow = request.getContextPath() + linkShow;
                                    }
                                }

                                isSelected = false;
                                if (request.getRequestURL().toString().contains(linkShow)) {
                                    out.println("<script>document.getElementById('menu" + objLink.getParent_id() + "').className='nav-top-item current';</script>");
                                    isSelected = true;
                                    if (objLink.getLink_level() == 3) {
                                        objRoot = adminLinkDAO1.getRow(objLink.getParent_id());
                                        if (objRoot != null) {
                                            out.println("<script>document.getElementById('menu" + objRoot.getParent_id() + "').className='nav-top-item current';</script>");
                                            out.println("<script>document.getElementById('menu" + objLink.getParent_id() + "').className='current';</script>");
                                        }

                                    }
                                }

                                if (objLink.getLink_level() == 1) {
                                    totalMainMenu++;
                                    if (i > 0 && totalMainMenu > 1) {
                                        out.println("</ul></li>");
                                    }
                                    out.println("<li><a id='menu" + objLink.getId() + "' href='" + linkShow + "' class='nav-top-item'>" + objLink.getName() + "</a>");
                                    out.println("<ul>");
                                } else if (objLink.getLink_level() == 2) {
                                    String onclickFunction = "href='" + linkShow + "'";
									if(isSelected){
                                        out.println("<li><a " + onclickFunction + " id='menu" + objLink.getId() + "' class='current'>" + objLink.getName() + "</a>");
                                        out.println("<ul id='submenu" + objLink.getId() + "' style='display:block;'>");
									}else{
										out.println("<li><a " + onclickFunction + " id='menu" + objLink.getId() + "' class=''>" + objLink.getName() + "</a>");
	                                    out.println("<ul id='submenu" + objLink.getId() + "' style='display:none;'>");
									}
                                    if (isSelected && cAdminLinkAll != null && cAdminLinkAll.size() > 0) {
                                        for (int idx = 0; idx < cAdminLinkAll.size(); idx++) {
                                            objSubLink = cAdminLinkAll.get(idx);
                                            if (objSubLink != null && objSubLink.getParent_id().compareTo(objLink.getId()) == 0 && objSubLink.getDisplay_top() == 0) {
                                                isShow = false;
                                                if (cAdminPermission != null && cAdminPermission.size() > 0) {
                                                    for (Iterator itAdminPermission = cAdminPermission.iterator(); itAdminPermission.hasNext();) {
                                                        objAdminRolePermission = (AdminRole) itAdminPermission.next();
                                                        if (objAdminRolePermission != null && objAdminRolePermission.getLink_id().toString().equals(objSubLink.getId().toString()) && objAdminRolePermission.getIs_select() == 0) {
                                                            isShow = true;
                                                            break;
                                                        }
                                                    }
                                                }
                                                if (isShow) {
                                                        out.println("<li><a href='" + request.getContextPath() + objSubLink.getUri() + "' style='color:olivedrab;'>" + objSubLink.getName() + " - </a></li>");
                                                }
                                            }
                                        }
                                    }
                                    out.println("</ul>");

                                    out.println("</li>");
                                }
                            }

                            isShow = false;
                        }
                    }
                }
            %>
        </ul>
		<p style="padding-top: 50px;">
            <%
                session.setAttribute("currentURI", request.getRequestURI().toString());
            %>
            <a href="<%=request.getContextPath() %>/admin/admin/link/reloadMenu.jsp" style="padding-top: 20px;">
                &laquo; reload menu &raquo;
            </a>
            &nbsp;&nbsp;
        </p>

        <script type="text/javascript">
            $(document).ready(function () {
                $("[id^='submenu']").css("display", "none;");
            });
            function showMenu(idx) {
            	alert('1');
               $("[id^='submenu']").css("display", "none");
                //$("[id^=submenu_]")
               $("#submenu" + idx).fadeIn(500);
               $("#menu" + idx).css("font-weight", "bold");
            }

            var EXTENSTION_IMAGE = [".jpe", ".jpg", ".gif", ".png", ".bmp", ".ico", ".svg", ".tif", ".drw", ".pct", ".psp", ".xcf", ".psd", ".raw"];
            function checkExtensionImg(imgName) {
                if (imgName.toUpperCase().substring(imgName.length - 3, imgName.length) == '.AI') {
                    return true;
                }
                if (imgName.toUpperCase().substring(imgName.length - 5, imgName.length) == '.JPEG' || imgName.toUpperCase().substring(imgName.length - 5, imgName.length) == '.SVGZ'
                        || imgName.toUpperCase().substring(imgName.length - 5, imgName.length) == '.TIFF') {
                    return true;
                }
                for (var i = 0; i < EXTENSTION_IMAGE.length; i++) {
                    if (imgName.toUpperCase().substring(imgName.length - 4, imgName.length) == EXTENSTION_IMAGE[i].toUpperCase()) {
                        return true;
                    }
                }
                return false;
            }

            function timeoutFumction() {
                $('#frm-data').html('Tải dữ liệu không thành công!. Xin hãy thử lại sau.');
                return true;
            }
            function browseImage(e, imgTag, nameTag) {
                var filePath = e.value;
                var reader = new FileReader();
                reader.onload = function (e) {
                    $(imgTag).attr('src', e.target.result);
                };
                if (typeof (nameTag) != 'undefined')
                    $(nameTag).val(e.value);
                reader.readAsDataURL(e.files[0]);
            }
            
            function inputNumber(e){
//                alert(e.keyCode);
              // Allow: backspace, delete, tab, escape, enter and .
        if ($.inArray(e.keyCode, [46, 8, 9, 27, 13, 110, 190]) !== -1 ||
             // Allow: Ctrl+A
            (e.keyCode == 65 && e.ctrlKey === true) ||
             // Allow: Ctrl+C
            (e.keyCode == 67 && e.ctrlKey === true) ||
             // Allow: Ctrl+X
            (e.keyCode == 88 && e.ctrlKey === true) ||
             // Allow: home, end, left, right
            (e.keyCode >= 35 && e.keyCode <= 39)) {
                 // let it happen, don't do anything
                 return;
        }
        // Ensure that it is a number and stop the keypress
        if ((e.shiftKey || ((e.keyCode < 48) || (e.keyCode > 57))) && ((e.keyCode < 96) || (e.keyCode > 105))) {
            e.preventDefault();
        }
            }
        </script>	
    </div>
</div> <!-- End #sidebar -->