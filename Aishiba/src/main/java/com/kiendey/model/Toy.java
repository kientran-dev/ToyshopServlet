package com.kiendey.model;

import jakarta.persistence.*;
import lombok.*;
import lombok.experimental.FieldDefaults;
import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.UpdateTimestamp;

import java.time.LocalDateTime;

@Entity
@Table(name = "toys")
@Getter
@Setter
@Builder//Dùng @Builder sẽ giúp việc tạo đối tượng Toy trở nên linh hoạt và dễ đọc hơn.
@NoArgsConstructor
@AllArgsConstructor
@FieldDefaults(level = AccessLevel.PRIVATE)
public class Toy {
    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    @Column(name = "id")
    String id;

    @Column(name = "name", nullable = false)
    String name;

    @Column(name = "price")
    double price;

    @Column(name = "stock")
    int stock;

    @Column(name = "description", columnDefinition = "TEXT")
    String description;

    @Column(name = "origin")
    String origin;

    @Column(name = "age")
    String age;

    @Column(name = "image")
    String image;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "category_id", nullable = false)
    Category category;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "brand_id", nullable = false)
    Brand brand;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "supplier_id", nullable = false)
    Supplier supplier;

    @Column(name = "create_at")
    @CreationTimestamp
    LocalDateTime createdAt;

    @Column(name = "update_at")
    @UpdateTimestamp
    LocalDateTime updatedAt;

    @Column(name = "is_deleted")
    boolean isDeleted ; // Trạng thái xóa mềm, mặc định là false (không bị xóa)
}