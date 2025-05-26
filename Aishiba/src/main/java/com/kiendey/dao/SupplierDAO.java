package com.kiendey.dao;

import com.kiendey.model.Supplier;

import java.util.List;

public interface SupplierDAO {
    // Define methods for CRUD operations on Supplier entities
    void createSupplier(Supplier supplier);
    Supplier readSupplier(String id);
    void updateSupplier(Supplier supplier);
    void deleteSupplier(String id);
    List<Supplier> getAllSuppliers();
    List<Supplier> searchSuppliersByName(String name);
    // Phương thức mới cho phân trang
    List<Supplier> getSuppliersByPage(int pageNumber, int pageSize);
    long getTotalSupplierCount();
}
