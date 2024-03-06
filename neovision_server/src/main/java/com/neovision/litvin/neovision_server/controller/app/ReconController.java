package com.neovision.litvin.neovision_server.controller.app;

import com.neovision.litvin.neovision_server.dto.app.request.ReconRequest;
import com.neovision.litvin.neovision_server.dto.app.response.ReconResponse;
import com.neovision.litvin.neovision_server.service.ReconService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.io.IOException;

@RestController
@RequestMapping("/app/recon")
@RequiredArgsConstructor
public class ReconController {

    final private ReconService reconService;

    @PostMapping("/create")
    @PreAuthorize("hasAuthority('SUBORDINATE')")
    public ResponseEntity<?> createReconWithReportUnits(@ModelAttribute  ReconRequest reconRequest) throws IOException {
        ReconResponse recon = reconService.createReconWithReportUnits(reconRequest);
        return ResponseEntity.ok(recon);
    }
}
