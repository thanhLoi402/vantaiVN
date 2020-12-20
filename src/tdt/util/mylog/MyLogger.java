package tdt.util.mylog;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.Properties;

import tdt.util.StringTool;
import tdt.util.conf.ConfigUtil;
import tdt.util.log4j.DebugClass;
import tdt.util.log4j.LogDef;
import tdt.util.log4j.LogWriter;

public class MyLogger {
	
	private static String		csModuleName	= "PiscesLog";
	private static String		fs				= File.separator;
	private static LogWriter	objWriter		= null;
	private static String		csPath			= "." + fs + "logf";
	private static byte			nLogLevel		= LogDef.LOG_LEVEL.LOG_INFO;
	
	static {
		loadConfig();
		initLogger();
	}
	
	private static void loadConfig() {
		Properties properties = new Properties();
		InputStream input = null;
		try {
			//input = new FileInputStream("conf/mylog.conf");
			input = new FileInputStream(ConfigUtil.class.getResource("mylog.conf").getFile());
			properties.load(input);
			try {
				csModuleName = properties.getProperty("modulename");
				csPath = properties.getProperty("path");
				nLogLevel = (byte) Integer.parseInt(properties.getProperty("level"));
			} catch (Exception localException1) {
				localException1.printStackTrace();
			}
		} catch (Exception ex) {
			ex.printStackTrace();
			
			if (input != null)
				try {
					input.close();
				} catch (IOException e) {
					e.printStackTrace();
				}
		} finally {
			if (input != null)
				try {
					input.close();
				} catch (IOException e) {
					e.printStackTrace();
				}
		}
	}
	
	private static void initLogger() {
		objWriter = new LogWriter(csModuleName, nLogLevel);
		objWriter.setFileLogInfo(true, csPath, csModuleName, LogDef.FILE.CHANGE_ON_SZIE, //Change file when maximum size reached
				LogDef.FILE.MAX_FILE_SIZE / 1, //10M
				LogDef.FILE.MAX_FILE_BACKUP_INDEX,// 1000 file per day               
				false //flush immediately
				);
		objWriter.setSysLogInfo(true, "localhost", 513);
		objWriter.setConsoleInfo(true);
		
		objWriter.open();
	}
	
	synchronized private static void log(String logString, byte nLevel) {
		if (objWriter != null) {
			objWriter.writeLog(logString, nLevel);
		} else {
			DebugClass.system_out_ln("[" + nLevel + "] " + logString);
		}
	}
	
	public static void log(String logString) {
		log(logString, LogDef.LOG_LEVEL.LOG_ALL);
	}
	
	public static void debug(String logString) {
		log(logString, LogDef.LOG_LEVEL.LOG_DEBUG);
	}
	
	public static void logInfo(String logString) {
		log(logString, LogDef.LOG_LEVEL.LOG_INFO);
	}
	
	public static void warning(String logString) {
		log(logString, LogDef.LOG_LEVEL.LOG_WARNING);
	}
	
	public static void error(String errorString) {
		log(errorString, LogDef.LOG_LEVEL.LOG_ERROR);
	}
	
	public static void error(Exception ex) {
		log(ex.getMessage(), LogDef.LOG_LEVEL.LOG_ERROR);
	}
	
	public static void fatal(String logString) {
		log(logString, LogDef.LOG_LEVEL.LOG_FATAL);
	}
	
	public static void logoff(String logString) {
		log(logString, LogDef.LOG_LEVEL.LOG_OFF);
	}
	
}
