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
            return results.get(0);// Trả về đối tượng đầu tiên tìm được

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
        List<Stock> stockList = new ArrayList<>();
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {

            // Bắt đầu với JOIN FETCH để lấy dữ liệu, không cần WHERE 1=1
            StringBuilder queryString = new StringBuilder("SELECT s FROM Stock s JOIN FETCH s.supplier");
            Map<String, Object> parameters = new HashMap<>();
            StringBuilder whereClause = new StringBuilder();

            // Xây dựng mệnh đề WHERE
            if (searchTerm != null && !searchTerm.trim().isEmpty()) {
                // SỬA LẠI: Tìm theo đúng trường mã định dạng (ví dụ: formattedId)
                whereClause.append(" (LOWER(s.id) LIKE LOWER(:searchTerm) OR LOWER(s.supplier.name) LIKE LOWER(:searchTerm))");
                parameters.put("searchTerm", "%" + searchTerm + "%");
            }

            if (status != null && !status.trim().isEmpty()) {
                if (!whereClause.isEmpty()) whereClause.append(" AND");
                whereClause.append(" s.status = :status");
                parameters.put("status", StockStatus.valueOf(status));
            }

            if (date != null && !date.trim().isEmpty()) {
                if (!whereClause.isEmpty()) whereClause.append(" AND");
                LocalDate localDate = LocalDate.parse(date);
                whereClause.append(" DATE(s.stockDate) = :filterDate");
                parameters.put("filterDate", localDate);
            }

            // Chỉ thêm WHERE một lần duy nhất nếu có điều kiện
            if (!whereClause.isEmpty()) {
                queryString.append(" WHERE ").append(whereClause);
            }
            queryString.append(" ORDER BY s.stockDate DESC");

            TypedQuery<Stock> query = session.createQuery(queryString.toString(), Stock.class);
            parameters.forEach(query::setParameter);
            query.setFirstResult((page - 1) * pageSize);
            query.setMaxResults(pageSize);

            stockList = query.getResultList();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return stockList;
    }

    @Override
    public int countFilteredStocks(String searchTerm, String status, String date) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {

            // Bắt đầu với câu truy vấn cơ bản, sẽ thêm JOIN nếu cần
            StringBuilder queryString = new StringBuilder("SELECT COUNT(s.id) FROM Stock s");
            Map<String, Object> parameters = new HashMap<>();
            StringBuilder whereClause = new StringBuilder();

            if (searchTerm != null && !searchTerm.trim().isEmpty()) {
                // SỬA LẠI: Thêm JOIN vào câu truy vấn và dùng alias cho supplier
                queryString = new StringBuilder("SELECT COUNT(s.id) FROM Stock s JOIN s.supplier sup");
                whereClause.append(" (LOWER(s.id) LIKE LOWER(:searchTerm) OR LOWER(sup.name) LIKE LOWER(:searchTerm))");
                parameters.put("searchTerm", "%" + searchTerm + "%");
            }

            if (status != null && !status.trim().isEmpty()) {
                if (!whereClause.isEmpty()) whereClause.append(" AND");
                whereClause.append(" s.status = :status");
                parameters.put("status", StockStatus.valueOf(status));
            }

            if (date != null && !date.trim().isEmpty()) {
                if (!whereClause.isEmpty()) whereClause.append(" AND");
                LocalDate localDate = LocalDate.parse(date);
                whereClause.append(" DATE(s.stockDate) = :filterDate");
                parameters.put("filterDate", localDate);
            }

            if (!whereClause.isEmpty()) {
                queryString.append(" WHERE ").append(whereClause);
            }

            TypedQuery<Long> query = session.createQuery(queryString.toString(), Long.class);
            parameters.forEach(query::setParameter);

            return query.getSingleResult().intValue();
        } catch (Exception e) {
            e.printStackTrace();
            return 0;
        }
    }
    // Continue implementing other methods...
}
