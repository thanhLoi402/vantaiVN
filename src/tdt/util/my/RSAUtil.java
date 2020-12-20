/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package tdt.util.my;

import java.io.BufferedReader;
import java.io.FileInputStream;
import java.io.FileReader;
import java.io.IOException;
import java.math.BigInteger;
import static java.nio.charset.StandardCharsets.UTF_8;
import javax.crypto.BadPaddingException;
import javax.crypto.Cipher;
import javax.crypto.IllegalBlockSizeException;
import javax.crypto.NoSuchPaddingException;
import java.security.*;
import java.security.spec.InvalidKeySpecException;
import java.security.spec.PKCS8EncodedKeySpec;
import java.security.spec.X509EncodedKeySpec;
import java.util.Properties;
import javax.xml.bind.DatatypeConverter;
import tdt.util.conf.ConfigUtil;

public class RSAUtil {

    private static String CP_PUBLIC_KEY_FILE;
    private static String CP_PRIVATE_KEY_FILE;
    private static String VT_PUBLIC_KEY_FILE;
    private String fileRSAConfig = ConfigUtil.class.getResource("keyRSA.conf").getFile();

    public RSAUtil() {
        try {
            loadProperties();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private void loadProperties() throws IOException {
        Properties properties = new Properties();
        BufferedReader input = null;
        try {
            input = new BufferedReader(new FileReader(fileRSAConfig));
            properties.load(input);
            try {
                try {
                    CP_PUBLIC_KEY_FILE = properties.getProperty("CP_PUBLIC_KEY_FILE");
                } catch (Exception e) {
                    e.printStackTrace();
                }
                try {
                    CP_PRIVATE_KEY_FILE = properties.getProperty("CP_PRIVATE_KEY_FILE");
                } catch (Exception e) {
                    e.printStackTrace();
                }
                try {
                    VT_PUBLIC_KEY_FILE = properties.getProperty("VT_PUBLIC_KEY_FILE");
                } catch (Exception e) {
                    e.printStackTrace();
                }
            } catch (Exception ex) {
                ex.printStackTrace();
            }
        } catch (Exception ex) {
            ex.printStackTrace();
            if (input != null) {
                try {
                    input.close();
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
        } finally {
            if (input != null) {
                try {
                    input.close();
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
        }
    }

    public static PublicKey getPublicKey(String base64PublicKey) {
        PublicKey publicKey = null;
        try {
            X509EncodedKeySpec keySpec = new X509EncodedKeySpec(DatatypeConverter.parseBase64Binary(base64PublicKey));
            KeyFactory keyFactory = KeyFactory.getInstance("RSA");
            publicKey = keyFactory.generatePublic(keySpec);
            return publicKey;
        } catch (NoSuchAlgorithmException e) {
            e.printStackTrace();
        } catch (InvalidKeySpecException e) {
            e.printStackTrace();
        }
        return publicKey;
    }
    
    public static PrivateKey getPrivateKey(String base64PrivateKey) {
        PrivateKey privateKey = null;
        PKCS8EncodedKeySpec keySpec = new PKCS8EncodedKeySpec(DatatypeConverter.parseBase64Binary(base64PrivateKey));
        KeyFactory keyFactory = null;
        try {
            keyFactory = KeyFactory.getInstance("RSA");
        } catch (NoSuchAlgorithmException e) {
            e.printStackTrace();
        }
        try {
            privateKey = keyFactory.generatePrivate(keySpec);
        } catch (InvalidKeySpecException e) {
            e.printStackTrace();
        }
        return privateKey;
    }

    private static byte[] encrypt(String data, String publicKey) throws BadPaddingException, IllegalBlockSizeException, InvalidKeyException, NoSuchPaddingException, NoSuchAlgorithmException {
        Cipher cipher = Cipher.getInstance("RSA/ECB/PKCS1Padding");
        cipher.init(Cipher.ENCRYPT_MODE, getPublicKey(publicKey));
        return cipher.doFinal(data.getBytes());
    }

    private static String decrypt(byte[] data, PrivateKey privateKey) throws NoSuchPaddingException, NoSuchAlgorithmException, InvalidKeyException, BadPaddingException, IllegalBlockSizeException {
        Cipher cipher = Cipher.getInstance("RSA/ECB/PKCS1Padding");
        cipher.init(Cipher.DECRYPT_MODE, privateKey);
        return new String(cipher.doFinal(data));
    }

    private static String decrypt(String data, String base64PrivateKey) throws IllegalBlockSizeException, InvalidKeyException, BadPaddingException, NoSuchAlgorithmException, NoSuchPaddingException {
        return decrypt(DatatypeConverter.parseBase64Binary(data), getPrivateKey(base64PrivateKey));
    }

    public String encryptCPRSA(String data) {
        String result = null;
        try {
            if (data != null && !data.trim().equals("")) {
                result = DatatypeConverter.printBase64Binary(encrypt(data, CP_PUBLIC_KEY_FILE));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return result;
    }
    
    // Thực hiện mã hóa DL bằng public key VT để gửi DL xác thực sang VT
    public String encryptVTRSA(String data) {
        String result = null;
        try {
            if (data != null && !data.trim().equals("")) {
                result = DatatypeConverter.printBase64Binary(encrypt(data, VT_PUBLIC_KEY_FILE));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return result;
    }
    
    // Sử dụng private key CP để giải mã DL VT trả về
    public String decryptOSPRSA(String data) {
        String result = null;
        try {
            if (data != null && !data.trim().equals("")) {
                result = decrypt(DatatypeConverter.parseBase64Binary(data), getPrivateKey(CP_PRIVATE_KEY_FILE));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return result;
    }
    
    
    public String decrypt111111(String data) {
        String result = null;
        try {
            if (data != null && !data.trim().equals("")) {
                result = decrypt(DatatypeConverter.parseBase64Binary(data), getPrivateKey(CP_PRIVATE_KEY_FILE));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return result;
    }
    
    // Sử dụng private key CP để tạo chữ ký gửi đi xác thực bên VT
    /**
     * 
     * @param plainText DL cần mã hóa
     * @return 
     */
    public String sign(String plainText) {
        try {
            PrivateKey priKey = getPrivateKey(CP_PRIVATE_KEY_FILE);
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
    
    public boolean verifyOSP(String plainText, String signature) {
        try {
            PublicKey pubKey = getPublicKey(CP_PUBLIC_KEY_FILE);
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
    
    // Sử dụng public key VT để Thực hiện check chữ ký của VT trên response trả về
    /**
     * 
     * @param plainText text verify
     * @param signature Chữ ký
     * @return 
     */
    public boolean verify(String plainText, String signature) {
        try {
            PublicKey pubKey = getPublicKey(VT_PUBLIC_KEY_FILE);
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
    
    

    public static void main(String[] args) throws IllegalBlockSizeException, InvalidKeyException, NoSuchPaddingException, BadPaddingException {
        try {
            String encryptedString = DatatypeConverter.printBase64Binary(encrypt("test ma hoa", CP_PUBLIC_KEY_FILE));
            System.out.println(encryptedString);
            String decryptedString = RSAUtil.decrypt(encryptedString, CP_PRIVATE_KEY_FILE);
            System.out.println(decryptedString);
        } catch (NoSuchAlgorithmException e) {
            System.err.println(e.getMessage());
        }

    }
    
    
    public static String encryptThisString(String input) 
    { 
        try { 
            // getInstance() method is called with algorithm SHA-1 
            MessageDigest md = MessageDigest.getInstance("SHA-1"); 
            // digest() method is called 
            // to calculate message digest of the input string 
            // returned as array of byte 
            byte[] messageDigest = md.digest(input.getBytes()); 
            // Convert byte array into signum representation 
            BigInteger no = new BigInteger(1, messageDigest); 
            // Convert message digest into hex value 
            String hashtext = no.toString(16); 
            // Add preceding 0s to make it 32 bit 
            while (hashtext.length() < 32) { 
                hashtext = "0" + hashtext; 
            } 
            // return the HashText 
            return hashtext; 
        } 
  
        // For specifying wrong message digest algorithms 
        catch (NoSuchAlgorithmException e) { 
            throw new RuntimeException(e); 
        } 
    } 
    
}
