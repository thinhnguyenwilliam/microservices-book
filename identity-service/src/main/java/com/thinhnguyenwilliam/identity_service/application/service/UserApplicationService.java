package com.thinhnguyenwilliam.identity_service.application.service;

import com.thinhnguyenwilliam.identity_service.application.command.CreateUserCommand;
import com.thinhnguyenwilliam.identity_service.application.dto.UserResponse;
import com.thinhnguyenwilliam.identity_service.application.port.in.CreateUserUseCase;
import com.thinhnguyenwilliam.identity_service.application.port.out.UserRepositoryPort;
import com.thinhnguyenwilliam.identity_service.domain.model.User;
import lombok.AccessLevel;
import lombok.RequiredArgsConstructor;
import lombok.experimental.FieldDefaults;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
@FieldDefaults(level = AccessLevel.PRIVATE, makeFinal = true)
public class UserApplicationService implements CreateUserUseCase {

    UserRepositoryPort userRepositoryPort;

    @Override
    public UserResponse createUser(CreateUserCommand command) {
        // 1. Convert Command to Domain Model
        User user = User.builder()
                .username(command.getUsername())
                .password(command.getPassword()) // Note: Should hash password in real app
                .firstName(command.getFirstName())
                .lastName(command.getLastName())
                .dob(command.getDob())
                .build();

        // 2. Save using Port Out
        User savedUser = userRepositoryPort.save(user);

        // 3. Convert Domain Model to Response DTO
        return UserResponse.builder()
                .id(savedUser.getId())
                .username(savedUser.getUsername())
                .firstName(savedUser.getFirstName())
                .lastName(savedUser.getLastName())
                .dob(savedUser.getDob())
                .build();
    }
}
