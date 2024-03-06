package com.neovision.litvin.neovision_server.dto.app;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@AllArgsConstructor
@NoArgsConstructor
@Data
public class UnitDTO {
    private Long id;
    private String name;
    private String imageUrl;
    private String modelUrl;
}
