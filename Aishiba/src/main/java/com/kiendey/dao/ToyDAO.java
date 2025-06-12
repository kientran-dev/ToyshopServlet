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
    List<Toy> getToysByPage(int pageNumber, int pageSize);
    long getTotalToyCount();
    /**
     * HÀM MỚI: Đếm số lượng sản phẩm (mẫu mã) trong mỗi danh mục.
     * @return Một List, mỗi phần tử là một Object[] chứa:
     * - Object[0]: Tên danh mục (String)
     * - Object[1]: Số lượng sản phẩm trong danh mục đó (Long)
     */
    List<Object[]> countToysByCategory();
    Toy findById(String id);
    boolean softDeleteToys(List<Integer> idsToDelete);
}
