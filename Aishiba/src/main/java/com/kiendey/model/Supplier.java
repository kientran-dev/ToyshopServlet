package com.kiendey.model;

import jakarta.persistence.*;
import lombok.*;

import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "suppliers")
@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Supplier extends AbstractEntity<String>{
    @Column(name = "name", nullable = false)
    String name;

    @Column(name = "address")
    String address;

    @Column(name = "phone_number")
    String phoneNumber;

    @Column(name = "email")
    String email;

    @Column(name = "website")
    String website;

    @Column(name = "description")
    String description;

    @OneToMany(mappedBy = "supplier")
    List<Stock> stocks = new ArrayList<>();

    @OneToMany (mappedBy = "supplier")
    List<Toy> toys = new ArrayList<>();

    @Column(name = "is_deleted")
    boolean isDeleted ; // Trạng thái xóa mềm, mặc định là false (không bị xóa)

    @Column(name = "status")
    boolean status;

    // Phương thức mới để định dạng mã nhà cung cấp
    public String getFormattedSupplierCode() {
        if (this.getId() != null && this.getId().length() >= 8) {
            return "NCC" + this.getId().substring(0, 4).toUpperCase();
        }
        return "NCC-N/A"; // Hoặc một giá trị mặc định khác nếu id không hợp lệ
    }
}
