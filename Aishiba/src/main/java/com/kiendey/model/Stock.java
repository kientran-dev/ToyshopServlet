package com.kiendey.model;

import com.kiendey.common.StockStatus;
import jakarta.persistence.*;
import lombok.*;
import java.time.LocalDateTime;
import java.util.List;

@Entity
@Table(name = "stocks")
@Getter
@Setter
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class Stock extends AbstractEntity<String>{

    @Column(name = "stock_date", nullable = false)
    LocalDateTime stockDate;

    @Enumerated(EnumType.STRING)
    @Column(name = "status", nullable = false)
    StockStatus status;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "supplier_id", nullable = false)
    Supplier supplier;

    @OneToMany(mappedBy = "stock", fetch = FetchType.LAZY)
    List<StockItem> stockItems = new java.util.ArrayList<>();

    public String getFormattedStockCode() {
        if (this.getId() != null && this.getId().length() >= 8) {
            return "DN" + this.getId().substring(0, 4).toUpperCase();
        }
        return "DN-N/A"; // Hoặc một giá trị mặc định khác nếu id không hợp lệ
    }
}
