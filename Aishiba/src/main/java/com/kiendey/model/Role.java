package com.kiendey.model;

import jakarta.persistence.*;
        import lombok.*;
        import lombok.experimental.FieldDefaults;

import java.util.Set;

@Entity
@Table(name = "roles")
@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
@FieldDefaults(level = AccessLevel.PRIVATE)
public class Role extends AbstractEntity<String> {

    @Column(name = "name", nullable = false, unique = true)
    String name;

    @Column(name = "description")
    String description;

    @OneToMany(mappedBy = "role")
    Set<User> users;

    @ManyToMany
    Set<Permission> permissions;

}
