package com.kiendey.dao;

import com.kiendey.model.Stock;

import java.time.LocalDateTime;
import java.util.List;

public interface StockDAO {
    void createStock(Stock Stock);
    Stock readStock(String id);
    void updateStock(Stock Stock);
    void deleteStock(String id);
    List<Stock> getAllStocks();
    List<Stock> getStocksBySupplierId(String supplierId);
    List<Stock> searchStocksByStatus(String status);
    List<Stock> getStocksByDate(LocalDateTime startDate, LocalDateTime endDate);
    Stock getStockById(String id);
    double getTotalStockAmount(String supplierId);//tinh tien tong cua tat ca san pham trong kho cua 1 nha cung cap
    double getFinalAmount(String StockId);
    // Phương thức mới cho phân trang
    List<Stock> getStocksByPage(int pageNumber, int pageSize);
    long getTotalStockCount();
}
