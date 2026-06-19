package com.thinhnguyenwilliam.identity_service.application.command;

import lombok.AccessLevel;
import lombok.Builder;
import lombok.Getter;
import lombok.experimental.FieldDefaults;

import java.time.LocalDate;

@Getter
@Builder
@FieldDefaults(level = AccessLevel.PRIVATE)
public class CreateUserCommand {
    String username;
    String password;
    String firstName;
    String lastName;
    LocalDate dob;
}
