package com.kiendey.dao;

import com.kiendey.model.StockItem;
import java.util.List;

public interface StockItemDAO {
    List<StockItem> getLowStockItems(int threshold);
    List<StockItem> getHighStockItems(int threshold);
    List<StockItem> getOutOfStockItems();
    void addStockItem(StockItem stockItem);
    void updateStockItem(StockItem stockItem);
    StockItem getStockItemByToyId(String toyId); // Thêm phương thức này để kiểm tra tồn tại
}