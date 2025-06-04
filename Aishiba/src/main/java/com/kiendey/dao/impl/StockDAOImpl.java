package com.kiendey.dao.impl;

import com.kiendey.dao.StockDAO;
import com.kiendey.model.Stock;
import com.kiendey.utils.HibernateUtil;
import org.hibernate.Transaction;

import java.time.LocalDateTime;
import java.util.List;

public class StockDAOImpl implements StockDAO {
    // Implement the methods defined in StockDAO interface here
    // For example:

    @Override
    public void createStock(Stock stock) {
        Transaction transaction = null;
        try (var session = HibernateUtil.getSessionFactory().openSession()) {
            transaction = session.beginTransaction();
            session.persist(stock);
            transaction.commit();
        } catch (Exception e) {
            if (transaction != null) {
                transaction.rollback();
            }
            throw new RuntimeException("Error creating Stock: " + e.getMessage(), e);
        }
    }

    @Override
    public Stock readStock(String id) {
        try (var session = HibernateUtil.getSessionFactory().openSession()) {
            return session.get(Stock.class, id);
        } catch (Exception e) {
            throw new RuntimeException("Error reading Stock: " + e.getMessage(), e);
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
    public double getTotalStockAmount(String supplierId) {
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


    // Continue implementing other methods...
}
