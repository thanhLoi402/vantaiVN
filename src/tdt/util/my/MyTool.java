package tdt.util.my;

import java.io.ByteArrayOutputStream;
import java.io.InputStream;
import java.net.URL;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.text.Normalizer;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Arrays;
import java.util.Collection;
import java.util.Collections;
import java.util.Comparator;
import java.util.Date;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import java.util.regex.Pattern;

import tdt.db.pool.DBPoolX;
import tdt.util.DateProc;
import tdt.util.StringTool;

public class MyTool {

    public static String getThu(int d, int m, int y) {
        int X = MOD((int) (UniversalToJD(d, m, y) + 2.5), 7);
        String thu = "";
        if (X == 1) {
            thu = "CN";
        }
        if (X == 2) {
            thu = "2";
        }
        if (X == 3) {
            thu = "3";
        }
        if (X == 4) {
            thu = "4";
        }
        if (X == 5) {
            thu = "5";
        }
        if (X == 6) {
            thu = "6";
        }
        if (X == 7) {
            thu = "7";
        }
        return thu;
    }

    public static String getThuFull(int d, int m, int y) {
        int X = MOD((int) (UniversalToJD(d, m, y) + 2.5), 7);
        String thu = "";
        if (X == 1) {
            thu = "Chủ Nhật";
        }
        if (X == 2) {
            thu = "Thứ 2";
        }
        if (X == 3) {
            thu = "Thứ 3";
        }
        if (X == 4) {
            thu = "Thứ 4";
        }
        if (X == 5) {
            thu = "Thứ 5";
        }
        if (X == 6) {
            thu = "Thứ 6";
        }
        if (X == 7) {
            thu = "Thứ 7";
        }
        return thu;
    }

    public static int MOD(int x, int y) {
        int z = x - (int) (y * Math.floor(((double) x / y)));
        if (z == 0) {
            z = y;
        }
        return z;
    }

    public static double UniversalToJD(int D, int M, int Y) {
        double JD;
        if (Y > 1582 || (Y == 1582 && M > 10) || (Y == 1582 && M == 10 && D > 14)) {
            JD = 367 * Y - INT(7 * (Y + INT((M + 9) / 12)) / 4) - INT(3 * (INT((Y + (M - 9) / 7) / 100) + 1) / 4) + INT(275 * M / 9) + D + 1721028.5;
        } else {
            JD = 367 * Y - INT(7 * (Y + 5001 + INT((M - 9) / 7)) / 4) + INT(275 * M / 9) + D + 1729776.5;
        }
        return JD;
    }

    public static int INT(double d) {
        return (int) Math.floor(d);
    }

    public static String convertTitle(String title) {
        for (int i = 0; i < title.length(); i++) {
            for (int index = 0; index < oldChar.length; index++) {
                if (oldChar[index] == title.charAt(i)) {
                    title = title.replace(title.charAt(i), newChar[index]);
                }
            }
        }
        //title = UTF8Tool.coDau2KoDau(title).toLowerCase();
        title = title.replaceAll(" ", "-").replaceAll("grave", "").replaceAll("circ", "").replaceAll("acute", "").replaceAll("tilde", "");
        title = title.replaceAll("[^a-zA-Z0-9-]+", "").replaceAll("-------", "-").replaceAll("------", "-").replaceAll("-----", "-").replaceAll("----", "-").replaceAll("---", "-").replaceAll("--", "-");
        return title;
    }

