package com.yassine.backend.Presentation;

import java.util.HashMap;
import java.util.Map;
import com.yassine.backend.Dao.Utilisateur;
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

    @PostMapping("/Inscrire")
    public @ResponseBody ResponseEntity<?> Inscrire(@RequestBody Utilisateur u) {
        Utilisateur registeredUser = gestionUtilisateur.register(u);
        if (registeredUser.getIdUtilisateur() != 0) {
            return ResponseEntity.ok(registeredUser);
        } else {
            return ResponseEntity.status(500).body(null);
        }
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
