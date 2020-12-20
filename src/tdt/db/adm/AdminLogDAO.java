package tdt.db.adm;

import tdt.db.pool.*;
import tdt.util.Encrypter;
import tdt.util.Logger;
import tdt.util.security.EncryptionException;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Collection;
import java.util.Vector;

public class AdminLogDAO {

    private Logger logger = null;
    private DBPoolX poolAdActive = null;
    private DBPoolX poolAdStandby = null;

    public AdminLogDAO() {
        try {
            poolAdStandby = DBPoolX.getInstance(DBPoolXName.AD_STANBY);
            poolAdActive = DBPoolX.getInstance(DBPoolXName.AD_ACTIVE);
            logger = new Logger(this.getClass().getName());
        } catch (Exception e) {
        }
    }

    public boolean insertRow(String admin, String description, int type) {
        Connection conn = null;
        PreparedStatement preStmt = null;
        String strSQL = null;
        boolean result = false;
        try {
            conn = poolAdActive.getConnection();
            strSQL = " insert into ADMIN_LOG ( ADMIN, DESCRIPTION, GEN_DATE, TYPE) "
                    + " values(?, ?, current_timestamp, ?)";
            preStmt = conn.prepareStatement(strSQL);
            preStmt.setString(1, admin);
            preStmt.setString(2, description);
            preStmt.setInt(3, type);
            if (preStmt.executeUpdate() > 0) {
                result = true;
            }
        } catch (Exception e) {
            e.printStackTrace();
            logger.error("insertRow: Error executing SQL " + strSQL + ">>>" + e.toString());
            System.out.println("[ERROR MEMBER ] insertRow " + e.getMessage());
        } finally {
            poolAdActive.releaseConnection(conn, preStmt);
        }
        return result;
    }

