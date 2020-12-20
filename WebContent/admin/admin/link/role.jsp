<%@page language="java" pageEncoding="utf-8"%>
<%@page import="java.util.*"%>
<%@page import="tdt.db.adm.AdminRole"%>
<%@page import="tdt.db.adm.AdminLog"%>
<%@page import="java.math.BigDecimal"%>
<jsp:useBean id="adminLinkDAO" class="tdt.db.adm.AdminLinkDAO" scope="session" />
<jsp:useBean id="adminDAO" class="tdt.db.adm.AdminDAO" scope="session" />
<jsp:useBean id="adminRoleDAO" class="tdt.db.adm.AdminRoleDAO" scope="session" />
<%@ include file="../../include/header.jsp" %>
<html >
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
		<title>Danh sách link uri</title>
		<link rel="icon" href="<%=request.getContextPath() %>/images/icon/admin.ico" type="image/x-icon" />
		<link rel="stylesheet" href="../../login/resources/css/reset.css" type="text/css" media="screen" />
		<link rel="stylesheet" href="../../login/resources/css/style.css" type="text/css" media="screen" />
		<link rel="stylesheet" href="../../login/resources/css/invalid.css" type="text/css" media="screen" />	
		<script type="text/javascript" src="../../login/resources/scripts/jquery-1.3.2.min.js"></script>
		<script type="text/javascript" src="../../login/resources/scripts/simpla.jquery.configuration.js"></script>
		<script type="text/javascript" src="../../login/resources/scripts/facebox.js"></script>
		<script type="text/javascript" src="../../login/resources/scripts/jquery.wysiwyg.js"></script>
		<script type="text/javascript" src="../../login/resources/scripts/jquery.datePicker.js"></script>
		<script type="text/javascript" src="../../login/resources/scripts/jquery.date.js"></script>
		<script type="text/javascript">
			function showMenu(id){
	 			id = id+ "";
	 			id = id.replace(" ",".");
	 			var pId = id.replace(".","-");
	 			if($(".menu"+id).css('display') == 'none'){
	 				$("#p"+id).text("(hide)");
	 				$("#p"+pId).text("(hide)");
	 				$(".menu"+id).css("display","table-row");
	 			}else{
	 				$("#p"+id).text("(show)");
	 				$("#p"+pId).text("(show)");
	 				$(".menu"+id).css("display","none");
	 			}
	 		}
			function retrieveURLAction(url,function_change) {			
			 	if (window.XMLHttpRequest) { // Non-IE browsers
		      		req = new XMLHttpRequest();
		      		try {
		      			url = url+"?admin="+frmList.slt_admin.value;     		 
		          		req.open("GET", url, true); //was get       
		      		} catch (e) {
		        		alert("Problem Communicating with Server\n"+e);
			      	}
			      	req.onreadystatechange = function_change;
			      	req.send(null);
		    	} else if (window.ActiveXObject) { // IE	
			      	req = new ActiveXObject("Microsoft.XMLHTTP");
			      	if (req) {
			        	req.open("GET", url, true);	 	
			        	req.onreadystatechange = function_change;
			        	req.send();
			      	}
		    	}
		  	}
			function processStateChange() {						
		  		if (req.readyState == 4) { // Complete
			  		if (req.status == 200) { // OK response
		        		document.getElementById("tab1").innerHTML = req.responseText;
		        	} else {
		        		alert("Problem with server response:\n " + req.statusText);
		      		}
	    		}
	  		}
	  		
	  		function checkRow(id){
	  			var checkName;
	  			if(document.getElementById('checkRow'+id).checked == true)
	  				isChecked = true;
	  			else
	  				isChecked = false;
	  			if(document.getElementById('roleSelect'+id).disabled == false)
	  				document.getElementById('roleSelect'+id).checked = isChecked;
	  			if(document.getElementById('roleInsert'+id).disabled == false)
	  				document.getElementById('roleInsert'+id).checked = isChecked;
	  			if(document.getElementById('roleUpdate'+id).disabled == false)
	  				document.getElementById('roleUpdate'+id).checked = isChecked;
	  			if(document.getElementById('roleDelete'+id).disabled == false)
	  				document.getElementById('roleDelete'+id).checked = isChecked;
	  		}
	  		
	  		function checkAll(type){
	  			var inputs = document.getElementsByTagName("input");
	  			var myname;
	  			var isChecked;
	  			var checkName;
	  			if(type == 'roleSelect')
	  				checkName = 'selectAll';
	  			else if(type == 'roleInsert')
	  				checkName = 'insertAll';
	  			else if(type == 'roleUpdate')
	  				checkName = 'updateAll';
	  			else if(type == 'roleDelete')
	  				checkName = 'deleteAll';
	  			if(document.getElementById(checkName).checked == true)
	  				isChecked = true;
	  			else
	  				isChecked = false;
	  				
				for (x=0;x<=inputs.length;x++){
					if(typeof inputs[x] != "undefined"){
					    myname = inputs[x].getAttribute("name");
					    if(myname !=null && myname.indexOf(type)==0){
					    	if(document.getElementById(myname).disabled == false)
					    		document.getElementById(myname).checked = isChecked;
					    }
					}   
				}
	  		}
	  		
	  		function checkAllAll(type){
	  			var inputs = document.getElementsByTagName("input");
	  			var myname;
	  			var checkName;
	  			var isChecked;
	  			
	  			if(type == 'roleSelect')
	  				checkName = 'selectAll';
	  			else if(type == 'roleInsert')
	  				checkName = 'insertAll';
	  			else if(type == 'roleUpdate')
	  				checkName = 'updateAll';
	  			else if(type == 'roleDelete')
	  				checkName = 'deleteAll';
	  			
	  			if(document.getElementById('roleAll').checked == true)
	  				isChecked = true;
	  			else
	  				isChecked = false;
	  				
				for (x=0;x<=inputs.length;x++){
					if(typeof inputs[x] != "undefined"){
					    myname = inputs[x].getAttribute("name");
					    if(myname !=null && myname.indexOf(type)==0){
					    	if(document.getElementById(myname).disabled == false)
					    		document.getElementById(myname).checked = isChecked;
					    }
					}   
				}
	  		}
		</script>

	</head>

