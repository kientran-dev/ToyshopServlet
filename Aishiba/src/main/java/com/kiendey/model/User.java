package com.kiendey.model;

import com.kiendey.common.Gender;
import jakarta.persistence.*;
import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import lombok.*;
import lombok.experimental.FieldDefaults;

import java.time.LocalDate;
import java.util.Date;

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
    private String email;

    @Column(name = "password")
    private String password;

    @Column(name = "name", nullable = false)
    @NotBlank(message = "Name is mandatory")
    private String name;

    @Column(name = "dob")
    private LocalDate dob;

    @Enumerated(EnumType.STRING)
    @Column(name = "gender")
    private Gender gender;

    @Column(name = "phone")
    @NotBlank(message = "Phone is mandatory")
    private String phone;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "role_id", nullable = false)
    private Role role;

    @Column(name = "address")
    private String address;

    @Column(name = "is_deleted")
    private boolean isDeleted;

    // Phương thức định dạng mã khách hàng từ UUID
    public String getFormattedUserCode() {
        if (this.getId() != null && this.getId().length() >= 4) {
            return "KH" + this.getId().substring(0, 4).toUpperCase();
        }
        return "KH-N/A";
    }

    // Phương thức chuyển LocalDate sang java.util.Date
    public Date getDobAsDate() {
        if (dob != null) {
            return java.util.Date.from(dob.atStartOfDay().atZone(java.time.ZoneId.systemDefault()).toInstant());
        }
        return null;
    }
}