    public static char[] oldChar = {'Á', 'À', 'Ã', 'Ả', 'Ạ', 'Ấ', 'Ầ', 'Ẫ', 'Ẩ', 'Ậ', 'Â', 'Ắ', 'Ằ', 'Ẵ', 'Ẳ', 'Ặ', 'Ă', 'á', 'à', 'ã', 'ả', 'ạ', 'ấ', 'ầ', 'ẫ', 'ẩ', 'ậ', 'â', 'ắ', 'ằ', 'ẵ', 'ẳ', 'ặ', 'ă', 'É', 'È', 'Ẽ', 'Ẻ', 'Ẹ', 'Ế', 'Ề', 'Ễ', 'Ể', 'Ệ', 'Ê', 'é', 'è', 'ẽ', 'ẻ', 'ẹ', 'ế', 'ề', 'ễ', 'ể', 'ệ', 'ê', 'Ó', 'Ò', 'Õ', 'Ỏ', 'Ọ', 'Ố', 'Ồ', 'Ỗ', 'Ổ', 'Ộ', 'Ô', 'Ớ', 'Ờ', 'Ỡ', 'Ở', 'Ợ', 'Ơ', 'ó', 'ò', 'õ', 'ỏ', 'ọ', 'ố', 'ồ', 'ỗ', 'ổ', 'ộ', 'ô', 'ớ', 'ờ', 'ỡ', 'ở', 'ợ', 'ơ', 'Ú', 'Ù',
        'Ũ', 'Ủ', 'Ụ', 'ú', 'ù', 'ũ', 'ủ', 'ụ', 'Ứ', 'Ừ', 'Ữ', 'Ử', 'Ự', 'Ư', 'ứ', 'ừ', 'ữ', 'ử', 'ự', 'ư', 'Í', 'Ì', 'Ĩ', 'Ỉ', 'Ị', 'í', 'ì', 'ĩ', 'ỉ', 'ị', 'Ý', 'Ỳ', 'Ỹ', 'Ỷ', 'Ỵ', 'ý', 'ỳ', 'ỹ', 'ỷ', 'ỵ', 'Đ', 'đ'};
    public static char[] newChar = {'A', 'A', 'A', 'A', 'A', 'A', 'A', 'A', 'A', 'A', 'A', 'A', 'A', 'A', 'A', 'A', 'A', 'a', 'a', 'a', 'a', 'a', 'a', 'a', 'a', 'a', 'a', 'a', 'a', 'a', 'a', 'a', 'a', 'a', 'E', 'E', 'E', 'E', 'E', 'E', 'E', 'E', 'E', 'E', 'E', 'e', 'e', 'e', 'e', 'e', 'e', 'e', 'e', 'e', 'e', 'e', 'O', 'O', 'O', 'O', 'O', 'O', 'O', 'O', 'O', 'O', 'O', 'O', 'O', 'O', 'O', 'O', 'O', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'U', 'U',
        'U', 'U', 'U', 'u', 'u', 'u', 'u', 'u', 'U', 'U', 'U', 'U', 'U', 'U', 'u', 'u', 'u', 'u', 'u', 'u', 'I', 'I', 'I', 'I', 'I', 'i', 'i', 'i', 'i', 'i', 'Y', 'Y', 'Y', 'Y', 'Y', 'y', 'y', 'y', 'y', 'y', 'D', 'd'};

    public static char removeAccent(char ch) {
        int index = Arrays.binarySearch(oldChar, ch);
        if (index >= 0) {
            ch = newChar[index];
        }
        return ch;
    }

    public static String removeAccent(String s) {
        StringBuilder sb = new StringBuilder(s);
        for (int i = 0; i < sb.length(); i++) {
            sb.setCharAt(i, removeAccent(sb.charAt(i)));
        }
        return sb.toString();
    }

    public static boolean checkArr(String list, String str) {
        boolean result = false;
        String[] arr = null;
        if (list != null) {
            arr = list.split(",");
        }
        if (arr != null && arr.length > 0) {
            for (int i = 0; i < arr.length; i++) {
                if (arr[i].equalsIgnoreCase(str)) {
                    result = true;
                    break;
                }
            }
        }
        return result;
    }

    public static boolean isValidDate(String inDate, String patter) {

        if (inDate == null) {
            return false;
        }

        // set the format to use as a constructor argument
        SimpleDateFormat dateFormat = new SimpleDateFormat(patter);

        if (inDate.trim().length() != dateFormat.toPattern().length()) {
            return false;
        }

        dateFormat.setLenient(false);

        try {
            // parse the inDate parameter
            dateFormat.parse(inDate.trim());
        } catch (ParseException pe) {
            return false;
        }
        return true;
    }

