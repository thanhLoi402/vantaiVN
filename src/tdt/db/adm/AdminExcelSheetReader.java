package tdt.db.adm;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.Vector;

import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.poifs.filesystem.POIFSFileSystem;

import tdt.db.pool.DBPoolX;
import tdt.db.pool.DBPoolXData;
import tdt.util.Md5;

public class AdminExcelSheetReader {
	private static AdminDAO adminDAO = new AdminDAO();
	private static DBPoolX poolConn = null;
	
	public static int getListFromExcelFile(InputStream inputStream) {
		System.out.println("vào đây");
		List cellDataList = new ArrayList();
		try {			
			POIFSFileSystem fsFileSystem = new POIFSFileSystem(inputStream);			
			HSSFWorkbook workBook = new HSSFWorkbook(fsFileSystem);
			HSSFSheet hssfSheet = workBook.getSheetAt(0);
			Iterator rowIterator = hssfSheet.rowIterator();
			HSSFRow hssfRow = null;
			Iterator iterator = null;
			HSSFCell hssfCell = null;
			List cellTempList = null;

			while (rowIterator.hasNext()) {
				hssfRow = (HSSFRow) rowIterator.next();
				iterator = hssfRow.cellIterator();
				cellTempList = new ArrayList();
				while (iterator.hasNext()) {
					hssfCell = (HSSFCell) iterator.next();
					try{
						hssfCell.setCellType(HSSFCell.CELL_TYPE_STRING);
					}catch(Exception ex){}
					cellTempList.add(hssfCell);
				}
				cellDataList.add(cellTempList);
				hssfRow = null;
			}
			hssfRow = null;
			iterator = null;
			hssfCell = null;
			cellTempList = null;
		} catch (Exception ex) {
			ex.printStackTrace();
		} finally {
			System.gc();
		}

		List cellTempList = null;
		
		Admin adm = null;
		Admin tmp = null;
		System.out.println("vào đây1");
		
		for (int i = 0; i <18; i++) {
			System.out.println(i);
			if (i % 500 == 0) {
				try {
					Thread.sleep(500);
					System.gc();
				} catch (Exception e) {
					// TODO: handle exception
				}
			}
			System.out.println("------->size:"+cellDataList.size());
			cellTempList = (List) cellDataList.get(i); // 1 row		
			adm = new Admin();
			adm.setUserName(cellTempList.get(2).toString().trim());
			
			tmp = adminDAO.getRowByUser(adm.getUserName());
			
			
			adm.setPassword(Md5.Hash("123456Abc"));
			adm.setStatus(0);
			adm.setRightRole(3);
			adm.setFullName(cellTempList.get(1)!=null?cellTempList.get(1).toString():cellTempList.get(2).toString());
			
			System.out.println(i + " ---> " +adm.getUserName() + " ---> " );
			if(tmp!=null){
				try {
					adm.setId(tmp.getId());
					adminDAO.updateRow(adm);
				} catch (IOException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
			} else{
				adminDAO.insertRow(adm);
			}
			
		}
		return 0;
	}
	public static boolean InsertRole(){
	boolean result=false;
	Admin adm = null;
	Connection conn = null;
	PreparedStatement preStmt = null;
	String strSQL = null;
	ResultSet rs = null;
	BigDecimal id = null;
	int count=0;
	String name="";
	try{
		System.out.println("ok1");
		conn = poolConn.getConnection();
		System.out.println("ok2");
		strSQL = "Select user_name from ADMIN where id>2047";
		preStmt = conn.prepareStatement(strSQL);
		rs = preStmt.executeQuery();
		System.out.println("ok3");
		if(rs.next()){
			System.out.println("name"+name);
			name=rs.getString(0);
			System.out.println(name+"--->name");
			rs.close();
			preStmt.close();
			strSQL= " insert into ADMIN_ROLE ( ADMIN, LINK_ID, IS_SELECT, IS_INSERT, IS_UPDATE, IS_DELETE, GEN_DATE, CREATED_BY) " +
					" values( ?, ?, ?, ?, ?, ?, current_timestamp, current_timestamp)";
			preStmt = conn.prepareStatement(strSQL);
			preStmt.setString(1, name);
			preStmt.setBigDecimal(2,new BigDecimal(410));
			preStmt.setInt(3, 0);
			preStmt.setInt(4, 0);
			preStmt.setInt(5, 0);
			preStmt.setInt(6, 1);
			if(preStmt.executeUpdate()>0){
				System.out.println(count+"-->count");
				count++;}
		}
	}catch(Exception e){
		System.out.println("exception: "+e.getMessage());
	}

        return count == 363;
	}
		
	public static void main(String[] args){
		try {
			InputStream is = new FileInputStream(DBPoolXData.class.getResource("DS_account_CSKH.xls").getFile());
			System.out.println(getListFromExcelFile(is));
		} catch (FileNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
}