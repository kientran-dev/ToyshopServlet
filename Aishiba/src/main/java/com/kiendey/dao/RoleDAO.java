package com.kiendey.dao;

import com.kiendey.model.Role;

import java.util.List;

public interface RoleDAO {
    void createRole(Role role);
    Role getRoleByName(String name);
    List<Role> getAllRoles();

}