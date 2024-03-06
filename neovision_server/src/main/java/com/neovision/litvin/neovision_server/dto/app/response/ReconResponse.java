package com.neovision.litvin.neovision_server.dto.app.response;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;
import java.util.List;

@AllArgsConstructor
@NoArgsConstructor
@Data
public class ReconResponse {
    private Long id;
    private String report;
    private String creatorName;
    private LocalDateTime timestamp;
    private List<ReportUnitResponse> reportUnits;
}