    public static Collection<String> sortingBoChuSo(Collection<String> cChuso) {
        if (cChuso == null || cChuso.isEmpty()) {
            return cChuso;
        }
        Comparator<String> comparator = new Comparator<String>() {
            public int compare(String c1, String c2) {
                return Integer.parseInt(c1) - Integer.parseInt(c2);
            }
        };
        Collections.sort((List<String>) cChuso, comparator);
        return cChuso;
    }

    public static byte[] downloadUrl(String url) {
        ByteArrayOutputStream outputStream = null;
        try {
            URL toDownload = new URL(url);
            outputStream = new ByteArrayOutputStream();
            byte[] chunk = new byte[4096];
            int bytesRead;
            InputStream stream = toDownload.openStream();

            while ((bytesRead = stream.read(chunk)) > 0) {
                outputStream.write(chunk, 0, bytesRead);
            }
        } catch (Exception ex) {
            System.out.println("error when download Imgage:" + url);
        }
        return outputStream.toByteArray();
    }

    public static boolean compareDateWithNow(String date) {
        boolean result = false;

        Timestamp tsNow = DateProc.createTimestamp();

        String[] arrDate = date.split("/");

        int day = Integer.parseInt(arrDate[0]);
        int month = Integer.parseInt(arrDate[1]);
        int year = Integer.parseInt(arrDate[2]);

        Timestamp ts = DateProc.buildTimestamp(year, month, day);

        result = tsNow.before(ts);

        return result;
    }

    public static int maxDayOfMonth(int month, int year) {
        int maxDay = 0;
        if (month == 1 || month == 3 || month == 5 || month == 7 || month == 8 || month == 10 || month == 12) {
            maxDay = 31;
        } else if (month == 4 || month == 6 || month == 9 || month == 11) {
            maxDay = 30;
        } else if (year % 400 == 0 || year % 4 == 0 && year % 100 != 0) {
            maxDay = 29;
        } else {
            maxDay = 28;
        }
        return maxDay;
    }

    public static String convertStringToDate(String str) {
        if (str == null || str.length() != 14) {
            return "";
        }
        String result = "";

        result = str.substring(6, 8) + "/" + str.substring(4, 6) + "/" + str.substring(0, 4) + " " + str.substring(8, 10) + ":" + str.substring(10, 12) + ":" + str.substring(12, 14);

        return result;
    }

    public static void main(String[] args) {
        System.out.println(removeAccent("Ưng"));
    }

    public static String unAccent(String s) {
        String temp = Normalizer.normalize(s, Normalizer.Form.NFD);
        Pattern pattern = Pattern.compile("\\p{InCombiningDiacriticalMarks}+");
        return pattern.matcher(temp).replaceAll("").replaceAll("Đ", "D").replaceAll("đ", "d");
    }

