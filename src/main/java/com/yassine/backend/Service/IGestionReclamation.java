package com.yassine.backend.Service;

import com.yassine.backend.Dao.Reclamation;
import com.yassine.backend.Dao.Utilisateur;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface IGestionReclamation extends JpaRepository<Reclamation,Integer> {
    List<Reclamation> findAllByUtilisateur(Utilisateur utilisateur);
}
