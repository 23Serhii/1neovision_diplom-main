package com.neovision.litvin.neovision_server.model;
import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

import java.time.LocalDateTime;
import java.util.List;

@Entity
@Getter
@Setter
public class Recon {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String report;

    private LocalDateTime timestamp = LocalDateTime.now();
    @ManyToOne
    @JoinColumn(name = "client_id")
    private Client createdBy; // Зв'язок з клієнтом, який створив доповідь

    @ManyToOne
    @JoinColumn(name = "session_id")
    private Session session;


    @OneToMany(mappedBy = "recon", fetch = FetchType.EAGER, cascade = CascadeType.ALL)
    private List<ReportUnit> reportUnits;

}
