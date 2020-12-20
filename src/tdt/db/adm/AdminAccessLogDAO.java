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


public class AdminAccessLogDAO {
	private Logger logger = null;
	private DBPoolX poolAdStandby = null;
	private DBPoolX poolAdActive = null;
	public AdminAccessLogDAO(){
		try {
			poolAdStandby=DBPoolX.getInstance(DBPoolXName.AD_SPLUS_STANBY);
			poolAdActive=DBPoolX.getInstance(DBPoolXName.AD_SPLUS_ACTIVE);
			logger =new Logger(this.getClass().getName());
		} catch (Exception e) {}	
	}
	
	
	public boolean insertRow(AdminAccessLog member){
		Connection conn = null;
		PreparedStatement preStmt = null;
		String strSQL = null;
		boolean result=false;
		try{
			conn = poolAdActive.getConnection();
			strSQL= " INSERT INTO  ADMIN_ACCESS_LOG(ID, USRNAME, IP, BROWSER, LOGIN_TIME) " +
					" VALUES(ADMIN_ACCESS_LOG_SEQ.nextval, ?, ?, ?, ?)";
			preStmt = conn.prepareStatement(strSQL);
			preStmt.setString(1, member.getUsrname());
			preStmt.setString(2, member.getIp());
			preStmt.setString(3, member.getBrowser());
			preStmt.setTimestamp(4, member.getLoginTime());
			
			if(preStmt.executeUpdate()>0){
				result=true;
			}
		}catch(Exception e){
			logger.error("insertRow: Error executing SQL " + strSQL + ">>>" + e.toString());
			System.out.println("[ERROR MEMBER ] insertRow "+e.getMessage());
		}finally{
			poolAdActive.releaseConnection(conn, preStmt);
		}
		return result;
	}
	
	public boolean updateTimeLogout(String username, String ip, String browser){
		Connection conn = null;
		PreparedStatement preStmt = null;
		String strSQL = null;
		boolean result = false;
		ResultSet rs = null;
		try{
			conn = poolAdActive.getConnection();
			
			strSQL = "select ID from ADMIN_ACCESS_LOG where USRNAME = ? and IP = ? and BROWSER = ? order by ID desc ";
			preStmt = conn.prepareStatement(strSQL);	
			preStmt.setString(1, username);
			preStmt.setString(2, ip);
			preStmt.setString(3, browser);
			rs = preStmt.executeQuery();
			if(rs.next()){
				BigDecimal id = rs.getBigDecimal(1);
				rs.close();
				preStmt.close();
				
				strSQL = "update ADMIN_ACCESS_LOG set LOGOUT_TIME = sysdate where ID = ?";
				preStmt = conn.prepareStatement(strSQL);	
				preStmt.setBigDecimal(1, id);
				if(preStmt.executeUpdate()>0)
					result = true;
			}
		}catch(Exception e){
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
					" ADMIN_ACCESS_LOG WHERE ID = ? ";
			preStmt = conn.prepareStatement(strSQL);
			preStmt.setInt(1, id);			
			if(preStmt.executeUpdate()>0){
				result=true;
			}
		}catch(SQLException e){
			logger.error("deleteRow: Error executing SQL " + strSQL + ">>>" + e.toString());
		}finally{
			poolAdActive.releaseConnection(conn, preStmt);
		}
		
		return result;
	}
	
	public Vector<AdminAccessLog> findAll(String admin ,int page, int rowsPerPage){
		int startRow = (page - 1) * rowsPerPage + 1;
		int stopRow = page * rowsPerPage;
		Connection conn = null;
		PreparedStatement preStmt = null;
		String strSQL = null;
		ResultSet rs = null;
		AdminAccessLog adm = null;
		Vector<AdminAccessLog> result = null;
		if(admin==null || admin.equals(""))admin = "%";
		else admin = "%"+admin+"%";
		try{
			result = new Vector<AdminAccessLog>();
			conn = poolAdStandby.getConnection();
			strSQL= "select * from" +
					"	( select ADMIN_ACCESS_LOG.*," +
					"		row_number() over( order by ID desc ) as R " +
					" 		from ADMIN_ACCESS_LOG where USRNAME like ?" +
					" ) where R>=? and R<=? ";
			preStmt = conn.prepareStatement(strSQL);
			preStmt.setString(1, admin.trim());
			preStmt.setInt(2, startRow);
			preStmt.setInt(3, stopRow);
			rs = preStmt.executeQuery();
			while(rs.next()){
				adm = new AdminAccessLog();
				adm.setId(rs.getBigDecimal("ID"));
				adm.setUsrname(rs.getString("USRNAME"));
				adm.setIp(rs.getString("IP"));
				adm.setBrowser(rs.getString("BROWSER"));
				adm.setLoginTime(rs.getTimestamp("LOGIN_TIME"));
				adm.setLogoutTime(rs.getTimestamp("LOGOUT_TIME"));
				result.add(adm);
			}
		}catch(Exception e){
			logger.error("findAll: Error executing SQL " + strSQL + ">>>" + e.toString());
		}finally{
			poolAdStandby.releaseConnection(conn, preStmt,rs);
		}
		return result;
	}
	
	public int countAll(String admin){	
		Connection conn = null;
		PreparedStatement preStmt = null;
		String strSQL = null;
		ResultSet rs = null;
		int count = 0;
		if(admin==null || admin.equals(""))admin = "%";
		else admin = "%"+admin+"%";
		try{
			conn = poolAdStandby.getConnection();
			strSQL= " SELECT count(*) " +
					" FROM 	 ADMIN_ACCESS_LOG WHERE USRNAME like ? ";
			preStmt = conn.prepareStatement(strSQL);
			preStmt.setString(1, admin.trim());
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

}
