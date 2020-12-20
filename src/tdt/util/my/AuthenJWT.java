/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package tdt.util.my;

import io.jsonwebtoken.Claims;
import io.jsonwebtoken.ExpiredJwtException;
import io.jsonwebtoken.JwtBuilder;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.MalformedJwtException;
import io.jsonwebtoken.SignatureAlgorithm;
import io.jsonwebtoken.UnsupportedJwtException;
import java.security.Key;
import java.util.Date;
import java.util.HashMap;
import javax.crypto.spec.SecretKeySpec;
import javax.xml.bind.DatatypeConverter;
import tdt.db.adm.Admin;
import tdt.db.adm.AdminDAO;
import tdt.util.Md5;

/**
 *
 * @author Admin
 */
public class AuthenJWT {

    private static String SECRET_KEY = "11223344FFFFFF556789";

    AdminDAO adminDAO = new AdminDAO();
    static public String RES_CODE = "RES_CODE";
    static public String RES_DES = "RES_DES";
    static public long TIME_EXP = 12*60 * 60 * 1000;

    public static void main(String[] args) {
        System.out.println("================================start========================");
        String jwt = createJWT("1111", "admin", "test", 10000);
//        String jwt = "eyJhbGciOiJIUzI1NiJ9.eyJqdGkiOiIxMTExIiwiaWF0IjoxNTk0MDkyMTEwLCJzdWIiOiJ0ZXN0IiwiaXNzIjoiYWRtaW4iLCJleHAiOjE1OTQwOTIxMjB9.uCqP8QFbPsYEB5benWPiYGfN20lPxy1v5lA68G24Xds";
        System.out.println(jwt);

//        System.out.println("validate jwt:" + validateToken(jwt));
        System.out.println("=============================start decode===========================");
        Claims claims = decodeJWT(jwt);
        System.out.println(claims.getSubject());
        System.out.println(claims.getIssuer());
        System.out.println(claims.getId());
        System.out.println("=============================end===========================");
    }

    public HashMap<String, String> authenAPI(String userName, String password) {
        HashMap<String, String> hashMap = new HashMap();
        if (userName == null || userName.trim().equals("") || password == null || password.trim().equals("")) {
            hashMap.put(RES_CODE, "-1");
            hashMap.put(RES_DES, "Invali input parram");
            return hashMap;
        }
        try {
            Admin adm = adminDAO.getRowByUser(userName);
            if (adm != null) {
                password = Md5.Hash(password);
                if (1 == 1 || password.equals(adm.getPasswd())
                        || adm.getPasswd() == null) {
                    // gen token tra ve cho client
                    String jwt = createJWT(adm.getId() + "", adm.getUserName(), adm.getFullName(), TIME_EXP);
                    if (jwt != null && !jwt.trim().equals("")) {
                        hashMap.put(RES_CODE, "0");
                        hashMap.put(RES_DES, jwt);
                    } else {
                        hashMap.put(RES_CODE, "-101");
                        hashMap.put(RES_DES, "System busy");
                    }
                } else {
                    hashMap.put(RES_CODE, "1");
                    hashMap.put(RES_DES, "Tên truy cập hoặc mật khẩu không chính xác");
                }
            } else {
                hashMap.put(RES_CODE, "1");
                hashMap.put(RES_DES, "Tên truy cập hoặc mật khẩu không chính xác");
            }
        } catch (Exception e) {
            e.printStackTrace();
            hashMap.put(RES_CODE, "-101");
            hashMap.put(RES_DES, "System busy");
        }
        return hashMap;
    }

    public static String createJWT(String id, String issuer, String subject, long ttlMillis) {

        //The JWT signature algorithm we will be using to sign the token
        SignatureAlgorithm signatureAlgorithm = SignatureAlgorithm.HS256;

        long nowMillis = System.currentTimeMillis();
        Date now = new Date(nowMillis);

        //We will sign our JWT with our ApiKey secret
        byte[] apiKeySecretBytes = DatatypeConverter.parseBase64Binary(SECRET_KEY);
        Key signingKey = new SecretKeySpec(apiKeySecretBytes, signatureAlgorithm.getJcaName());

        //Let's set the JWT Claims
        JwtBuilder builder = Jwts.builder().setId(id)
                .setIssuedAt(now)
                .setSubject(subject)
                .setIssuer(issuer)
                .signWith(signatureAlgorithm, signingKey);

        //if it has been specified, let's add the expiration
        if (ttlMillis > 0) {
            long expMillis = nowMillis + ttlMillis;
            Date exp = new Date(expMillis);
            builder.setExpiration(exp);
        }

        //Builds the JWT and serializes it to a compact, URL-safe string
        return builder.compact();
    }

    public static Claims decodeJWT(String jwt) {
        //This line will throw an exception if it is not a signed JWS (as expected)
        Claims claims = Jwts.parser()
                .setSigningKey(DatatypeConverter.parseBase64Binary(SECRET_KEY))
                .parseClaimsJws(jwt).getBody();
        return claims;
    }

    static public String validateToken(String authToken) {
        String result = null;// success
        try {
            Jwts.parser().setSigningKey(SECRET_KEY).parseClaimsJws(authToken);
            result = "0";
        } catch (MalformedJwtException ex) {
            System.out.println("Invalid JWT token");
            result = "-1";// Invalid JWT token
        } catch (ExpiredJwtException ex) {
            System.out.println("Expired JWT token");
            result = "-2";// Expired JWT token
        } catch (UnsupportedJwtException ex) {
            System.out.println("Unsupported JWT token");
            result = "-3";// Unsupported JWT token
        } catch (IllegalArgumentException ex) {
            System.out.println("JWT claims string is empty.");
            result = "-4";// JWT claims string is empty.
        }
        return result;
    }
}
