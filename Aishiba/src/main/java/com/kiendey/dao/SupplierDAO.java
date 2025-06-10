package com.kiendey.dao;

import com.kiendey.model.Supplier;
import java.util.List;

public interface SupplierDAO {
    void createSupplier(Supplier supplier);
    Supplier readSupplier(String id);
    void updateSupplier(Supplier supplier);
    void deleteSupplier(String id);
    List<Supplier> getAllSuppliers();
    List<Supplier> searchSuppliersByName(String name);
    List<Supplier> getSuppliersByPage(int pageNumber, int pageSize);
    long getTotalSupplierCount();
}
