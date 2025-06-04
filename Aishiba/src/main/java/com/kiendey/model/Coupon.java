package com.kiendey.model;

import jakarta.persistence.*;
import lombok.*;
import java.time.LocalDate;
import java.util.List;

@Entity
@Table(name = "coupons")
@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Coupon extends AbstractEntity<String>{

    @Column(name = "start_date")
    LocalDate startDate;

    @Column(name = "end_date")
    LocalDate endDate;

    @Column(name = "discount")
    double discount;

    @Column(name = "description")
    String description;

    @OneToMany(mappedBy = "coupon")
    List<Order> orders;

    public Coupon(String couponId) {
        super();
        this.setId(couponId);
    }
    @PrePersist
    @PreUpdate
    private void toUpperCase() {
        if (this.getId() != null) {
            this.setId(this.getId().toUpperCase()) ;
        }
    }
}
