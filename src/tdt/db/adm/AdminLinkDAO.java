package tdt.db.adm;

import tdt.db.pool.*;
import tdt.util.Logger;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Vector;

public class AdminLinkDAO {

    private Logger logger = null;
    private DBPoolX poolAdStandby = null;
    private DBPoolX poolAdActive = null;

    public AdminLinkDAO() {
        try {
            poolAdStandby = DBPoolX.getInstance(DBPoolXName.AD_STANBY);
            poolAdActive = DBPoolX.getInstance(DBPoolXName.AD_ACTIVE);
            logger = new Logger(this.getClass().getName());
        } catch (Exception e) {
        }
    }

    public boolean insertRow(AdminLink obj) {
        if (obj == null) {
            return false;
        }
        Connection conn = null;
        PreparedStatement preStmt = null;
        String strSQL = null;
        boolean result = false;
        ResultSet rs = null;
        try {
            conn = poolAdActive.getConnection();

            strSQL = "select ID from ADMIN_LINK where URI = ? and URI != '#' ";
            preStmt = conn.prepareStatement(strSQL);
            preStmt.setString(1, obj.getUri());
            rs = preStmt.executeQuery();
            if (!rs.next()) {
                rs.close();
                preStmt.close();
                strSQL = " insert into ADMIN_LINK ( NAME, URI, PARENT_ID, STATUS, POSITION, GEN_DATE, DISPLAY_TOP, IS_SELECT, IS_INSERT, IS_UPDATE, IS_DELETE) "
                        + " values(?, ?, ?, ?, ?, current_timestamp, ?, ?, ?, ?, ?)";
                preStmt = conn.prepareStatement(strSQL);
                preStmt.setString(1, obj.getName());
                preStmt.setString(2, obj.getUri());
                preStmt.setBigDecimal(3, obj.getParent_id());
                preStmt.setInt(4, obj.getStatus());
                preStmt.setInt(5, obj.getPosition());
                preStmt.setInt(6, obj.getDisplay_top());
                preStmt.setInt(7, obj.getIs_select());
                preStmt.setInt(8, obj.getIs_insert());
                preStmt.setInt(9, obj.getIs_update());
                preStmt.setInt(10, obj.getIs_delete());
                if (preStmt.executeUpdate() > 0) {
                    result = true;
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

    public BigDecimal getMaxId() {
        Connection conn = null;
        PreparedStatement preStmt = null;
        String strSQL = null;
        BigDecimal result = null;
        ResultSet rs = null;
        try {
            conn = poolAdStandby.getConnection();
            strSQL = " select * from (select ID from ADMIN_LINK order by ID desc) where rownum = 1";
            preStmt = conn.prepareStatement(strSQL);
            rs = preStmt.executeQuery();
            if (rs.next()) {
                result = rs.getBigDecimal(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
            logger.error("getMaxId: Error executing SQL " + strSQL + ">>>" + e.toString());
            System.out.println("getMaxId: " + e.getMessage());
        } finally {
            poolAdStandby.releaseConnection(conn, preStmt, rs);
        }
        return result;
    }

    public boolean updateRow(AdminLink obj) {
        if (obj == null) {
            return false;
        }
        Connection conn = null;
        PreparedStatement preStmt = null;
        String strSQL = null;
        boolean result = false;
        try {
            conn = poolAdActive.getConnection();
            strSQL = " update ADMIN_LINK set NAME=?, URI=?, PARENT_ID=?, STATUS=?, POSITION=?, GEN_DATE=current_timestamp, DISPLAY_TOP=?, "
                    + "	IS_SELECT=?, IS_INSERT=?, IS_UPDATE=?, IS_DELETE=? where ID=? ";
            preStmt = conn.prepareStatement(strSQL);
            preStmt.setString(1, obj.getName());
            preStmt.setString(2, obj.getUri());
            preStmt.setBigDecimal(3, obj.getParent_id());
            preStmt.setInt(4, obj.getStatus());
            preStmt.setInt(5, obj.getPosition());
            preStmt.setInt(6, obj.getDisplay_top());
            preStmt.setInt(7, obj.getIs_select());
            preStmt.setInt(8, obj.getIs_insert());
            preStmt.setInt(9, obj.getIs_update());
            preStmt.setInt(10, obj.getIs_delete());
            preStmt.setBigDecimal(11, obj.getId());
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


    public Vector<AdminLink> getTreeView2(BigDecimal parentId, int status) {
        Vector<AdminLink> adminLinks = new Vector<>();
        Vector<AdminLink> result1 = null;
        try {
            result1 = getAdminLinkByParentId(parentId, status);
            if (result1 != null && result1.size() > 0) {
                for (AdminLink adminLink1 : result1) {
                    adminLinks.add(adminLink1);
                    Vector<AdminLink> result2 = getAdminLinkByParentId(adminLink1.getId(), status);
                    if (result2 != null && result2.size() > 0) {
                        for (AdminLink adminLink2 : result2) {
                            adminLinks.add(adminLink2);
                            Vector<AdminLink> result3 = getAdminLinkByParentId(adminLink2.getId(), status);
                            if (result3 != null && result3.size() > 0) {
                                adminLinks.addAll(result3);

                            }
                        }
                    }

                }
            }
        } catch (Exception e) {
            logger.error(e);
            e.printStackTrace();
        }
        return adminLinks;
    }

    public Vector<AdminLink> getAdminLinkByParentId(BigDecimal parentId, int status) {
        Connection conn = null;
        PreparedStatement preStmt = null;
        String strSQL = null;
        ResultSet rs1 = null;
        Vector<AdminLink> result = null;
        AdminLink obj = null;
        String where = "";
        if (status != -1) {
            where = " and STATUS = " + status;
        }
        try {
            conn = poolAdStandby.getConnection();
            strSQL = "select * from ADMIN_LINK where PARENT_ID = ? " + where + " order by POSITION asc";
            preStmt = conn.prepareStatement(strSQL);
            preStmt.setBigDecimal(1, parentId);
            rs1 = preStmt.executeQuery();
            result = new Vector<AdminLink>();
            while (rs1.next()) {
                obj = new AdminLink();
                obj.setId(rs1.getBigDecimal("ID"));
                obj.setUri(rs1.getString("URI"));
                obj.setName(rs1.getString("NAME"));
                obj.setParent_id(rs1.getBigDecimal("PARENT_ID"));
                obj.setStatus(rs1.getInt("STATUS"));
                obj.setPosition(rs1.getInt("POSITION"));
                obj.setGen_date(rs1.getTimestamp("GEN_DATE"));
                obj.setDisplay_top(rs1.getInt("DISPLAY_TOP"));
                obj.setIs_select(rs1.getInt("IS_SELECT"));
                obj.setIs_insert(rs1.getInt("IS_INSERT"));
                obj.setIs_update(rs1.getInt("IS_UPDATE"));
                obj.setIs_delete(rs1.getInt("IS_DELETE"));
                obj.setLink_level(rs1.getInt("LINK_LEVEL"));
                result.add(obj);
            }

        } catch (Exception e) {
            logger.error("getAdminLinkByParentId: Error executing SQL " + strSQL + ">>>" + e.toString());
            System.out.println("getAdminLinkByParentId: Error executing SQL " + strSQL + ">>>" + e.toString());
        } finally {
            poolAdStandby.releaseConnection(conn, preStmt, rs1);
        }
        return result;
    }


    public Vector<AdminLink> findAll() {
        Connection conn = null;
        PreparedStatement preStmt = null;
        ResultSet rs = null;
        String strSQL = null;
        Vector<AdminLink> result = null;
        AdminLink obj = null;
        try {
            conn = poolAdStandby.getConnection();
            strSQL = "select * from ADMIN_LINK order by POSITION";
            preStmt = conn.prepareStatement(strSQL);
            rs = preStmt.executeQuery();
            result = new Vector<AdminLink>();
            while (rs.next()) {
                obj = new AdminLink();
                obj.setId(rs.getBigDecimal("ID"));
                obj.setUri(rs.getString("URI"));
                obj.setName(rs.getString("NAME"));
                obj.setParent_id(rs.getBigDecimal("PARENT_ID"));
                obj.setStatus(rs.getInt("STATUS"));
                obj.setPosition(rs.getInt("POSITION"));
                obj.setGen_date(rs.getTimestamp("GEN_DATE"));
                obj.setDisplay_top(rs.getInt("DISPLAY_TOP"));
                obj.setIs_select(rs.getInt("IS_SELECT"));
                obj.setIs_insert(rs.getInt("IS_INSERT"));
                obj.setIs_update(rs.getInt("IS_UPDATE"));
                obj.setIs_delete(rs.getInt("IS_DELETE"));
                obj.setLink_level(rs.getInt("LINK_LEVEL"));
                result.add(obj);
            }

        } catch (Exception e) {
            logger.error("findAll: Error executing SQL " + strSQL + ">>>" + e.toString());
            System.out.println("findAll: Error executing SQL " + strSQL + ">>>" + e.toString());
        } finally {
            poolAdStandby.releaseConnection(conn, preStmt, rs);
        }
        return result;
    }

    public Vector<AdminLink> findAllChildren(BigDecimal parentId) {
        Connection conn = null;
        PreparedStatement preStmt = null;
        ResultSet rs = null;
        String strSQL = null;
        Vector<AdminLink> result = null;
        AdminLink obj = null;
        try {
            conn = poolAdStandby.getConnection();
            strSQL = "select * from ADMIN_LINK where PARENT_ID = ? order by POSITION asc";
            preStmt = conn.prepareStatement(strSQL);
            preStmt.setBigDecimal(1, parentId);
            rs = preStmt.executeQuery();
            result = new Vector<AdminLink>();
            while (rs.next()) {
                obj = new AdminLink();
                obj.setId(rs.getBigDecimal("ID"));
                obj.setUri(rs.getString("URI"));
                obj.setName(rs.getString("NAME"));
                obj.setParent_id(rs.getBigDecimal("PARENT_ID"));
                obj.setStatus(rs.getInt("STATUS"));
                obj.setPosition(rs.getInt("POSITION"));
                obj.setGen_date(rs.getTimestamp("GEN_DATE"));
                obj.setDisplay_top(rs.getInt("DISPLAY_TOP"));
                obj.setIs_select(rs.getInt("IS_SELECT"));
                obj.setIs_insert(rs.getInt("IS_INSERT"));
                obj.setIs_update(rs.getInt("IS_UPDATE"));
                obj.setIs_delete(rs.getInt("IS_DELETE"));
                obj.setLink_level(rs.getInt("LINK_LEVEL"));
                result.add(obj);
            }

        } catch (Exception e) {
            logger.error("findAll: Error executing SQL " + strSQL + ">>>" + e.toString());
            System.out.println("findAll: Error executing SQL " + strSQL + ">>>" + e.toString());
        } finally {
            poolAdStandby.releaseConnection(conn, preStmt, rs);
        }
        return result;
    }

    public Vector<AdminLink> getTreeView2Level(String status) {
        Connection conn = null;
        PreparedStatement preStmt = null;
        ResultSet rs = null;
        String strSQL = null;
        PreparedStatement preStmt1 = null;
        ResultSet rs1 = null;
        String strSQL1 = null;
        Vector<AdminLink> result = null;
        AdminLink obj = null;
        BigDecimal id = null;
        try {
            conn = poolAdStandby.getConnection();
            strSQL = "select * from ADMIN_LINK where PARENT_ID = 0 and STATUS in(" + status + ") order by POSITION asc";
            preStmt = conn.prepareStatement(strSQL);
            rs = preStmt.executeQuery();
            result = new Vector<AdminLink>();
            while (rs.next()) {
                obj = new AdminLink();
                obj.setId(rs.getBigDecimal("ID"));
                obj.setUri(rs.getString("URI"));
                obj.setName(rs.getString("NAME"));
                obj.setParent_id(rs.getBigDecimal("PARENT_ID"));
                obj.setStatus(rs.getInt("STATUS"));
                obj.setPosition(rs.getInt("POSITION"));
                obj.setGen_date(rs.getTimestamp("GEN_DATE"));
                obj.setDisplay_top(rs.getInt("DISPLAY_TOP"));
                obj.setIs_select(rs.getInt("IS_SELECT"));
                obj.setIs_insert(rs.getInt("IS_INSERT"));
                obj.setIs_update(rs.getInt("IS_UPDATE"));
                obj.setIs_delete(rs.getInt("IS_DELETE"));
                obj.setLink_level(rs.getInt("LINK_LEVEL"));
                result.add(obj);
                id = rs.getBigDecimal("ID");
                strSQL1 = "select * from ADMIN_LINK where PARENT_ID = ? and STATUS in(" + status + ") order by POSITION asc";
                preStmt1 = conn.prepareStatement(strSQL1);
                preStmt1.setBigDecimal(1, id);
                rs1 = preStmt1.executeQuery();
                while (rs1.next()) {
                    obj = new AdminLink();
                    obj.setId(rs1.getBigDecimal("ID"));
                    obj.setUri(rs1.getString("URI"));
                    obj.setName(rs1.getString("NAME"));
                    obj.setParent_id(rs1.getBigDecimal("PARENT_ID"));
                    obj.setStatus(rs1.getInt("STATUS"));
                    obj.setPosition(rs1.getInt("POSITION"));
                    obj.setGen_date(rs1.getTimestamp("GEN_DATE"));
                    obj.setDisplay_top(rs1.getInt("DISPLAY_TOP"));
                    obj.setIs_select(rs1.getInt("IS_SELECT"));
                    obj.setIs_insert(rs1.getInt("IS_INSERT"));
                    obj.setIs_update(rs1.getInt("IS_UPDATE"));
                    obj.setIs_delete(rs1.getInt("IS_DELETE"));
                    obj.setLink_level(rs1.getInt("LINK_LEVEL"));
                    //System.out.println(obj.getName());
                    result.add(obj);
                }
                rs1.close();
                preStmt1.close();
            }

        } catch (Exception e) {
            logger.error("getTreeView2Level: Error executing SQL " + strSQL + ">>>" + e.toString());
            System.out.println("getTreeView2Level: Error executing SQL " + strSQL + ">>>" + e.toString());
        } finally {
            try {
                if (rs1 != null) {
                    rs1.close();
                }
                if (preStmt1 != null) {
                    preStmt1.close();
                }
                poolAdStandby.releaseConnection(conn, preStmt, rs);
            } catch (SQLException e) {
                // TODO Auto-generated catch block
                e.printStackTrace();
            }
        }
        return result;
    }

    public AdminLink getRow(BigDecimal id) {
        Connection conn = null;
        PreparedStatement preStmt = null;
        ResultSet rs = null;
        String strSQL = null;
        AdminLink obj = null;
        try {
            conn = poolAdStandby.getConnection();
            strSQL = "select * from ADMIN_LINK where ID = ?";
            preStmt = conn.prepareStatement(strSQL);
            preStmt.setBigDecimal(1, id);
            rs = preStmt.executeQuery();
            if (rs.next()) {
                obj = new AdminLink();
                obj.setId(rs.getBigDecimal("ID"));
                obj.setUri(rs.getString("URI"));
                obj.setName(rs.getString("NAME"));
                obj.setParent_id(rs.getBigDecimal("PARENT_ID"));
                obj.setStatus(rs.getInt("STATUS"));
                obj.setPosition(rs.getInt("POSITION"));
                obj.setGen_date(rs.getTimestamp("GEN_DATE"));
                obj.setDisplay_top(rs.getInt("DISPLAY_TOP"));
                obj.setIs_select(rs.getInt("IS_SELECT"));
                obj.setIs_insert(rs.getInt("IS_INSERT"));
                obj.setIs_update(rs.getInt("IS_UPDATE"));
                obj.setIs_delete(rs.getInt("IS_DELETE"));
                obj.setLink_level(rs.getInt("LINK_LEVEL"));
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

    public boolean deleteRow(BigDecimal id) {
        Connection conn = null;
        PreparedStatement preStmt = null;
        ResultSet rs = null;
        String strSQL = null;
        boolean resutl = false;
        try {
            conn = poolAdActive.getConnection();
            strSQL = "delete from ADMIN_LINK where ID = ?";
            preStmt = conn.prepareStatement(strSQL);
            preStmt.setBigDecimal(1, id);
            if (preStmt.executeUpdate() > 0) {
                resutl = true;
            }

            preStmt.close();
            strSQL = "delete from ADMIN_ROLE where LINK_ID = ?";
            preStmt = conn.prepareStatement(strSQL);
            preStmt.setBigDecimal(1, id);
            preStmt.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
            logger.error("deleteRow: Error executing SQL " + strSQL + ">>>"
                    + e.toString());
        } finally {
            poolAdActive.releaseConnection(conn, preStmt);
        }
        return resutl;
    }

    public boolean updateCurrentLevel(BigDecimal id, int level) {
        Connection conn = null;
        PreparedStatement preStmt = null;
        String strSQL = null;
        boolean result = false;
        try {
            conn = poolAdActive.getConnection();
            strSQL = " update ADMIN_LINK set LINK_LEVEL=? where ID=? ";
            preStmt = conn.prepareStatement(strSQL);
            preStmt.setInt(1, level);
            preStmt.setBigDecimal(2, id);
            if (preStmt.executeUpdate() > 0) {
                result = true;
            }
        } catch (Exception e) {
            e.printStackTrace();
            logger.error("updateCurrentLevel: Error executing SQL " + strSQL + ">>>" + e.toString());
            System.out.println("updateCurrentLevel: " + e.getMessage());
        } finally {
            poolAdActive.releaseConnection(conn, preStmt);
        }
        return result;
    }

    public static int[] getCurrentMenuId(BigDecimal id, Vector<AdminLink> cAdminLink) {
        AdminLink objLink = null;

        int idMenuLevel2 = 0;
        int idMenuLevel1 = 0;

        if (id == null || cAdminLink == null) {
            return new int[]{idMenuLevel1, idMenuLevel2};
        }

        while (!id.toString().equals("0")) {
            for (int i = 0; i < cAdminLink.size(); i++) {
                objLink = cAdminLink.get(i);
                if (objLink != null) {
                    if (objLink.getId().toString().equals(id.toString())) {
                        id = objLink.getParent_id();
                        if (objLink.getLink_level() == 2) {
                            idMenuLevel2 = objLink.getId().intValue();
                            idMenuLevel1 = objLink.getParent_id().intValue();
                        }
                        break;
                    }
                }
            }
        }
        return new int[]{idMenuLevel1, idMenuLevel2};

    }

    public static int getCurrentLevel(BigDecimal id, Vector<AdminLink> cAdminLink) {
        if (id == null || cAdminLink == null) {
            return -1;
        }
        int level = 0;

        AdminLink objLink = null;

        while (!id.toString().equals("0")) {
            for (int i = 0; i < cAdminLink.size(); i++) {
                objLink = cAdminLink.get(i);
                if (objLink != null) {
                    if (objLink.getId().toString().equals(id.toString())) {
                        id = objLink.getParent_id();
                        level++;
                        break;
                    }
                }
            }
            if (level == 0) {
                return -1;
            }
        }

        return level;

    }

    public static void main(String[] args) {
        AdminLinkDAO linkDAO = new AdminLinkDAO();
        Vector<AdminLink> cAdminLink = linkDAO.getTreeView2Level("0,9");
        System.out.println(cAdminLink.size());

    }

    public static AdminLink getCurrentMenu(Vector<AdminLink> cAdminLink, BigDecimal id) {
        String menu = "";
        AdminLink obj = null;
        for (int i = 0; i < cAdminLink.size(); i++) {
            obj = cAdminLink.get(i);
            if (obj != null) {
                if (obj.getId().toString().equals(id.toString())) {
                    id = obj.getParent_id();
                    break;
                }
            }
        }
        for (int i = 0; i < cAdminLink.size(); i++) {
            obj = cAdminLink.get(i);
            if (obj != null) {
                if (obj.getId().toString().equals(id.toString())) {
                    break;
                }
            }
        }
        return obj;
    }

    public static Vector<AdminLink> getTreeView5Level(Vector<AdminLink> cAdminLink) {
        Vector<AdminLink> cVector = new Vector<AdminLink>();
        AdminLink objAdminLink1 = null;
        AdminLink objAdminLink2 = null;
        AdminLink objAdminLink3 = null;
        AdminLink objAdminLink4 = null;
        AdminLink objAdminLink5 = null;

        int index1 = 0, index2 = 0, index3 = 0, index4 = 0, index5 = 0;

        Vector<AdminLink> cResult = new Vector<AdminLink>();

        for (int i = 0; i < cAdminLink.size(); i++) {
            objAdminLink1 = cAdminLink.get(i);
            if (objAdminLink1 != null && objAdminLink1.getParent_id().toString().equals("0")) {
                index1++;
//				System.out.println("--"+ (index1)+ "." + objAdminLink1.getName());
                cResult.add(objAdminLink1);
                for (int i1 = 0; i1 < cAdminLink.size(); i1++) {
                    objAdminLink2 = cAdminLink.get(i1);
                    if (objAdminLink2 != null && objAdminLink2.getParent_id().toString().equals(objAdminLink1.getId().toString())) {
                        index2++;
//						System.out.println("----"+ (index2)+ "." + objAdminLink2.getName());	
                        cResult.add(objAdminLink2);
                        for (int i2 = 0; i2 < cAdminLink.size(); i2++) {
                            objAdminLink3 = cAdminLink.get(i2);
                            if (objAdminLink3 != null && objAdminLink3.getParent_id().toString().equals(objAdminLink2.getId().toString())) {
                                index3++;
//								System.out.println("------"+ (index3)+ "." + objAdminLink3.getName());
                                cResult.add(objAdminLink3);
                                for (int i3 = 0; i3 < cAdminLink.size(); i3++) {
                                    objAdminLink4 = cAdminLink.get(i3);
                                    if (objAdminLink4 != null && objAdminLink4.getParent_id().toString().equals(objAdminLink3.getId().toString())) {
                                        index4++;
                                        cResult.add(objAdminLink4);
//										System.out.println("--------"+ (index4) +"." +  objAdminLink4.getName());						
                                        for (int i4 = 0; i4 < cAdminLink.size(); i4++) {
                                            objAdminLink5 = cAdminLink.get(i4);
                                            if (objAdminLink5 != null && objAdminLink5.getParent_id().toString().equals(objAdminLink4.getId().toString())) {
                                                index5++;
                                                cResult.add(objAdminLink5);
//												System.out.println("--------"+ (index5) + "." + objAdminLink5.getName());						
                                            }
                                        }
                                        index5 = 0;
                                    }
                                }
                                index4 = 0;
                            }
                        }
                        index3 = 0;
                    }
                }
                index2 = 0;
            }
        }
        return cVector;
    }

}
