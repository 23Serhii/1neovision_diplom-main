package com.neovision.litvin.neovision_server.controller.admin;

import com.neovision.litvin.neovision_server.model.Unit;
import com.neovision.litvin.neovision_server.repository.UnitRepository;
import com.neovision.litvin.neovision_server.service.FileService;
import com.neovision.litvin.neovision_server.service.HelpfullyService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.util.List;

@RestController
@RequestMapping("/api/admin")
@RequiredArgsConstructor
@Slf4j
public class AdminUnitController {
    final private UnitRepository unitRepository;

    @GetMapping("/constants")
    public ResponseEntity<?> getConstants() {
        List<Unit> constantList = unitRepository.findAll();
        return ResponseEntity.ok(constantList);
    }

    @PostMapping("/constants")
    public ResponseEntity<?> addConstant(
            @RequestParam String name,
            @RequestParam(required = false) MultipartFile file) {

        Unit unit = new Unit();
        unit.setName(name);

        try {
            String constantFile = FileService.saveFile(file, "src/main/uploads/constants");
            unit.setModelUrl("/uploads/constants/" + constantFile);
            unit.setImageUrl("/uploads/default/default-avatar.png");
        } catch (IOException e) {
            log.error("File null");
            return (ResponseEntity<?>) ResponseEntity.badRequest();
        }

        unit = unitRepository.save(unit);
        unit.setModelUrl(HelpfullyService.getFileUrl(unit.getModelUrl()));

        return ResponseEntity.ok(unit);
    }
//
//
//    @PutMapping("/constants")
//    public ResponseEntity<?> updateConstant(@RequestBody ConstantsDtoListWrapper constantsDtoListWrapperList) {
//        if (constantsDtoListWrapperList != null) {
//            List<Constant> updatedConstants = new ArrayList<>();
//            for (ConstantDto constantDto : constantsDtoListWrapperList.getConstants()) {
//                Optional<Constant> constantOptional = constantRepository.findById(constantDto.getId());
//                if (constantOptional.isEmpty())
//                    return new ResponseEntity<>(new Response(true, "Constant with ID " + constantDto.getId() + " not found"), HttpStatus.NOT_FOUND);
//
//                Constant constant = constantOptional.get();
//                constant.setName(constantDto.getName());
//                constant.setDescription(constantDto.getDescription());
//                constant.setType(constantDto.getType());
//
//                if (constantDto.getType().equals(TypeConstant.FILE) && constantDto.getFile() != null) {
//                    try {
//                        String constantFile = FileService.saveFile(constantDto.getFile(), "src/main/uploads/constants");
//                        constant.setValue("/uploads/constants/" + constantFile);
//                    } catch (IOException e) {
//                        log.error("Error saving file for constant with ID " + constantDto.getId(), e);
//                        return new ResponseEntity<>(new Response(true, "Error saving file"), HttpStatus.BAD_REQUEST);
//                    }
//                } else if (constantDto.getType().equals(TypeConstant.TEXT)) {
//                    constant.setValue(constantDto.getValue());
//                }
//
//                updatedConstants.add(constantRepository.save(constant));
//            }
//
//            Activity activity = new Activity();
//            activity.setUser(admin);
//            activity.setText("Updated constants");
//            activityRepository.save(activity);
//            return ResponseEntity.ok(updatedConstants);
//        } else {
//            return new ResponseEntity<>(new Response(true, "List null"), HttpStatus.BAD_REQUEST);
//        }
//    }

    @DeleteMapping("/constants/{id}")
    public ResponseEntity<?> deleteConstant( @PathVariable Long id) {
        unitRepository.deleteById(id);
        return ResponseEntity.ok("Constant deleted");
    }

}
