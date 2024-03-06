package com.neovision.litvin.neovision_server.model;
import com.neovision.litvin.neovision_server.model.enums.Role;
import lombok.Getter;
import lombok.Setter;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import jakarta.persistence.*;
import java.util.Collection;
import java.util.Collections;
import java.util.List;

@Entity
@Getter
@Setter
public class Client implements UserDetails {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String login;
    private String password;
    private String avatar ="/uploads/default/default-avatar.jpeg";

    private String email;
    private Role role; // "COMMANDER" або "SUBORDINATE"

    @ManyToMany
    @JoinTable(
            name = "client_session",
            joinColumns = @JoinColumn(name = "client_id"),
            inverseJoinColumns = @JoinColumn(name = "session_id"))
    private List<Session> sessions;

    @ManyToOne(cascade={CascadeType.MERGE, CascadeType.REMOVE, CascadeType.REFRESH, CascadeType.DETACH})
    @JoinColumn(name = "commander_id", referencedColumnName = "id")
    private Client commander;

    @OneToMany(mappedBy = "commander")
    private List<Client> subordinates;

    @OneToMany(mappedBy = "creator")
    private List<Session> createdSessions; // Список сесій, створених клієнтом

    @Override
    public Collection<? extends GrantedAuthority> getAuthorities() {
        return Collections.singletonList(new SimpleGrantedAuthority(role.name()));
    }

    @Override
    public String getPassword() {
        return password;
    }

    @Override
    public String getUsername() {
        return email;
    }

    @Override
    public boolean isAccountNonExpired() { return true; }

    @Override
    public boolean isAccountNonLocked() { return true; }

    @Override
    public boolean isCredentialsNonExpired() { return true; }

    @Override
    public boolean isEnabled() { return true; }
}

