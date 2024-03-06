package com.neovision.litvin.neovision_server.dto.app.request;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.springframework.web.multipart.MultipartFile;

import java.util.ArrayList;
import java.util.List;

@AllArgsConstructor
@NoArgsConstructor
@Data
public class ReportUnitRequest {
    private Long unitId;
    private String description;
    private double latitude;
    private double longitude;
    private List<MultipartFile> unitPhotoFiles = new ArrayList<>();
}
