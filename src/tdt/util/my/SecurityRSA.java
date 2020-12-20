/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package tdt.util.my;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import static java.nio.charset.StandardCharsets.UTF_8;
import java.security.KeyFactory;
import java.security.KeyPair;
import java.security.KeyPairGenerator;
import java.security.PrivateKey;
import java.security.PublicKey;
import java.security.SecureRandom;
import java.security.Signature;
import java.security.spec.PKCS8EncodedKeySpec;
import java.security.spec.X509EncodedKeySpec;
import javax.crypto.Cipher;
import javax.xml.bind.DatatypeConverter;
import tdt.util.conf.ConfigUtil;
import static tdt.util.my.RSAUtil.getPublicKey;

/**
 *
 * @author Admin
 */
public class SecurityRSA {

    private static String PUBLIC_KEY_FILE = ConfigUtil.class.getResource("publicKey.rsa").getFile();
    private static String PRIVATE_KEY_FILE = ConfigUtil.class.getResource("privateKey.rsa").getFile();
//    private static String PUBLIC_KEY_FILE = "E:\\Data\\2.Working\\8.VAS_RD\\22.Splus\\1.1.wapSplusViettel\\wapSplusVT\\src\\java\\tdt\\util\\common\\publicKey.rsa";
//    private static String PRIVATE_KEY_FILE = "E:\\Data\\2.Working\\8.VAS_RD\\22.Splus\\1.1.wapSplusViettel\\wapSplusVT\\src\\java\\tdt\\util\\common\\privateKey.rsa";

