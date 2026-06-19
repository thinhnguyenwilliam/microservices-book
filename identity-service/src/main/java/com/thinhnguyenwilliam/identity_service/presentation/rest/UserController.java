package com.thinhnguyenwilliam.identity_service.presentation.rest;

import com.thinhnguyenwilliam.identity_service.application.command.CreateUserCommand;
import com.thinhnguyenwilliam.identity_service.application.dto.UserRequest;
import com.thinhnguyenwilliam.identity_service.application.dto.UserResponse;
import com.thinhnguyenwilliam.identity_service.application.port.in.CreateUserUseCase;
import lombok.AccessLevel;
import lombok.RequiredArgsConstructor;
import lombok.experimental.FieldDefaults;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/users")
@RequiredArgsConstructor
@FieldDefaults(level = AccessLevel.PRIVATE, makeFinal = true)
public class UserController {

    CreateUserUseCase createUserUseCase;

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public UserResponse createUser(@RequestBody UserRequest request) {
        // Map Request DTO to Command
        CreateUserCommand command = CreateUserCommand.builder()
                .username(request.getUsername())
                .password(request.getPassword())
                .firstName(request.getFirstName())
                .lastName(request.getLastName())
                .dob(request.getDob())
                .build();

        // Execute Use Case
        return createUserUseCase.createUser(command);
    }
}
