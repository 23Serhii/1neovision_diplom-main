package com.neovision.litvin.neovision_server.service;

import com.neovision.litvin.neovision_server.config.security.jwt.JwtService;
import com.neovision.litvin.neovision_server.dto.admin.LoginDTO;
import com.neovision.litvin.neovision_server.dto.admin.LoginResponseDTO;
import com.neovision.litvin.neovision_server.dto.app.request.LoginAppRequest;
import com.neovision.litvin.neovision_server.dto.app.response.LoginAppResponse;
import com.neovision.litvin.neovision_server.model.Client;
import com.neovision.litvin.neovision_server.model.User;
import lombok.RequiredArgsConstructor;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class AuthService {
    private final JwtService jwtService;
    private final ClientService clientService;
    private final UserService userService;
    private final AuthenticationManager authenticationManager;
    public LoginResponseDTO adminLogin(LoginDTO loginDTO){
        User user = userService.getUserByEmail(loginDTO.email()).orElseThrow(()->new UsernameNotFoundException("User not found"));
        return new LoginResponseDTO(user.getUsername());
    }


    public LoginAppResponse appLogin(LoginAppRequest loginDTO) throws AuthenticationException {
        // Validate client
        Client client = clientService.getClientByEmail(loginDTO.email()).orElseThrow(() -> new UsernameNotFoundException("Client not found"));

        // Authenticate
        authenticationManager.authenticate(new UsernamePasswordAuthenticationToken(loginDTO.email(), loginDTO.password()));

        // Generate JWT token
        String jwtToken = jwtService.generateToken(client);
        return new LoginAppResponse(jwtToken);
    }
}
