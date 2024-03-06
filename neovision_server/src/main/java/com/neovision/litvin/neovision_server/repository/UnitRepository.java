package com.neovision.litvin.neovision_server.repository;
import com.neovision.litvin.neovision_server.model.Unit;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface UnitRepository extends JpaRepository<Unit, Long> {

    boolean existsByName(String name);

    Optional<Unit> getUnitByName(String name);
    Optional<Unit> getUnitById(Long id);

}
