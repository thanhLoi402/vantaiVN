package tdt.db.service;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import org.json.JSONArray;
import org.json.JSONObject;
import tdt.db.pool.DBPoolX;
import tdt.db.pool.DBPoolXName;
import tdt.util.Logger;

public class DaoExcuteSql {

    private Logger logger = null;
    private DBPoolX poolConn = null;

    public DaoExcuteSql() {
        try {
            this.poolConn = DBPoolX.getInstance(DBPoolXName.SERVICE_SPLUS_ACTIVE);
            this.logger = new Logger(getClass().getName());
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public JSONArray findAll(String sql, int page, int rowsPerPage) {
        int startRow = (page - 1) * rowsPerPage + 1;
        int stopRow = page * rowsPerPage;
        Connection conn = null;
        PreparedStatement preStmt = null;
        StringBuilder strSQL = new StringBuilder();
        JSONArray resultArray = new JSONArray();
        ResultSet rs = null;
        try {
            sql = sql.trim().replace("&", "'");
            String[] arrayString = sql.substring(6, sql.indexOf("from")).split(",");
            for (int i = 0; i < arrayString.length; i++) {
                if ((arrayString[i] != null) && (arrayString[i].trim().indexOf("as") > 0)) {
                    arrayString[i] = arrayString[i].substring(arrayString[i].indexOf("as") + 2, arrayString[i].length());
                }
            }
            conn = this.poolConn.getConnection();
            strSQL.append("select * from ( select a.*, row_number() over (order by " + arrayString[0] + " desc) as R " + "from (" + sql + ") a ");

            strSQL.append(") where R >= ? and R <= ?");
            preStmt = conn.prepareStatement(strSQL.toString());
            int i = 1;
            preStmt.setInt(i, startRow);
            i++;
            preStmt.setInt(i, stopRow);
            rs = preStmt.executeQuery();

            JSONObject obj;
            while (rs.next()) {
                obj = new JSONObject();
                for (int j = 0; j < arrayString.length; j++) {
                    obj.put(arrayString[j].trim(), rs.getObject(j + 1));
                }
                resultArray.put(obj);
            }
            return resultArray;
        } catch (Exception e) {
            try {
                this.logger.error("findAll: Error executing SQL " + strSQL + ">>>" + e.toString());
                JSONObject obj = new JSONObject();
                obj.put("ERROR", e.getMessage());
                resultArray.put(obj);
            } catch (Exception ex) {
                ex.printStackTrace();
            }
        } finally {
            this.poolConn.releaseConnection(conn, preStmt, rs);
        }
        return resultArray;
    }

    public int countAll(String sql) {
        Connection conn = null;
        PreparedStatement preStmt = null;
        StringBuilder strSQL = new StringBuilder();
        ResultSet rs = null;
        int count = 0;
        try {
            conn = this.poolConn.getConnection();
            sql = sql.trim().replace("&", "'");
            strSQL.append("select count(1) from (" + sql + ") ");
            preStmt = conn.prepareStatement(strSQL.toString());
            rs = preStmt.executeQuery();
            if (rs.next()) {
                count = rs.getInt(1);
            }
        } catch (Exception e) {
            this.logger.error("countAll: Error executing SQL " + strSQL + ">>>" + e.toString());
        } finally {
            this.poolConn.releaseConnection(conn, preStmt, rs);
        }
        return count;
    }
}