    public static String[] parseWapReqLink(String link) {
        System.out.println(link);
        String cpId = "";
        String linkType = "";
        String pckType = "";
        String pck = "";
        String subPck = "";

        try {
            if (link != null && link.trim().length() > 0) {
                link = link.toUpperCase().trim();
                if (link.startsWith("/")) {
                    link = link.substring(1);
                }
                link = link.replaceAll(".HTML", "");

                int index = link.indexOf("/");
                if (index != -1) {
                    cpId = link.substring(0, index);
                    link = link.substring(index + 1);
                    //da tach CP ra khoi link

                    if (link.startsWith("DANG-KY-GOI-")) {
                        //link popup
                        linkType = "1";
                        link = link.substring(12);
                        String[] arrLink = link.split("-");
                        if (arrLink != null && arrLink.length > 0) {
                            if (arrLink.length == 1) {
                                //link co dang: DANG-KY-GOI-MIZUVIP
                                if (link.equals("MIZU1") || link.equals("MIZU2") || link.equals("MIZUVIP")) {
                                    pck = link;
                                } else {
                                    pck = "MIZUVIP";
                                }
                                pckType = "DAY";
                            } else {
                                String tmp1 = arrLink[arrLink.length - 1];
                                String tmp2 = arrLink[arrLink.length - 2];

                                if (StringTool.isNumberic(tmp1)) {
                                    //sublink
                                    subPck = tmp1;
                                    pck = tmp2;
                                } else {
                                    pck = tmp1;
                                }
//								if (pck.equals(MizuParam.MIZU1_DAILY_CODE)) {
//									pck = "MIZU1";
//									pckType = "DAY";
//								} else if (pck.equals(MizuParam.MIZU2_DAILY_CODE)) {
//									pck = "MIZU2";
//									pckType = "DAY";
//								} else if (pck.equals(MizuParam.MIZU3_DAILY_CODE)) {
//									pck = "MIZUVIP";
//									pckType = "DAY";
//								} else if (pck.equals(MizuParam.MIZU1_WEEKLY_CODE)) {
//									pck = "MIZU1";
//									pckType = "WEEK";
//								} else if (pck.equals(MizuParam.MIZU2_WEEKLY_CODE)) {
//									pck = "MIZU2";
//									pckType = "WEEK";
//								} else if (pck.equals(MizuParam.MIZU3_WEEKLY_CODE)) {
//									pck = "MIZUVIP";
//									pckType = "WEEK";
//								} else if (pck.equals("MIZUVIP")) {
//									pck = "MIZUVIP";
//									pckType = "DAY";
//								} else if (pck.equals("MIZU1")) {
//									pck = "MIZU1";
//									pckType = "DAY";
//								} else if (pck.equals("MIZU2")) {
//									pck = "MIZU2";
//									pckType = "DAY";
//								} else {
//									pck = "MIZUVIP";
//									pckType = "DAY";
//								}
                            }
                        }
                    } else {
                        //link auto
                        linkType = "0";
                        if (link.startsWith("GOI-TUAN-")) {
                            //link dk goi tuan
                            pckType = "WEEK";
                            link = link.substring(9);
                        } else {
                            //link dk goi ngay
                            pckType = "DAY";
                        }

                        if (link.equals("MIZU1") || link.equals("MIZU2") || link.equals("MIZUVIP")) {
                            pck = link;
                        } else {
                            pck = "MIZUVIP";
                        }
                    }
                }
            }
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }

        return new String[]{cpId, linkType, pckType, pck, subPck};
    }

    //lay phan tu co trong A nhung ko co trong B
    public static String[] getElementNotInAray(String[] arrA, String[] arrB) {
        String[] arrResult = null;
        String result = "";
        boolean isFound = false;
        if (arrA != null && arrB != null) {
            for (int i = 0; i < arrA.length; i++) {
                for (int j = 0; j < arrB.length; j++) {
                    isFound = false;
                    if (arrA[i].equals(arrB[j])) {
                        isFound = true;
                        break;
                    }
                }
                if (!isFound) {
                    result += arrA[i] + ",";
                }
            }
            if (result.endsWith(",")) {
                result = result.substring(0, result.length() - 1);
            }
            if (result.trim().length() > 0) {
                arrResult = result.split(",");
            }
        }
        return arrResult;
    }

    public static Long getSequent(Connection conn, String sequents) {
        if (sequents == null || sequents.trim().equals("")) {
            return null;
        } else {
            try {
                String strSQL = " select " + sequents + ".nextval from dual";
                PreparedStatement preStmt = conn.prepareStatement(strSQL);
                ResultSet rs = preStmt.executeQuery();
                if (rs.next()) {
                    return rs.getLong(1);
                }
            } catch (SQLException ex) {
                Logger.getLogger(MyTool.class.getName()).log(Level.SEVERE, null, ex);
                return null;
            }
        }
        return null;
    }

    public int countAll(DBPoolX poolX, tdt.util.Logger logger, String tableName) {
        int result = 0;
        Connection conn = null;
        PreparedStatement preStmt = null;
        String strSQL = "";
        ResultSet rs = null;
        try {
            conn = poolX.getConnection();
            strSQL = "select COUNT(*) from  " + tableName;
            preStmt = conn.prepareStatement(strSQL);
            rs = preStmt.executeQuery();
            if (rs.next()) {
                result = rs.getInt(1);
            }
        } catch (Exception e) {
            logger.error(this.getClass().getName() + ".countAll err: " + e.getMessage());
        } finally {
            poolX.releaseConnection(conn, preStmt, rs);
        }
        return result;
    }

