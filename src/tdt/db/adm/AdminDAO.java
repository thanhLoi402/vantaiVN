package tdt.db.adm;
import tdt.db.pool.*;
import tdt.util.Logger;
import tdt.util.Md5;
import java.io.IOException;
import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Collection;
import java.util.Vector;


public class AdminDAO {
	private Logger logger = null;
	private DBPoolX poolAdStandby = null;
	private DBPoolX poolAdActive = null;
	public AdminDAO(){
		try {
			poolAdStandby=DBPoolX.getInstance(DBPoolXName.AD_STANBY);
			poolAdActive=DBPoolX.getInstance(DBPoolXName.AD_ACTIVE);
			logger =new Logger(this.getClass().getName());
		} catch (Exception e) {}	
	}
	
	
	public boolean insertRow(Admin member){
		Connection conn = null;
		PreparedStatement preStmt = null;
		String strSQL = null;
		boolean result=false;
		try{
			conn = poolAdActive.getConnection();
			strSQL= " INSERT INTO  admin( USER_NAME, PASSWD, GEN_DATE, STATUS, " +
					"					RIGHT_ROLE, FULL_NAME, MOBILE, EMAIL, IP) " +
					" VALUES(,?,?,current_timestamp,?," +
					"			?, ?, ?, ?, ?)";
			preStmt = conn.prepareStatement(strSQL);
			preStmt.setString(1, member.getUserName().trim());
			preStmt.setString(2, Md5.Hash(member.getPassword().trim()));
			preStmt.setInt(3, member.getStatus());
			preStmt.setInt(4, member.getRightRole());
			preStmt.setString(5, member.getFullName());
			preStmt.setString(6, member.getMobile());
			preStmt.setString(7, member.getEmail());
			preStmt.setString(8, member.getIp());
			
			if(preStmt.executeUpdate()>0){
				result=true;
			}
		}catch(Exception e){
                    e.printStackTrace();
			logger.error("insertRow: Error executing SQL " + strSQL + ">>>" + e.toString());
			System.out.println("[ERROR MEMBER ] insertRow "+e.getMessage());
		}finally{
			poolAdActive.releaseConnection(conn, preStmt);
		}
		return result;
	}
	
	public boolean updateRow(Admin member) throws IOException{
		
		Connection conn = null;
		PreparedStatement preStmt = null;
		String strSQL = null;
		boolean result=false;
		
		try{
			conn = poolAdActive.getConnection();
			strSQL= " UPDATE " +
					" admin SET PASSWD = ?,STATUS = ? ,GEN_DATE = current_timestamp, " +
					"			RIGHT_ROLE = ?, FULL_NAME = ?, MOBILE = ?, EMAIL = ?, IP = ? " +
					" WHERE ID = ? ";
			preStmt = conn.prepareStatement(strSQL);			
			preStmt.setString(1, member.getPassword());
			preStmt.setInt(2, member.getStatus());
			
			preStmt.setInt(3, member.getRightRole());
			preStmt.setString(4, member.getFullName());
			preStmt.setString(5, member.getMobile());
			preStmt.setString(6, member.getEmail());
			preStmt.setString(7, member.getIp());			
			preStmt.setBigDecimal(8, member.getId());			
			if(preStmt.executeUpdate()>0){
				result=true;
			}
		}catch(Exception e){
                    e.printStackTrace();
			logger.error("updateRow: Error executing SQL " + strSQL + ">>>" + e.toString());
			System.out.println("updateRow: Error executing SQL " + ">>>" + e.getMessage());
		}finally{
			poolAdActive.releaseConnection(conn, preStmt);
		}
		
		return result;
	}
	public boolean deleteRow(int id) throws IOException{
		
		Connection conn = null;
		PreparedStatement preStmt = null;
		String strSQL = null;
		boolean result=false;
		
		try{
			conn = poolAdActive.getConnection();
			strSQL= " DELETE FROM  " +
					" admin WHERE ID = ? ";
			preStmt = conn.prepareStatement(strSQL);
			preStmt.setInt(1, id);			
			if(preStmt.executeUpdate()>0){
				result=true;
			}
		}catch(SQLException e){
                    e.printStackTrace();
			logger.error("deleteRow: Error executing SQL " + strSQL + ">>>" + e.toString());
		}finally{
			poolAdActive.releaseConnection(conn, preStmt);
		}
		
		return result;
	}
	
