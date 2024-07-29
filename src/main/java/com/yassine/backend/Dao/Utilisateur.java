package com.yassine.backend.Dao;

import java.util.Collection;
import java.util.Collections;
import com.fasterxml.jackson.annotation.JsonIgnore;
import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.ToString;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;

import java.util.List;

@Entity
@Data
@AllArgsConstructor
@NoArgsConstructor
@ToString
public class Utilisateur implements UserDetails {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer idUtilisateur;

    private String password;
    private String cin;
    private String nom;
    private String prenom;
    private String numerotelephone;
    @Column(unique = true)
    private String email;
    private String adresse;
    private String age;


    @OneToOne @JsonIgnore
    private DemandeCreationCompte demandecreationcompte;
    @ManyToOne
    private Role role;
    @OneToMany(mappedBy = "utilisateur") @JsonIgnore
    private List<Offre> offres;
    @OneToMany(mappedBy = "utilisateur") @JsonIgnore
    private List<Reclamation> reclamations;

    @Override @JsonIgnore
    public Collection<? extends GrantedAuthority> getAuthorities() {
        return Collections.singleton(role);
    }

    @Override @JsonIgnore
    public String getUsername() {
        return email;
    }

    @Override @JsonIgnore
    public boolean isAccountNonExpired() {
        return true;
    }

    @Override @JsonIgnore
    public boolean isAccountNonLocked() {
        return true;
    }

    @Override @JsonIgnore
    public boolean isCredentialsNonExpired() {
        return true;
    }

    @Override @JsonIgnore
    public boolean isEnabled() {
        return true;
    }
}

