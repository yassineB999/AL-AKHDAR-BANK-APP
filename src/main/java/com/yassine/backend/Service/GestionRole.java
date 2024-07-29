package com.yassine.backend.Service;

import com.yassine.backend.Dao.Role;
import lombok.Data;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@Data
public class GestionRole {
    private final IGestionRole IGR;

    public boolean ajouterRole(Role r) {
        if(r == null) return  false;
        IGR.save(r);
        return true;
    }

    public boolean modifierRole(Role r) {
        if(r == null) return  false;
        IGR.save(r);
        return true;
    }

    public boolean supprimerRole(int idRole) {
        if(idRole < 1) return  false;
        IGR.deleteById(idRole);
        return true;

    }

    public Role chercherRole(int idRole) {
        System.out.println(idRole);
        return IGR.findById(idRole).orElse(null);
    }

    public List<Role> afficherRoles() {
        return IGR.findAll();
    }
}
