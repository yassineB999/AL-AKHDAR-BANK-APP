package com.yassine.backend.Presentation;

import com.yassine.backend.Dao.DemandeCreationCompte;
import com.yassine.backend.Dao.Reclamation;
import com.yassine.backend.Dao.Utilisateur;
import com.yassine.backend.Dao.Utils;
import com.yassine.backend.Service.*;
import lombok.Data;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.web.bind.annotation.*;

import java.util.List;
@RestController
@RequestMapping("/App/api/client/")
@Data
public class ClientController {

    @Autowired
    private final GestionUtilisateur gestionUtilisateur;
    @Autowired
    private final GestionRole gestionRole;
    @Autowired
    private final GestionDemandeCreationCompte gestionDemandeCreationCompte;
    @Autowired
    private final GestionReclamation gestionReclamation;
    @Autowired
    private final GestionOffre gestionOffre;
    @Autowired
    private PasswordEncoder passwordEncoder;

    @PostMapping("/SendDemandeCreationCompte")
    public ResponseEntity<?> sendDemandeCreationCompte() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if (authentication == null) {
            return ResponseEntity.status(401).body("No authenticated user found");
        }

        UserDetails userDetails = (UserDetails) authentication.getPrincipal();
        Utilisateur clientUser = gestionUtilisateur.findByEmail(userDetails.getUsername());

        if (clientUser == null || clientUser.getRole().getIdRole() != Utils.ROLE_CLIENT) {
            return ResponseEntity.status(403).body("Unauthorized action");
        }

        // Check if the user already has a DemandeCreationCompte
        if (clientUser.getDemandecreationcompte() != null) {
            return ResponseEntity.status(400).body("You have already submitted a request for account creation");
        }

        // Create a new DemandeCreationCompte
        DemandeCreationCompte newDemande = new DemandeCreationCompte();
        newDemande.setUtilisateur(clientUser);
        gestionDemandeCreationCompte.ajouterDemandeCreationCompte(newDemande);

        // Set the demandeCreationCompte in the user
        clientUser.setDemandecreationcompte(newDemande);
        gestionUtilisateur.getU().save(clientUser);

        return ResponseEntity.ok("Request for account creation submitted successfully");
    }
    @GetMapping("/profile")
    public ResponseEntity<?> getUserProfile() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if (authentication == null) {
            return ResponseEntity.status(401).body("No authenticated user found");
        }

        UserDetails userDetails = (UserDetails) authentication.getPrincipal();
        Utilisateur clientUser = gestionUtilisateur.findByEmail(userDetails.getUsername());
        if (clientUser.getRole().getIdRole() == Utils.ROLE_CLIENT) {
            return ResponseEntity.ok(clientUser);
        } else {
            return ResponseEntity.status(403).body("Access denied");
        }
    }

    @PutMapping("/updateProfile")
    public ResponseEntity<?> updatehisProfil(@RequestBody Utilisateur utilisateur) {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if (authentication == null) {
            return ResponseEntity.status(401).body("No authenticated user found");
        }

        UserDetails userDetails = (UserDetails) authentication.getPrincipal();
        Utilisateur clientUser = gestionUtilisateur.findByEmail(userDetails.getUsername());
        if (clientUser.getRole().getIdRole() == Utils.ROLE_CLIENT) {

            Utilisateur updatedClient = gestionUtilisateur.updateUser(clientUser.getIdUtilisateur(), utilisateur);
            return ResponseEntity.ok(updatedClient);
        } else {
            return ResponseEntity.status(403).body("Access denied");
        }
    }
}
