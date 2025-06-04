package com.kiendey.model;

import com.kiendey.common.DeliveryMethodName;
import com.kiendey.utils.DeliveryMethodNameConverter;
import jakarta.persistence.*;
import lombok.*;

import java.util.List;

@Entity
@Table(name = "deliveries")
@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class DeliveryMethod extends AbstractEntity<String>{

    //@Enumerated(EnumType.STRING)
    @Convert(converter = DeliveryMethodNameConverter.class)
    @Column(name = "method_name", nullable = false)
    DeliveryMethodName deliveryMethodName;

    @Column(name = "price")
    double price;

    @Column(name = "description")
    String description;

    @OneToMany(mappedBy = "deliveryMethod", fetch = FetchType.LAZY)
    List<Order> orders;

    public DeliveryMethod(String deliveryMethodId) {
        super();
        this.setId(deliveryMethodId);
    }
}
