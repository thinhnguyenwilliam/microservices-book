package com.thinhnguyenwilliam.identity_service.infrastructure.persistence.adapter;

import com.thinhnguyenwilliam.identity_service.application.port.out.UserRepositoryPort;
import com.thinhnguyenwilliam.identity_service.domain.model.User;
import com.thinhnguyenwilliam.identity_service.infrastructure.persistence.entity.UserEntity;
import com.thinhnguyenwilliam.identity_service.infrastructure.persistence.repository.JpaUserRepository;
import lombok.AccessLevel;
import lombok.RequiredArgsConstructor;
import lombok.experimental.FieldDefaults;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.cache.annotation.CachePut;
import org.springframework.stereotype.Component;

import java.util.Optional;

@Component
@RequiredArgsConstructor
@FieldDefaults(level = AccessLevel.PRIVATE, makeFinal = true)
public class UserRepositoryAdapter implements UserRepositoryPort {

    JpaUserRepository jpaUserRepository;

    @Override
    @CachePut(value = "users", key = "#user.username")
    public User save(User user) {
        // Convert Domain to Entity
        UserEntity entity = UserEntity.builder()
                .id(user.getId())
                .username(user.getUsername())
                .password(user.getPassword())
                .firstName(user.getFirstName())
                .lastName(user.getLastName())
                .dob(user.getDob())
                .build();

        // Save Entity
        UserEntity savedEntity = jpaUserRepository.save(entity);

        // Convert back to Domain
        return toDomain(savedEntity);
    }

    @Override
    @Cacheable(value = "users", key = "#username")
    public Optional<User> findByUsername(String username) {
        return jpaUserRepository.findByUsername(username)
                .map(this::toDomain);
    }

    private User toDomain(UserEntity entity) {
        return User.builder()
                .id(entity.getId())
                .username(entity.getUsername())
                .password(entity.getPassword())
                .firstName(entity.getFirstName())
                .lastName(entity.getLastName())
                .dob(entity.getDob())
                .build();
    }
}
