package com.kiendey.dao;

import com.kiendey.model.User;

import java.util.List;

public interface UserDAO {
    // Define methods for CRUD operations on User entities
    void createUser(User user);

    User readUser(String id);

    void updateUser(User user);

    void deleteUser(String id);

    void softDeleteUser(String id);

    void restoreUser(String id);

    List<User> getAllUsers();

    List<User> searchUsersByName(String name);

    List<User> getUsersByPage(int pageNumber, int pageSize);

    List<User> getDeletedUsersByPage(int pageNumber, int pageSize);

    long getTotalUserCount();

    long getTotalDeletedUserCount();
}