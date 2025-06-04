package com.kiendey.dao.impl;

import com.kiendey.dao.PaymentMethodDAO;
import com.kiendey.model.PaymentMethod;
import com.kiendey.utils.HibernateUtil;

import java.util.List;

public class PaymentMethodDAOImpl implements PaymentMethodDAO {
    // Implement the methods defined in PaymentMethodDAO interface here
    // For example:

    @Override
    public List<PaymentMethod> getAllPaymentMethods() {
        try (var session = HibernateUtil.getSessionFactory().openSession()) {
            return session.createQuery("FROM PaymentMethod", PaymentMethod.class).list();
        } catch (Exception e) {
            throw new RuntimeException("Error retrieving payment methods: " + e.getMessage(), e);
        }
    }
}
