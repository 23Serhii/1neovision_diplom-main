package com.neovision.litvin.neovision_server.service;

import lombok.extern.slf4j.Slf4j;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.UUID;

@Slf4j
public class FileService {
    public static String saveFile(MultipartFile file, String path) throws IOException {
        String fileName = UUID.randomUUID() + file.getOriginalFilename();

        Path root  = Paths.get(path);
        Path resolve  = root.resolve(fileName);

        if (!root.toFile().exists()) {
            if (!root.toFile().mkdirs()) {
                System.out.println("Failed to create directory: " + root.toFile().getPath());
            }
        }

        if (resolve.toFile().exists())
            log.warn("File already exists: " + fileName);
        else
            Files.copy(file.getInputStream(), resolve);

        return fileName;
    }
}
