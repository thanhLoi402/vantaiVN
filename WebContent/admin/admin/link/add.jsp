<%@ page language="java" pageEncoding="utf-8"%>
<%@page import="tdt.db.adm.*"%>
<%@page import="java.math.*"%>
<%@page import="java.io.*"%>
<%@page import="tdt.util.Md5"%>
<%@page import="tdt.util.DateProc"%>
<%@page import="java.util.Vector"%>
<%@page import="java.util.Collection"%>
<%@page import="java.util.Iterator"%>
<%@page import="tdt.util.StringTool"%>
<jsp:useBean id="adminLinkDAO" class="tdt.db.adm.AdminLinkDAO" scope="session" />
<jsp:useBean id="adminRoleDAO" class="tdt.db.adm.AdminRoleDAO" scope="session" />
<jsp:useBean id="adminDAO" class="tdt.db.adm.AdminDAO" scope="session" />
<%@ include file="../../include/header.jsp" %>
<% 
		response.setCharacterEncoding("utf-8");
  		request.setCharacterEncoding("utf-8");
  		
  		String sId = request.getParameter("id");
  		if(sId==null)sId = "";
  		String sAction = request.getParameter("action");
  		if(sAction==null)sAction = "";  		
  		
		
		String sUri = request.getParameter("txt_uri");
		if(sUri==null)
			sUri = "";
		sUri = sUri.trim();	
		String sName = request.getParameter("txt_name");
		if(sName==null)
			sName = "";
			
		String sParentId = request.getParameter("slt_parentId");
		if(sParentId==null)
			sParentId = "0";
			
		String sStatus = request.getParameter("slt_status");
		if(sStatus==null)
			sStatus = "0";
			
		String sPosition = request.getParameter("txt_position");
		if(sPosition==null)
			sPosition = "1";
			
		String sDisplayTop = request.getParameter("chk_displayTop");
		if(sDisplayTop==null)
			sDisplayTop = "1";
			
		String sSelect = request.getParameter("chk_select");
		if(sSelect==null)
			sSelect = "1";
		
		String sInsert = request.getParameter("chk_insert");
		if(sInsert==null)
			sInsert = "1";
		
		String sUpdate = request.getParameter("chk_update");
		if(sUpdate==null)
			sUpdate = "1";
			
		String sDelete = request.getParameter("chk_delete");
		if(sDelete==null)
			sDelete = "1";
			
  		
  		AdminLink obj = null;
  		
	    if(sId.length()>0 && StringTool.isNumberic(sId)){
  			try{
  				obj = adminLinkDAO.getRow(new BigDecimal(sId));
  			}catch(Exception ex){}
  		}		
  		
  		
  		
  		boolean isOK = false;
  		if(sAction.equals("INSERT")){  
  			if(!curPageIsInsert){
				response.sendRedirect(request.getContextPath()+"/admin/access/");
				return;
			}
  			obj = new AdminLink();
  			obj.setName(sName);
  			obj.setUri(sUri);
  			obj.setParent_id(new BigDecimal(sParentId));
  			obj.setStatus(Integer.parseInt(sStatus));
  			obj.setPosition(Integer.parseInt(sPosition));
  			obj.setDisplay_top(Integer.parseInt(sDisplayTop));		
  			obj.setIs_select(Integer.parseInt(sSelect));	
  			obj.setIs_insert(Integer.parseInt(sInsert));
  			obj.setIs_update(Integer.parseInt(sUpdate));
  			obj.setIs_delete(Integer.parseInt(sDelete));
  			isOK = adminLinkDAO.insertRow(obj);
  			
  			if(isOK){ 
  				BigDecimal currentId = adminLinkDAO.getMaxId();
  				Vector<AdminLink> cResults = adminLinkDAO.findAll();
  				adminLinkDAO.updateCurrentLevel(currentId, AdminLinkDAO.getCurrentLevel(currentId, cResults));
  			
  				String description = "Thêm mới link quản trị " + sName;
				adminLogDAO.insertRow(session.getAttribute("datavasosp.adm.username").toString(), description, AdminLog.TYPE_INSERT);
				
				Collection cAdministrator = adminDAO.getAll("",1,1000);
				AdminRole objAdminRole = new AdminRole();
				objAdminRole.setIs_select(Integer.parseInt(sSelect));	
	  			objAdminRole.setIs_insert(Integer.parseInt(sInsert));
	  			objAdminRole.setIs_update(Integer.parseInt(sUpdate));
	  			objAdminRole.setIs_delete(Integer.parseInt(sDelete));
	  			objAdminRole.setCreated_by(session.getAttribute("datavasosp.adm.username").toString());
	  			objAdminRole.setLink_id(adminLinkDAO.getMaxId());
	  			Admin objAdministrator = null;
				if(cAdministrator!=null && cAdministrator.size()>0){
					for(Iterator itAdministrator = cAdministrator.iterator(); itAdministrator.hasNext();){
						objAdministrator = (Admin) itAdministrator.next();
						if(objAdministrator!=null && objAdministrator.getRightRole()==1){
							objAdminRole.setAdmin(objAdministrator.getUserName());
							adminRoleDAO.insertRow(objAdminRole);
							//System.out.println("insert row Admin: "+objAdministrator.getUserName()+":"+adminRoleDAO.insertRow(objAdminRole));
						}
					}
				}
				
  				out.println("<script type=\"text/javascript\">alert('Tạo mới thành công');window.location.href='index.jsp';</script>");
  			}else out.println("<script type=\"text/javascript\">alert('Tạo mới không thành công. Link URI đã tồn tại');history.go(-1);</script>");
  		}
  		if(sAction.equals("EDIT")){
  			if(!curPageIsUpdate){
				response.sendRedirect(request.getContextPath()+"/admin/access/");
				return;
			}
			BigDecimal currentParent = obj.getParent_id();
			boolean isUpdateParent = false;
			
  			obj = new AdminLink();
  			obj.setName(sName);
  			obj.setUri(sUri);  			
  			obj.setParent_id(new BigDecimal(sParentId));
  			//if(!currentParent.toString().equals(sParentId))
  			//	isUpdateParent = true;
  			obj.setStatus(Integer.parseInt(sStatus));
  			obj.setPosition(Integer.parseInt(sPosition));
  			obj.setDisplay_top(Integer.parseInt(sDisplayTop));
  			obj.setIs_select(Integer.parseInt(sSelect));	
  			obj.setIs_insert(Integer.parseInt(sInsert));
  			obj.setIs_update(Integer.parseInt(sUpdate));
  			obj.setIs_delete(Integer.parseInt(sDelete));
  			obj.setId(new BigDecimal(sId));
  			isOK = adminLinkDAO.updateRow(obj);		
  			if(isOK){   	
  				Vector<AdminLink> cResults = adminLinkDAO.findAll();
  				int currentLevel = AdminLinkDAO.getCurrentLevel(new BigDecimal(sId), cResults);
  				//if(isUpdateParent)
  				//	currentLevel=currentLevel+1;
  				adminLinkDAO.updateCurrentLevel(new BigDecimal(sId), currentLevel);			
  				String description = "Cập nhật link quản trị " + sName;
				adminLogDAO.insertRow(session.getAttribute("datavasosp.adm.username").toString(), description, AdminLog.TYPE_UPDATE);
  				out.println("<script type=\"text/javascript\">alert('Cập nhật thành công');window.location.href='index.jsp';</script>");
  			}else out.println("<script type=\"text/javascript\">alert('Cập nhật không thành công');history.go(-1);</script>");
  		}
  %>
