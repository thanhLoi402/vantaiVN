<%@page import="tdt.util.my.MyTool"%>
<%@page import="tdt.db.service.vas.partner.PartnerMan"%>
<%@page import="tdt.db.service.vas.partner.Partner"%>
<%@page import="tdt.db.service.vas.partner.PartnerOwner"%>
<%@page import="tdt.util.StringTool"%>
<%@ page language="java" pageEncoding="utf-8"%>
<%@page import="tdt.db.adm.*"%>
<%@page import="java.math.*"%>
<%@page import="java.io.*"%>
<%@page import="tdt.util.Md5"%>
<%@page import="tdt.util.DateProc"%>
<jsp:useBean id="adminDAO" class="tdt.db.adm.AdminDAO" scope="session" />
<jsp:useBean id="partnerDAO" class="tdt.db.service.vas.partner.PartnerDAO" scope="session" />
<jsp:useBean id="partnerManDAO" class="tdt.db.service.vas.partner.PartnerManDAO" scope="session" />
<jsp:useBean id="partnerOwnerDAO" class="tdt.db.service.vas.partner.PartnerOwnerDAO" scope="session" />
<%@ include file="../../include/header.jsp" %>
<% 
		curPageIsSelect = true;
		response.setCharacterEncoding("utf-8");
  		request.setCharacterEncoding("utf-8");

  		String ownerId = request.getParameter("ownerId");
  		if(ownerId==null)ownerId = "";
  		String sAction = request.getParameter("action");
  		if(sAction==null)sAction = "";
  		
  		PartnerOwner objOwner = partnerOwnerDAO.getRow(new BigDecimal(ownerId));
  		if(objOwner==null){
  			response.sendRedirect("owner.jsp");
  			return;
  		}
  		
  		Vector<Partner> vPartners = (Vector<Partner>) partnerDAO.findAllObjHashkeyWithOwner("", 1, 5000);
  		PartnerMan objMan = null;
  		Partner objPartner = null;
  		String[] arrNewPartner = request.getParameterValues("partner");
  		
  		if(sAction.equalsIgnoreCase("UPDATE")){
  			String crrPartner = "";
  			String[] arrCrrPartner = null;
  			String[] arrTmp = null;
  			if(vPartners!=null && vPartners.size()>0){
  				for(int i=0;i<vPartners.size();i++){
  					objPartner = vPartners.get(i);
  					if(objPartner!=null && objPartner.getLstOwnerId()!=null){
  						arrTmp = objPartner.getLstOwnerId().split(";");
  						if(arrTmp!=null && arrTmp.length>0){
  							for(int j=0;j<arrTmp.length;j++){
  								if(arrTmp[j].equals(ownerId)){
  									crrPartner+= objPartner.getId()+",";
  									break;
  								}
  							}
  						}
  					}
  				}
  			}
  			if(crrPartner.endsWith(","))
  				crrPartner = crrPartner.substring(0, crrPartner.length()-1);
  			if(crrPartner.trim().length()>0)
  				arrCrrPartner = crrPartner.split(",");
  			
  			if(arrNewPartner==null)
  				arrNewPartner = new String[]{};
  			if(arrCrrPartner==null)
  				arrCrrPartner = new String[]{};
  			if(arrCrrPartner.length==0 && arrNewPartner.length>0){
  				//chi insert
  				for(int i=0;i<arrNewPartner.length;i++){
  					objMan = new PartnerMan();
  					objMan.setOwnerId(new BigDecimal(ownerId));
  					objMan.setCpId(new BigDecimal(arrNewPartner[i]));
  					objMan.setCreatedBy(adm_control.getUserName());
  					partnerManDAO.insertRow(objMan);
  				}
  				
  			} else if(arrCrrPartner.length>0 && arrNewPartner.length==0){
  				//chi delete
  				for(int i=0;i<arrCrrPartner.length;i++){
  					partnerManDAO.deleteRow(new BigDecimal(ownerId), new BigDecimal(arrCrrPartner[i]));
  				}
  			} else if(arrCrrPartner.length>0 && arrNewPartner.length>0){
  				String[] arr2Delete = MyTool.getElementNotInAray(arrCrrPartner, arrNewPartner);
  				String[] arr2Insert = MyTool.getElementNotInAray(arrNewPartner, arrCrrPartner);
  				if(arr2Delete!=null && arr2Delete.length>0){
  					for(int i=0;i<arr2Delete.length;i++){
  	  					partnerManDAO.deleteRow(new BigDecimal(ownerId), new BigDecimal(arr2Delete[i]));
  	  				}
  				}
  				
  				if(arr2Insert!=null && arr2Insert.length>0){
  					for(int i=0;i<arr2Insert.length;i++){
  	  					objMan = new PartnerMan();
  	  					objMan.setOwnerId(new BigDecimal(ownerId));
  	  					objMan.setCpId(new BigDecimal(arr2Insert[i]));
  	  					objMan.setCreatedBy(adm_control.getUserName());
  	  					partnerManDAO.insertRow(objMan);
  	  				}
  				}
  				
  			}
  			vPartners = (Vector<Partner>) partnerDAO.findAllObjHashkeyWithOwner("", 1, 5000);
  			
  		}
  		
  %>
