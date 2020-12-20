package tdt.util.my;

import java.io.CharArrayWriter;
import java.io.Reader;

public class ClobTool {
	public static String getString(java.sql.Clob clobData) {
		String content = "";
		try {
			Reader reader = clobData.getCharacterStream();
			CharArrayWriter writer = new CharArrayWriter();
			int i = -1;
			while((i = reader.read()) != -1) {
				writer.write(i);
			}
			content = new String(writer.toCharArray());
		} catch (Exception e) {
//			System.out.println("Error get clob string >> " + e.getMessage());
		} 
		return content;
	}
}
