package com.kiendey.model;

import com.kiendey.common.Gender;
import jakarta.persistence.*;
import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import lombok.*;
import lombok.experimental.FieldDefaults;

import java.time.LocalDate;

@Entity
@Table(name = "users")
@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
@FieldDefaults(level = AccessLevel.PRIVATE)
public class User extends AbstractEntity<String> {

    @Column(name = "email")
    @NotBlank(message = "Email is mandatory")
    @Email(message = "Email should be valid")
    String email;

    @Column(name = "password")
    String password;

    @Column(name = "name", nullable = false)
    String name;

    @Column(name = "dob")
    LocalDate dob;

    @Enumerated(EnumType.STRING)
    @Column(name = "gender")
    Gender gender;

    @Column(name = "phone")
    String phone;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "role_id", nullable = false)
    Role role;

    @Column(name = "address")
    String address;

    @Column(name = "group_name")
    String group;

    @Column(name = "note")
    String note;

    @Column(name = "facebook")
    String facebook;

    @Column(name = "customer_type")
    String customerType; // "Cá nhân" or "Công ty"

    @Column(name = "tax_code")
    String taxCode;

    @Column(name = "id_card")
    String idCard;

    @Column(name = "created_date")
    LocalDate createdDate;

    @Column(name = "creator")
    String creator;

    @Column(name = "is_deleted")
    boolean isDeleted; // Soft delete flag, default false

    // Method to format user code
    public String getFormattedUserCode() {
        if (this.getId() != null && this.getId().length() >= 8) {
            return "KH" + this.getId().substring(0, 4).toUpperCase();
        }
        return "KH-N/A";
    }
}


