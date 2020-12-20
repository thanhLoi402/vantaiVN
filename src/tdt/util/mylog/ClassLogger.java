package tdt.util.mylog;

import java.io.BufferedReader;
import java.io.FileReader;
import java.util.Hashtable;

import tdt.util.Logger;
import tdt.util.conf.ConfigUtil;

/**
 * ThangDT, 6:55:34 PM E: thangdt@gmail.com
 *
 * @author ThangDT
 * @see ClassLogger.java
 */

public class ClassLogger {
	static Logger	logger	= new Logger("ClassLogger");
	
	/**
	 * @param args
	 */
	public static void main(String[] args) {
		//TODO ThangDT | 
		
	}
	
	private static Hashtable<String, Boolean>	hashClassName2EnableLog	= null;
	static {
		hashClassName2EnableLog = new Hashtable<String, Boolean>();
		loadConfig();
	}
	
	private static int							RELOAD_HASHES_TIMEOUT	= 10;	//minute
	private static long							TIME_LOADED				= 0;
	
	private static void reloadConfigIfNeeded() {
		if (System.currentTimeMillis() - TIME_LOADED > RELOAD_HASHES_TIMEOUT * 60 * 1000) {
			loadConfig();
		}
	}
	
	public static boolean isLogOnClass(String className) {
		reloadConfigIfNeeded();
		if (hashClassName2EnableLog.get(className) != null)
			return hashClassName2EnableLog.get(className);
		return false;
	}
	
	private static void loadConfig() {
		TIME_LOADED = System.currentTimeMillis();
		logger.log("ClassLogger | loadConfig()");
		try {
			BufferedReader in = new BufferedReader(new FileReader(ConfigUtil.class.getResource("logclass.conf").getFile()));
			String line = in.readLine();
			for (; line != null; line = in.readLine()) {
				line = line.trim();
				if ("".equals(line) || line.startsWith("#")) {
					continue;
				}
				
				//logger.log(line);
				int idx = line.indexOf("=");
				if (idx <= 0) {
					logger.log("   Seperator '=' is NOT found.");
					continue;
				}
				
				String className = line.substring(0, idx).trim();
				String value = line.substring(idx + 1).trim();
				
				if (className == null || className.equals("") || value == null || value.equals("")) {
					continue;
				}
				try {
					hashClassName2EnableLog.put(className, "true".equalsIgnoreCase(value));
				} catch (Exception e) {
					continue;
				}
				logger.log(className + "|" + value);
			}
		} catch (Exception ex) {
			ex.printStackTrace();
		}
		
	}
}
