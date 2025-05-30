package com.kiendey.dao.impl;

import com.kiendey.dao.StockItemDAO;
import com.kiendey.model.StockItem;
import com.kiendey.utils.HibernateUtil;
import org.hibernate.Session;
import org.hibernate.Transaction;
import org.hibernate.query.Query;

import java.util.Collections;
import java.util.List;

public class StockItemDAOImpl implements StockItemDAO {

    @Override
    public List<StockItem> getLowStockItems(int threshold) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            // Sử dụng JOIN FETCH để tải đối tượng Toy cùng lúc với StockItem
            String hql = "FROM StockItem si JOIN FETCH si.toy WHERE si.quantity <= :threshold ORDER BY si.quantity ASC";
            Query<StockItem> query = session.createQuery(hql, StockItem.class);
            query.setParameter("threshold", threshold);
            return query.list();
        } catch (Exception e) {
            e.printStackTrace();
            return Collections.emptyList();
        }
    }

    @Override
    public List<StockItem> getHighStockItems(int threshold) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            // Sử dụng JOIN FETCH để tải đối tượng Toy cùng lúc với StockItem
            String hql = "FROM StockItem si JOIN FETCH si.toy WHERE si.quantity >= :threshold ORDER BY si.quantity DESC";
            Query<StockItem> query = session.createQuery(hql, StockItem.class);
            query.setParameter("threshold", threshold);
            return query.list();
        } catch (Exception e) {
            e.printStackTrace();
            return Collections.emptyList();
        }
    }

    @Override
    public List<StockItem> getOutOfStockItems() {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            // Sử dụng JOIN FETCH để tải đối tượng Toy cùng lúc với StockItem
            String hql = "FROM StockItem si JOIN FETCH si.toy WHERE si.quantity = 0 ORDER BY si.toy.name ASC";
            Query<StockItem> query = session.createQuery(hql, StockItem.class);
            return query.list();
        } catch (Exception e) {
            e.printStackTrace();
            return Collections.emptyList();
        }
    }

    @Override
    public void addStockItem(StockItem stockItem) {
        Transaction transaction = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            transaction = session.beginTransaction();
            session.persist(stockItem);
            transaction.commit();
        } catch (Exception e) {
            if (transaction != null) {
                transaction.rollback();
            }
            e.printStackTrace();
        }
    }

    @Override
    public void updateStockItem(StockItem stockItem) {
        Transaction transaction = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            transaction = session.beginTransaction();
            session.merge(stockItem); // Sử dụng merge để cập nhật
            transaction.commit();
        } catch (Exception e) {
            if (transaction != null) {
                transaction.rollback();
            }
            e.printStackTrace();
        }
    }

    @Override
    public StockItem getStockItemByToyId(String toyId) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            // Sử dụng JOIN FETCH để tải Toy cùng lúc
            String hql = "FROM StockItem si JOIN FETCH si.toy WHERE si.toy.id = :toyId";
            Query<StockItem> query = session.createQuery(hql, StockItem.class);
            query.setParameter("toyId", toyId);
            return query.uniqueResult(); // uniqueResult() để lấy một kết quả duy nhất hoặc null
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }
}