package com.neovision.litvin.neovision_server.dto.app.response;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

@AllArgsConstructor
@NoArgsConstructor
@Data
public class ReportUnitResponse {
    private Long id;
    private Long unitId;
    private String name;
    private String description;
    private double latitude;
    private double longitude;
    private List<String> unitPhotoUrls;
}
