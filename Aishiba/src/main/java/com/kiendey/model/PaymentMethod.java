package com.kiendey.model;

import com.kiendey.common.PaymentMethodName;
import com.kiendey.utils.PaymentMethodNameConverter;
import jakarta.persistence.*;
import lombok.*;

import java.util.List;

@Entity
@Table(name = "payments")
@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class PaymentMethod extends AbstractEntity <String>{

    //@Enumerated(EnumType.STRING)
    // Giả sử tên cột trong DB là "method_name" hoặc tương tự
    // Nếu không dùng autoApply=true trong converter, bạn cần dòng @Convert này:
    @Convert(converter = PaymentMethodNameConverter.class)
    @Column(name = "method_name")
    PaymentMethodName paymentMethod;

    @OneToMany(mappedBy = "paymentMethod", fetch = FetchType.LAZY)
    List<Order> orders;

}
