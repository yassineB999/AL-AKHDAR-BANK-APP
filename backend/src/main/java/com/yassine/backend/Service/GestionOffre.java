package com.yassine.backend.Service;

import com.yassine.backend.Dao.Offre;
import com.yassine.backend.Dao.Role;
import lombok.Data;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@Data
public class GestionOffre {

            /*OPERATIONS CRUD*/
    private final IGestionOffre IGO;

    public boolean ajouterOffre(Offre o) {
        if(o == null) return false;
        IGO.save(o);
        return true;
    }

    public boolean modifierOffre(Offre o) {
        if(o == null) return false;
        IGO.save(o);
        return true;
    }

    public boolean supprimerOffre(int idOffre) {
        if(idOffre < 1) return false;
        IGO.deleteById(idOffre);
        return true;
    }

    public Offre chercherOffre(int idOffre) {
        return IGO.findById(idOffre).get();

    }
    public List<Offre> afficherOffre() {
        return IGO.findAll();
    }
}

