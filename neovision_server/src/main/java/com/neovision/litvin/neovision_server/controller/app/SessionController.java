package com.neovision.litvin.neovision_server.controller.app;

import com.neovision.litvin.neovision_server.dto.app.SessionDTO;
import com.neovision.litvin.neovision_server.model.Client;
import com.neovision.litvin.neovision_server.service.SessionService;
import com.neovision.litvin.neovision_server.service.UnitService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.util.List;

@RestController
@RequestMapping("/app/session")
@RequiredArgsConstructor
public class SessionController {
    private final SessionService sessionService;
    private final UnitService unitService;

    @GetMapping("/list")
    public ResponseEntity<?> getSessions(@AuthenticationPrincipal Client client) {
        List<SessionDTO> sessionDTOList = sessionService.getSessionsByClientIdAndRole(client.getId(),client.getRole());
        return ResponseEntity.ok(sessionDTOList);
    }

    @PostMapping("/create")
    @PreAuthorize("hasAuthority('COMMANDER')")
    public ResponseEntity<?> createSession(@AuthenticationPrincipal Client client,
                                           @ModelAttribute  SessionDTO sessionDTO,
                                           @RequestParam MultipartFile mapFile) {
        try {
            sessionService.create(sessionDTO, client,mapFile);
            return ResponseEntity.ok(true);
        } catch (IOException e) {
            throw new RuntimeException(e);
        }
    }

    @DeleteMapping("/delete")
    @PreAuthorize("hasAuthority('COMMANDER')")
    public ResponseEntity<?> deleteSessionById(@RequestParam Long id) {
        sessionService.deleteSessionById(id);
        return ResponseEntity.ok("Removed successfully");
    }
}
