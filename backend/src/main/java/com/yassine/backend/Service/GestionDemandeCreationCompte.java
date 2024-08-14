package com.yassine.backend.Service;

import com.yassine.backend.Dao.DemandeCreationCompte;
import lombok.Data;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@Data
public class GestionDemandeCreationCompte {

            /*OPERATIONS CRUD*/
    private final IGestionDemandeCreationCompte IGDCC;

    public boolean ajouterDemandeCreationCompte(DemandeCreationCompte d) {
        if(d == null) return false;
        IGDCC.save(d);
        return true;
    }

    public boolean modifierDemandeCreationCompte(DemandeCreationCompte d) {
        if(d == null) return false;
        IGDCC.save(d);
        return true;
    }
    public boolean supprimerDemandeCreationCompte(int idDemandeCreationCompte) {
        if(idDemandeCreationCompte < 1) return false;
        IGDCC.deleteById(idDemandeCreationCompte);
        return true;
    }

    public DemandeCreationCompte chercherDemandeCreationCompte(int idDemandeCreationCompte) {
        return IGDCC.findById(idDemandeCreationCompte).get();

    }

    public List<DemandeCreationCompte> afficherDemandeCreationCompte() {
        return IGDCC.findAll();
    }

}