	public Collection getAll(String var,int page,int rowsPerPage){
		int startRow = (page - 1) * rowsPerPage + 1;
		int stopRow = page * rowsPerPage;
		Connection conn = null;
		PreparedStatement preStmt = null;
		String strSQL = null;
		ResultSet rs = null;
		Admin adm = null;
		Vector result = new Vector();
		if(var==null || var.equals(""))var = "%";
		else var = "%"+var+"%";
		try{
			conn = poolAdStandby.getConnection();
			strSQL= "select * from" +
					"	( SELECT ID, USER_NAME, PASSWD, GEN_DATE, STATUS,  " +
					"		RIGHT_ROLE, FULL_NAME, MOBILE, EMAIL, IP," +
					"		row_number() over( order by GEN_DATE desc ) as R " +
					" 		FROM 	 admin WHERE USER_NAME like ? " +
					" ) aa where R>=? and R<=? ";
			preStmt = conn.prepareStatement(strSQL);
			preStmt.setString(1, var.trim());
			preStmt.setInt(2, startRow);
			preStmt.setInt(3, stopRow);
			rs = preStmt.executeQuery();
			while(rs.next()){
				adm = new Admin();
				adm.setId(rs.getBigDecimal(1));
				adm.setUserName(rs.getString(2));
				adm.setPassword(rs.getString(3));
				adm.setGenDate(rs.getTimestamp(4));
				adm.setStatus(rs.getInt(5));
				adm.setRightRole(rs.getInt(6));
				adm.setFullName(rs.getString(7));
				adm.setMobile(rs.getString(8));
				adm.setEmail(rs.getString(9));
				adm.setIp(rs.getString(10));
				result.add(adm);
			}
		}catch(Exception e){
                    e.printStackTrace();
			logger.error("getAll: Error executing SQL " + strSQL + ">>>" + e.toString());
		}finally{
			poolAdStandby.releaseConnection(conn, preStmt,rs);
		}
		return result;
	}
	
	
	public Collection getAll(String var, int type, int page,int rowsPerPage){
		int startRow = (page - 1) * rowsPerPage + 1;
		int stopRow = page * rowsPerPage;
		Connection conn = null;
		PreparedStatement preStmt = null;
		String strSQL = null;
		ResultSet rs = null;
		Admin adm = null;
		Vector result = new Vector();
		if(var==null || var.equals(""))var = "%";
		else var = "%"+var+"%";
		try{
			conn = poolAdStandby.getConnection();
			strSQL= "select * from" +
					"	( SELECT ID, USER_NAME, PASSWD, GEN_DATE, STATUS,  " +
					"		RIGHT_ROLE, FULL_NAME, MOBILE, EMAIL, IP," +
					"		row_number() over( order by GEN_DATE desc ) as R " +
					" 		FROM 	 admin WHERE RIGHT_ROLE = ? and USER_NAME like ? " +
					" ) where R>=? and R<=? ";
			preStmt = conn.prepareStatement(strSQL);
			preStmt.setInt(1, type);
			preStmt.setString(2, var.trim());
			preStmt.setInt(3, startRow);
			preStmt.setInt(4, stopRow);
			rs = preStmt.executeQuery();
			while(rs.next()){
				adm = new Admin();
				adm.setId(rs.getBigDecimal(1));
				adm.setUserName(rs.getString(2));
				adm.setPassword(rs.getString(3));
				adm.setGenDate(rs.getTimestamp(4));
				adm.setStatus(rs.getInt(5));
				adm.setRightRole(rs.getInt(6));
				adm.setFullName(rs.getString(7));
				adm.setMobile(rs.getString(8));
				adm.setEmail(rs.getString(9));
				adm.setIp(rs.getString(10));
				result.add(adm);
			}
		}catch(Exception e){
                    e.printStackTrace();
			logger.error("getAll: Error executing SQL " + strSQL + ">>>" + e.toString());
		}finally{
			poolAdStandby.releaseConnection(conn, preStmt,rs);
		}
		return result;
	}
	
	public int countAll(String var){	
		Connection conn = null;
		PreparedStatement preStmt = null;
		String strSQL = null;
		ResultSet rs = null;
		int count = 0;
		if(var==null || var.equals(""))var = "%";
		else var = "%"+var+"%";
		try{
			conn = poolAdStandby.getConnection();
			strSQL= " SELECT count(*) " +
					" FROM 	 admin WHERE USER_NAME like ? ";
			preStmt = conn.prepareStatement(strSQL);
			preStmt.setString(1, var.trim());
			rs = preStmt.executeQuery();
			if(rs.next()){
				count = rs.getInt(1);
			}
		}catch(Exception e){
			logger.error("countAll: Error executing SQL " + strSQL + ">>>" + e.toString());
		}finally{
			poolAdStandby.releaseConnection(conn, preStmt,rs);
		}
		return count;
	}
	
