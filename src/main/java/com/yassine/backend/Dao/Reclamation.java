package com.yassine.backend.Dao;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.ToString;

import java.util.Date;

@Entity
@Data
@AllArgsConstructor
@NoArgsConstructor
@ToString
public class Reclamation {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long idReclamation;

    private Date date;
    private String description;
    private String type;
    private String status;

    @ManyToOne
    private Utilisateur utilisateur;

}
