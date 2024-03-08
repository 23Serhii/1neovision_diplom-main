package com.neovision.litvin.neovision_server;

import com.neovision.litvin.neovision_server.model.Client;
import com.neovision.litvin.neovision_server.model.Unit;
import com.neovision.litvin.neovision_server.model.User;
import com.neovision.litvin.neovision_server.model.enums.Role;
import com.neovision.litvin.neovision_server.service.ClientService;
import com.neovision.litvin.neovision_server.service.UnitService;
import com.neovision.litvin.neovision_server.service.UserService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.boot.CommandLineRunner;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Component;


@SuppressWarnings("SpellCheckingInspection")
@Component
@RequiredArgsConstructor
@Slf4j
public class CommandLineRunnerImpl implements CommandLineRunner {

    private final PasswordEncoder passwordEncoder;
    private final UserService userService;
    private final ClientService clientService;
    private final UnitService unitService;


    @Override
    public void run(String... args) {
        initAdminUser();
        initAppClient();
        initUnits();
    }

    private void initAppClient() {
        String email = "neovision@gmail.com";
        Client commander;
        if (!clientService.existsByEmail(email)) {
            Client client = new Client();
            client.setLogin("Whiskey");
            client.setRole(Role.COMMANDER);
            client.setEmail(email);
            client.setPassword(passwordEncoder.encode("zsxadc1234"));
            commander = clientService.addClient(client);
            log.warn(client.getPassword());
        }else {
            commander = clientService.getClientByEmail(email).get();
        }
        String emailSubordinate = "neovision@gmail.coms";
        createSubordinate(commander, emailSubordinate,"Alpha");
        String emailSubordinate2 = "neovision@gmail.comss";
        createSubordinate(commander, emailSubordinate2,"Brabo");
        String emailSubordinate3 = "neovision@gmail.comsss";
        createSubordinate(commander, emailSubordinate3,"Charlie");
        String emailSubordinate4 = "neovision@gmail.comssss";
        createSubordinate(commander, emailSubordinate4,"Delta");
    }

    private void createSubordinate(Client existingCommander, String emailSubordinate, String login) {
        // Перезавантаження командира з бази даних
        Client commander = clientService.getClientById(existingCommander.getId()).orElseThrow(() -> new RuntimeException("Commander not found"));

        if (!clientService.existsByEmail(emailSubordinate)) {
            Client client = new Client();
            client.setLogin(login);
            client.setCommander(commander); // Тепер commander є сутністю, асоційованою з поточною сесією
            client.setRole(Role.SUBORDINATE);
            client.setEmail(emailSubordinate);
            client.setPassword(passwordEncoder.encode("zsxadc1234"));
            clientService.addClient(client);
            log.warn(client.getPassword());
        }
    }


    private void initAdminUser() {
        String email = "gostaroff@icloud.com";
        if (!userService.existsByEmail(email)) {
            User user = new User();
            user.setEmail(email);
            user.setUsername("gostar");
            user.setPassword(passwordEncoder.encode("zsxadc1234"));
            userService.addUser(user);
        }
    }

    private void initUnits(){
        if (!unitService.existsByName("Oplot")) {
            Unit unit = new Unit();
            unit.setName("Oplot");
            unit.setImageUrl("/uploads/ar/oplot.png");
            unit.setModelUrl("/uploads/ar/oplot.usdz");
            unitService.addUnit(unit);
        }
        if (!unitService.existsByName("Challenger 2")) {
            Unit unit = new Unit();
            unit.setName("Challenger 2");
            unit.setImageUrl("/uploads/ar/challenger2.png");
            unit.setModelUrl("/uploads/ar/challenger2.usdz");
            unitService.addUnit(unit);
        }
        if (!unitService.existsByName("HIMMARS")) {
            Unit unit = new Unit();
            unit.setName("HIMMARS");
            unit.setImageUrl("/uploads/ar/himars.png");
            unit.setModelUrl("/uploads/ar/himars.usdz");
            unitService.addUnit(unit);
        }
        if (!unitService.existsByName("StarLink")) {
            Unit unit = new Unit();
            unit.setName("StarLink");
            unit.setImageUrl("/uploads/ar/starlink.png");
            unit.setModelUrl("/uploads/ar/starlink.usdz");
            unitService.addUnit(unit);
        }
    }
}
