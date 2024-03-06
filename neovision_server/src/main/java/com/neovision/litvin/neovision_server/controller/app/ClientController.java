package com.neovision.litvin.neovision_server.controller.app;

import com.neovision.litvin.neovision_server.dto.app.ClientInfoDTO;
import com.neovision.litvin.neovision_server.model.Client;
import com.neovision.litvin.neovision_server.service.ClientService;
import com.neovision.litvin.neovision_server.service.HelpfullyService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/app/client")
@RequiredArgsConstructor
public class ClientController {
    private final ClientService clientService;

    @GetMapping("/info")
    public ResponseEntity<?> info(@AuthenticationPrincipal Client client) {
        try {
            return ResponseEntity.ok(new ClientInfoDTO(client.getId(), client.getLogin(), client.getEmail(), client.getRole(), HelpfullyService.getFileUrl(client.getAvatar())));
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(e.getMessage());
        }
    }

    @GetMapping("/subordinates")
    @PreAuthorize("hasAuthority('COMMANDER')")
    public ResponseEntity<?> getSubordinates(@AuthenticationPrincipal Client client) {
        List<ClientInfoDTO> clientInfoDTOList = clientService.getSubordinates(client.getId());
        return ResponseEntity.ok(clientInfoDTOList);
    }
}
