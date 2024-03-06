package com.neovision.litvin.neovision_server.repository;

import com.neovision.litvin.neovision_server.model.Client;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface ClientRepository extends JpaRepository<Client, Long> {

    // Пошук клієнта за іменем користувача
    Optional<Client> findByLogin(String login);

    Optional<Client> findByEmail(String email);

    List<Client> findByCommanderId(Long commanderId);
    // Перевірка чи існує клієнт за іменем користувача
    boolean existsByLogin(String login);

    boolean existsByEmail(String email);
}
