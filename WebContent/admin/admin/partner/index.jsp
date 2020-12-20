<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@page import="tdt.util.DateProc"%>
<%@page import="java.net.URLDecoder"%>
<%@page import="tdt.db.service.vas.partner.Partner"%>
<%@page import="java.math.BigDecimal"%>
<%@page import="tdt.db.adm.AdminLog"%>
<%@page import="tdt.util.Md5"%>
<jsp:useBean id="partnerDAO" class="tdt.db.service.vas.partner.PartnerDAO" scope="session" />
<jsp:useBean id="partnerOwnerDAO" class="tdt.db.service.vas.partner.PartnerOwnerDAO" scope="session" />
<%@ include file="../../include/header.jsp" %>
<%
	request.setCharacterEncoding("UTF-8");
	response.setCharacterEncoding("UTF-8");
	request.setCharacterEncoding("UTF-8");			
	Collection rs = null;
	String sAction = request.getParameter("action");
	if(sAction==null)sAction="";
	
	String owner = request.getParameter("owner");
	if(owner==null)
		owner = "";
	
	
	if(sAction.equalsIgnoreCase("RESET")){
		String id = request.getParameter("id");
		String username = request.getParameter("name");
		Partner objPartnerTmp = new Partner();
		objPartnerTmp.setId(new BigDecimal(id));
		objPartnerTmp.setPass(Md5.Hash("123456"));
		if(partnerDAO.changePassword(objPartnerTmp)){
			out.println("<script>alert('Reset mật khẩu cho kênh kinh doanh: "+username+" thành công. Mật khẩu mới: 123456');window.location='index.jsp'</script>");
		}
	}
	
	int tong = 0;
	tong = partnerDAO.countAllObjHasKeyWithOwnerId(owner);

	int n = 100;
	int pn = tong / n;
	if (tong % n > 0)
		pn = pn + 1;
	//int dd = pn * n - 1;
	int currentPn = 1;
	//String ps = request.getParameter("p");
	//if (ps == null) ps = "1";
	//rs = partnerDAO.findAllObjHasKey(name , Integer.parseInt(ps), n);
	
	
	//System.out.println(currentPn+"|"+pn);
	
	String id = request.getParameter("id");
	if(id==null) id = "";
	
	
	String sMessageResponse = request.getParameter("r");
	
	Collection cCategory = null;
	
	if(sAction.equals("DEL")){
		if(!curPageIsDelete){
	response.sendRedirect(request.getContextPath()+"/admin/access/");
	return;
		}
		Admin objAdmin = null;
		if(partnerDAO.deleteRow(new BigDecimal(id))){
	try{
		String description = "Xóa kênh kinh doanh " + request.getParameter("name");
		adminLogDAO.insertRow(session.getAttribute("datavasosp.adm.username").toString(), description, AdminLog.TYPE_DELETE);
	}catch(Exception ex){}
		}
	}
	
	try{
		currentPn = Integer.parseInt(request.getParameter("p"));
	}catch(Exception ex){}
	rs = partnerDAO.findAllObjHashkeyWithOwner(owner , currentPn, n);
	
	Hashtable<BigDecimal, String> hashtable = partnerOwnerDAO.findHashtable();
%>
<html >
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>Danh sách kênh kinh doanh</title>
<link rel="icon" href="<%=request.getContextPath()%>/images/icon/admin.ico" type="image/x-icon" />
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

</head>

