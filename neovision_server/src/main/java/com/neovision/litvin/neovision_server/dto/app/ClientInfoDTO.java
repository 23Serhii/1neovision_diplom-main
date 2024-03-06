package com.neovision.litvin.neovision_server.dto.app;

import com.neovision.litvin.neovision_server.model.enums.Role;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@AllArgsConstructor
@NoArgsConstructor
@Data
public class ClientInfoDTO {
    private Long id;
    private String login;
    private String email;
    private Role role;
    private String avatar;

//    private List<SessionDTO> sessions;

}
