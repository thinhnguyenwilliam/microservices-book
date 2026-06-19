package com.thinhnguyenwilliam.identity_service.application.port.out;

import com.thinhnguyenwilliam.identity_service.domain.model.User;

import java.util.Optional;

public interface UserRepositoryPort {
    User save(User user);
    Optional<User> findByUsername(String username);
}
