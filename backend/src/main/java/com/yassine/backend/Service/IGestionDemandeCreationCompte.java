package com.yassine.backend.Service;

import com.yassine.backend.Dao.DemandeCreationCompte;
import org.springframework.data.jpa.repository.JpaRepository;

public interface IGestionDemandeCreationCompte extends JpaRepository<DemandeCreationCompte,Integer> {
}
