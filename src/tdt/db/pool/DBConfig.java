/*    */ package tdt.db.pool;
/*    */ 
/*    */ import java.io.FileInputStream;
/*    */ import java.io.IOException;
/*    */ import java.io.PrintStream;
/*    */ import java.util.Properties;
/*    */ 
/*    */ public class DBConfig
/*    */ {
/*  9 */   public static String operator = "";
/* 10 */   public static String db_driver_smpp = "oracle.jdbc.driver.OracleDriver";
/* 11 */   public static String db_url_smpp = "jdbc:oracle:thin:@192.168.0.209:1521:sms";
/* 12 */   public static String db_user_smpp = "vcsms";
/* 13 */   public static String db_pass_smpp = "vcsms***";
/*    */ 
/* 15 */   public static String db_driver_Service = "oracle.jdbc.driver.OracleDriver";
/* 16 */   public static String db_url_Service = "jdbc:oracle:thin:@192.168.0.209:1521:sms";
/* 17 */   public static String db_user_Service = "vcsms";
/* 18 */   public static String db_pass_Service = "vcsms***";
/* 19 */   private static Properties properties = new Properties();
/* 20 */   public static boolean databaseEnabled = true;
/*    */ 
/*    */   public static void loadProperties()
/*    */     throws IOException
/*    */   {
/* 29 */     FileInputStream propsFile = new FileInputStream("./conf/database.conf");
/* 30 */     properties.load(propsFile);
/* 31 */     propsFile.close();
/*    */ 
/* 33 */     db_driver_smpp = properties.getProperty("db_driver_smpp", db_driver_smpp);
/* 34 */     db_url_smpp = properties.getProperty("db_url_smpp", db_url_smpp);
/* 35 */     db_user_smpp = properties.getProperty("db_user_smpp", db_user_smpp);
/* 36 */     db_pass_smpp = properties.getProperty("db_pass_smpp", db_pass_smpp);
/*    */ 
/* 38 */     db_driver_Service = properties.getProperty("db_driver_service", db_driver_Service);
/* 39 */     db_url_Service = properties.getProperty("db_url_service", db_url_Service);
/* 40 */     db_user_Service = properties.getProperty("db_user_service", db_user_Service);
/* 41 */     db_pass_Service = properties.getProperty("db_pass_service", db_pass_Service);
/*    */ 
/* 43 */     System.out.println(db_url_Service);
/*    */ 
/* 45 */     int i = getIntProperty("database_enabled", 0);
/* 46 */     /*    *//* 48 *//*    *//*    *//* 51 *//*    */
    databaseEnabled = i == 1;
/* 53 */     System.out.println("Database\t" + (isDatabaseEnabled() ? "enabled" : "disabled"));
/*    */   }
/*    */ 
/*    */   static int getIntProperty(String propName, int defaultValue)
/*    */   {
/* 58 */     return Integer.parseInt(properties.getProperty(propName, Integer.toString(defaultValue)));
/*    */   }
/*    */ 
/*    */   public static boolean isDatabaseEnabled()
/*    */   {
/* 63 */     return databaseEnabled;
/*    */   }
/*    */ }

/* Location:           D:\Achives\osp\cp\
 * Qualified Name:     cp.db.pool.DBConfig
 * JD-Core Version:    0.6.2
 */