	public int countAll(String var, int type){	
		Connection conn = null;
		PreparedStatement preStmt = null;
		String strSQL = null;
		ResultSet rs = null;
		int count = 0;
		if(var==null || var.equals(""))var = "%";
		else var = "%"+var+"%";
		try{
			conn = poolAdStandby.getConnection();
			strSQL= " SELECT count(*) " +
					" FROM 	 admin WHERE RIGHT_ROLE = ? and USER_NAME like ? ";
			preStmt = conn.prepareStatement(strSQL);
			preStmt.setInt(1, type);
			preStmt.setString(2, var.trim());
			rs = preStmt.executeQuery();
			if(rs.next()){
				count = rs.getInt(1);
			}
		}catch(Exception e){
			logger.error("countAll: Error executing SQL " + strSQL + ">>>" + e.toString());
		}finally{
			poolAdStandby.releaseConnection(conn, preStmt,rs);
		}
		return count;
	}
	

	public boolean changePass(BigDecimal id,String pass,String newpass) throws IOException{
		Connection conn = null;
		PreparedStatement preStmt = null;
		String strSQL = null;
		boolean result=false;
		try{
			conn = poolAdActive.getConnection();
			strSQL= " UPDATE " +
					" admin SET PASSWD = ? WHERE ID = ? AND PASSWD = ?";
			preStmt = conn.prepareStatement(strSQL);
			preStmt.setString(1, newpass.trim());
			preStmt.setBigDecimal(2, id);
			preStmt.setString(3, pass);			
			if(preStmt.executeUpdate()>0){
				result=true;
			}
		}catch(SQLException e){
			logger.error("resetPass: Error executing SQL " + strSQL + ">>>" + e.toString());
			System.out.println("resetPass: Error executing SQL " + strSQL + ">>>" + e.toString());			
		}finally{
			poolAdActive.releaseConnection(conn, preStmt);
		}
		return result;
	}
	
	public boolean resetPass(int id,String pass) throws IOException{
		Connection conn = null;
		PreparedStatement preStmt = null;
		String strSQL = null;
		boolean result=false;
		try{
			conn = poolAdActive.getConnection();
			strSQL= " UPDATE " +
					" admin SET PASSWD = ? WHERE ID = ? ";
			preStmt = conn.prepareStatement(strSQL);
			preStmt.setString(1, pass.trim());
			preStmt.setInt(2, id);			
			if(preStmt.executeUpdate()>0){
				result=true;
			}
		}catch(SQLException e){
			logger.error("resetPass: Error executing SQL " + strSQL + ">>>" + e.toString());
			
		}finally{
			poolAdActive.releaseConnection(conn, preStmt);
		}
		
		return result;
	}
	public boolean updateStatus(int id,int status) throws IOException{
		Connection conn = null;
		PreparedStatement preStmt = null;
		String strSQL = null;
		boolean result=false;
		try{
			conn = poolAdActive.getConnection();
			strSQL= " UPDATE " +
					" admin SET STATUS = ? WHERE ID = ? ";
			preStmt = conn.prepareStatement(strSQL);
			preStmt.setInt(1, status);
			preStmt.setInt(2, id);			
			if(preStmt.executeUpdate()>0){
				result=true;
			}
		}catch(SQLException e){
			logger.error("updateStatus: Error executing SQL " + strSQL + ">>>" + e.toString());
		}finally{
			poolAdActive.releaseConnection(conn, preStmt);
		}
		
		return result;
	}
	
	public Admin getRowByUser(String username){		
//		logger.logs("getRowByUser|" + username);
		Connection conn = null;
		PreparedStatement preStmt = null;
		String strSQL = null;
		ResultSet rs = null;
		Admin adm = null;
		try{
			conn = poolAdStandby.getConnection();
			strSQL= " SELECT ID,USER_NAME,PASSWD,GEN_DATE,STATUS,RIGHT_ROLE, FULL_NAME, MOBILE, EMAIL, IP  " +
					" FROM 	 admin " +
					" WHERE  USER_NAME = ? ";
			preStmt = conn.prepareStatement(strSQL);
			preStmt.setString(1, username);
			System.out.println(username);
			System.out.println(strSQL);
			rs = preStmt.executeQuery();
			if(rs.next()){
				adm = new Admin();
				adm.setId(rs.getBigDecimal(1));
				adm.setUserName(rs.getString(2));
				adm.setPassword(rs.getString(3));
				adm.setGenDate(rs.getTimestamp(4));
				adm.setStatus(rs.getInt(5));
				adm.setRightRole(rs.getInt(6));
				adm.setFullName(rs.getString(7));
				adm.setMobile(rs.getString(8));
				adm.setEmail(rs.getString(9));
				adm.setIp(rs.getString(10));
			}
		}catch(Exception e){
			logger.error("[ERROR ] getRowByUser: Error executing SQL " + strSQL + ">>>" + e.toString());
			System.out.println("[ERROR ] getRowByUser: Error executing SQL " + strSQL + ">>>" + e.toString());
		}finally{
			poolAdStandby.releaseConnection(conn, preStmt,rs);
		}
		return adm;
	}
	
