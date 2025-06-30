package com.kiendey.dao.impl;

import com.kiendey.dao.UserDAO;
import com.kiendey.model.User;
import com.kiendey.utils.HibernateUtil;
import org.hibernate.Session;
import org.hibernate.Transaction;
import org.hibernate.query.Query;

import java.util.List;

public class UserDAOImpl implements UserDAO {

    @Override
    public void createUser(User user) {
        Session session = null;
        Transaction transaction = null;
        try {
            session = HibernateUtil.getSessionFactory().openSession();
            transaction = session.beginTransaction();
            session.persist(user);
            transaction.commit();
            session.refresh(user); // Ensure the ID is populated
        } catch (Exception e) {
            if (transaction != null) {
                transaction.rollback();
            }
            throw new RuntimeException("Error creating User: " + e.getMessage(), e);
        } finally {
            if (session != null && session.isOpen()) {
                session.close();
            }
        }
    }

    @Override
    public User readUser(String id) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            return session.get(User.class, id);
        } catch (Exception e) {
            throw new RuntimeException("Error reading User: " + e.getMessage(), e);
        }
    }

    @Override
    public void updateUser(User user) {
        Transaction transaction = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            transaction = session.beginTransaction();
            session.merge(user);
            transaction.commit();
        } catch (Exception e) {
            if (transaction != null) {
                transaction.rollback();
            }
            throw new RuntimeException("Error updating User: " + e.getMessage(), e);
        }
    }

    @Override
    public void deleteUser(String id) {
        Transaction transaction = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            transaction = session.beginTransaction();
            User user = session.get(User.class, id);
            if (user != null) {
                session.remove(user); // Physically delete the user
            }
            transaction.commit();
        } catch (Exception e) {
            if (transaction != null) {
                transaction.rollback();
            }
            throw new RuntimeException("Error deleting User: " + e.getMessage(), e);
        }
    }

    @Override
    public void softDeleteUser(String id) {
        Transaction transaction = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            transaction = session.beginTransaction();
            User user = session.get(User.class, id);
            if (user != null) {
                user.setDeleted(true);
                session.merge(user);
            }
            transaction.commit();
        } catch (Exception e) {
            if (transaction != null) {
                transaction.rollback();
            }
            throw new RuntimeException("Error soft deleting User: " + e.getMessage(), e);
        }
    }

    @Override
    public void restoreUser(String id) {
        Transaction transaction = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            transaction = session.beginTransaction();
            User user = session.get(User.class, id);
            if (user != null) {
                user.setDeleted(false);
                session.merge(user);
            }
            transaction.commit();
        } catch (Exception e) {
            if (transaction != null) {
                transaction.rollback();
            }
            throw new RuntimeException("Error restoring User: " + e.getMessage(), e);
        }
    }

    @Override
    public List<User> getAllUsers() {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            return session.createQuery("FROM User u WHERE u.isDeleted = false", User.class).list();
        } catch (Exception e) {
            throw new RuntimeException("Error getting all active Users: " + e.getMessage(), e);
        }
    }

    @Override
    public List<User> searchUsersByName(String name) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            String hql = "FROM User u WHERE u.name LIKE :name AND u.isDeleted = false";
            return session.createQuery(hql, User.class)
                    .setParameter("name", "%" + name + "%")
                    .list();
        } catch (Exception e) {
            throw new RuntimeException("Error searching active Users by name: " + e.getMessage(), e);
        }
    }

    @Override
    public List<User> getUsersByPage(int pageNumber, int pageSize) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            Query<User> query = session.createQuery("FROM User u WHERE u.isDeleted = false ORDER BY u.id DESC",
                    User.class);
            query.setFirstResult((pageNumber - 1) * pageSize);
            query.setMaxResults(pageSize);
            List<User> users = query.list();
            System.out.println("Fetched " + users.size() + " users for page " + pageNumber);
            return users;
        } catch (Exception e) {
            throw new RuntimeException("Error retrieving Users by page: " + e.getMessage(), e);
        }
    }

    @Override
    public List<User> getDeletedUsersByPage(int pageNumber, int pageSize) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            Query<User> query = session.createQuery("FROM User u WHERE u.isDeleted = true",
                    User.class);
            query.setFirstResult((pageNumber - 1) * pageSize);
            query.setMaxResults(pageSize);
            List<User> users = query.list();
            System.out.println("Fetched " + users.size() + " deleted users for page " + pageNumber);
            return users;
        } catch (Exception e) {
            throw new RuntimeException("Error retrieving deleted Users by page: " + e.getMessage(), e);
        }
    }

    @Override
    public long getTotalUserCount() {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            return session.createQuery("SELECT COUNT(u.id) FROM User u WHERE u.isDeleted = false", Long.class)
                    .uniqueResult();
        } catch (Exception e) {
            throw new RuntimeException("Error counting active Users: " + e.getMessage(), e);
        }
    }

    @Override
    public long getTotalDeletedUserCount() {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            return session.createQuery("SELECT COUNT(u.id) FROM User u WHERE u.isDeleted = true", Long.class)
                    .uniqueResult();
        } catch (Exception e) {
            throw new RuntimeException("Error counting deleted Users: " + e.getMessage(), e);
        }
    }

    @Override
    public User findByEmail(String googleEmail) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            String hql = "FROM User u WHERE u.email = :googleEmail";
            return session.createQuery(hql, User.class)
                    .setParameter("googleEmail", googleEmail)
                    .uniqueResult();
        } catch (Exception e) {
            throw new RuntimeException("Error finding User by email: " + e.getMessage(), e);
        }
    }
}