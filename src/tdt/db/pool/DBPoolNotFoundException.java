package tdt.db.pool;
/**
 * @author Nguyen Trong Tho
 * @version 1.0
 */

/**
 * This exception is thrown when fail to connect to ORACLE
 */

public class DBPoolNotFoundException extends Exception {
    public DBPoolNotFoundException() {
        super();
    }
    public DBPoolNotFoundException(String s) {
        super(s);
    }
}
