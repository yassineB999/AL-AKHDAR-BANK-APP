package com.yassine.backend.Presentation;

import java.util.HashMap;
import java.util.Map;
import com.yassine.backend.Dao.Utilisateur;
import com.yassine.backend.Service.GestionRole;
import com.yassine.backend.Service.GestionUtilisateur;
import lombok.Data;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/App/api")
@Data
public class AppController {
    @Autowired
    public final GestionUtilisateur gestionUtilisateur;

    @Autowired
    public final GestionRole gr;
    @PostMapping("/Inscrire")
    public ResponseEntity<?> Inscrire(@RequestBody Utilisateur u) {
        if (gestionUtilisateur.findByEmail(u.getEmail()) != null){
            Map<String, Object> errorResponse = new HashMap<>();
            errorResponse.put("status", "error");
            errorResponse.put("message", "email already exists");
            return ResponseEntity.status(401).body(errorResponse);
        }

        Utilisateur newUser = new Utilisateur();
        newUser.setEmail(u.getEmail());
        newUser.setPassword(u.getPassword());
        newUser.setCin(u.getCin());
        newUser.setNumerotelephone(u.getNumerotelephone());
        newUser.setAdresse(u.getAdresse());
        newUser.setNom(u.getNom());
        newUser.setPrenom(u.getPrenom());
        newUser.setAge(u.getAge());


        gestionUtilisateur.createUser(newUser);
        // Prepare the response body
        Map<String, Object> responseBody = new HashMap<>();
        responseBody.put("status", "success");
        responseBody.put("message", "Account registered successfully");

        return ResponseEntity.ok().body(responseBody);
    }
    @PostMapping("/Authentifie")
    public @ResponseBody ResponseEntity<?> Authentifie(@RequestBody Utilisateur req){
        try {
            System.out.println("TRRYING TO GENERATE TOKEN");
            String token = gestionUtilisateur.login(req);
            System.out.println(token);
            Utilisateur u = gestionUtilisateur.findByEmail(req.getEmail());
            System.out.println(u.getEmail());
            char roleChar = u.getRole().getLibelle().charAt(0);

            // Create a map to hold the response data
            Map<String, Object> response = new HashMap<>();
            response.put("token", token);
            response.put("role", roleChar);

            return ResponseEntity.ok(response);
        } catch (Exception e) {
            return ResponseEntity.status(401).body(e.getMessage());
        }
    }
}
