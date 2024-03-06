package com.neovision.litvin.neovision_server.service;

import lombok.extern.slf4j.Slf4j;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;

import jakarta.servlet.http.HttpServletRequest;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

@SuppressWarnings("SpellCheckingInspection")
@Slf4j
public class HelpfullyService {

//    private static final String GOOGLE_API_KEY = "AIzaSyAbyadqDovF_ZvTsPJG4bd9IxD50JEzpQs";
    private static final String EMAIL_REGEX = "^(.+)@(\\S+)$";

    private static final Pattern EMAIL_PATTERN = Pattern.compile(EMAIL_REGEX);

    public static boolean isValidEmail(String email) {
        if (email == null) {
            return false;
        }
        Matcher matcher = EMAIL_PATTERN.matcher(email);
        return matcher.matches();
    }

    private static String getCurrentBaseUrl() {
        ServletRequestAttributes sra = (ServletRequestAttributes) RequestContextHolder.getRequestAttributes();
        assert sra != null;
        HttpServletRequest req = sra.getRequest();
        return req.getScheme() + "://" + req.getServerName() + ":" + req.getServerPort() + req.getContextPath();
    }

    public static String getFileUrl(String filePath) {
        if (filePath == null) {
            return null;
        } else if (filePath.startsWith("/")) {
            return getCurrentBaseUrl() + filePath;
        } else {
            return filePath;
        }
    }
}
