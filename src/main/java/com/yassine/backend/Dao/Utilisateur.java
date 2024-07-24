package com.yassine.backend.Dao;

import com.fasterxml.jackson.annotation.JsonIgnore;
import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.ToString;

import java.util.List;

@Entity
@Data
@AllArgsConstructor
@NoArgsConstructor
@ToString
public class Utilisateur {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long idUtilisateur;

    private String password;
    private String cin;
    private String nom;
    private String prenom;
    private String numeroTelephone;
    private String email;

    @OneToOne
    private DemandeCreationCompte demandecreationcompte;
    @ManyToOne
    private Role role;
    @OneToMany(mappedBy = "utilisateur") @JsonIgnore
    private List<Offre> offres;
    @OneToMany(mappedBy = "utilisateur") @JsonIgnore
    private List<Reclamation> reclamations;

}