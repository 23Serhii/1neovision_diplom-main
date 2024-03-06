package com.neovision.litvin.neovision_server.controller.app;

import com.neovision.litvin.neovision_server.dto.app.UnitDTO;
import com.neovision.litvin.neovision_server.service.UnitService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/app/units")
@RequiredArgsConstructor
public class UnitsController {
    final private UnitService unitService;

    @GetMapping("/list")
    public ResponseEntity<?> getUnits() {
        List<UnitDTO> unitDTOList = unitService.getAllUnits();
        return ResponseEntity.ok(unitDTOList);
    }
}
