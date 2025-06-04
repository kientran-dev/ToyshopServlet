package com.kiendey.dao.impl;

import com.kiendey.dao.DeliveryMethodDAO;
import com.kiendey.model.DeliveryMethod;
import com.kiendey.model.PaymentMethod;
import com.kiendey.utils.HibernateUtil;

import java.util.List;

public class DeliveryMethodDAOImpl implements DeliveryMethodDAO {
    @Override
    public List<DeliveryMethod> getAllDeliveryMethods() {
        try (var session = HibernateUtil.getSessionFactory().openSession()) {
            return session.createQuery("FROM DeliveryMethod", DeliveryMethod.class).list();
        } catch (Exception e) {
            throw new RuntimeException("Error retrieving delivery methods: " + e.getMessage(), e);
        }
    }
}
