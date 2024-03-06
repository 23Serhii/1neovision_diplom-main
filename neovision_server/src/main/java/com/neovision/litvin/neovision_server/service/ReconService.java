package com.neovision.litvin.neovision_server.service;

import com.neovision.litvin.neovision_server.dto.app.request.ReconRequest;
import com.neovision.litvin.neovision_server.dto.app.request.ReportUnitRequest;
import com.neovision.litvin.neovision_server.dto.app.response.ReconResponse;
import com.neovision.litvin.neovision_server.dto.app.response.ReportUnitResponse;
import com.neovision.litvin.neovision_server.model.*;
import com.neovision.litvin.neovision_server.repository.*;
import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@Service
@RequiredArgsConstructor
public class ReconService {

    private final ReconRepository reconRepository;
    private final ClientRepository clientRepository;
    private final SessionRepository sessionRepository;
    private final ReportUnitRepository reportUnitRepository;
    private final UnitRepository unitRepository;

    @Transactional
    public ReconResponse createReconWithReportUnits(ReconRequest request) throws IOException {
        Client createdBy = clientRepository.findById(request.getCreatedById()).orElseThrow(() -> new RuntimeException("Client not found"));
        Session session = sessionRepository.findById(request.getSessionId()).orElseThrow(() -> new RuntimeException("Session not found"));

        Recon recon = new Recon();
        recon.setReport(request.getReport());
        recon.setCreatedBy(createdBy);
        recon.setSession(session);
        recon = reconRepository.save(recon);

        for (ReportUnitRequest reportUnitRequest : request.getReportUnits()) {
            ReportUnit reportUnit = new ReportUnit();
            reportUnit.setDescription(reportUnitRequest.getDescription());
            reportUnit.setLatitude(reportUnitRequest.getLatitude());
            reportUnit.setLongitude(reportUnitRequest.getLongitude());

            reportUnit.setRecon(recon);
            // Assuming you have a method to find a Unit by id
            Unit unit = unitRepository.getUnitById(reportUnitRequest.getUnitId()).get(); // Retrieve the Unit object
            reportUnit.setUnit(unit);
            List<String> photoUrls = new ArrayList<>();
            for (MultipartFile photo : reportUnitRequest.getUnitPhotoFiles()) {
                String photoUrl;
                if (photo != null) {
                    photoUrl = FileService.saveFile(photo, "src/main/uploads/report-unit");
                    photoUrls.add("/uploads/report-unit/" + photoUrl);
                }
            }
            reportUnit.setPhotos(photoUrls);

            reportUnitRepository.save(reportUnit);
        }
        List<ReportUnit> reportUnits = reportUnitRepository.findAllByReconId(recon.getId());

        List<ReportUnitResponse> reportUnitResponses = new ArrayList<>();
        for (ReportUnit reportUnit : reportUnits) {
            List<String> unitPhotoUrls = new ArrayList<>();
            for (String unitPhotoUrl : reportUnit.getPhotos()) {
                unitPhotoUrls.add(HelpfullyService.getFileUrl(unitPhotoUrl));
            }
            reportUnitResponses.add(new ReportUnitResponse(reportUnit.getId(), reportUnit.getUnit().getId(), reportUnit.getUnit().getName(), reportUnit.getDescription(), reportUnit.getLatitude(), reportUnit.getLongitude(), unitPhotoUrls));
        }

        return new ReconResponse(recon.getId(), recon.getReport(), recon.getCreatedBy().getUsername(), recon.getTimestamp(), reportUnitResponses);
    }
}
