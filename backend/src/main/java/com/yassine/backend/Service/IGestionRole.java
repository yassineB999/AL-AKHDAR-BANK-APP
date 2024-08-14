package com.yassine.backend.Service;

import com.yassine.backend.Dao.Role;
import org.springframework.data.jpa.repository.JpaRepository;

public interface IGestionRole extends JpaRepository<Role,Integer> {

}