<html >
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<title><%=obj==null?"Thêm mới":"Cập nhật thông tin" %></title>
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
	<script type="text/javascript" src="../../include/tool.js"></script>
	<script type="text/javascript">	
		function checkForm(isInsert){	
			var formInput = document.frmAdd;		
			var name = formInput.txt_name.value;
			var uri = formInput.txt_uri.value;
			var position = formInput.txt_position.value;
						
			if(name==''){			
				alert('Bạn chưa nhập tên');
	  			return false;
	  		}
	  		if(uri==''){			
				alert('Bạn chưa nhập uri');
	  			return false;
	  		}
	  		if(position==''){			
				alert('Bạn chưa nhập thứ tự hiển thị');
	  			return false;
	  		}
	  		if(isInsert)
	  			formInput.action.value='INSERT';  		
	  		else
	  			formInput.action.value='EDIT';  	
	  		formInput.submit();
		}   
	</script>

</head>

	<body>
	<div id="body-wrapper"> <!-- Wrapper for the radial gradient background -->
		
		<jsp:include page="../../include/left.jsp" />
		<div id="main-content"> <!-- Main Content Section with everything -->
			
			<noscript> <!-- Show a notification if the user has disabled javascript -->
				<div class="notification error png_bg">
					<div>
						Javascript is disabled or is not supported by your browser. Please <a href="http://browsehappy.com/" title="Upgrade to a better browser">upgrade</a> your browser or <a href="http://www.google.com/support/bin/answer.py?answer=23852" title="Enable Javascript in your browser">enable</a> Javascript to navigate the interface properly.
					</div>
				</div>
			</noscript>
			<%@ include file="../../../admin/include/tool.jsp" %>
			<div class="clear"></div>
			<!-- Page Head -->
			<h2 align="center"><%=sId.length()>0? "CẬP NHẬT THÔNG TIN LINK URL":"TẠO MỚI THÔNG TIN LINK URL" %></h2>
			
			<div class="clear"></div> <!-- End .clear -->
			
			<div class="content-box"><!-- Start Content Box -->
				
				<div class="content-box-header">
					
					<h3></h3>
					
					<div class="clear"></div>
					
				</div> <!-- End .content-box-header -->
				
				<div class="content-box-content">
					
					<div class="tab-content default-tab" id="tab1"> <!-- This is the target div. id must match the href of this div's tab -->
						
						<form method="post" name="frmAdd" >
				  		<input type="hidden" name="action"/>
				  		<input type="hidden" name="id" value="<%=sId %>"/>
				  		<table width="100%" cellpadding="4" cellspacing="4" border="1" rules="all">
				  			<tr>
				  				<td width="20%" class="header">
				  					<label>Name :</label> 
				  				</td>
				  				<td>
				  					<input style="width: 300px;" name="txt_name" value="<%=obj!=null && obj.getName()!=null?obj.getName():"" %>"  class="text-input" type="text"  /> 
				  				</td>
				  			</tr>
				  			<tr>
				  				<td width="20%" class="header">
				  					<label>URI :</label> 
				  				</td>
				  				<td>
				  					<input style="width: 300px;" name="txt_uri" value="<%=obj!=null && obj.getUri()!=null?obj.getUri():"" %>"  class="text-input" type="text"  /> 
				  				</td>
				  			</tr>
				  			<tr>
				  				<td class="header">
				  					<label>Parent :</label> 
				  				</td>
				  				<td>
				  					<select name="slt_parentId" >
										<option value="0">Root</option>
										<%
											Vector<AdminLink> cAdminLink = adminLinkDAO.getTreeView(-1);
											String str = "";
											int pos1 = 0, pos2 = 0, pos3 = 0, pos4 = 0, pos5 = 0;
											int level = 0;
											AdminLink objLink = null;
											if(cAdminLink!=null && cAdminLink.size()>0){
												for(int i=0;i<cAdminLink.size();i++){
													objLink = cAdminLink.get(i);
													if(objLink!=null){
														level = objLink.getLink_level();
															
														if(level==1){
															pos1++;
															str = "--" + pos1+". ";
															pos2 = 0;
														}else if(level==2){
															pos2++;
															str = "- - - - " + pos2+". ";
															pos3 = 0;
														}else if(level==3){
															pos3++;
															str = "- - - - - - - - " + pos3+". ";
															pos4 = 0;
														}else if(level==4){
															pos4++;
															str = "- - - - - - - - - - - - " + pos4+". ";
															pos5 = 0;
														}else if(level==5){
															pos5++;
															str = "- - - - - - - - - - - - - - - - " + pos5+". ";
														}
										%>
											<option value="<%=objLink.getId() %>" <%if(obj!=null && obj.getParent_id()!=null && obj.getParent_id().toString().equals(objLink.getId().toString())){ %> selected="selected" <%} %>>
												<%= str + objLink.getName() %>
											</option>
										<%
													
													}
												}
											}
										%>
									</select>	 
				  				</td>
				  			</tr>	
				  			
				  			<tr>
				  				<td class="header">
				  					<label>Status:</label>
				  				</td>
				  				<td>
									<input type="radio" name="slt_status" value="9" <%if(obj!=null && obj.getStatus()==9){ %> checked="checked" <%} %>> All
									<input type="radio" name="slt_status" value="0" <%if((obj!=null && obj.getStatus()==0) || obj == null){ %> checked="checked" <%} %>> Server	
									<input type="radio" name="slt_status" value="2" <%if(obj!=null && obj.getStatus()==2){ %> checked="checked" <%} %>> Client	
									<input type="radio" name="slt_status" value="1" <%if(obj!=null && obj.getStatus()==1){ %> checked="checked" <%} %>> Deactive		
				  					
				  				</td>
				  			</tr>
				  			
				  			<tr>
				  				<td class="header">
				  					<label>Position :</label> 
				  				</td>
				  				<td>
				  					<input style="width: 300px;" name="txt_position" value="<%=obj!=null?obj.getPosition():"" %>"  class="text-input" type="number"  /> 
				  				</td>
				  			</tr>	
				  			<tr>
				  				<td class="header">
				  					<label>Display Top :</label> 
				  				</td>
				  				<td>
				  					<input type="checkbox" value="0" name="chk_displayTop" <%if(obj!=null && obj.getDisplay_top()==0){ %> checked="checked" <%} %>>
				  				</td>
				  			</tr>
				  			
				  			<tr>
				  				<td class="header">
				  					<label>Function :</label> 
				  				</td>
				  				<td>
				  					 <input type="checkbox" value="0" name="chk_select" <%if(obj!=null && obj.getIs_select()==0){ %> checked="checked" <%} %>> SELECT
				  					<br/>
				  					 <input type="checkbox" value="0" name="chk_insert" <%if(obj!=null && obj.getIs_insert()==0){ %> checked="checked" <%} %>> INSERT
				  					<br/>
				  					 <input type="checkbox" value="0" name="chk_update" <%if(obj!=null && obj.getIs_update()==0){ %> checked="checked" <%} %>> UPDATE
				  					<br/>
				  					 <input type="checkbox" value="0" name="chk_delete" <%if(obj!=null && obj.getIs_delete()==0){ %> checked="checked" <%} %>> DELETE
				  				</td>
				  			</tr>						
				  			
				  			<tr>
				  				<td colspan="2" align="center">
				  					<input class="button" type="button" value="<%=sId.length()>0? "EDIT":"ADD" %>" onclick="checkForm(<%=sId.length()>0? "false":"true" %>);"/>
				  				</td>
				  			</tr>
				  		</table>
				  		</form>
						
					</div> <!-- End #tab1 -->
					
				</div> <!-- End .content-box-content -->
				
			</div> <!-- End .content-box -->
			
			<div class="clear"></div>
			
			
			<div id="footer">
				<small> <!-- Remove this notice or replace it with whatever you want -->
						
				</small>
			</div><!-- End #footer -->
			
		</div> 
	</div>
	</body>	
</html>
