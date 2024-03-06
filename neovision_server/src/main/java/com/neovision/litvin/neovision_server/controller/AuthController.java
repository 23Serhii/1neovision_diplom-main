package com.neovision.litvin.neovision_server.controller;

import com.neovision.litvin.neovision_server.dto.admin.LoginDTO;
import com.neovision.litvin.neovision_server.dto.admin.LoginResponseDTO;
import com.neovision.litvin.neovision_server.dto.app.request.LoginAppRequest;
import com.neovision.litvin.neovision_server.dto.app.response.LoginAppResponse;
import com.neovision.litvin.neovision_server.service.AuthService;
import com.neovision.litvin.neovision_server.service.HelpfullyService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/auth")
@Slf4j
@RequiredArgsConstructor
public class AuthController {

    // Сервіс для авторизації
    private final AuthService authService;

    @PostMapping("/admin/login")
    public ResponseEntity<?> loginAdmin(@RequestBody LoginDTO loginDto) {
        if (!HelpfullyService.isValidEmail(loginDto.email())) {
            return ResponseEntity.badRequest().body("Invalid email format");
        }
//        try {
            LoginResponseDTO response = authService.adminLogin(loginDto);
            return ResponseEntity.ok(response);
//        } catch (Exception e) {
//            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(e.getMessage());
//        }
    }

    @PostMapping("/app/login")
//    @PreAuthorize("hasAuthority('COMMANDER')")
    public ResponseEntity<?> loginApp(@RequestBody LoginAppRequest loginDto) {
        if (!HelpfullyService.isValidEmail(loginDto.email())) {
            return ResponseEntity.badRequest().body("Invalid email format");
        }
        try {
            LoginAppResponse response = authService.appLogin(loginDto);
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(e.getMessage());
        }
    }
}