<%	
	response.setCharacterEncoding("utf-8");
	request.setCharacterEncoding("utf-8");
		
	String sAction = request.getParameter("action");
	if(sAction==null)sAction="";
	
	String admin = request.getParameter("admin");
	if(admin == null) admin = "";
	
	Vector<AdminLink> cAdminLink = adminLinkDAO.getTreeView(-1);
	
	if(sAction.equals("UPDATE")){
		if(!curPageIsUpdate || !curPageIsInsert){
			response.sendRedirect(request.getContextPath()+"/admin/access/");
			return;
		}
		String isSelect = "";
		String isInsert = "";
		String isUpdate = "";
		String isDelete = "";
		String sAdmin = request.getParameter("slt_admin");
		adminRoleDAO.deleteRow(sAdmin);
		if(cAdminLink!=null && cAdminLink.size()>0){
			AdminLink objAdminLink = null;
			AdminRole objAdminRole = null;
			for(int i=0;i<cAdminLink.size();i++){
				objAdminLink = cAdminLink.get(i);
				if(objAdminLink!=null){
					isSelect = request.getParameter("roleSelect"+objAdminLink.getId());
					if(isSelect==null) isSelect="1";
					isInsert = request.getParameter("roleInsert"+objAdminLink.getId());
					if(isInsert==null) isInsert="1";
					isUpdate = request.getParameter("roleUpdate"+objAdminLink.getId());
					if(isUpdate==null) isUpdate="1";
					isDelete = request.getParameter("roleDelete"+objAdminLink.getId());
					if(isDelete==null) isDelete="1";
					
					objAdminRole = new AdminRole();
					objAdminRole.setAdmin(sAdmin);
					objAdminRole.setLink_id(objAdminLink.getId());
					objAdminRole.setIs_select(Integer.parseInt(isSelect));
					objAdminRole.setIs_insert(Integer.parseInt(isInsert));
					objAdminRole.setIs_update(Integer.parseInt(isUpdate));
					objAdminRole.setIs_delete(Integer.parseInt(isDelete));		
					objAdminRole.setCreated_by(session.getAttribute("datavasosp.adm.username").toString());			
					
					if(adminRoleDAO.insertRow(objAdminRole)){
						String strPermission = "";
						if(isSelect.equals("0"))
							strPermission+= "SELECT-";
						if(isInsert.equals("0"))
							strPermission+= "INSERT-";
						if(isUpdate.equals("0"))
							strPermission+= "UPDATE-";
						if(isDelete.equals("0"))
							strPermission+= "DELETE-";
						if(strPermission.endsWith("-"))
							strPermission = strPermission.substring(0, strPermission.length()-1);
						String description = "Update quyền "+strPermission+" cho " +sAdmin+ " tại chuyên mục " + objAdminLink.getName(); 
						adminLogDAO.insertRow(session.getAttribute("datavasosp.adm.username").toString(), description , AdminLog.TYPE_UPDATE);
					}				
				}
			}
		}	
	}
	
	
 %>
	<body>
	<div id="body-wrapper"> <!-- Wrapper for the radial gradient background -->
		
		<jsp:include page="../../include/left.jsp" />
		<div id="main-content"> <!-- Main Content Section with everything -->					
			<!-- Page Head -->
			<%@ include file="../../../admin/include/tool.jsp" %>
			<div class="clear"></div> <!-- End .clear -->
			<h2 align="center">PHÂN QUYỀN CHO ADMIN</h2>
			<div class="clear"></div> <!-- End .clear -->
			
			<div class="content-box"><!-- Start Content Box -->
				<form method="post" name="frmList">
				<input type="hidden" name="action"/>
				<input type="hidden" name="id"/>
				<div class="content-box-header" style="padding-top: 5px;padding-left: 20px;">					
					<select name="slt_admin" onchange="retrieveURLAction('showAdminRole.jsp',processStateChange);">
						<option value="">--Chọn Admin--</option>
						<%
							Collection cAdmin = adminDAO.getAll("",1,1000);
							String roleType = "";
							if(cAdmin!=null && cAdmin.size()>0){
								Admin objAdmin = null;
								for(Iterator it = cAdmin.iterator(); it.hasNext();){
									objAdmin = (Admin) it.next();
									if(objAdmin!=null){
										if(objAdmin.getRightRole() == Admin.RIGHT_ADMIN)
											roleType = "Admin";
										else if(objAdmin.getRightRole() == Admin.RIGHT_MEMBER)
											roleType = "Member";
										else if(objAdmin.getRightRole() == Admin.RIGHT_TELCO)
											roleType = "Telco";
										else if(objAdmin.getRightRole() == Admin.RIGHT_PARTNER)
											roleType = "Partner";
						%>
							<option <%if(admin.equals(objAdmin.getUserName())){ %> selected="selected" <%} %> value="<%=objAdmin.getUserName() %>"><%=objAdmin.getUserName() %> -- <%=roleType %> </option>
						<%
									
									}
								}
							}
						%>
					</select>
				<div class="clear"></div>
					
				</div> <!-- End .content-box-header -->
				
				<div class="content-box-content">
					
					<div class="tab-content default-tab" id="tab1"> <!-- This is the target div. id must match the href of this div's tab -->
						<%
							if(admin!=null && !admin.equals("")){
								//Vector<AdminLink> cAdminLink = adminLinkDAO.getTreeView();
								Collection cAdminRole = adminRoleDAO.findAllObjHaskey(admin,"",1,1000);
						%>
							<table>							
								<thead>
									<tr>
									   <th>STT</th>
									   <th>Name</th>
									   <th><input type="checkbox" onclick="checkAll('roleSelect');" id="selectAll" name="selectAll" value="0"> Select</th>	
									   <th><input type="checkbox" onclick="checkAll('roleInsert');" id="insertAll" name="insertAll" value="0"> Insert</th>	
									   <th><input type="checkbox" onclick="checkAll('roleUpdate');" id="updateAll" name="updateAll" value="0"> Update</th>	
									   <th><input type="checkbox" onclick="checkAll('roleDelete');" id="deleteAll" name="deleteAll" value="0"> Delete</th>	
									</tr>
								</thead>						 
								<tbody>
									<%									
									if(cAdminLink!=null && cAdminLink.size()>0){
										AdminLink objLink = null;
										AdminRole objRole = null;
										boolean isSelect = false;
										boolean isInsert = false;
										boolean isUpdate = false;
										boolean isDelete = false;
										String[] arrColor = new String[] {"#0000EE", "red", "green", "#9900CC", "#001100"};		
										BigDecimal parentId = null;
										int totalParent = 0;
										String color = "";
										BigDecimal pId = null;
										BigDecimal p2Id = null;
										String link = "";
										for(int i=0;i<cAdminLink.size();i++){
											objLink = cAdminLink.get(i);
											if(objLink!=null){
												parentId = objLink.getParent_id();
												if(parentId.toString().equals("0")){
													totalParent++;
													color = arrColor[totalParent%arrColor.length];
													pId = objLink.getId();
												}	
												link = objLink.getUri();
												if(link.indexOf("admin")!=-1){
													link = request.getContextPath()+ "/" + link.substring(link.indexOf("admin"));
												}
												isSelect = false;
												isInsert = false;
												isUpdate = false;
												isDelete = false;
												if(cAdminRole!=null && cAdminRole.size()>0){
													for(Iterator itRole = cAdminRole.iterator(); itRole.hasNext();){
														objRole = (AdminRole) itRole.next();
														if(objRole!=null && objRole.getLink_id().toString().equals(objLink.getId().toString())){
															if(objRole.getIs_select()==0)
																isSelect = true;
															if(objRole.getIs_insert()==0)
																isInsert = true;
															if(objRole.getIs_update()==0)
																isUpdate = true;
															if(objRole.getIs_delete()==0)
																isDelete = true;
														}
													}
												}
												if(objLink.getParent_id().toString().equals(pId.toString())){
													p2Id = objLink.getId();
												}
									%>
									<tr style="background-color: white;" <%if(!objLink.getParent_id().toString().equals("0")){ %> class="menu<%=pId %><%=objLink.getLink_level()>2?(" "+p2Id):"" %>" <%} %>>
									   	<td><b><%=i+1%></b> <input type="checkbox" id="checkRow<%=objLink.getId() %>" onclick="checkRow('<%=objLink.getId() %>')" name="checkRow<%=objLink.getId() %>"></td>
										<td>
											<%
												if(objLink.getLink_level()==1)
													out.println("<span style='padding-left:50px;'></span>");
												else if(objLink.getLink_level()==2)
													out.println("<span style='padding-left:100px;'></span>");
												else if(objLink.getLink_level()==3)
													out.println("<span style='padding-left:150px;'></span>");
												else if(objLink.getLink_level()==4)
													out.println("<span style='padding-left:200px;'></span>");
												else if(objLink.getLink_level()==5)
													out.println("<span style='padding-left:250px;'></span>");
											%>
										<a style="color: <%=color %>; <%if(objLink.getParent_id().toString().equals("0")){ %> font-weight:bold;<%} %>" href="<%=objLink.getStatus()==2?"":link%>"><%=objLink.getName()%></a>
										<%if(objLink.getParent_id().toString().equals("0")){ %><a id="p<%=pId %>" onclick="showMenu(<%=pId %>)">(hide)</a> <%} %>
										
										<%if(objLink.getLink_level()==2){ %>
										<a id="p<%=pId+ "-" + p2Id %>" onclick="showMenu('<%=pId + " " + p2Id %>')">(hide)</a>
										<%} %>							
										</td>
										<td><input value="0" <%if(isSelect){ %> checked="checked" <%} %> id="roleSelect<%=objLink.getId()%>" name="roleSelect<%=objLink.getId() %>" type="checkbox" <%if(objLink.getIs_select()==1){ %> style="opacity:0.3;" disabled="disabled"<%} %>> </td>
										<td><input value="0" <%if(isInsert){ %> checked="checked" <%} %> id="roleInsert<%=objLink.getId()%>" name="roleInsert<%=objLink.getId() %>" type="checkbox" <%if(objLink.getIs_insert()==1){ %> style="opacity:0.3;" disabled="disabled"<%} %>> </td>
										<td><input value="0" <%if(isUpdate){ %> checked="checked" <%} %> id="roleUpdate<%=objLink.getId()%>" name="roleUpdate<%=objLink.getId() %>" type="checkbox" <%if(objLink.getIs_update()==1){ %> style="opacity:0.3;" disabled="disabled"<%} %>> </td>
										<td><input value="0" <%if(isDelete){ %> checked="checked" <%} %> id="roleDelete<%=objLink.getId()%>" name="roleDelete<%=objLink.getId() %>" type="checkbox" <%if(objLink.getIs_delete()==1){ %> style="opacity:0.3;" disabled="disabled"<%} %>> </td>
									</tr>
									<%	}}
									} %>								
								</tbody>
							</table>
							<table cellpadding="4" cellspacing="4" border="0"  width="80%">
								<tr>
									<td>
										<input class="button" type="button" value="UPDATE" onclick="frmList.action.value='UPDATE';frmList.submit();"/>
									</td>
									<td></td>
								</tr>
							</table>					
							
						<%} %>
					</div> <!-- End #tab1 -->					
				</div> <!-- End .content-box-content -->
				</form>
			</div> <!-- End .content-box -->
			
			<div class="clear"></div>
			
			
			<%@include file="../../include/footer.jsp" %>
			
		</div> 
	</div></body>
</html>
