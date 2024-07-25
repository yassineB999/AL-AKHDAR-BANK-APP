package com.yassine.backend.Dao;

import com.fasterxml.jackson.annotation.JsonIgnore;
import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.ToString;
import org.springframework.security.core.GrantedAuthority;

import java.util.List;

@Entity
@Data
@AllArgsConstructor
@NoArgsConstructor
@ToString
public class Role implements GrantedAuthority {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int idRole;

    private String libelle;

    @OneToMany(mappedBy = "role") @JsonIgnore
    private List<Utilisateur> utilisateurs;

    @Override
    public String getAuthority() {
        return String.valueOf(idRole);
    }
}

