package com.yassine.backend.Dao;
import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.ToString;

import java.time.LocalDateTime;
import java.util.List;
import java.sql.Date;

@Entity @Data @AllArgsConstructor @NoArgsConstructor @ToString
public class DemandeCreationCompte {

    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer idDemandeCreationCompte;

    private LocalDateTime date;

    @PrePersist
    public void prePersist() {
        date = LocalDateTime.now();
    }

    @OneToOne(cascade = CascadeType.REMOVE)
    private Utilisateur utilisateur;

}
