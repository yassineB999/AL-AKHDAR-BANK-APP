package com.yassine.backend.Dao;
import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.ToString;

import java.util.List;
import java.sql.Date;

@Entity @Data @AllArgsConstructor @NoArgsConstructor @ToString
public class DemandeCreationCompte {

    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int idDemandeCreationCompte;

    private Date date;

    @OneToOne
    private Utilisateur utilisateur;
}
