package com.neovision.litvin.neovision_server.service;

import com.neovision.litvin.neovision_server.dto.app.ClientInfoDTO;
import com.neovision.litvin.neovision_server.model.Client;
import com.neovision.litvin.neovision_server.repository.ClientRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class ClientService {

    private final ClientRepository clientRepository;

    public boolean existsByEmail(String email){
        return clientRepository.existsByEmail(email);
    }

    // Додавання нового клієнта
    public Client addClient(Client client) {
        // Тут можна додати додаткову логіку перевірки або обробки
        return clientRepository.save(client);
    }

    public void saveAll(List<Client> clients){
        clientRepository.saveAll(clients);
    }

    public List<ClientInfoDTO> getSubordinates(Long commanderId){
        List<Client> clients = clientRepository.findByCommanderId(commanderId);
        List<ClientInfoDTO> clientInfoDTOList = new ArrayList<>();
        for(Client client : clients){
            clientInfoDTOList.add(new ClientInfoDTO(client.getId(),client.getLogin(),client.getEmail(),client.getRole(),HelpfullyService.getFileUrl(client.getAvatar())));
        }
        return clientInfoDTOList;
    }


    // Отримання всіх клієнтів
    public List<Client> getAllClients() {
        return clientRepository.findAll();
    }

    // Отримання клієнта за ID
    public Optional<Client> getClientById(Long id) {
        return clientRepository.findById(id);
    }

    public Optional<Client> getClientByEmail(String email){
        return clientRepository.findByEmail(email);
    }

    // Оновлення інформації клієнта
    public Client updateClient(Client client) {
        // Тут можна додати перевірку на існування клієнта
        return clientRepository.save(client);
    }

    // Видалення клієнта
    public void deleteClient(Long id) {
        clientRepository.deleteById(id);
    }
}
