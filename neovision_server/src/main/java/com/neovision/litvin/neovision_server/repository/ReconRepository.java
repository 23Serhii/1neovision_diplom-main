package com.neovision.litvin.neovision_server.repository;

import com.neovision.litvin.neovision_server.model.Recon;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface ReconRepository extends JpaRepository<Recon, Long> {
    // Знайти всі Recon за sessionId
    List<Recon> findBySessionId(Long sessionId);

    // Знайти всі Recon за sessionId та createdBy.id
    List<Recon> findBySessionIdAndCreatedById(Long sessionId, Long createdById);

    Optional<Recon> findById(Long id);
}
