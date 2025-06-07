package com.kiendey.dao.impl;

import com.kiendey.common.StockStatus;
import com.kiendey.dao.StockDAO;
import com.kiendey.model.Stock;
import com.kiendey.utils.HibernateUtil;
import jakarta.persistence.TypedQuery;
import org.hibernate.Session;
import org.hibernate.Transaction;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class StockDAOImpl implements StockDAO {
    // Implement the methods defined in StockDAO interface here
    // For example:

    @Override
    public boolean createStock(Stock stock) {
        Transaction transaction = null;
        try (var session = HibernateUtil.getSessionFactory().openSession()) {
            transaction = session.beginTransaction();
            session.persist(stock); // Save the stock object
            transaction.commit();
            return true; // Return true if creation is successful
        } catch (Exception e) {
            if (transaction != null) {
                transaction.rollback(); // Rollback in case of error
            }
            throw new RuntimeException("Error creating Stock: " + e.getMessage(), e);
        }
    }

    @Override
    public Stock readStock(String id) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            String queryString = """
                             SELECT s FROM Stock s 
                             JOIN FETCH s.supplier 
                             LEFT JOIN FETCH s.stockItems si 
                             LEFT JOIN FETCH si.toy 
                             WHERE s.id = :id
                             """;

            TypedQuery<Stock> query = session.createQuery(queryString, Stock.class);
            query.setParameter("id", id);

            // 2. Sử dụng getResultList() để tránh lỗi NoResultException nếu không tìm thấy ID
            List<Stock> results = query.getResultList();
            if (results.isEmpty()) {
                return null; // Trả về null nếu không tìm thấy
            }
            return results.getFirst(); // Trả về đối tượng đầu tiên tìm được

        } catch (Exception e) {
            // Ghi lại lỗi để tiện cho việc debug
            System.err.println("Lỗi khi đọc Stock với ID " + id + ": " + e.getMessage());
            e.printStackTrace();
            // Cân nhắc có nên ném ngoại lệ ở đây không, hoặc chỉ trả về null
            return null;
        }
    }

    @Override
    public void updateStock(Stock stock) {
        Transaction transaction = null;
        try (var session = HibernateUtil.getSessionFactory().openSession()) {
            transaction = session.beginTransaction();
            session.merge(stock);
            transaction.commit();
        } catch (Exception e) {
            if (transaction != null) {
                transaction.rollback();
            }
            throw new RuntimeException("Error updating Stock: " + e.getMessage(), e);
        }
    }

    @Override
    public void deleteStock(String id){
        Transaction transaction = null;
        try (var session = HibernateUtil.getSessionFactory().openSession()) {
            transaction = session.beginTransaction();
            Stock stock = session.get(Stock.class, id);
            if (stock != null) {
                session.remove(stock);
            } else {
                throw new RuntimeException("Stock not found with ID: " + id);
            }
            transaction.commit();
        } catch (Exception e) {
            if (transaction != null) {
                transaction.rollback();
            }
            throw new RuntimeException("Error deleting Stock: " + e.getMessage(), e);
        }
    }

    @Override
    public List<Stock> getAllStocks() {
        try (var session = HibernateUtil.getSessionFactory().openSession()) {
            return session.createQuery("FROM Stock", Stock.class).list();
        } catch (Exception e) {
            throw new RuntimeException("Error retrieving all Stocks: " + e.getMessage(), e);
        }
    }

    @Override
    public List<Stock> getStocksBySupplierId(String supplierId) {
        try (var session = HibernateUtil.getSessionFactory().openSession()) {
            return session.createQuery("FROM Stock s WHERE s.supplier.id = :userId", Stock.class)
                          .setParameter("supplierId", supplierId)
                          .list();
        } catch (Exception e) {
            throw new RuntimeException("Error retrieving Stocks by User ID: " + e.getMessage(), e);
        }
    }
    @Override
    public List<Stock> searchStocksByStatus(String status) {
        try (var session = HibernateUtil.getSessionFactory().openSession()) {
            return session.createQuery("FROM Stock s WHERE s.status = :status", Stock.class)
                          .setParameter("status", status)
                          .list();
        } catch (Exception e) {
            throw new RuntimeException("Error searching Stocks by status: " + e.getMessage(), e);
        }
    }

    @Override
    public List<Stock> getStocksByDate(LocalDateTime startDate, LocalDateTime endDate) {
        try (var session = HibernateUtil.getSessionFactory().openSession()) {
            return session.createQuery("FROM Stock s WHERE s.stockDate BETWEEN :startDate AND :endDate", Stock.class)
                    .setParameter("startDate", startDate)
                    .setParameter("endDate", endDate)
                    .list();
        } catch (Exception e) {
            throw new RuntimeException("Error retrieving Stocks by date range: " + e.getMessage(), e);
        }
    }
    @Override
    public Stock getStockById(String id) {
        try (var session = HibernateUtil.getSessionFactory().openSession()) {
            return session.get(Stock.class, id);
        } catch (Exception e) {
            throw new RuntimeException("Error retrieving Stock by ID: " + e.getMessage(), e);
        }
    }

    @Override
    public double getTotalAmount(String supplierId) {
        try (var session = HibernateUtil.getSessionFactory().openSession()) {
            return session.createQuery("SELECT SUM(si.quantity * si.toy.price) FROM Stock s JOIN s.stockItems si WHERE s.supplier.id = :supplierId", Double.class)
                          .setParameter("supplierId", supplierId)
                          .uniqueResultOptional()
                          .orElse(0.0);
        } catch (Exception e) {
            throw new RuntimeException("Error calculating total stock amount: " + e.getMessage(), e);
        }
    }
    @Override
    public double getFinalAmount(String stockId) {
        try (var session = HibernateUtil.getSessionFactory().openSession()) {
            return session.createQuery("SELECT SUM(si.quantity * si.toy.price) FROM Stock s JOIN s.stockItems si WHERE s.id = :stockId", Double.class)
                          .setParameter("stockId", stockId)
                          .uniqueResultOptional()
                          .orElse(0.0);
        } catch (Exception e) {
            throw new RuntimeException("Error calculating final amount for Stock: " + e.getMessage(), e);
        }
    }

    @Override
    public List<Stock> getStocksByPage(int pageNumber, int pageSize) {
        try (var session = HibernateUtil.getSessionFactory().openSession()) {
            return session.createQuery("FROM Stock", Stock.class)
                          .setFirstResult((pageNumber - 1) * pageSize)
                          .setMaxResults(pageSize)
                          .list();
        } catch (Exception e) {
            throw new RuntimeException("Error retrieving Stocks by page: " + e.getMessage(), e);
        }
    }

    @Override
    public long getTotalStockCount() {
        try (var session = HibernateUtil.getSessionFactory().openSession()) {
            return session.createQuery("SELECT COUNT(s) FROM Stock s", Long.class).uniqueResult();
        } catch (Exception e) {
            throw new RuntimeException("Error counting total Stocks: " + e.getMessage(), e);
        }
    }

    @Override
    public boolean updateStockStatus(String stockId, StockStatus status) {
        Transaction transaction = null;
        try (var session = HibernateUtil.getSessionFactory().openSession()) {
            transaction = session.beginTransaction();
            Stock stock = session.get(Stock.class, stockId);
            if (stock != null) {
                stock.setStatus(status);
                session.update(stock);
                transaction.commit();
                return true; // Return true if update is successful
            } else {
                throw new RuntimeException("Stock not found with ID: " + stockId);
            }
        } catch (Exception e) {
            if (transaction != null) {
                transaction.rollback(); // Rollback in case of error
            }
            throw new RuntimeException("Error updating Stock status: " + e.getMessage(), e);
        }
    }

    @Override
    public List<Stock> searchAndFilterStocks(String searchTerm, String status, String date, int page, int pageSize) {
        // Luôn trả về một danh sách rỗng nếu có lỗi, thay vì null
        List<Stock> stockList = new ArrayList<>();

        // Sử dụng try-with-resources để đảm bảo session luôn được đóng
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {

            // 1. XÂY DỰNG CÂU TRUY VẤN ĐỘNG
            // StringBuilder hiệu quả hơn khi nối chuỗi
            StringBuilder queryString = new StringBuilder("SELECT s FROM Stock s JOIN FETCH s.supplier s_sup");

            // Map để chứa các tham số, giúp tránh lỗi SQL Injection
            Map<String, Object> parameters = new HashMap<>();

            StringBuilder whereClause = new StringBuilder();

            // Thêm điều kiện tìm kiếm (searchTerm)
            if (searchTerm != null && !searchTerm.trim().isEmpty()) {
                whereClause.append(" (LOWER(s.formattedStockCode) LIKE LOWER(:searchTerm) OR LOWER(s_sup.name) LIKE LOWER(:searchTerm))");
                parameters.put("searchTerm", "%" + searchTerm + "%");
            }

            // Thêm điều kiện lọc theo trạng thái (status)
            if (status != null && !status.trim().isEmpty()) {
                if (whereClause.length() > 0) {
                    whereClause.append(" AND");
                }
                whereClause.append(" s.status = :status");
                parameters.put("status", StockStatus.valueOf(status)); // Chuyển String thành Enum
            }

            // Thêm điều kiện lọc theo ngày (date)
            if (date != null && !date.trim().isEmpty()) {
                if (whereClause.length() > 0) {
                    whereClause.append(" AND");
                }
                LocalDate localDate = LocalDate.parse(date, DateTimeFormatter.ISO_LOCAL_DATE);
                LocalDateTime startOfDay = localDate.atStartOfDay();
                LocalDateTime endOfDay = localDate.plusDays(1).atStartOfDay();

                whereClause.append(" s.stockDate >= :startDate AND s.stockDate < :endDate");
                parameters.put("startDate", startOfDay);
                parameters.put("endDate", endOfDay);
            }

            // Nối mệnh đề WHERE vào câu truy vấn chính nếu có
            if (whereClause.length() > 0) {
                queryString.append(" WHERE").append(whereClause);
            }

            // Luôn sắp xếp để kết quả nhất quán
            queryString.append(" ORDER BY s.stockDate DESC");

            // 2. TẠO QUERY VÀ GÁN THAM SỐ
            TypedQuery<Stock> query = session.createQuery(queryString.toString(), Stock.class);

            // Gán các tham số từ Map vào câu truy vấn
            for (Map.Entry<String, Object> entry : parameters.entrySet()) {
                query.setParameter(entry.getKey(), entry.getValue());
            }

            // 3. THỰC HIỆN PHÂN TRANG
            query.setFirstResult((page - 1) * pageSize);
            query.setMaxResults(pageSize);

            // 4. THỰC THI VÀ LẤY KẾT QUẢ
            stockList = query.getResultList();

        } catch (Exception e) {
            // Ghi lại lỗi để debug
            e.printStackTrace();
        }

        return stockList;
    }
    @Override
    public int countFilteredStocks(String searchTerm, String status, String date) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            // Sử dụng LEFT JOIN để không làm thay đổi kết quả đếm
            StringBuilder queryString = new StringBuilder("SELECT COUNT(s.id) FROM Stock s LEFT JOIN s.supplier s_sup");
            Map<String, Object> parameters = new HashMap<>();
            StringBuilder whereClause = new StringBuilder();

            // Xây dựng mệnh đề WHERE giống hệt như trong hàm searchAndFilterStock
            if (searchTerm != null && !searchTerm.trim().isEmpty()) {
                whereClause.append(" (LOWER(s.formattedStockCode) LIKE LOWER(:searchTerm) OR LOWER(s_sup.name) LIKE LOWER(:searchTerm))");
                parameters.put("searchTerm", "%" + searchTerm + "%");
            }

            if (status != null && !status.trim().isEmpty()) {
                if (!whereClause.isEmpty()) {
                    whereClause.append(" AND");
                }
                whereClause.append(" s.status = :status");
                // ==========================================================
                // === ĐÂY LÀ DÒNG SỬA LỖI CHÍNH ===
                // Chuyển đổi chuỗi thành Enum trước khi gán vào tham số
                parameters.put("status", StockStatus.valueOf(status));
                // ==========================================================
            }

            if (date != null && !date.trim().isEmpty()) {
                if (!whereClause.isEmpty()) {
                    whereClause.append(" AND");
                }
                LocalDate localDate = LocalDate.parse(date, DateTimeFormatter.ISO_LOCAL_DATE);
                LocalDateTime startOfDay = localDate.atStartOfDay();
                LocalDateTime endOfDay = localDate.plusDays(1).atStartOfDay();

                whereClause.append(" s.stockDate >= :startDate AND s.stockDate < :endDate");
                parameters.put("startDate", startOfDay);
                parameters.put("endDate", endOfDay);
            }

            if (!whereClause.isEmpty()) {
                queryString.append(" WHERE").append(whereClause);
            }

            TypedQuery<Long> query = session.createQuery(queryString.toString(), Long.class);

            for (Map.Entry<String, Object> entry : parameters.entrySet()) {
                query.setParameter(entry.getKey(), entry.getValue());
            }

            return query.getSingleResult().intValue();

        } catch (Exception e) {
            e.printStackTrace();
            return 0;
        }
    }
    // Continue implementing other methods...
}
