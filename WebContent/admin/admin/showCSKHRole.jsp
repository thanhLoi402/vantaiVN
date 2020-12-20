<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@page import="tdt.db.adm.AdminLink"%>
<%@page import="tdt.db.adm.AdminRole"%>
<%@page import="java.math.BigDecimal"%>
<jsp:useBean id="adminLinkDAO" class="tdt.db.adm.AdminLinkDAO" scope="session" />
<jsp:useBean id="adminDAO" class="tdt.db.adm.AdminDAO" scope="session" />
<jsp:useBean id="adminRoleDAO" class="tdt.db.adm.AdminRoleDAO" scope="session" />
<%
	String admin = request.getParameter("admin");
	if(admin!=null && !admin.equals("")){
		Vector<AdminLink> cAdminLink = adminLinkDAO.getTreeView2(new BigDecimal(0), -1); 
		Collection cAdminRole = adminRoleDAO.findAllObjHaskey(admin,"",1,1000);
%>
	<table>							
		<thead>
			<tr>
				<th><input type="checkbox" id="roleAll" name="roleAll" onclick="checkAllAll('roleSelect');checkAllAll('roleInsert');checkAllAll('roleUpdate');checkAllAll('roleDelete');" value="0">Chọn tất cả </th>
			</tr>
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
					if(objLink!=null && ( objLink.getId().toString().equals("13") || objLink.getId().toString().equals("410"))
							 || objLink.getId().toString().equals("395") || objLink.getParent_id().toString().equals("395")
							){	
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
				<td><input value="0" <%if(isSelect){ %> checked="checked" <%} %> id="roleSelect<%=objLink.getId() %>" name="roleSelect<%=objLink.getId() %>" type="checkbox" <%if(objLink.getIs_select()==1){ %> style="opacity:0.3;" disabled="disabled"<%} %>> </td>
				<td><input value="0" <%if(isInsert){ %> checked="checked" <%} %> id="roleInsert<%=objLink.getId() %>" name="roleInsert<%=objLink.getId() %>" type="checkbox" <%if(objLink.getIs_insert()==1){ %> style="opacity:0.3;" disabled="disabled"<%} %>> </td>
				<td><input value="0" <%if(isUpdate){ %> checked="checked" <%} %> id="roleUpdate<%=objLink.getId() %>" name="roleUpdate<%=objLink.getId() %>" type="checkbox" <%if(objLink.getIs_update()==1){ %> style="opacity:0.3;" disabled="disabled"<%} %>> </td>
				<td><input value="0" <%if(isDelete){ %> checked="checked" <%} %> id="roleDelete<%=objLink.getId() %>" name="roleDelete<%=objLink.getId() %>" type="checkbox" <%if(objLink.getIs_delete()==1){ %> style="opacity:0.3;" disabled="disabled"<%} %>> </td>
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
