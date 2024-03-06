package com.neovision.litvin.neovision_server.repository;

import com.neovision.litvin.neovision_server.model.Session;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface SessionRepository extends JpaRepository<Session, Long> {
    List<Session> findByCreatorId(Long creatorId);

    @Override
    void deleteById(Long id);

    @Query("SELECT s FROM Session s JOIN s.clients c WHERE c.id = :clientId")
    List<Session> findByClientId(Long clientId);
}
