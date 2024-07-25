package com.yassine.backend.Dao;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.ToString;

import java.sql.Date;

@Entity @Data @AllArgsConstructor @NoArgsConstructor @ToString
public class Offre {

    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int idOffre;

    private Date dateDebut;
    private String libelle;
    private String description;
    private Date dateFin;

    @ManyToOne
    private Utilisateur utilisateur;

}