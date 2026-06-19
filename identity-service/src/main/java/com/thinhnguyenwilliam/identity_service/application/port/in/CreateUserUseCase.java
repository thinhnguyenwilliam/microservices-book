package com.thinhnguyenwilliam.identity_service.application.port.in;

import com.thinhnguyenwilliam.identity_service.application.command.CreateUserCommand;
import com.thinhnguyenwilliam.identity_service.application.dto.UserResponse;

public interface CreateUserUseCase {
    UserResponse createUser(CreateUserCommand command);
}
