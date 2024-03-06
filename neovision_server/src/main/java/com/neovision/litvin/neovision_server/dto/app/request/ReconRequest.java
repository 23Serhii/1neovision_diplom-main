package com.neovision.litvin.neovision_server.dto.app.request;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.ArrayList;
import java.util.List;

@AllArgsConstructor
@NoArgsConstructor
@Data
public class ReconRequest {
    private String report;
    private Long createdById; //For search Client
    private Long sessionId; //For search Session
    private List<ReportUnitRequest> reportUnits = new ArrayList<>();
}