<html >
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
		<title>Quản lý đối tác <%=objOwner.getCpName() %></title>
		<link rel="stylesheet" href="../../login/resources/css/reset.css" type="text/css" media="screen" />
		<link rel="stylesheet" href="../../login/resources/css/style.css" type="text/css" media="screen" />
		<link rel="stylesheet" href="../../login/resources/css/invalid.css" type="text/css" media="screen" />	
		<script type="text/javascript" src="../../login/resources/scripts/jquery-1.3.2.min.js"></script>
		<script type="text/javascript" src="../../login/resources/scripts/simpla.jquery.configuration.js"></script>
		<script type="text/javascript" src="../../login/resources/scripts/facebox.js"></script>
		<script type="text/javascript" src="../../login/resources/scripts/jquery.wysiwyg.js"></script>
		<script type="text/javascript" src="../../login/resources/scripts/jquery.datePicker.js"></script>
		<script type="text/javascript" src="../../login/resources/scripts/jquery.date.js"></script>
		<link rel="stylesheet" href="../../include/calendar_orange.css" title="calendar" />
		<script language="javascript" src="../../include/calendar.js"></script>
	</head>

 
	<body>
	<div id="body-wrapper"> <!-- Wrapper for the radial gradient background -->
		
		<jsp:include page="../../include/left.jsp" />
		<div id="main-content"> <!-- Main Content Section with everything -->
			<%@ include file="../../../admin/include/tool.jsp" %>
			
			<div class="clear">
			<!-- Page Head -->
			<h2 align="center">Quản lý đối tác</h2>
			
			<div class="clear"></div> <!-- End .clear -->
			
			<div class="content-box"><!-- Start Content Box -->
				
				<div class="content-box-header">
					
					<h3></h3>
					<a href="owner.jsp"><input class="button" type="button" value="Xem danh sách"/></a>
					<div class="clear"></div>
					
				</div> <!-- End .content-box-header -->
				
				<div class="content-box-content">
					<div class="tab-content default-tab" id="tab1"> <!-- This is the target div. id must match the href of this div's tab -->
						
						<form method="post" name="frmAdd" >
				  		<input type="hidden" name="action" value="UPDATE"/>
				  		<input type="hidden" name="id" value="<%=ownerId %>"/>
				  		<input type="hidden" name="path"/>
				  		<table width="100%" cellpadding="4" cellspacing="4" border="1" rules="all">
				  			<tr>
				  				<td width="20%" class="header">
				  					<label>Tên đối tác :</label> 
				  				</td>
				  				<td style="font-size: 16px;">
				  					<%=objOwner.getCpName() %> - <%=objOwner.getUsrname() %>
				  				</td>
				  			</tr>
				  			<tr>
				  				<td width="20%" class="header">
				  					<label>Chọn kênh kinh doanh :</label> 
				  				</td>
				  				<td>
				  					<%
				  						int j=0;
				  						boolean isChecked = false;
				  						String lstOwnerId = null;
				  						if(vPartners!=null && vPartners.size()>0){
				  							for(int i=0;i<vPartners.size();i++){
				  								objPartner = vPartners.get(i);
				  								if(objPartner!=null){
				  									isChecked = false;
				  									lstOwnerId = objPartner.getLstOwnerId();
				  									if(lstOwnerId!=null){
				  										lstOwnerId = ";" + lstOwnerId + ";";
				  										if(lstOwnerId.contains(";"+ownerId+";"))
				  											isChecked = true;
				  									}
				  									//if(objPartner.getOwnerId()==null || isChecked){
					  									if(j>0 && j%3==0)
					  										out.println("<br/><br/>");
				  					%>
				  						<div style="display: inline-table; width: 30%">
				  							<input <%=isChecked?"checked='checked'":"" %> type="checkbox" name="partner" value="<%=objPartner.getId()%>"> <%=objPartner.getUser() %> - <%=objPartner.getContactName() %>
				  						</div>
				  					<%
				  										j++;
				  									//}
				  								}
				  							}
				  						}
				  					%>
				  				</td>
				  			</tr>
				  			<tr>
				  				<td colspan="2" align="center">
				  					<input class="button" type="submit" value="Cập nhật"/>
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
