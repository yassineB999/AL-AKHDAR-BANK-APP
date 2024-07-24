package com.yassine.backend.Service;

import com.yassine.backend.Dao.Reclamation;
import org.springframework.data.jpa.repository.JpaRepository;

public interface IGestionReclamation extends JpaRepository<Reclamation,Integer> {
}
