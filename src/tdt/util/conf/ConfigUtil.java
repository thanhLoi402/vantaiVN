package tdt.util.conf;

import java.util.Date;
import tdt.util.my.AESEncryption;
import tdt.util.my.Constant;
import tdt.util.my.RSAUtil;

public class ConfigUtil {

    public static void main(String[] args) {
try {
    System.out.println(new Date().getTime());
            String data = "isdn=0977974545&subid=2VhVOtzOXubd1/T2MY1+EJIFy/hVfl1CGgblsnPyBIQ=";
            RSAUtil sAUtil  = new RSAUtil();
            String valueAES = AESEncryption.encrypt(data, Constant.AESE_KEY);
    String strInputRSA = "value="+valueAES+"&key="+ Constant.AESE_KEY;
    String outPutRSA = sAUtil.encryptCPRSA(strInputRSA);
    String outPutSign = sAUtil.sign(outPutRSA);
    
    
            encriptRSA(data);
            
            decriptVTRSA(outPutRSA, outPutSign);
        } catch (Exception e) {
        }
    }

    private static void encriptRSA(String data) {
        try {
            RSAUtil sAUtil  = new RSAUtil();
//       System.out.println(Encrypter.encrypt("rp789065"));

            String valueAES = AESEncryption.encrypt(data, Constant.AESE_KEY);
            String strInputRSA = "value=" + valueAES + "&key=" + Constant.AESE_KEY;
            String outPutRSA = sAUtil.encryptVTRSA(strInputRSA);
            String outPutSign = sAUtil.sign(outPutRSA);
            System.out.println("outPutRSA1:" + outPutRSA);
            System.out.println("outPutSign1:" + outPutSign);
            outPutRSA = java.net.URLEncoder.encode(outPutRSA, "UTF-8");
            outPutSign = java.net.URLEncoder.encode(outPutSign, "UTF-8");
            System.out.println("outPutRSA:" + outPutRSA);
            System.out.println("outPutSign:" + outPutSign);
            String paramUrl = "src=WEB&ser=SPLUS&transid=osp-20191102091911&data=" + outPutRSA + "&sig=" + outPutSign;
            System.out.println(paramUrl);
        } catch (Exception ex) {
            ex.printStackTrace();
        }
    }

    
    
    private static void decriptVTRSA(String conntent, String sig){
        try {
            RSAUtil rSAUtil = new RSAUtil();
            if (rSAUtil.verifyOSP(conntent, sig)) {
                String dataDecryptRSA = rSAUtil.decrypt111111(conntent);
                String strArr[] = dataDecryptRSA.split("&");
                String valueAES = strArr[0].substring(6, strArr[0].length());
                String keyAES = strArr[1].substring(4, strArr[1].length());
                String dataDecryptAESE = AESEncryption.decrypt(valueAES, keyAES);
                String strArrAESE[] = dataDecryptAESE.split("&");
                String isdn = strArrAESE[0].substring(4, strArrAESE[0].length());
                String msisdnId = strArrAESE[1].substring(5, strArrAESE[1].length());
                if (msisdnId != null) {
                    System.out.println("isdn:" + isdn);
                    System.out.println("msisdnId:" + msisdnId);
                }
            } else {
                System.out.println("null");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    
    
}
