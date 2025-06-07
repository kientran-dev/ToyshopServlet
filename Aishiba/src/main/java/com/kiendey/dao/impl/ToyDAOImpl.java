package com.kiendey.dao.impl;

import com.kiendey.dao.ToyDAO;
import com.kiendey.model.Toy;
import com.kiendey.utils.HibernateUtil;
import org.hibernate.Session;
import org.hibernate.Transaction;
import org.hibernate.query.Query;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

public class ToyDAOImpl implements ToyDAO {
    // Implement the methods defined in the ToyDAO interface
    
    @Override
    public void createToy(Toy toy) {
        Transaction transaction = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            transaction = session.beginTransaction();
            session.persist(toy); // Lưu đối tượng user
            transaction.commit();
        } catch (Exception e) {
            if (transaction != null) {
                transaction.rollback();
            }
            e.printStackTrace(); // Hoặc xử lý exception tốt hơn
        }
        
    }

    @Override
    public Toy readToy(String id) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            return session.get(Toy.class, id);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    @Override
    public void updateToy(Toy toy) {
        Transaction transaction = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            transaction = session.beginTransaction();
            session.merge(toy);
            transaction.commit();
        } catch (Exception e) {
            if (transaction != null) {
                transaction.rollback();
            }
            e.printStackTrace();
        }
    }

    @Override
    public void deleteToy(String id) {
        Transaction transaction = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            transaction = session.beginTransaction();
            Toy toy = session.get(Toy.class, id);
            if (toy != null) {
                session.remove(toy);
            }
            transaction.commit();
        } catch (Exception e) {
            if (transaction != null) {
                transaction.rollback();
            }
            e.printStackTrace();
        }
    }

    @Override
    public List<Toy> getAllToys() {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            return session.createQuery("FROM Toy", Toy.class).list();
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    @Override
    public List<Toy> getToysByCategory(String categoryId) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            String hql = "FROM Toy t WHERE t.category.id = :categoryId";
            return session.createQuery(hql, Toy.class)
                    .setParameter("categoryId", categoryId)
                    .list();
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    @Override
    public List<Toy> searchToysByName(String name) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            String hql = "FROM Toy t WHERE t.name LIKE :name";
            return session.createQuery(hql, Toy.class)
                    .setParameter("name", "%" + name + "%")
                    .list();
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    @Override
    public List<Toy> searchToysByNameOrId(String term) {
        // Luôn khởi tạo một danh sách rỗng để trả về, an toàn hơn là trả về null.
        List<Toy> results = new ArrayList<>();
        if (term == null || term.trim().isEmpty()) {
            return results;
        }
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            String hql = "FROM Toy t WHERE (lower(t.name) LIKE :term OR lower(t.id) LIKE :term) AND t.isDeleted = false ORDER BY t.createdAt DESC";
            // Tạo câu truy vấn
            Query<Toy> query = session.createQuery(hql, Toy.class);
            // Đặt tham số :term (đã được chuyển về chữ thường)
            query.setParameter("term", "%" + term.toLowerCase() + "%");
            // Tối ưu hiệu năng: Giới hạn số lượng kết quả trả về cho autocomplete là 10.
            query.setMaxResults(10);
            // Thực thi và lấy kết quả
            results = query.list();
        } catch (Exception e) {
            // Trong một ứng dụng thực tế, bạn nên dùng một thư viện ghi log (logger) thay vì printStackTrace.
            e.printStackTrace();
        }
        return results;
    }

    @Override
    public List<Toy> getToysByPage(int pageNumber, int pageSize) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            // Sắp xếp theo tên để đảm bảo thứ tự nhất quán giữa các trang
            Query<Toy> query = session.createQuery("FROM Toy t ORDER BY t.name ASC", Toy.class);
            query.setFirstResult((pageNumber - 1) * pageSize);
            query.setMaxResults(pageSize);
            return query.list();
        } catch (Exception e) {
            e.printStackTrace();
            return Collections.emptyList();
        }
    }

    @Override
    public long getTotalToyCount() {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            String hql = "SELECT COUNT(t.id) FROM Toy t WHERE t.isDeleted = false";
            return session.createQuery(hql, Long.class).uniqueResult();
        } catch (Exception e) {
            e.printStackTrace();
            return 0L;
        }
    }
}