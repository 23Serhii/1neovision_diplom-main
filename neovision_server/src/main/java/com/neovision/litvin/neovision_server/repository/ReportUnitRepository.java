package com.neovision.litvin.neovision_server.repository;

import com.neovision.litvin.neovision_server.model.ReportUnit;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface ReportUnitRepository extends JpaRepository<ReportUnit, Long> {
    List<ReportUnit> findAllByReconId (Long id);
}
