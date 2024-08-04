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
            Utilisateur updatedUser = gestionUtilisateur.updateUser(idUser, utilisateur);
            return ResponseEntity.ok(updatedUser);
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

                Utilisateur updatedAdmin = gestionUtilisateur.updateUser(adminUser.getIdUtilisateur(), utilisateur);
                return ResponseEntity.ok(updatedAdmin);
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
    @GetMapping("/DetailsDemandes/{idDemandes}")
    public ResponseEntity<?> detailsDemandes(@PathVariable int idDemandes ) {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if (authentication == null) {
            return ResponseEntity.status(401).body("No authenticated user found");
        }

        UserDetails userDetails = (UserDetails) authentication.getPrincipal();
        Utilisateur adminUser = gestionUtilisateur.findByEmail(userDetails.getUsername());

        if (adminUser == null) {
            return ResponseEntity.status(404).body("User not found");
        }

        DemandeCreationCompte demandecreationcompte = gestionDemandeCreationCompte.chercherDemandeCreationCompte(idDemandes);
        return ResponseEntity.ok(demandecreationcompte);
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

    @PostMapping("/TotalReclamation")
    public ResponseEntity<?> totalReclamation() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if (authentication == null) {
            return ResponseEntity.status(401).body("No authenticated user found");
        }

        UserDetails userDetails = (UserDetails) authentication.getPrincipal();
        Utilisateur adminUser = gestionUtilisateur.findByEmail(userDetails.getUsername());

        if (adminUser == null || adminUser.getRole() == null || adminUser.getRole().getIdRole() != Utils.ROLE_ADMIN) {
            return ResponseEntity.status(403).body("Access denied or user/role not found");
        }

        long ReclamationCount = gestionReclamation.afficherReclamation().size();

        return ResponseEntity.ok(ReclamationCount);
    }

    @GetMapping("/DetailsReclamation/{idReclamation}")
    public ResponseEntity<?> detailsReclamation(@PathVariable int idReclamation ) {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if (authentication == null) {
            return ResponseEntity.status(401).body("No authenticated user found");
        }

        UserDetails userDetails = (UserDetails) authentication.getPrincipal();
        Utilisateur adminUser = gestionUtilisateur.findByEmail(userDetails.getUsername());

        if (adminUser == null) {
            return ResponseEntity.status(404).body("User not found");
        }

        Reclamation reclamations = gestionReclamation.chercherReclamation(idReclamation);

        return ResponseEntity.ok(reclamations);
    }


    @GetMapping("/ListOffre")
    public ResponseEntity<?> listOffres() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if (authentication == null) {
            return ResponseEntity.status(401).body("No authenticated user found");
        }

        UserDetails userDetails = (UserDetails) authentication.getPrincipal();
        Utilisateur adminUser = gestionUtilisateur.findByEmail(userDetails.getUsername());
        if (adminUser.getRole().getIdRole() == Utils.ROLE_ADMIN) {
            List<Offre> offres = gestionOffre.afficherOffre();
            return ResponseEntity.ok(offres);
        } else {
            return ResponseEntity.status(403).body("Access denied");
        }
    }
    @PostMapping("/addOffre")
    public ResponseEntity<?> addOffre(@RequestBody Offre offre) {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if (authentication == null) {
            return ResponseEntity.status(401).body("No authenticated user found");
        }

        UserDetails userDetails = (UserDetails) authentication.getPrincipal();
        Utilisateur adminUser = gestionUtilisateur.findByEmail(userDetails.getUsername());
        if (adminUser.getRole().getIdRole() == Utils.ROLE_ADMIN) {
            try {
                offre.setUtilisateur(adminUser); // Set the utilisateur field to the authenticated user
                boolean isAdded = gestionOffre.ajouterOffre(offre);
                if (isAdded) {
                    return ResponseEntity.ok(offre);
                } else {
                    return ResponseEntity.status(400).body("Error adding offer");
                }
            } catch (Exception e) {
                return ResponseEntity.status(500).body("Error adding offer: " + e.getMessage());
            }
        } else {
            return ResponseEntity.status(403).body("Access denied");
        }
    }


    @PutMapping("/updateOffre/{idOffre}")
    public ResponseEntity<?> updateOffre(@PathVariable int idOffre, @RequestBody Offre updatedOffre) {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if (authentication == null) {
            return ResponseEntity.status(401).body("No authenticated user found");
        }

        UserDetails userDetails = (UserDetails) authentication.getPrincipal();
        Utilisateur adminUser = gestionUtilisateur.findByEmail(userDetails.getUsername());
        if (adminUser.getRole().getIdRole() == Utils.ROLE_ADMIN) {
            Offre existingOffre = gestionOffre.chercherOffre(idOffre);
            if (existingOffre != null) {
                try {
                    existingOffre.setDateDebut(updatedOffre.getDateDebut());
                    existingOffre.setLibelle(updatedOffre.getLibelle());
                    existingOffre.setDescription(updatedOffre.getDescription());
                    existingOffre.setDateFin(updatedOffre.getDateFin());
                    boolean isUpdated = gestionOffre.modifierOffre(existingOffre);
                    if (isUpdated) {
                        return ResponseEntity.ok(existingOffre);
                    } else {
                        return ResponseEntity.status(400).body("Error updating offer");
                    }
                } catch (Exception e) {
                    return ResponseEntity.status(500).body("Error updating offer: " + e.getMessage());
                }
            } else {
                return ResponseEntity.status(404).body("Offer not found");
            }
        } else {
            return ResponseEntity.status(403).body("Access denied");
        }
    }

    @DeleteMapping("/deleteOffre/{idOffre}")
    public ResponseEntity<?> deleteOffre(@PathVariable int idOffre) {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if (authentication == null) {
            return ResponseEntity.status(401).body("No authenticated user found");
        }

        UserDetails userDetails = (UserDetails) authentication.getPrincipal();
        Utilisateur adminUser = gestionUtilisateur.findByEmail(userDetails.getUsername());
        if (adminUser.getRole().getIdRole() == Utils.ROLE_ADMIN) {
            try {
                boolean isDeleted = gestionOffre.supprimerOffre(idOffre);
                if (isDeleted) {
                    return ResponseEntity.ok("Offer deleted successfully");
                } else {
                    return ResponseEntity.status(404).body("Offer not found");
                }
            } catch (Exception e) {
                return ResponseEntity.status(500).body("Error deleting offer: " + e.getMessage());
            }
        } else {
            return ResponseEntity.status(403).body("Access denied");
        }
    }
    @PostMapping("/TotalOffre")
    public ResponseEntity<?> totalOffres() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if (authentication == null) {
            return ResponseEntity.status(401).body("No authenticated user found");
        }

        UserDetails userDetails = (UserDetails) authentication.getPrincipal();
        Utilisateur adminUser = gestionUtilisateur.findByEmail(userDetails.getUsername());

        if (adminUser == null || adminUser.getRole() == null || adminUser.getRole().getIdRole() != Utils.ROLE_ADMIN) {
            return ResponseEntity.status(403).body("Access denied or user/role not found");
        }

        long offreCount = gestionOffre.afficherOffre().size();

        return ResponseEntity.ok(offreCount);
    }
}
