package com.neovision.litvin.neovision_server.service;

import com.neovision.litvin.neovision_server.dto.app.SessionDTO;
import com.neovision.litvin.neovision_server.dto.app.response.ReconResponse;
import com.neovision.litvin.neovision_server.dto.app.response.ReportUnitResponse;
import com.neovision.litvin.neovision_server.model.Client;
import com.neovision.litvin.neovision_server.model.Recon;
import com.neovision.litvin.neovision_server.model.ReportUnit;
import com.neovision.litvin.neovision_server.model.Session;
import com.neovision.litvin.neovision_server.model.enums.Role;
import com.neovision.litvin.neovision_server.repository.ReconRepository;
import com.neovision.litvin.neovision_server.repository.SessionRepository;
import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

@Service
@Slf4j
@RequiredArgsConstructor
public class SessionService {

    private final SessionRepository sessionRepository;
    private final ClientService clientService;
    public final ReconRepository reconRepository;


    @Transactional
    public void deleteSessionById(Long id) {
        Session session = sessionRepository.findById(id).orElseThrow();
        for (Client client : session.getClients()) {
            client.getSessions().remove(session); // Видаляємо сесію зі списку сесій клієнта
        }
        sessionRepository.delete(session); // Видаляємо сесію
    }

    @Transactional
    public List<SessionDTO> getSessionsByClientIdAndRole(Long id, Role role) {
        boolean isCommander = role == Role.COMMANDER;
        List<SessionDTO> sessionDTOList = new ArrayList<>();
        List<Session> sessions =  isCommander?  sessionRepository.findByCreatorId(id):sessionRepository.findByClientId(id) ;
        for (Session session : sessions) {
            List<Long> subIds = new ArrayList<>();
            for (Client sub : session.getClients()) {
                subIds.add(sub.getId());
            }
            List<ReconResponse> reconResponses = new ArrayList<>();
            for (Recon recon : session.getReports()){
                if(!isCommander && !recon.getCreatedBy().getId().equals(id)){
                    continue;
                }
                List<ReportUnitResponse> reportUnitResponses = new ArrayList<>();
                for(ReportUnit reportUnit :recon.getReportUnits()){
                    List<String> unitPhotoUrls = new ArrayList<>();
                    for(String unitPhotoUrl : reportUnit.getPhotos()){
                        unitPhotoUrls.add(HelpfullyService.getFileUrl(unitPhotoUrl));
                    }
                    reportUnitResponses.add(new ReportUnitResponse(reportUnit.getId(),reportUnit.getUnit().getId(),reportUnit.getUnit().getName(),reportUnit.getDescription(),reportUnit.getLatitude(),reportUnit.getLongitude(),unitPhotoUrls));
                }
                reconResponses.add(new ReconResponse(recon.getId(),recon.getReport(),recon.getCreatedBy().getLogin(),recon.getTimestamp(),reportUnitResponses));
            }
            sessionDTOList.add(
                    new SessionDTO(session.getId(),
                            session.getName(),
                            session.getDescription(),
                            session.getStartTime(),
                            session.getCenterLat(),
                            session.getCenterLng(),
                            HelpfullyService.getFileUrl(session.getMapImage()),
                            subIds,reconResponses));
        }
        return sessionDTOList;
    }

    @Transactional
    public void create(SessionDTO sessionDTO, Client client, MultipartFile mapFile) throws IOException {
        Session session = new Session();
        session.setName(sessionDTO.getName());
        session.setDescription(sessionDTO.getDescription());
        session.setCreator(client);
        session.setCenterLat(sessionDTO.getCenterLat());
        session.setCenterLng(sessionDTO.getCenterLng());

        List<Client> clients = new ArrayList<>();
        for (Long id : sessionDTO.getSubordinatesIds()) {
            Optional<Client> clientOptional = clientService.getClientById(id);
            if (clientOptional.isPresent()) {
                Client subClient = clientOptional.get();
                clients.add(subClient);
                subClient.getSessions().add(session); // Додаємо сесію до клієнта
            }
        }

        session.setClients(clients);

        String mapImage = null;
        if (mapFile != null) {
            mapImage = FileService.saveFile(mapFile, "src/main/uploads/maps");
            session.setMapImage("/uploads/maps/" + mapImage);
        }

        sessionRepository.save(session); // Зберігаємо сесію з усіма зв'язками
    }
}
