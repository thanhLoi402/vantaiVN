package tdt.db.adm;

import tdt.db.pool.*;
import tdt.util.Logger;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Collection;
import java.util.Vector;

public class AdminRoleDAO {

    private Logger logger = null;
    private DBPoolX poolAdStandby = null;
    private DBPoolX poolAdActive = null;

    public AdminRoleDAO() {
        try {
            poolAdStandby = DBPoolX.getInstance(DBPoolXName.AD_STANBY);
            poolAdActive = DBPoolX.getInstance(DBPoolXName.AD_ACTIVE);
            logger = new Logger(this.getClass().getName());
        } catch (Exception e) {
        }
    }

    public boolean insertRow(AdminRole obj) {
        if (obj == null) {
            return false;
        }
        Connection conn = null;
        PreparedStatement preStmt = null;
        String strSQL = null;
        boolean result = false;
        ResultSet rs = null;
        BigDecimal id = null;
        try {
            conn = poolAdActive.getConnection();

            strSQL = "select ID from ADMIN_ROLE where ADMIN = ? and LINK_ID = ? ";
            preStmt = conn.prepareStatement(strSQL);
            preStmt.setString(1, obj.getAdmin());
            preStmt.setBigDecimal(2, obj.getLink_id());
            rs = preStmt.executeQuery();
            if (rs.next()) {
                id = rs.getBigDecimal("ID");
                rs.close();
                preStmt.close();
                strSQL = " update ADMIN_ROLE set ADMIN=?, LINK_ID=?, IS_SELECT=?, IS_INSERT=?, IS_UPDATE=?, IS_DELETE=?, LAST_UPDATED=current_timestamp where ID=? ";
                preStmt = conn.prepareStatement(strSQL);
                preStmt.setString(1, obj.getAdmin());
                preStmt.setBigDecimal(2, obj.getLink_id());
                preStmt.setInt(3, obj.getIs_select());
                preStmt.setInt(4, obj.getIs_insert());
                preStmt.setInt(5, obj.getIs_update());
                preStmt.setInt(6, obj.getIs_delete());
                preStmt.setBigDecimal(7, id);
                if (preStmt.executeUpdate() > 0) {
                    result = true;
                }
            } else {
                rs.close();
                preStmt.close();
                if (obj.getIs_select() == 1 && obj.getIs_insert() == 1 && obj.getIs_update() == 1 && obj.getIs_delete() == 1) {

                } else {
                    strSQL = " insert into ADMIN_ROLE ( ADMIN, LINK_ID, IS_SELECT, IS_INSERT, IS_UPDATE, IS_DELETE, GEN_DATE, CREATED_BY) "
                            + " values(?, ?, ?, ?, ?, ?, current_timestamp, ?)";
                    preStmt = conn.prepareStatement(strSQL);
                    preStmt.setString(1, obj.getAdmin());
                    preStmt.setBigDecimal(2, obj.getLink_id());
                    preStmt.setInt(3, obj.getIs_select());
                    preStmt.setInt(4, obj.getIs_insert());
                    preStmt.setInt(5, obj.getIs_update());
                    preStmt.setInt(6, obj.getIs_delete());
                    preStmt.setString(7, obj.getCreated_by());
                    if (preStmt.executeUpdate() > 0) {
                        result = true;
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            logger.error("insertRow: Error executing SQL " + strSQL + ">>>" + e.toString());
            System.out.println("insertRow: " + e.getMessage());
        } finally {
            poolAdActive.releaseConnection(conn, preStmt);
        }
        return result;
    }

    public boolean updateRow(AdminRole obj) {
        if (obj == null) {
            return false;
        }
        Connection conn = null;
        PreparedStatement preStmt = null;
        String strSQL = null;
        boolean result = false;
        try {
            conn = poolAdActive.getConnection();
            strSQL = " update ADMIN_ROLE set ADMIN=?, LINK_ID=?, IS_SELECT=?, IS_INSERT=?, IS_UPDATE=?, IS_DELETE=?, LAST_UPDATED=current_timestamp where ID=? ";
            preStmt = conn.prepareStatement(strSQL);
            preStmt.setString(1, obj.getAdmin());
            preStmt.setBigDecimal(2, obj.getLink_id());
            preStmt.setInt(3, obj.getIs_select());
            preStmt.setInt(4, obj.getIs_insert());
            preStmt.setInt(5, obj.getIs_update());
            preStmt.setInt(6, obj.getIs_delete());
            preStmt.setBigDecimal(7, obj.getId());
            if (preStmt.executeUpdate() > 0) {
                result = true;
            }
        } catch (Exception e) {
            e.printStackTrace();
            logger.error("updateRow: Error executing SQL " + strSQL + ">>>" + e.toString());
            System.out.println("updateRow: " + e.getMessage());
        } finally {
            poolAdActive.releaseConnection(conn, preStmt);
        }
        return result;
    }

    public AdminRole getRow(BigDecimal id) {
        Connection conn = null;
        PreparedStatement preStmt = null;
        ResultSet rs = null;
        String strSQL = null;
        AdminRole obj = null;
        try {
            conn = poolAdStandby.getConnection();
            strSQL = "select ADMIN_ROLE.*, ADMIN_LINK.NAME, ADMIN_LINK.URI from ADMIN_ROLE join ADMIN_LINK on ADMIN_ROLE.LINK_ID = ADMIN_LINK.ID where ADMIN_ROLE.ID = ?";
            preStmt = conn.prepareStatement(strSQL);
            preStmt.setBigDecimal(1, id);
            rs = preStmt.executeQuery();
            if (rs.next()) {
                obj = new AdminRole();
                obj.setId(rs.getBigDecimal("ID"));
                obj.setAdmin(rs.getString("ADMIN"));
                obj.setLink_id(rs.getBigDecimal("LINK_ID"));
                obj.setIs_select(rs.getInt("IS_SELECT"));
                obj.setIs_insert(rs.getInt("IS_INSERT"));
                obj.setIs_update(rs.getInt("IS_UPDATE"));
                obj.setIs_delete(rs.getInt("IS_DELETE"));
                obj.setGen_date(rs.getTimestamp("GEN_DATE"));
                obj.setCreated_by(rs.getString("CREATED_BY"));
                obj.setLast_updated(rs.getTimestamp("LAST_UPDATED"));
                obj.setLink_name(rs.getString("NAME"));
                obj.setLink_uri(rs.getString("URI"));

            }

        } catch (Exception e) {
            e.printStackTrace();
            logger.error("getRow: Error executing SQL " + strSQL + ">>>"
                    + e.toString());
        } finally {
            poolAdStandby.releaseConnection(conn, preStmt, rs);
        }
        return obj;
    }

    public AdminRole getRole(String admin, BigDecimal linkId) {
        Connection conn = null;
        PreparedStatement preStmt = null;
        ResultSet rs = null;
        String strSQL = null;
        AdminRole obj = null;
        try {
            conn = poolAdStandby.getConnection();
            strSQL = "select * from ADMIN_ROLE where ADMIN = ? and LINK_ID = ?";
            preStmt = conn.prepareStatement(strSQL);
            preStmt.setString(1, admin);
            preStmt.setBigDecimal(2, linkId);
            rs = preStmt.executeQuery();
            if (rs.next()) {
                obj = new AdminRole();
                obj.setId(rs.getBigDecimal("ID"));
                obj.setAdmin(rs.getString("ADMIN"));
                obj.setLink_id(rs.getBigDecimal("LINK_ID"));
                obj.setIs_select(rs.getInt("IS_SELECT"));
                obj.setIs_insert(rs.getInt("IS_INSERT"));
                obj.setIs_update(rs.getInt("IS_UPDATE"));
                obj.setIs_delete(rs.getInt("IS_DELETE"));
                obj.setGen_date(rs.getTimestamp("GEN_DATE"));
                obj.setCreated_by(rs.getString("CREATED_BY"));
                obj.setLast_updated(rs.getTimestamp("LAST_UPDATED"));
            }

        } catch (Exception e) {
            e.printStackTrace();
            logger.error("getRole: Error executing SQL " + strSQL + ">>>"
                    + e.toString());
        } finally {
            poolAdStandby.releaseConnection(conn, preStmt, rs);
        }
        return obj;
    }

    public boolean deleteRow(BigDecimal id) {
        Connection conn = null;
        PreparedStatement preStmt = null;
        ResultSet rs = null;
        String strSQL = null;
        boolean resutl = false;
        try {
            conn = poolAdActive.getConnection();
            strSQL = "delete from ADMIN_ROLE where ID = ?";
            preStmt = conn.prepareStatement(strSQL);
            preStmt.setBigDecimal(1, id);
            if (preStmt.executeUpdate() > 0) {
                resutl = true;
            }

        } catch (Exception e) {
            e.printStackTrace();
            logger.error("deleteRow: Error executing SQL " + strSQL + ">>>"
                    + e.toString());
        } finally {
            poolAdActive.releaseConnection(conn, preStmt);
        }
        return resutl;
    }

    public boolean deleteRow(String usrname) {
        Connection conn = null;
        PreparedStatement preStmt = null;
        ResultSet rs = null;
        String strSQL = null;
        boolean resutl = false;
        try {
            conn = poolAdActive.getConnection();
            strSQL = "delete from ADMIN_ROLE where ADMIN = ?";
            preStmt = conn.prepareStatement(strSQL);
            preStmt.setString(1, usrname);
            if (preStmt.executeUpdate() > 0) {
                resutl = true;
            }

        } catch (Exception e) {
            e.printStackTrace();
            logger.error("deleteRow: Error executing SQL " + strSQL + ">>>"
                    + e.toString());
        } finally {
            poolAdActive.releaseConnection(conn, preStmt);
        }
        return resutl;
    }

    public Collection<AdminRole> findAllObjHaskey(String admin, String link_id, int page, int rowsPerPage) {
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
            where += " and ADMIN_ROLE.ADMIN = '" + admin + "' ";
        }

        if (link_id == null || link_id.equals("")) {
            where += " ";
        } else {
            where += " and ADMIN_ROLE.LINK_ID = " + link_id + " ";
        }

        Vector<AdminRole> result = null;
        try {
            conn = poolAdStandby.getConnection();

            strSQL = "select aa.* from "
                    + "	( select ADMIN_ROLE.*, ADMIN_LINK.NAME, ADMIN_LINK.URI, "
                    + "	row_number() over(order by ADMIN_ROLE.ID desc) as R "
                    + "	from ADMIN_ROLE join ADMIN_LINK on ADMIN_ROLE.LINK_ID = ADMIN_LINK.ID "
                    + "	where ADMIN_ROLE.ID >0 " + where + ") aa"
                    + " where aa.R>=? and aa.R<=?";

            preStmt = conn.prepareStatement(strSQL);
            preStmt.setInt(1, startRow);
            preStmt.setInt(2, stopRow);
            rs = preStmt.executeQuery();
            result = new Vector<AdminRole>();
            AdminRole obj = null;
            while (rs.next()) {
                obj = new AdminRole();
                obj.setId(rs.getBigDecimal("ID"));
                obj.setAdmin(rs.getString("ADMIN"));
                obj.setLink_id(rs.getBigDecimal("LINK_ID"));
                obj.setIs_select(rs.getInt("IS_SELECT"));
                obj.setIs_insert(rs.getInt("IS_INSERT"));
                obj.setIs_update(rs.getInt("IS_UPDATE"));
                obj.setIs_delete(rs.getInt("IS_DELETE"));
                obj.setGen_date(rs.getTimestamp("GEN_DATE"));
                obj.setCreated_by(rs.getString("CREATED_BY"));
                obj.setLast_updated(rs.getTimestamp("LAST_UPDATED"));
                obj.setLink_name(rs.getString("NAME"));
                obj.setLink_uri(rs.getString("URI"));
                result.add(obj);
            }
        } catch (SQLException ex) {
            logger.error(this.getClass().getName() + ".findAllObjHaskey | SQL | " + ex.getErrorCode() + ":" + ex.getMessage() + " | Error executing " + strSQL + " >>> "
                    + ex.getMessage());
        } catch (Exception ex) {
            logger.error(this.getClass().getName() + ".findAllObjHaskey | ex: " + ex.toString());
        } finally {
            poolAdStandby.releaseConnection(conn, preStmt, rs);
        }
        return result;
    }

    public int countAllObjHaskey(String admin, String link_id) {
        Connection conn = null;
        PreparedStatement preStmt = null;
        ResultSet rs = null;
        String strSQL = null;

        String where = "";

        if (admin == null || admin.equals("")) {
            where += " ";
        } else {
            where += " and ADMIN = '" + admin + "' ";
        }

        if (link_id == null || link_id.equals("")) {
            where += " ";
        } else {
            where += " and LINK_ID = " + link_id + " ";
        }

        int result = 0;
        try {
            conn = poolAdStandby.getConnection();

            strSQL = "select count(*) from ADMIN_ROLE where ID>0 " + where + "";

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

    public boolean InsertRole() {
        Connection conn = null;
        PreparedStatement preStmt = null;
        PreparedStatement preStmt2 = null;
        String strSQL = null;
        ResultSet rs = null;
        int count = 0;
        String name = "";
        try {
            System.out.println("ok1");
            conn = poolAdActive.getConnection();
            System.out.println("ok2");
            strSQL = "Select user_name from ADMIN where id>3881";
            preStmt = conn.prepareStatement(strSQL);
            rs = preStmt.executeQuery();
            System.out.println("ok3");
            while (rs.next()) {
                System.out.println("name" + name);
                name = rs.getString("user_name");
                System.out.println(name + "--->name");

                strSQL = " insert into ADMIN_ROLE ( ADMIN, LINK_ID, IS_SELECT, IS_INSERT, IS_UPDATE, IS_DELETE, GEN_DATE, CREATED_BY) "
                        + " values(?, ?, ?, ?, ?, ?, current_timestamp, current_timestamp)";
                preStmt2 = conn.prepareStatement(strSQL);
                preStmt2.setString(1, name);
                preStmt2.setBigDecimal(2, new BigDecimal(410));
                preStmt2.setInt(3, 0);
                preStmt2.setInt(4, 1);
                preStmt2.setInt(5, 1);
                preStmt2.setInt(6, 1);
                if (preStmt2.executeUpdate() > 0) {
                    System.out.println(count + "-->count");
                    count++;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            System.out.println("exception: " + e.getMessage());
            logger.error(e);
        } finally {
            poolAdActive.releaseConnection(conn, preStmt, rs);
        }

        return count == 18;
    }

    public static void main(String[] args) {
        AdminRoleDAO dao = new AdminRoleDAO();
        System.out.println(dao.findAllObjHaskey("", "", 1, 30).size());

    }
}
