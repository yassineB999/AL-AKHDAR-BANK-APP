package com.yassine.backend.Service;

import com.yassine.backend.Dao.Reclamation;
import com.yassine.backend.Dao.Utilisateur;
import lombok.Data;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@Data
public class GestionReclamation {
    private final IGestionReclamation IGR;

    public boolean ajouterReclamation(Reclamation r) {
        if(r == null) return false;
        IGR.save(r);
        return true;
    }
    public boolean modifierReclamation(Reclamation r) {
        if(r == null) return false;
        IGR.save(r);
        return true;
    }

    public boolean supprimerReclamation(int idReclamation) {
        if(idReclamation < 1) return false;
        IGR.deleteById(idReclamation);
        return true;
    }

    public Reclamation chercherReclamation(int idReclamation) {
       return IGR.findById(idReclamation).get();

    }

    public List<Reclamation> afficherReclamation() {
        return IGR.findAll();
    }

    public  List<Reclamation> findAllByUtilisateur(Utilisateur utilisateur) {
        return IGR.findAllByUtilisateur(utilisateur);
    }
}