    private static char[] SOURCE_CHARACTERS = {'À', 'Á', 'Â', 'Ã', 'È', 'É',
        'Ê', 'Ì', 'Í', 'Ò', 'Ó', 'Ô', 'Õ', 'Ù', 'Ú', 'Ý', 'à', 'á', 'â',
        'ã', 'è', 'é', 'ê', 'ì', 'í', 'ò', 'ó', 'ô', 'õ', 'ù', 'ú', 'ý',
        'Ă', 'ă', 'Đ', 'đ', 'Ĩ', 'ĩ', 'Ũ', 'ũ', 'Ơ', 'ơ', 'Ư', 'ư', 'Ạ',
        'ạ', 'Ả', 'ả', 'Ấ', 'ấ', 'Ầ', 'ầ', 'Ẩ', 'ẩ', 'Ẫ', 'ẫ', 'Ậ', 'ậ',
        'Ắ', 'ắ', 'Ằ', 'ằ', 'Ẳ', 'ẳ', 'Ẵ', 'ẵ', 'Ặ', 'ặ', 'Ẹ', 'ẹ', 'Ẻ',
        'ẻ', 'Ẽ', 'ẽ', 'Ế', 'ế', 'Ề', 'ề', 'Ể', 'ể', 'Ễ', 'ễ', 'Ệ', 'ệ',
        'Ỉ', 'ỉ', 'Ị', 'ị', 'Ọ', 'ọ', 'Ỏ', 'ỏ', 'Ố', 'ố', 'Ồ', 'ồ', 'Ổ',
        'ổ', 'Ỗ', 'ỗ', 'Ộ', 'ộ', 'Ớ', 'ớ', 'Ờ', 'ờ', 'Ở', 'ở', 'Ỡ', 'ỡ',
        'Ợ', 'ợ', 'Ụ', 'ụ', 'Ủ', 'ủ', 'Ứ', 'ứ', 'Ừ', 'ừ', 'Ử', 'ử', 'Ữ',
        'ữ', 'Ự', 'ự',};
    private static char[] DESTINATION_CHARACTERS = {'A', 'A', 'A', 'A', 'E',
        'E', 'E', 'I', 'I', 'O', 'O', 'O', 'O', 'U', 'U', 'Y', 'a', 'a',
        'a', 'a', 'e', 'e', 'e', 'i', 'i', 'o', 'o', 'o', 'o', 'u', 'u',
        'y', 'A', 'a', 'D', 'd', 'I', 'i', 'U', 'u', 'O', 'o', 'U', 'u',
        'A', 'a', 'A', 'a', 'A', 'a', 'A', 'a', 'A', 'a', 'A', 'a', 'A',
        'a', 'A', 'a', 'A', 'a', 'A', 'a', 'A', 'a', 'A', 'a', 'E', 'e',
        'E', 'e', 'E', 'e', 'E', 'e', 'E', 'e', 'E', 'e', 'E', 'e', 'E',
        'e', 'I', 'i', 'I', 'i', 'O', 'o', 'O', 'o', 'O', 'o', 'O', 'o',
        'O', 'o', 'O', 'o', 'O', 'o', 'O', 'o', 'O', 'o', 'O', 'o', 'O',
        'o', 'O', 'o', 'U', 'u', 'U', 'u', 'U', 'u', 'U', 'u', 'U', 'u',
        'U', 'u', 'U', 'u',};

    public String getStrNoXml(Object obj) {
        String strReturn;
        if (obj == null) {
            return "";
        } else {
            strReturn = obj.toString().replaceAll("<", "&lt;").replaceAll(">", "&gt;");
            if (strReturn.length() <= 200) {
                return strReturn;
            } else {
                return strReturn.substring(0, 150).concat("...");
            }
        }
    }

    public String shortenWords(Object obj, int targetLength) {
        String strReturn;
        if (obj == null) {
            return "";
        } else {
            strReturn = obj.toString();
            if (strReturn.length() <= targetLength) {
                return strReturn;
            } else {
                return strReturn.substring(0, targetLength).concat("...");
            }
        }
    }

    public static String setParameterList(int listSize) {
        StringBuilder where = new StringBuilder();
        String str = "";
        for (int i = 0; i < listSize; i++) {
            where.append("?,");
            if (where != null && !where.toString().trim().equals("")) {
                str = where.substring(0, where.length() - 1);
            }
        }
        return str;
    }

