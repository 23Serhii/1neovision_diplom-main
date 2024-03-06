package com.neovision.litvin.neovision_server.model;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;
import java.util.List;

@Entity
@Getter
@Setter
public class ReportUnit {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String description;
    private double latitude;
    private double longitude;

    @ElementCollection
    private List<String> photos;

    @ManyToOne
    @JoinColumn(name = "recon_id")
    private Recon recon;

    @ManyToOne
    @JoinColumn(name = "unit_id")
    private Unit unit; // Зв'язок з Unit
}
