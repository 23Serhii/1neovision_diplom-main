package com.neovision.litvin.neovision_server;

import lombok.extern.slf4j.Slf4j;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.scheduling.annotation.EnableAsync;

@SuppressWarnings("SpellCheckingInspection")
@SpringBootApplication
@Slf4j
@EnableAsync
public class NeovisionServerApplication {
	public static void main(String[] args) {
		SpringApplication.run(NeovisionServerApplication.class, args);
	}

}
