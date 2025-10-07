/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package util;

import org.mindrot.jbcrypt.BCrypt;

public class PasswordUtil {
    // cost 10–12 là hợp lý cho project học tập
    public static String hash(String plain) {
        return BCrypt.hashpw(plain, BCrypt.gensalt(10));
    }
    public static boolean verify(String plain, String hash) {
        return BCrypt.checkpw(plain, hash);
    }
}
