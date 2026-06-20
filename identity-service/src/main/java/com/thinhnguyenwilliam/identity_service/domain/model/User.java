package com.thinhnguyenwilliam.identity_service.domain.model;

import lombok.*;
import lombok.experimental.FieldDefaults;

import java.io.Serializable;
import java.time.LocalDate;

/**
 * Domain Model - tầng Domain (Business Core).
 * Class này là trái tim của business logic - KHÔNG phụ thuộc vào JPA, Spring, hay bất kỳ framework nào.
 * Đây là "User" theo nghĩa business, không phải nghĩa database.
 */
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
@FieldDefaults(level = AccessLevel.PRIVATE)
public class User implements Serializable {

    String id;
    String username;
    String password;
    String firstName;
    String lastName;
    LocalDate dob;

    // Business logic đặt ở đây
    public String getFullName() {
        return firstName + " " + lastName;
    }

    public boolean isAdult() {
        if (dob == null) return false;
        return dob.plusYears(18).isBefore(LocalDate.now());
    }
}
