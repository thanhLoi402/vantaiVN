package tdt.util.my;

import java.io.*;
import java.math.BigInteger;
import java.net.URLEncoder;
import java.security.*;
import javax.crypto.*;
import javax.crypto.spec.*;
import org.apache.commons.codec.binary.Hex;

public class AESEncryption {

    //http://docs.oracle.com/javase/7/docs/api/javax/crypto/Cipher.html
    //  "algorithm/mode/padding" or  "algorithm"
    //PHP & Test: http://www.coderelic.com/examples/AES_Encryption_Example.php 
    private static final String characterEncoding = "UTF-8";
//    private static final String cipherTransformation = "AES/CBC/PKCS5Padding";
    private static final String cipherTransformation = "AES";
    private static final String aesEncryptionAlgorithm = "AES";
    public static String KEY_AES = "VAS.RD.REPORT123";

    public static byte[] decrypt(byte[] cipherText, byte[] key, byte[] initialVector) throws NoSuchAlgorithmException, NoSuchPaddingException, InvalidKeyException, InvalidAlgorithmParameterException, IllegalBlockSizeException, BadPaddingException {
        Cipher cipher = Cipher.getInstance(cipherTransformation);
        SecretKeySpec secretKeySpecy = new SecretKeySpec(key, aesEncryptionAlgorithm);
        IvParameterSpec ivParameterSpec = new IvParameterSpec(initialVector);
        cipher.init(Cipher.DECRYPT_MODE, secretKeySpecy, ivParameterSpec);
        cipherText = cipher.doFinal(cipherText);
        return cipherText;
    }

    public static byte[] encrypt(byte[] plainText, byte[] key, byte[] initialVector) throws NoSuchAlgorithmException, NoSuchPaddingException, InvalidKeyException, InvalidAlgorithmParameterException, IllegalBlockSizeException, BadPaddingException {
        Cipher cipher = Cipher.getInstance(cipherTransformation);
        SecretKeySpec secretKeySpec = new SecretKeySpec(key, aesEncryptionAlgorithm);
        IvParameterSpec ivParameterSpec = new IvParameterSpec(initialVector);
        cipher.init(Cipher.ENCRYPT_MODE, secretKeySpec, ivParameterSpec);
        plainText = cipher.doFinal(plainText);
        return plainText;
    }

    public static String encrypt(String Data, String password) throws Exception {
        SecretKeySpec key = new SecretKeySpec(password.getBytes(characterEncoding), aesEncryptionAlgorithm);
        Cipher c = Cipher.getInstance("AES");
        c.init(Cipher.ENCRYPT_MODE, key);
        byte[] encVal = c.doFinal(Data.getBytes("UTF-8"));
        String encryptedValue = Base64.encodeToString(encVal, Base64.DEFAULT);

        return encryptedValue;
    }

    public static String decrypt(String encryptedText, String password) {
        try {
            SecretKeySpec key = new SecretKeySpec(password.getBytes(characterEncoding), aesEncryptionAlgorithm);
            Cipher cipher = Cipher.getInstance("AES/CBC/PKCS5Padding");
            cipher.init(Cipher.DECRYPT_MODE, key);
            return new String(cipher.doFinal(Base64.decode(encryptedText, Base64.DEFAULT)));
        } catch (Exception e) {
            e.printStackTrace();
            System.out.println("Error while decrypting: " + e.toString());
        }
        return null;
    }
    
    public static String decrypt(String encryptedText, byte[] password) {
        try {
            SecretKeySpec key = new SecretKeySpec(password, aesEncryptionAlgorithm);
            Cipher cipher = Cipher.getInstance("AES");
            cipher.init(Cipher.DECRYPT_MODE, key);
            return new String(cipher.doFinal(Base64.decode(encryptedText, Base64.DEFAULT)));
        } catch (Exception e) {
            e.printStackTrace();
            System.out.println("Error while decrypting: " + e.toString());
        }
        return null;
    }

    private static byte[] getKeyBytes(String key) throws UnsupportedEncodingException {
        byte[] keyBytes = new byte[16];
        byte[] parameterKeyBytes = key.getBytes(characterEncoding);
        System.arraycopy(parameterKeyBytes, 0, keyBytes, 0, Math.min(parameterKeyBytes.length, keyBytes.length));
        return keyBytes;
    }

    /// <summary>
    /// Encrypts plaintext using AES 128bit key and a Chain Block Cipher and returns a base64 encoded string
    /// </summary>
    /// <param name="plainText">Plain text to encrypt</param>
    /// <param name="key">Secret key</param>
    /// <returns>Base64 encoded string</returns>
    public static String encrypt1(String plainText, String key) {
        String sEncrypted = null;
        try {
            byte[] plainTextbytes = plainText.getBytes(characterEncoding);
            byte[] keyBytes = getKeyBytes(key);
            byte[] iniVector = keyBytes;
            sEncrypted = Base64.encodeToString(encrypt(plainTextbytes, keyBytes, iniVector), Base64.DEFAULT);
        } catch (Exception e) {
            e.printStackTrace();
            // TODO: handle exception
        }
        return sEncrypted;
    }

    public static String encryptURL(String plainText, String key) {
        String sEncrypted = null;
        try {
            byte[] plainTextbytes = plainText.getBytes(characterEncoding);
            byte[] keyBytes = getKeyBytes(key);
            byte[] iniVector = keyBytes;
            sEncrypted = Base64.encodeToString(encrypt(plainTextbytes, keyBytes, iniVector), Base64.DEFAULT);
            sEncrypted = URLEncoder.encode(sEncrypted, "utf-8");
        } catch (Exception e) {
            // TODO: handle exception
        }
        return sEncrypted;
    }

    /// <summary>
    /// Decrypts a base64 encoded string using the given key (AES 128bit key and a Chain Block Cipher)
    /// </summary>
    /// <param name="encryptedText">Base64 Encoded String</param>
    /// <param name="key">Secret Key</param>
    /// <returns>Decrypted String</returns>
    public static String decrypt1(String encryptedText, String key) {
        String sDecrypted = null;
        try {
            byte[] cipheredBytes = Base64.decode(encryptedText, Base64.DEFAULT);
            byte[] keyBytes = getKeyBytes(key);
            byte[] iniVector = keyBytes;
            sDecrypted = new String(decrypt(cipheredBytes, keyBytes, iniVector), characterEncoding);
        } catch (Exception e) {
            // TODO: handle exception
        }
        return sDecrypted;
    }

    public static String toHex(String arg) {
        return String.format("%x", new BigInteger(1, arg.getBytes(/*YOUR_CHARSET?*/)));
    }

    public static String toString(String strHex) {
        try {
            byte[] bytes = Hex.decodeHex(strHex.toCharArray());
            return new String(bytes, "UTF-8");
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
    public static byte[] toByteArray(String strHex) {
        try {
            byte[] bytes = Hex.decodeHex(strHex.toCharArray());
            return bytes;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public static void main(String args[]) {
        try {

            String key = "Ngày hôm nay tôi đói";
            //String url = "http://forum.sms.vn";
            System.out.println(toHex(key));
//            System.out.println(AESEncryption.decrypt("wva2dygB0g9zYBDHTsWVD5JFt1uPTBvAx%2FqNq%2F2AFnTztrv%2BPfa8X4frGYkT13RD%0A", "HYAPMSLG2MEB1KCK"));

            System.out.println(toString(toHex(key)));
        } catch (Exception ex) {
            ex.printStackTrace();
        }
    }
}