    public static void main1(String[] args) {
        try {
            SecureRandom sr = new SecureRandom();
            // Thuật toán phát sinh khóa - RSA
            // Độ dài khóa 1024(bits), độ dài khóa này quyết định đến độ an toàn của khóa, càng lớn thì càng an toàn
            // Demo chỉ sử dụng 1024 bit. Nhưng theo khuyến cáo thì độ dài khóa nên tối thiểu là 2048
            KeyPairGenerator kpg = KeyPairGenerator.getInstance("RSA");
            kpg.initialize(1024, sr);

            // Khởi tạo cặp khóa
            KeyPair kp = kpg.genKeyPair();
            // PublicKey
            PublicKey publicKey = kp.getPublic();
            // PrivateKey
            PrivateKey privateKey = kp.getPrivate();

            File publicKeyFile = createKeyFile(new File(PUBLIC_KEY_FILE));
            File privateKeyFile = createKeyFile(new File(PRIVATE_KEY_FILE));

            // Lưu Public Key
            FileOutputStream fos = new FileOutputStream(publicKeyFile);
            fos.write(publicKey.getEncoded());
            fos.close();

            // Lưu Private Key
            fos = new FileOutputStream(privateKeyFile);
            fos.write(privateKey.getEncoded());
            fos.close();

            System.out.println("Generate key successfully");
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public static void main(String[] args) {
        try {

            String valueAES = AESEncryption.encrypt("ip=66.249.82.125&time=3243434343", Constant.AESE_KEY);
            String strInputRSA = "value=" + valueAES + "&key=" + AESEncryption.toHex(Constant.AESE_KEY);
            System.out.println("strInputRSA:"+ strInputRSA);
            String outPutRSA = encryptRSA(strInputRSA);
            String outPutSign = sign(outPutRSA);

            String strdata = java.net.URLEncoder.encode(outPutRSA, "UTF-8");
            String strSign = java.net.URLEncoder.encode(outPutSign, "UTF-8");
            System.out.println("outPutRSA1:" + strdata);
            System.out.println("outPutSign1:" + strSign);

            System.out.println("==================giải mã================================");

            String paramData = java.net.URLDecoder.decode(strdata, "UTF-8");
            String paramSig = java.net.URLDecoder.decode(strSign, "UTF-8");
            System.out.println(verifyOSP(paramData, paramSig));

            String dataDecryptRSA = decryptRSA(paramData);
            System.out.println("dataDecryptRSA:"+ dataDecryptRSA);
            String strArr[] = dataDecryptRSA.split("&");
            String valueAES1 = strArr[0].substring(6, strArr[0].length());
            String keyAES = AESEncryption.toString(strArr[1].substring(4, strArr[1].length()));
            System.out.println("valueAES1:"+ valueAES1);
            System.out.println("keyAES:"+ keyAES);
            String dataDecryptAESE = AESEncryption.decrypt(valueAES1, keyAES);
            System.out.println("dataDecryptAESE:"+ dataDecryptAESE);
            
            
            //

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    
    public static void main3(String[] args) {
        try {
            String keyAES = AESEncryption.toString("37333730366337353733323333323330");
            System.out.println(AESEncryption.decrypt("VBuXFq5VMrOFm48sTQwfyUdq5pemSaRVKLEVHuS2QL2KM4MB76l9rVf9tzJBm1Sw", keyAES));
        } catch (Exception e) {
        }
    }
    
    private static File createKeyFile(File file) throws IOException {
        if (!file.exists()) {
            file.createNewFile();
        } else {
            file.delete();
            file.createNewFile();
        }
        return file;
    }

    public static PublicKey getPublicKey() {
        try {
            FileInputStream fis = new FileInputStream(PUBLIC_KEY_FILE);
            byte[] b = new byte[fis.available()];
            fis.read(b);
            fis.close();
            // Tạo public key
            X509EncodedKeySpec spec = new X509EncodedKeySpec(b);
            KeyFactory factory = KeyFactory.getInstance("RSA");
            PublicKey pubKey = factory.generatePublic(spec);
            return pubKey;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public static PrivateKey getPrivateKey() {
        try {
            // Đọc file chứa private key
            FileInputStream fis = new FileInputStream(PRIVATE_KEY_FILE);
            byte[] b = new byte[fis.available()];
            fis.read(b);
            fis.close();

            // Tạo private key
            PKCS8EncodedKeySpec spec = new PKCS8EncodedKeySpec(b);
            KeyFactory factory = KeyFactory.getInstance("RSA");
            PrivateKey priKey = factory.generatePrivate(spec);
            return priKey;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public static String encryptRSA(String data) {
        String result = null;
        try {
            if (data != null && !data.trim().equals("")) {
                Cipher cipher = Cipher.getInstance("RSA/ECB/PKCS1Padding");
                cipher.init(Cipher.ENCRYPT_MODE, getPublicKey());
                result = DatatypeConverter.printBase64Binary(cipher.doFinal(data.getBytes()));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return result;
    }

    public static String decryptRSA(String data) {
        String result = null;
        try {
            if (data != null && !data.trim().equals("")) {
                Cipher cipher = Cipher.getInstance("RSA/ECB/PKCS1Padding");
                cipher.init(Cipher.DECRYPT_MODE, getPrivateKey());
                result = new String(cipher.doFinal(DatatypeConverter.parseBase64Binary(data)));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return result;
    }

    public static String sign(String plainText) {
        try {
            PrivateKey priKey = getPrivateKey();
            Signature privateSignature = Signature.getInstance("SHA1withRSA");
            privateSignature.initSign(priKey);
            privateSignature.update(plainText.getBytes(UTF_8));
            byte[] signature = privateSignature.sign();
            return DatatypeConverter.printBase64Binary(signature);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public static boolean verifyOSP(String plainText, String signature) {
        try {
            PublicKey pubKey = getPublicKey();
            Signature publicSignature = Signature.getInstance("SHA1withRSA");
            publicSignature.initVerify(pubKey);
            publicSignature.update(plainText.getBytes(UTF_8));
            byte[] signatureBytes = DatatypeConverter.parseBase64Binary(signature);
            return publicSignature.verify(signatureBytes);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

//    public static String encrpytionRSA(String content) {
//        try {
//            if (content == null || content.trim().equals("")) {
//                return null;
//            }
//            // Đọc file chứa public key
//            FileInputStream fis = new FileInputStream(PUBLIC_KEY_FILE);
//            byte[] b = new byte[fis.available()];
//            fis.read(b);
//            fis.close();
//
//            // Tạo public key
//            X509EncodedKeySpec spec = new X509EncodedKeySpec(b);
//            KeyFactory factory = KeyFactory.getInstance("RSA");
//            PublicKey pubKey = factory.generatePublic(spec);
//
//            // Mã hoá dữ liệu
//            Cipher c = Cipher.getInstance("RSA");
//            c.init(Cipher.ENCRYPT_MODE, pubKey);
//            byte encryptOut[] = c.doFinal(content.getBytes(UTF_8));
//            return Base64.encodeToString(encryptOut, Base64.DEFAULT);
//
//        } catch (Exception e) {
//            e.printStackTrace();
//        }
//        return null;
//    }
//
//    public static String decrpytionRSA(String content) {
//        try {
//            if (content == null || content.trim().equals("")) {
//                return null;
//            }
//            // Đọc file chứa private key
//            FileInputStream fis = new FileInputStream(PRIVATE_KEY_FILE);
//            byte[] b = new byte[fis.available()];
//            fis.read(b);
//            fis.close();
//
//            // Tạo private key
//            PKCS8EncodedKeySpec spec = new PKCS8EncodedKeySpec(b);
//            KeyFactory factory = KeyFactory.getInstance("RSA");
//            PrivateKey priKey = factory.generatePrivate(spec);
//
//            // Giải mã dữ liệu
//            Cipher c = Cipher.getInstance("RSA");
//            c.init(Cipher.DECRYPT_MODE, priKey);
//            byte decryptOut[] = c.doFinal(Base64.decode(content, Base64.DEFAULT));
//            return new String(decryptOut, UTF_8);
//
//        } catch (Exception e) {
//            e.printStackTrace();
//        }
//        return null;
//    }
//
//    public static String sign(String plainText) {
//        try {
//            // Đọc file chứa private key
//            FileInputStream fis = new FileInputStream(PRIVATE_KEY_FILE);
//            byte[] b = new byte[fis.available()];
//            fis.read(b);
//            fis.close();
//
//            // Tạo private key
//            PKCS8EncodedKeySpec spec = new PKCS8EncodedKeySpec(b);
//            KeyFactory factory = KeyFactory.getInstance("RSA");
//            PrivateKey priKey = factory.generatePrivate(spec);
//
//            Signature privateSignature = Signature.getInstance("SHA256withRSA");
//            privateSignature.initSign(priKey);
//            privateSignature.update(plainText.getBytes(UTF_8));
//            byte[] signature = privateSignature.sign();
//            return Base64.encodeToString(signature, Base64.DEFAULT);
//        } catch (Exception e) {
//            e.printStackTrace();
//        }
//        return null;
//    }
//
//    public static boolean verify(String plainText, String signature) {
//        try {
//
//            // Đọc file chứa public key
//            FileInputStream fis = new FileInputStream(PUBLIC_KEY_FILE);
//            byte[] b = new byte[fis.available()];
//            fis.read(b);
//            fis.close();
//
//            // Tạo public key
//            X509EncodedKeySpec spec = new X509EncodedKeySpec(b);
//            KeyFactory factory = KeyFactory.getInstance("RSA");
//            PublicKey pubKey = factory.generatePublic(spec);
//
//            Signature publicSignature = Signature.getInstance("SHA256withRSA");
//            publicSignature.initVerify(pubKey);
//            publicSignature.update(plainText.getBytes(UTF_8));
//
//            byte[] signatureBytes = Base64.decode(signature, Base64.DEFAULT);
//
//            return publicSignature.verify(signatureBytes);
//        } catch (Exception e) {
//            e.printStackTrace();
//        }
//        return false;
//    }
}
