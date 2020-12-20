package tdt.util.my;

import java.io.UnsupportedEncodingException;
import java.net.URLDecoder;
import java.net.URLEncoder;

import tdt.util.security.AES;

public class AESTool {
	static String AES_KEY = "VAS.RD.REPORT123";
	
	public static String encryptURL(String str){
		String result = null;
		try {
			result = AES.encrypt(URLEncoder.encode(str,"UTF-8"), AES_KEY);
		} catch (UnsupportedEncodingException e) {
			e.printStackTrace();
		}
		return result;
	}
	
	public static String decryptURL(String str){
		String result = null;
		try {
			result = AES.decrypt(URLDecoder.decode(str,"UTF-8"), AES_KEY);
			result = result.replaceAll("%2F", "/").replace("%26", "&");
		} catch (UnsupportedEncodingException e) {
			e.printStackTrace();
		}
		return result;
	}
	
	public static void main(String[] args){
		System.out.println(decryptURL("dkEoiXzlHzFoUqhNsPkHGDBZiw0DZ305tSuh  jP6qg="));
	}
	
}
