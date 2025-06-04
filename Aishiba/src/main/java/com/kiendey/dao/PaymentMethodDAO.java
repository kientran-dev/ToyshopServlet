package com.kiendey.dao;

import com.kiendey.model.PaymentMethod;

import java.util.List;

public interface PaymentMethodDAO {
    List<PaymentMethod> getAllPaymentMethods();
}