	public Admin getRowById(int id){
		
		Connection conn = null;
		PreparedStatement preStmt = null;
		String strSQL = null;
		ResultSet rs = null;
		Admin adm = null;
		try{
			conn = poolAdStandby.getConnection();
			strSQL= " SELECT ID,USER_NAME,PASSWD,GEN_DATE,STATUS,RIGHT_ROLE, FULL_NAME, MOBILE, EMAIL, IP " +
					" FROM 	 admin " +
					" WHERE  ID = ? ";
			preStmt = conn.prepareStatement(strSQL);
			preStmt.setInt(1, id);
			rs = preStmt.executeQuery();
			if(rs.next()){
				adm = new Admin();
				adm.setId(rs.getBigDecimal(1));
				adm.setUserName(rs.getString(2));
				adm.setPassword(rs.getString(3));
				adm.setGenDate(rs.getTimestamp(4));
				adm.setStatus(rs.getInt(5));
				adm.setRightRole(rs.getInt(6));
				adm.setFullName(rs.getString(7));
				adm.setMobile(rs.getString(8));
				adm.setEmail(rs.getString(9));
				adm.setIp(rs.getString(10));
			}
		}catch(Exception e){
			logger.error("getRowById: Error executing SQL " + strSQL + ">>>" + e.toString());
			System.out.println("getRowById: Error executing SQL " + strSQL + ">>>" + e.toString());
		}finally{
			poolAdStandby.releaseConnection(conn, preStmt,rs);
		}
		return adm;
	}
	public static void main(String [] args){
		AdminDAO admDAO = new AdminDAO();
		System.out.println(admDAO.insertRow());
	}
	
	
	
	public int insertRow(){
		Connection conn = null;
		PreparedStatement preStmt = null;
		String strSQL = null;
		ResultSet rs = null;
		String usrname = null;
		AdminRole role = null;
		AdminRoleDAO roleDAO = new AdminRoleDAO();
		int result = 0;
		try{
			conn = poolAdStandby.getConnection();
			strSQL= "select USER_NAME from ADMIN where ID > 108 order by ID asc";
			preStmt = conn.prepareStatement(strSQL);
			rs = preStmt.executeQuery();
			while(rs.next()){
				usrname = rs.getString(1);
				
				role = new AdminRole();
				
				role.setAdmin(usrname);
				role.setLink_id(new BigDecimal(13));
				role.setIs_select(0);
				role.setIs_insert(1);
				role.setIs_update(1);
				role.setIs_delete(1);
				role.setCreated_by("auto");
				if(roleDAO.insertRow(role))
					result++;
				
				role = new AdminRole();
				
				role.setAdmin(usrname);
				role.setLink_id(new BigDecimal(1));
				role.setIs_select(0);
				role.setIs_insert(1);
				role.setIs_update(1);
				role.setIs_delete(1);
				role.setCreated_by("auto");
				if(roleDAO.insertRow(role))
					result++;
				
				role = new AdminRole();
				
				role.setAdmin(usrname);
				role.setLink_id(new BigDecimal(350));
				role.setIs_select(0);
				role.setIs_insert(1);
				role.setIs_update(1);
				role.setIs_delete(1);
				role.setCreated_by("auto");
				if(roleDAO.insertRow(role))
					result++;
				
				
				role = new AdminRole();
				
				role.setAdmin(usrname);
				role.setLink_id(new BigDecimal(410));
				role.setIs_select(0);
				role.setIs_insert(0);
				role.setIs_update(0);
				role.setIs_delete(1);
				role.setCreated_by("auto");
				if(roleDAO.insertRow(role))
					result++;
			}
		}catch(Exception e){
			logger.error("insertRow: Error executing SQL " + strSQL + ">>>" + e.toString());
		}finally{
			poolAdStandby.releaseConnection(conn, preStmt,rs);
		}
		return result;
	}
}
