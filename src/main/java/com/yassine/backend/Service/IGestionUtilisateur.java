package com.yassine.backend.Service;

import com.yassine.backend.Dao.Utilisateur;
import org.springframework.data.jpa.repository.JpaRepository;

public interface IGestionUtilisateur extends JpaRepository<Utilisateur,Integer> {
}
