package com.kiendey.dao;

import com.kiendey.model.Toy;

import java.util.List;

public interface ToyDAO {
    // Define methods for CRUD operations on Toy entities
    void createToy(Toy toy);
    Toy readToy(String id);
    void updateToy(Toy toy);
    void deleteToy(String id);
    List<Toy> getAllToys();
    List<Toy> getToysByCategory(String categoryId);
    List<Toy> searchToysByName(String name);
    List<Toy> searchToysByNameOrId(String term);
}
