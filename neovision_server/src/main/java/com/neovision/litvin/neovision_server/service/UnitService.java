package com.neovision.litvin.neovision_server.service;

import com.neovision.litvin.neovision_server.dto.app.UnitDTO;
import com.neovision.litvin.neovision_server.model.Unit;
import com.neovision.litvin.neovision_server.repository.UnitRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;

@Service
@RequiredArgsConstructor
public class UnitService {

    private final UnitRepository unitRepository;

    public boolean existsByName(String name) {
        return unitRepository.existsByName(name);
    }

    public List<UnitDTO> getAllUnits() {
        List<Unit> units = unitRepository.findAll();
        List<UnitDTO> unitDTOList = new ArrayList<>();
        for (Unit unit : units) {
            unitDTOList.add(new UnitDTO(unit.getId(), unit.getName(), HelpfullyService.getFileUrl(unit.getImageUrl()), HelpfullyService.getFileUrl(unit.getModelUrl())));
        }
        return unitDTOList;
    }

    public Unit addUnit(Unit unit) {
        return unitRepository.save(unit);
    }

}
