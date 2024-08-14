package com.yassine.backend.Service;

import com.yassine.backend.Dao.Offre;
import org.springframework.data.jpa.repository.JpaRepository;

public interface IGestionOffre extends JpaRepository<Offre,Integer> {

}
