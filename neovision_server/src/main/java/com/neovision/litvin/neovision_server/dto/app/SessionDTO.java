package com.neovision.litvin.neovision_server.dto.app;

import com.neovision.litvin.neovision_server.dto.app.response.ReconResponse;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

@AllArgsConstructor
@NoArgsConstructor
@Data
public class SessionDTO {
    private Long id;
    private String name;
    private String description;
    private LocalDateTime startTime = LocalDateTime.now();
    private Double centerLat;
    private Double centerLng;
    private String sessionMap = "";
    private List<Long> subordinatesIds = new ArrayList<>();
    private List<ReconResponse> recons= new ArrayList<>();;
}
