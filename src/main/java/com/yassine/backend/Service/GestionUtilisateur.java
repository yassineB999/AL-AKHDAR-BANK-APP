package com.yassine.backend.Service;

import com.yassine.backend.Dao.JWTUtils;
import com.yassine.backend.Dao.Utilisateur;
import com.yassine.backend.Dao.Utils;
import lombok.Data;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;
@Service
@Data
public class GestionUtilisateur implements UserDetailsService {
    @Autowired
    private GestionRole gr;

    @Autowired
    private IGestionUtilisateur u;

    @Autowired
    private IGestionRole r;

    @Autowired
    private JWTUtils jwtUtils;

    @Autowired
    private PasswordEncoder passwordEncoder;

    @Autowired
    private AuthenticationManager authenticationManager;


    public String login(Utilisateur loginRequest) {
        authenticationManager.authenticate(
                new UsernamePasswordAuthenticationToken(loginRequest.getEmail(), loginRequest.getPassword()));
        var user = u.findByEmail(loginRequest.getEmail());
        return jwtUtils.generateToken(user);
    }

    public String refreshToken(String refreshToken) {
        String email = jwtUtils.extractUsername(refreshToken);
        var user = u.findByEmail(email);
        if (jwtUtils.isTokenValid(refreshToken, user)) {
            return jwtUtils.generateToken(user);
        }
        throw new RuntimeException("Invalid refresh token");
    }


    @Override
    public UserDetails loadUserByUsername(String email) throws UsernameNotFoundException {
        return u.findByEmail(email);
    }

    // Get all users
    public List<Utilisateur> getAllUsers() {
        return u.findAll();
    }

    // Get user by ID
    public Optional<Utilisateur> getUserById(Integer id) {
        return u.findById(id);
    }

    // Update user
    public Utilisateur updateUser(Integer id, Utilisateur userDetails) {
        Utilisateur user = u.findById(id).orElseThrow(() -> new RuntimeException("User not found"));
        user.setNom(userDetails.getNom());
        user.setPrenom(userDetails.getPrenom());
        user.setAdresse(userDetails.getAdresse());
        user.setAge(userDetails.getAge());
        user.setEmail(userDetails.getEmail());
        user.setRole(userDetails.getRole());
        if (userDetails.getPassword() != null && !userDetails.getPassword().isEmpty()) {
            user.setPassword(passwordEncoder.encode(userDetails.getPassword()));
        }
        return u.save(user);
    }


    public boolean createUser(Utilisateur user){
        try{
            if(user == null) return false;

            user.setPassword(passwordEncoder.encode(user.getPassword()));

            user.setRole(gr.chercherRole(Utils.ROLE_CLIENT));
            u.save(user);
            return true;
        }
        catch(Exception e){
            System.out.println(e.getMessage());
            return false;
        }
    }

    public Utilisateur findByEmail(String email){
        return u.findByEmail(email);
    }


    // Delete user
    public void supprimerUtilisateur(Integer id) {
        u.deleteById(id);
    }
}

