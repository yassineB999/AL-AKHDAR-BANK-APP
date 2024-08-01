package com.yassine.backend.Presentation;

import com.yassine.backend.Dao.*;
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
import java.util.stream.Collectors;

@RestController
@RequestMapping("/App/api/admin/")
@Data
public class AdminController {

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

    @PostMapping("/TotalClient")
    public ResponseEntity<?> totalClients() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if (authentication == null) {
            return ResponseEntity.status(401).body("No authenticated user found");
        }

        UserDetails userDetails = (UserDetails) authentication.getPrincipal();
        Utilisateur adminUser = gestionUtilisateur.findByEmail(userDetails.getUsername());

        if (adminUser == null || adminUser.getRole() == null || adminUser.getRole().getIdRole() != Utils.ROLE_ADMIN) {
            return ResponseEntity.status(403).body("Access denied or user/role not found");
        }

        long clientCount = gestionUtilisateur.getAllUsers().stream()
                .filter(user -> user.getRole() != null && user.getRole().getIdRole() == Utils.ROLE_CLIENT)
                .count();

        return ResponseEntity.ok(clientCount);
    }


    @GetMapping("/ListClient")
    public ResponseEntity<?> listClients() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if (authentication == null) {
            return ResponseEntity.status(401).body("No authenticated user found");
        }

        UserDetails userDetails = (UserDetails) authentication.getPrincipal();
        Utilisateur adminUser = gestionUtilisateur.findByEmail(userDetails.getUsername());
        if (adminUser != null && adminUser.getRole() != null && adminUser.getRole().getIdRole() == Utils.ROLE_ADMIN) {
            List<Utilisateur> allUsers = gestionUtilisateur.getAllUsers();
            List<Utilisateur> clients = allUsers.stream()
                    .filter(user -> user.getRole() != null && user.getRole().getIdRole() == Utils.ROLE_CLIENT)
                    .collect(Collectors.toList());
            return ResponseEntity.ok(clients);
        } else {
            return ResponseEntity.status(403).body("Access denied or no role assigned");
        }
    }

    @DeleteMapping("/deleteClient/{idUtilisateur}")
    public ResponseEntity<?> deleteClient(@PathVariable Integer idUtilisateur) {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if (authentication == null) {
            return ResponseEntity.status(401).body("No authenticated user found");
        }

        UserDetails userDetails = (UserDetails) authentication.getPrincipal();
        Utilisateur adminUser = gestionUtilisateur.findByEmail(userDetails.getUsername());
        if (adminUser.getRole().getIdRole() == Utils.ROLE_ADMIN) {
            Utilisateur userToDelete = gestionUtilisateur.getUserById(idUtilisateur)
                    .orElse(null);
            if (userToDelete != null && userToDelete.getRole().getIdRole() == Utils.ROLE_CLIENT) {
                try {
                    gestionUtilisateur.supprimerUtilisateur(idUtilisateur);
                    return ResponseEntity.ok("Client deleted successfully");
                } catch (Exception e) {
                    return ResponseEntity.status(500).body("Error deleting client: " + e.getMessage());
                }
            } else {
                return ResponseEntity.status(403).body("Cannot delete admin users or user not found");
            }
        } else {
            return ResponseEntity.status(403).body("Access denied");
        }
    }


    @PutMapping("/updateClient/{idUser}")
    public ResponseEntity<?> updateClient(@PathVariable Integer idUser, @RequestBody Utilisateur utilisateur) {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if (authentication == null) {
            return ResponseEntity.status(401).body("No authenticated user found");
        }

        UserDetails userDetails = (UserDetails) authentication.getPrincipal();
        Utilisateur adminUser = gestionUtilisateur.findByEmail(userDetails.getUsername());
        if (adminUser.getRole().getIdRole() == Utils.ROLE_ADMIN) {
            Utilisateur userToUpdate = gestionUtilisateur.getUserById(idUser).orElse(null);
            if (userToUpdate != null) {
                try {
                    userToUpdate.setCin(utilisateur.getCin());
                    userToUpdate.setNom(utilisateur.getNom());
                    userToUpdate.setPrenom(utilisateur.getPrenom());
                    userToUpdate.setEmail(utilisateur.getEmail());
                    userToUpdate.setNumerotelephone(utilisateur.getNumerotelephone());
                    userToUpdate.setAdresse(utilisateur.getAdresse());
                    userToUpdate.setAge(utilisateur.getAge());
                    // Preserve the role if not explicitly set in the update request
                    if (utilisateur.getRole() != null) {
                        userToUpdate.setRole(utilisateur.getRole());
                    }
                    if (utilisateur.getPassword() != null && !utilisateur.getPassword().isEmpty()) {
                        userToUpdate.setPassword(utilisateur.getPassword());
                    }
                    Utilisateur updatedUser = gestionUtilisateur.updateUser(idUser, userToUpdate);
                    return ResponseEntity.ok(updatedUser);
                } catch (Exception e) {
                    return ResponseEntity.status(500).body("Error updating client: " + e.getMessage());
                }
            } else {
                return ResponseEntity.status(403).body("Cannot update admin users or user not found");
            }
        } else {
            return ResponseEntity.status(403).body("Access denied");
        }
    }

    @PostMapping("/addClient")
    public ResponseEntity<?> addClient(@RequestBody Utilisateur client) {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if (authentication == null) {
            return ResponseEntity.status(401).body("No authenticated user found");
        }

        UserDetails userDetails = (UserDetails) authentication.getPrincipal();
        Utilisateur adminUser = gestionUtilisateur.findByEmail(userDetails.getUsername());
        if (adminUser == null || adminUser.getRole() == null) {
            return ResponseEntity.status(403).body("Access denied or user/role not found");
        }

        // Ensure that only users with admin role can add new clients
        if (adminUser.getRole().getIdRole() == Utils.ROLE_ADMIN) {
            try {
                Role clientRole = gestionRole.chercherRole(Utils.ROLE_CLIENT);
                if (clientRole == null) {
                    return ResponseEntity.status(500).body("Default client role not found");
                }
                client.setRole(clientRole);

                boolean userCreated = gestionUtilisateur.createUser(client);
                if (userCreated) {
                    return ResponseEntity.ok("Client added successfully");
                } else {
                    return ResponseEntity.status(400).body("Error adding client");
                }
            } catch (Exception e) {
                return ResponseEntity.status(500).body("Error adding client: " + e.getMessage());
            }
        } else {
            return ResponseEntity.status(403).body("Access denied");
        }
    }

    @GetMapping("/profile")
    public ResponseEntity<?> getUserProfile() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if (authentication == null) {
            return ResponseEntity.status(401).body("No authenticated user found");
        }

        UserDetails userDetails = (UserDetails) authentication.getPrincipal();
        Utilisateur adminUser = gestionUtilisateur.findByEmail(userDetails.getUsername());
        if (adminUser.getRole().getIdRole() == Utils.ROLE_ADMIN) {
            return ResponseEntity.ok(adminUser);
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
        Utilisateur adminUser = gestionUtilisateur.findByEmail(userDetails.getUsername());
        if (adminUser.getRole().getIdRole() == Utils.ROLE_ADMIN) {
            try {
                adminUser.setNom(utilisateur.getNom());
                adminUser.setPrenom(utilisateur.getPrenom());
                adminUser.setNumerotelephone(utilisateur.getNumerotelephone());
                adminUser.setAdresse(utilisateur.getAdresse());
                adminUser.setEmail(utilisateur.getEmail());
                adminUser.setAge(utilisateur.getAge());
                adminUser.setCin(utilisateur.getCin());

                if (utilisateur.getPassword() != null && !utilisateur.getPassword().isEmpty()) {
                    adminUser.setPassword(utilisateur.getPassword());
                }
                Utilisateur updatedAdmin = gestionUtilisateur.updateUser(adminUser.getIdUtilisateur(), adminUser);
                return ResponseEntity.ok(updatedAdmin);
            } catch (Exception e) {
                return ResponseEntity.status(500).body("Error updating profile: " + e.getMessage());
            }
        } else {
            return ResponseEntity.status(403).body("Access denied");
        }
    }

    @GetMapping("/ListDemande")
    public @ResponseBody ResponseEntity<?> listDemande() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if (authentication == null) {
            return ResponseEntity.status(401).body("No authenticated user found");
        }

        UserDetails userDetails = (UserDetails) authentication.getPrincipal();
        Utilisateur adminUser = gestionUtilisateur.findByEmail(userDetails.getUsername());
        if (adminUser.getRole().getIdRole() == Utils.ROLE_ADMIN) {
            List<DemandeCreationCompte> demandes = gestionDemandeCreationCompte.afficherDemandeCreationCompte();
            return ResponseEntity.ok(demandes);
        } else {
            return ResponseEntity.status(403).body("Access denied");
        }
    }
    @PostMapping("/TotalDemande")
    public ResponseEntity<?> totaldemandes() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if (authentication == null) {
            return ResponseEntity.status(401).body("No authenticated user found");
        }

        UserDetails userDetails = (UserDetails) authentication.getPrincipal();
        Utilisateur adminUser = gestionUtilisateur.findByEmail(userDetails.getUsername());

        if (adminUser == null || adminUser.getRole() == null || adminUser.getRole().getIdRole() != Utils.ROLE_ADMIN) {
            return ResponseEntity.status(403).body("Access denied or user/role not found");
        }

        long demandeCount = gestionDemandeCreationCompte.afficherDemandeCreationCompte().size();

        return ResponseEntity.ok(demandeCount);
    }

    @GetMapping("/ListReclamation")
    public @ResponseBody ResponseEntity<?> listReclamation() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if (authentication == null) {
            return ResponseEntity.status(401).body("No authenticated user found");
        }

        UserDetails userDetails = (UserDetails) authentication.getPrincipal();
        Utilisateur adminUser = gestionUtilisateur.findByEmail(userDetails.getUsername());
        if (adminUser.getRole().getIdRole() == Utils.ROLE_ADMIN) {
            List<Reclamation> reclamations = gestionReclamation.afficherReclamation();
            return ResponseEntity.ok(reclamations);
        } else {
            return ResponseEntity.status(403).body("Access denied");
        }
    }

}