    public Collection<AdminLog> findAllObjHaskey(String admin, String type, int page, int rowsPerPage) {
        int startRow = (page - 1) * rowsPerPage + 1;
        int stopRow = page * rowsPerPage;
        Connection conn = null;
        PreparedStatement preStmt = null;
        ResultSet rs = null;
        String strSQL = null;

        String where = "";

        if (admin == null || admin.equals("")) {
            where += " ";
        } else {
            where += " and (ADMIN like '%" + admin + "%' or DESCRIPTION like '%" + admin + "%' )";
        }

        if (type == null || type.equals("")) {
            where += " ";
        } else {
            where += " and TYPE = " + type + " ";
        }

        Vector<AdminLog> result = null;
        try {
            conn = poolAdStandby.getConnection();
            strSQL = "select aa.* from("
                    + "	select ADMIN_LOG.*, "
                    + "		row_number() over(order by ADMIN_LOG.ID desc) as R "
                    + " 	from ADMIN_LOG "
                    + " 	where ADMIN_LOG.ID >0 " + where + ") aa"
                    + " where aa.R>=? and aa.R<=?";

            preStmt = conn.prepareStatement(strSQL);
            preStmt.setInt(1, startRow);
            preStmt.setInt(2, stopRow);
            rs = preStmt.executeQuery();
            result = new Vector<AdminLog>();
            AdminLog log = null;
            while (rs.next()) {
                log = new AdminLog();
                log.setId(rs.getBigDecimal("ID"));
                log.setDescription(rs.getString("DESCRIPTION"));
                log.setAdmin(rs.getString("ADMIN"));
                log.setGen_date(rs.getTimestamp("GEN_DATE"));
                log.setType(rs.getInt("TYPE"));
                result.add(log);
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
            logger.error(this.getClass().getName() + ".findAllObjHaskey | SQL | " + ex.getErrorCode() + ":" + ex.getMessage() + " | Error executing " + strSQL + " >>> "
                    + ex.getMessage());
        } catch (Exception ex) {
            ex.printStackTrace();
            logger.error(this.getClass().getName() + ".findAllObjHaskey | ex: " + ex.toString());
        } finally {
            poolAdStandby.releaseConnection(conn, preStmt, rs);
        }
        return result;
    }

    public Collection<AdminLog> findAllCSKHLog(String admin, String type, int page, int rowsPerPage) {
        int startRow = (page - 1) * rowsPerPage + 1;
        int stopRow = page * rowsPerPage;
        Connection conn = null;
        PreparedStatement preStmt = null;
        ResultSet rs = null;
        String strSQL = null;

        String where = "";

        if (admin == null || admin.equals("")) {
            where += " ";
        } else {
            where += " and ADMIN in (" + admin + ")";
        }

        if (type == null || type.equals("")) {
            where += " ";
        } else {
            where += " and TYPE = " + type + " ";
        }

        Vector<AdminLog> result = null;
        try {
            conn = poolAdStandby.getConnection();
            strSQL = "select aa.* from("
                    + "	select ADMIN_LOG.*, "
                    + "		row_number() over(order by ADMIN_LOG.ID desc) as R "
                    + " 	from ADMIN_LOG "
                    + " 	where ADMIN_LOG.ID >0 " + where + ") aa"
                    + " where aa.R>=? and aa.R<=?";

            preStmt = conn.prepareStatement(strSQL);
            preStmt.setInt(1, startRow);
            preStmt.setInt(2, stopRow);
            rs = preStmt.executeQuery();
            result = new Vector<AdminLog>();
            AdminLog log = null;
            while (rs.next()) {
                log = new AdminLog();
                log.setId(rs.getBigDecimal("ID"));
                log.setDescription(rs.getString("DESCRIPTION"));
                log.setAdmin(rs.getString("ADMIN"));
                log.setGen_date(rs.getTimestamp("GEN_DATE"));
                log.setType(rs.getInt("TYPE"));
                result.add(log);
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
            logger.error(this.getClass().getName() + ".findAllObjHaskey | SQL | " + ex.getErrorCode() + ":" + ex.getMessage() + " | Error executing " + strSQL + " >>> "
                    + ex.getMessage());
        } catch (Exception ex) {
            ex.printStackTrace();
            logger.error(this.getClass().getName() + ".findAllObjHaskey | ex: " + ex.toString());
        } finally {
            poolAdStandby.releaseConnection(conn, preStmt, rs);
        }
        return result;
    }

    public int countAllObjHaskey(String admin, String type) {
        Connection conn = null;
        PreparedStatement preStmt = null;
        ResultSet rs = null;
        String strSQL = null;

        String where = "";

        if (admin == null || admin.equals("")) {
            where += " ";
        } else {
            where += " and (ADMIN like '%" + admin + "%' or DESCRIPTION like '%" + admin + "%' )";
        }

        if (type == null || type.equals("")) {
            where += " ";
        } else {
            where += " and TYPE = " + type + " ";
        }

        int result = 0;
        try {
            conn = poolAdStandby.getConnection();
            strSQL = "select count(ID) from ADMIN_LOG where ID >0 " + where;
            preStmt = conn.prepareStatement(strSQL);
            rs = preStmt.executeQuery();
            if (rs.next()) {
                result = rs.getInt(1);
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
            logger.error(this.getClass().getName() + ".countAllObjHaskey | SQL | " + ex.getErrorCode() + ":" + ex.getMessage() + " | Error executing " + strSQL + " >>> "
                    + ex.getMessage());
        } catch (Exception ex) {
            ex.printStackTrace();
            logger.error(this.getClass().getName() + ".countAllObjHaskey | ex: " + ex.toString());
        } finally {
            poolAdStandby.releaseConnection(conn, preStmt, rs);
        }
        return result;
    }

    public int countAllCSKHLog(String admin, String type) {
        Connection conn = null;
        PreparedStatement preStmt = null;
        ResultSet rs = null;
        String strSQL = null;

        String where = "";

        if (admin == null || admin.equals("")) {
            where += " ";
        } else {
            where += " and ADMIN in(" + admin + ")";
        }

        if (type == null || type.equals("")) {
            where += " ";
        } else {
            where += " and TYPE = " + type + " ";
        }

        int result = 0;
        try {
            conn = poolAdStandby.getConnection();
            strSQL = "select count(ID) from ADMIN_LOG where ID >0 " + where;
            System.out.println(strSQL);
            preStmt = conn.prepareStatement(strSQL);
            rs = preStmt.executeQuery();
            if (rs.next()) {
                result = rs.getInt(1);
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
            logger.error(this.getClass().getName() + ".countAllCSKHLog | SQL | " + ex.getErrorCode() + ":" + ex.getMessage() + " | Error executing " + strSQL + " >>> "
                    + ex.getMessage());
        } catch (Exception ex) {
            ex.printStackTrace();
            logger.error(this.getClass().getName() + ".countAllCSKHLog | ex: " + ex.toString());
        } finally {
            poolAdStandby.releaseConnection(conn, preStmt, rs);
        }
        return result;
    }

    public static void main(String[] args) {
//		AdminLogDAO logDAO = new AdminLogDAO();
//		System.out.println(logDAO.countAllCSKHLog("'adminhn','adminhcm','admindn'", ""));

        try {
            System.out.println(Encrypter.decrypt("cuWbC3S/UvKRIrHrHYfkEg=="));
        } catch (EncryptionException e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        }
    }
}
