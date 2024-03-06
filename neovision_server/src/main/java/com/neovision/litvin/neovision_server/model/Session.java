package com.neovision.litvin.neovision_server.model;
import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

import java.time.LocalDateTime;
import java.util.List;

@Entity
@Getter
@Setter
public class Session {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String name;
    private String description;
    private LocalDateTime startTime = LocalDateTime.now();
    private Double centerLat;
    private Double centerLng;
    private String mapImage;

    @OneToMany(mappedBy = "session",cascade = CascadeType.ALL)
    private List<Recon> reports; // Список доповідей від підлеглих

    @ManyToOne
    @JoinColumn(name = "creator_id", referencedColumnName = "id")
    private Client creator; // Клієнт, який створив сесію

    @ManyToMany(mappedBy = "sessions", cascade = {CascadeType.PERSIST, CascadeType.MERGE, CascadeType.REFRESH, CascadeType.DETACH})
    private List<Client> clients; // Список клієнтів, які приєднані до сесії
}
