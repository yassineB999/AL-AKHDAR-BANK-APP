package com.yassine.backend;

import com.yassine.backend.Dao.Role;
import com.yassine.backend.Service.GestionRole;
import lombok.Data;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.ApplicationContext;

@SpringBootApplication
public class BackendApplication {

    public static void main(String[] args) {
        ApplicationContext ac = SpringApplication.run(BackendApplication.class, args);
        GestionRole gr = ac.getBean(GestionRole.class);

        gr.ajouterRole(new Role(1, "CLIENT", null));

        gr.ajouterRole(new Role(2, "ADMIN", null));
    }

}
