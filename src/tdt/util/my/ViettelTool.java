package tdt.util.my;

import java.util.Vector;
import java.util.regex.Pattern;

import tdt.util.conf.ConfigUtil;
import tdt.util.file.FileTool;
import tdt.util.network.IPv4Tool;
import tdt.util.network.IPv6Address;
import tdt.util.network.IPv6AddressRange;
import tdt.util.network.IPv6Network;

public class ViettelTool {
	private static final String fileName = ConfigUtil.class.getResource("IPPoolVT.lst").getFile();
	
        private static final String fileNameIpv6 = ConfigUtil.class.getResource("IPv6PoolVT.lst").getFile();
        
         private static final Pattern IPV6_STD_PATTERN = Pattern.compile("^(?:[0-9a-fA-F]{1,4}:){7}[0-9a-fA-F]{1,4}$");
    private static final Pattern IPV6_HEX_COMPRESSED_PATTERN = Pattern.compile("^((?:[0-9A-Fa-f]{1,4}(?::[0-9A-Fa-f]{1,4})*)?)::((?:[0-9A-Fa-f]{1,4}(?::[0-9A-Fa-f]{1,4})*)?)$");

    public static boolean isIPv6StdAddress(final String input) {
        return IPV6_STD_PATTERN.matcher(input).matches();
    }

    public static boolean isIPv6HexCompressedAddress(final String input) {
        return IPV6_HEX_COMPRESSED_PATTERN.matcher(input).matches();
    }

    public static boolean isIPv6Address(final String input) {
        return isIPv6StdAddress(input) || isIPv6HexCompressedAddress(input);
    }

    
	public static boolean isViettelIP(String requestIP){
		boolean result = false;
		
		Vector<String> lstIP = (Vector<String>) FileTool.getContentOfFile(fileName);
		if(lstIP!=null && lstIP.size()>0){
			String ip = null;
			for(int i=0; i<lstIP.size(); i++){
				ip = lstIP.get(i);
				if(ip!=null){
					try{
						if(IPv4Tool.isInRange(requestIP, ip)){
							result = true;
							break;
						}
					} catch(Exception ex){}
				}
			}
		}
                
                Vector<String> lstIPv6 = (Vector<String>) FileTool.getContentOfFile(fileNameIpv6);
        if (lstIPv6 != null && lstIPv6.size() > 0) {
            String ip = null;
            for (int i = 0; i < lstIPv6.size(); i++) {
                ip = lstIPv6.get(i);
                if (ip != null) {
                    try {
                        IPv6Network strangeNetwork = IPv6Network.fromString(ip);
                        IPv6AddressRange range = IPv6AddressRange.fromFirstAndLast(IPv6Address.fromString(strangeNetwork.getFirst().toString()),IPv6Address.fromString(strangeNetwork.getLast().toString()));
                        if (isIPv6Address(requestIP)) {
                            if (range.contains(IPv6Address.fromString(requestIP))) {
                                result = true;
                            }
                        }
                    } catch (Exception ex) {
                    }
                }
            }
        }
        
		return result;
	}
	
	public static void main(String[] args){
		
//		for(int i=0;i<=255;i++){
//			boolean isResult = tdt.util.network.IPv4Tool.isInRange("195.189.142." + i, "195.189.142.0/23");
//			System.out.println(i + "--" + isResult);
//		}
		
//		String text = "HBgznDYbfpNKplIeq12n8 ZZRJYqblSMYM9xyfj4CbI=";
//		text = text.replaceAll(" ", "+");
//		
//		System.out.println(AES.decrypt(text, "UXqckUQgy6nOaf7e"));
		
String  forwarded = "for=171.255.68.174";
    if(forwarded!=null && forwarded.trim().length()>3){
        forwarded = forwarded.substring(4);
    }
    System.out.println("forwarded:"+ forwarded);
    
    
		boolean result = isViettelIP("2402:800:411f:e683:9d96:82e7:c552:adc9");
		System.out.println(result);
		//10.163-182.0.0/16
	}
	
}
