package com.kiendey.model;

import com.kiendey.common.OrderStatus;
import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDateTime;
import java.util.List;

@Entity
@Table(name = "orders")
@Getter
@Setter
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class Order extends AbstractEntity<String> {

    @Column(name = "order_date", nullable = false)
    LocalDateTime orderDate;

    @Enumerated(EnumType.STRING)
    @Column(name = "status", nullable = false)
    OrderStatus status;

    @Column(name = "address", nullable = false)
    String address;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "coupon_id", nullable = false)
    Coupon coupon;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "customer_id", nullable = false)
    User user;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "payment_id", nullable = false)
    PaymentMethod paymentMethod;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "delivery_id", nullable = false)
    DeliveryMethod deliveryMethod;

    @OneToMany(mappedBy = "order", fetch = FetchType.LAZY)
    List<OrderItem> orderItems = new java.util.ArrayList<>();

    public String getStatusText() { // Ví dụ
        if (this.status != null) {
            switch (this.status) {
                case CHO_XU_LY: return "Chờ xử lý";
                case DA_XAC_NHAN: return "Đã xác nhận";
                case DANG_GIAO_HANG: return "Đã giao hàng";
                case HOAN_THANH: return "Đã nhận hàng";
                case DA_HUY: return "Đã hủy";
                default: return this.status.name();
            }
        }
        return "N/A";
    }

    public String getStatusBadgeClass() { // Ví dụ
        if (this.status != null) {
            switch (this.status) {
                case CHO_XU_LY: return "bg-warning text-dark";
                case DA_XAC_NHAN: return "bg-info text-dark";
                case DANG_GIAO_HANG: return "bg-primary";
                case HOAN_THANH: return "bg-success";
                case DA_HUY: return "bg-danger";
                default: return "bg-light text-dark";
            }
        }
        return "bg-light text-dark";
    }

    public String getFormattedOrderCode() {
        if (this.getId() != null && this.getId().length() >= 8) {
            return "DH" + this.getId().substring(0, 4).toUpperCase();
        }
        return "DH-N/A"; // Hoặc một giá trị mặc định khác nếu id không hợp lệ
    }
}
