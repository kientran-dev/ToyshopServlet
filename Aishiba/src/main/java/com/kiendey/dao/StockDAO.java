package com.kiendey.dao;

import com.kiendey.common.StockStatus;
import com.kiendey.model.Stock;
import com.kiendey.model.Stock;

import java.time.LocalDateTime;
import java.util.List;

public interface StockDAO {
    boolean createStock(Stock Stock);
    Stock readStock(String id);
    void updateStock(Stock Stock);
    void deleteStock(String id);
    List<Stock> getAllStocks();
    List<Stock> getStocksBySupplierId(String supplierId);
    List<Stock> searchStocksByStatus(String status);
    List<Stock> getStocksByDate(LocalDateTime startDate, LocalDateTime endDate);
    Stock getStockById(String id);
    double getTotalAmount(String supplierId);//tinh tien tong cua tat ca san pham trong kho cua 1 nha cung cap
    double getFinalAmount(String StockId);
    // Phương thức mới cho phân trang
    List<Stock> getStocksByPage(int pageNumber, int pageSize);
    long getTotalStockCount();
    boolean updateStockStatus(String stockId, StockStatus status);
    List<Stock> searchAndFilterStocks(String searchTerm, String status, String dateStr, int page, int pageSize);
    int countFilteredStocks(String searchTerm, String status, String dateStr);
}
