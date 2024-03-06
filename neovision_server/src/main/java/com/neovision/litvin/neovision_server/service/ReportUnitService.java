package com.neovision.litvin.neovision_server.service;

import com.neovision.litvin.neovision_server.model.Recon;
import com.neovision.litvin.neovision_server.model.ReportUnit;
import com.neovision.litvin.neovision_server.model.Unit;
import com.neovision.litvin.neovision_server.repository.ReconRepository;
import com.neovision.litvin.neovision_server.repository.ReportUnitRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class ReportUnitService {

    private final ReportUnitRepository reportUnitRepository;
    private final ReconRepository reconRepository;


    //2
    public ReportUnit addReportUnitToRecon(Long reconId, String description, double latitude, double longitude, Unit unit) {
        // Знаходимо об'єкт Recon
        Recon recon = reconRepository.findById(reconId).orElseThrow(() -> new RuntimeException("Recon not found"));

        // Створення нового ReportUnit
        ReportUnit reportUnit = new ReportUnit();
        reportUnit.setDescription(description);
        reportUnit.setLatitude(latitude);
        reportUnit.setLongitude(longitude);
        reportUnit.setUnit(unit);
        reportUnit.setRecon(recon);

        // Збереження ReportUnit
        ReportUnit savedReportUnit = reportUnitRepository.save(reportUnit);

        // Додавання ReportUnit до списку в Recon та оновлення Recon
        recon.getReportUnits().add(savedReportUnit);
        reconRepository.save(recon);

        return savedReportUnit;
    }
}
