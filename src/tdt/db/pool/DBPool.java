package tdt.db.pool;

import tdt.util.Logger;
import java.io.PrintStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Iterator;
import java.util.LinkedList;

public class DBPool {
	private static Logger logger = new Logger("DBPool");

	private static LinkedList pool = new LinkedList();
	public static final int MAX_CONNECTIONS = 10;
	public static final int INI_CONNECTIONS = 1;
	public static boolean isConnected = true;

	static {
		build(1);
	}

	public static void build(int number) {
		logger.log("establishing " + number + " connections...");
		Connection conn = null;
		for (int i = 0; i < 1; i++) {
			try {
				conn = makeDBConnection();
			} catch (SQLException ex) {
				logger.log("Error: " + ex.getMessage());
				logger.log(">>TDT>>\tKhong noi dc voi database roi !");
				System.exit(1);
			}
			if (conn != null)
				pool.addLast(conn);
		}
	}

	public static Connection getConnection() {
		Connection conn = null;
		while (conn == null) {
			try {
				synchronized (pool) {
					if (pool.size() > 0) {
						conn = (Connection) pool.removeFirst();
					}
				}

				if ((conn == null) || (conn.isClosed())) {
					conn = makeDBConnection();
				}
				if (conn != null)
					conn.setAutoCommit(true);
				else
					Thread.sleep(1000L);
			} catch (Exception ex) {
				logger.error("getConnection: " + ex.getMessage());
				conn = null;
			}
		}
		return conn;
	}

	public static void putConnection(Connection conn) {
		try {
			if ((conn == null) || (conn.isClosed())) {
				logger.log("putConnection: conn is null or closed: " + conn);
				return;
			}
			if (pool.size() >= 10) {
				conn.close();
				return;
			}
		} catch (SQLException localSQLException) {
			synchronized (pool) {
				pool.addLast(conn);
			}
		}
	}

	public static void release() {
		logger.log("Closing connections in pool...");
		synchronized (pool) {
			for (Iterator it = pool.iterator(); it.hasNext();) {
				Connection conn = (Connection) it.next();
				try {
					conn.close();
				} catch (SQLException e) {
					logger
							.error("release: Cannot close connection! (maybe closed?)");
				}
			}
			pool.clear();
		}
		logger.log("OK");
	}

	public static int size() {
		synchronized (pool) {
			return pool.size();
		}
	}

	public static boolean isEmpty() {
		synchronized (pool) {
			return pool.isEmpty();
		}
	}

	public void finalize() {
		release();
	}

	public static Connection makeDBConnection() throws SQLException {
		Connection conn = null;
		try {
			Class.forName(DBConfig.db_driver_Service);

			conn = DriverManager.getConnection(DBConfig.db_url_Service,
					DBConfig.db_user_Service, DBConfig.db_pass_Service);
		} catch (ClassNotFoundException ex) {
			throw new SQLException(ex.getMessage());
		}
		return conn;
	}

	public static void main(String[] args) {
		DBPool pool = new DBPool();
		try {
			System.out.println(makeDBConnection());
		} catch (SQLException ex) {
			ex.printStackTrace();
		}
	}

	public static void load() {
	}
}