<body>
	<div id="body-wrapper"> <!-- Wrapper for the radial gradient background -->		
		<jsp:include page="../../include/left.jsp" />
		<div id="main-content" style="padding-top: 3px;"> <!-- Main Content Section with everything -->					
			<!-- Page Head -->
			<noscript> <!-- Show a notification if the user has disabled javascript -->
				<div class="notification error png_bg">
					<div>
						Javascript is disabled or is not supported by your browser. Please <a href="http://browsehappy.com/" title="Upgrade to a better browser">upgrade</a> your browser or <a href="http://www.google.com/support/bin/answer.py?answer=23852" title="Enable Javascript in your browser">enable</a> Javascript to navigate the interface properly.
					</div>
				</div>
			</noscript>
			
			
			<%@ include file="../../../admin/include/tool.jsp" %>
			<div class="clear"></div> <!-- End .clear -->		
			<a href="owner.jsp"><input type="submit" value="DANH SÁCH ĐỐI TÁC" class="button" id="btnSearch111" /></a>	
			
			
			<!--<noscript>--> <!-- Show a notification if the user has disabled javascript -->
				<div class="notification attention png_bg">
					<a href="#" class="close"><img
							src="../../login/resources/images/icons/cross_grey_small.png"
							title="Close this notification" alt="close" />
					</a>
					<div>
						attention!!!
					</div>
				</div>
			<!--</noscript>-->
							
			<div class="content-box" ><!-- Start Content Box -->
				<form method="get" name="frmListCat" id="frmListCat">
				<input type="hidden" name="id"/>
				<input type="hidden" name="name"/>
				<input type="hidden" name="action"/>
				<div class="content-box-header" style="padding-top: 3px;">					
					<h3 align="left">Danh sách kênh kinh doanh
						<img src="<%=request.getContextPath()%>/admin/login/resources/images/icons/arr.png" height="15px"/></h3>	
						<span style="float: right;padding-right: 20px;"><input class="button" type="button" value="THÊM MỚI" onclick="window.location.href='add.jsp';"/></span>
					<div class="clear"></div>	
				</div> <!-- End .content-box-header -->
				
				<div class="content-box-content">					
					<div class="tab-content default-tab" id="tab1"> <!-- This is the target div. id must match the href of this div's tab -->						
						<select name="owner">
							<option value="">Chọn đối tác</option>
							<%
								if(hashtable !=null && hashtable.size()>0){
																			Set s = hashtable.entrySet();
																	        Iterator i=s.iterator();
																	        Map.Entry m = null;
																	        while(i.hasNext()){	
																	        	m = (Map.Entry)i.next();
																	        	if(m!=null){
							%>
								<option <%=m.getKey().toString().equals(owner)?"selected":""%> value="<%=m.getKey()%>"><%=m.getValue()%></option>
							<%
								}
																	        }
																		}
							%>
						</select>
						
						&nbsp;&nbsp;&nbsp;&nbsp;
						<input type="submit" value="TÌM KIẾM" class="button" id="btnSearch" />
						
						<table>							
							<thead>
								<tr>
								   <th>STT</th>
								   <th style="color: red;">ID</th>
								   <th>Tên kênh KD</th>
								   <th>Tên truy cập</th>
								   <th>Tên liên hệ</th>
								   <th>Đối tác</th>
								   <th>SĐT</th>
								   <th>Trạng thái</th>
								   <th>Khởi tạo</th>
								   <th>Cập nhật</th>
								   <th>Reset pass</th>
								   <th>Tùy chọn</th>
								</tr>
							</thead>
						 
							<tfoot>
								<tr>
									<td colspan="7">
										<div class="bulk-actions align-left" >
											Tổng số bản ghi : <%=tong%>
										</div>
										
										<%
																					if(pn>1){
																																															String pageUrl = "index.jsp?p=";
																				%>
										<div class="pagination">
											<a href="<%=pageUrl%>1" title="First Page">&laquo; First</a>
											<a href="<%=pageUrl%><%=currentPn-1>0?(currentPn-1):1%>" title="Previous Page">&laquo; Prev</a>
											Page <%=currentPn + "/" + pn%>											
											<select name="page" style="height: 25px;" ONCHANGE="location = this.options[this.selectedIndex].value;">
												<%
													for(int i=1;i<=pn;i++){
												%>
													<option value="<%=pageUrl+i%>" <%if(currentPn==i){%> selected="selected" <%}%> ><%=i%></option>
												<%
													}
												%>
											</select>
											
											<a href="<%=pageUrl%><%=currentPn+1<pn?currentPn+1:pn%>" title="Next Page">Next &raquo;</a>
											<a href="<%=pageUrl%><%=pn%>" title="Last Page">Last &raquo;</a>
										</div> 
										<%
 											}
 										%>
										<!-- End .pagination -->
										 
										<div class="clear"></div>
									</td>
								</tr>
								<tr style="font-size: 13px;">
									<th colspan="3" style="font-weight: normal;">Link kinh doanh</th>
									<th colspan="9" style="font-weight: normal;">
										...
									</th>
								</tr>
							</tfoot>						 
							<tbody>
								<%
									if (rs != null) {
																					int i = 0;
																					String gendate = "";
																					String colorHidden = "";
																					Partner obj = null;
																					String[] arrOwner = null;
																					String strOwner = "";
																					String lstOwner = "";
																					for (Iterator iterator = rs.iterator(); iterator.hasNext();) {
																						lstOwner = "";
																						obj = (Partner) iterator.next();
																						if(obj==null) continue;
																						if(obj.getStatus()==1) colorHidden="#D9D6D6";
																						else
																							colorHidden = "";
																						i++;
								%>
								<tr style="color: <%=colorHidden %>; ">
									<td><b><%=i %></b></td>
									<td>
										<a href="#" style="color: red; "  title="CPID">
											<%=obj.getId() %>
										</a>
									</td>
									<td>
										<%=obj.getName() %>											
									</td>
									<td><%=obj.getUser() %></td>
									<td>
										<%=obj.getContactName() %>
									</td>
									<td>
										<%
											if(obj.getLstOwnerId()!=null){
												arrOwner = obj.getLstOwnerId().split(";");
												if(arrOwner!=null && arrOwner.length>0){
													for(int j=0;j<arrOwner.length;j++){
														strOwner = arrOwner[j];
														if(strOwner!=null && strOwner.trim().length()>0){
															try{
															lstOwner+= hashtable.get(new BigDecimal(strOwner)) + ", ";
															}catch(Exception ex){}
														}
													}
												}
												lstOwner = lstOwner.trim();
												if(lstOwner.endsWith(","))
													lstOwner = lstOwner.substring(0, lstOwner.length()-1);
												out.println(lstOwner);
											}
										%>
									</td>
									<td><%=obj.getMobile() %></td>
									<td><%=obj.getStatus()==0?"Active":"Deactive" %></td>
									<td><%=DateProc.getDateTime24hString(obj.getGenDate()) %></td>
									<td><%=DateProc.getDateTime24hString(obj.getLastUpdate()) %></td>
									<td>
										<a style="cursor: pointer;" onclick="if(confirm('Bạn có muốn reset mật khẩu cho kênh kinh doanh này không?')){frmListCat.id.value='<%=obj.getId()%>';frmListCat.name.value='<%=obj.getUser() %>';frmListCat.action.value='RESET';frmListCat.submit();}">reset</a>
									</td>
									<td>
										<!-- Icons -->
										 
										 <a href="add.jsp?id=<%=obj.getId() %>" title="Edit">
										 	<img src="<%=request.getContextPath() %>/admin/login/resources/images/icons/pencil.png" alt="Edit" />
										 </a>
										 <a title="Delete" onclick="if(confirm('Bạn có muốn xóa kênh kinh doanh này không?')){ frmListCat.action.value='DEL';frmListCat.name.value='<%=obj.getUser() %>';frmListCat.id.value='<%=obj.getId() %>';frmListCat.submit();}"><img src="<%=request.getContextPath() %>/admin/login/resources/images/icons/cross.png" alt="Delete" /></a> 
									</td>
								</tr>
								<%	} 
								}%>								
							</tbody>
						</table>
					</div> <!-- End #tab1 -->					
				</div> <!-- End .content-box-content -->
				</form>
			</div> <!-- End .content-box -->
			<span id="spanTagAction" name="spanTagAction">	
				<input class="button" type="button" value="THÊM MỚI" onclick="window.location.href='add.jsp';"/>
			</span>
			<div class="clear"></div>
			
			
			
			<%@include file="../../include/footer.jsp" %>
			
		</div> 
	</div>
</body>
</html>