    private static SimpleDateFormat formatter = new SimpleDateFormat("dd/MM/yyyy");

    public static Date formatStringDDMMYYYYToDate(String strDate) {
        if (strDate == null || strDate.toString().trim().equals("")) {
            return null;
        }
        try {
            return formatter.parse(strDate);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    public static String formatDateDDMMYYYYToString(Date date) {
        try {
            if (date != null) {
                return formatter.format(date);
            }
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
        return null;
    }

    //convert String format "20160819" thành String format "19/08/2016"
    public static String convertFormatDate(String input) {
        String result = "";
        if (input != null && !input.equals("") && !input.equals("null")) {
            try {
                String day = input.substring(6, 8);
                String month = input.substring(4, 6);
                String year = input.substring(0, 4);
                result = day + "/" + month + "/" + year;
            } catch (Exception ex) {
            }
        }
        return result;
    }
    //convert to %

    public static Double getPercen(Double number1, Double number2) {
        Double kq = new Double("0.00");
        if (number1 != null && number2 != null) {
            kq = (double) number1.intValue() / number2.intValue();
            kq = (double) Math.round(kq * 100);
        }
        if (kq != null && kq.compareTo(100D) > 0) {
            kq = 100D;
        }
        return kq;
    }
    //Convert to QUÝ

    public static String getQuarterByMonth(int month) {
        String result = "";
        if (month < 4) {
            result = "I";
        } else if (month < 7) {
            result = "II";
        } else if (month < 10) {
            result = "III";
        } else {
            result = "IV";
        }
        return result;

    }

    public static String formatObjToString(Object obj, String patten) {
        String result = "0";
        try {
            if (obj != null && patten != null) {
                result = String.format(patten, obj);
            }
        } catch (Exception e) {
            e.printStackTrace();
            result = "";
        }
        return result;
    }

    public static String getNTDT(int ntdt) {
        try {

            if (ntdt == 0) {
                return "";
            }
            if (ntdt == 1) {
                return "0-5.000";
            }
            if (ntdt == 2) {
                return "5.000-10.000";
            }
            if (ntdt == 3) {
                return "10.000-15.000";
            }
            if (ntdt == 4) {
                return "15.000-20.000";
            }
            if (ntdt == 5) {
                return "20.000-25.000";
            }
            if (ntdt == 6) {
                return "25.000-30.000";
            }
            if (ntdt == 7) {
                return "30.000-35.000";
            }
            if (ntdt == 8) {
                return "35.000-40.000";
            }
            if (ntdt == 9) {
                return "40.000-45.000";
            }
            if (ntdt == 10) {
                return "45.000-50.000";
            }
            if (ntdt == 11) {
                return "50.000-55.000";
            }
            if (ntdt == 12) {
                return "55.000-60.000";
            }
            if (ntdt == 13) {
                return "60.000-65.000";
            }
            if (ntdt == 14) {
                return "65.000-70.000";
            }
            if (ntdt == 15) {
                return "70.000-75.000";
            }
            if (ntdt == 16) {
                return "75.000-80.000";
            }
            if (ntdt == 17) {
                return "80.000-85.000";
            }
            if (ntdt == 18) {
                return "85.000-90.000";
            }
            if (ntdt == 19) {
                return "90.000-95.000";
            }
            if (ntdt == 20) {
                return "95.000-100.000";
            }
            if (ntdt == 21) {
                return "100.000-150.000";
            }
            if (ntdt == 22) {
                return "150.000-200.000";
            }
            if (ntdt == 23) {
                return "200.000-250.000";
            }
            if (ntdt == 24) {
                return "250.000-300.000";
            }
            if (ntdt == 25) {
                return "300.000-350.000";
            }
            if (ntdt == 26) {
                return "350.000-400.000";
            }
            if (ntdt == 27) {
                return "400.000-450.000";
            }
            if (ntdt == 28) {
                return "450.000-500.000";
            }
            if (ntdt == 29) {
                return "500.000-1.000.000";
            }
            if (ntdt == 30) {
                return "1.000.000-10.000.000";
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return "0";
    }
}
