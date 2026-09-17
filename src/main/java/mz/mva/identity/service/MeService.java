package mz.mva.identity.service;

import java.util.UUID;
import mz.mva.identity.domain.User;
import mz.mva.identity.dto.ChangePasswordRequest;
import mz.mva.identity.dto.UpdateProfileRequest;
import mz.mva.identity.dto.UserResponse;
import mz.mva.identity.repository.UserRepository;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

/**
 * Self-service profile — deliberately separate from {@link UserAdminService},
 * which is gated by USER_MANAGE. Every authenticated user (any role) can read
 * and update their own profile and password; nothing here touches roles or
 * account status.
 */
@Service
public class MeService {

    /** A small avatar image only — rejects anything that would bloat the users table. */
    private static final int MAX_PHOTO_DATA_URL_LENGTH = 300_000;

    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;

    public MeService(UserRepository userRepository, PasswordEncoder passwordEncoder) {
        this.userRepository = userRepository;
        this.passwordEncoder = passwordEncoder;
    }

    @Transactional(readOnly = true)
    public UserResponse findSelf(UUID userId) {
        return toResponse(getOrThrow(userId));
    }

    @Transactional
    public UserResponse updateSelf(UUID userId, UpdateProfileRequest request) {
        User user = getOrThrow(userId);
        if (request.profilePhotoDataUrl() != null && request.profilePhotoDataUrl().length() > MAX_PHOTO_DATA_URL_LENGTH) {
            throw new IllegalArgumentException("Profile photo is too large");
        }
        if (!request.email().equals(user.getEmail())
                && userRepository.findByEmail(request.email()).isPresent()) {
            throw new UserAlreadyExistsException("Email already in use: " + request.email());
        }
        user.setDisplayName(request.displayName());
        user.setEmail(request.email());
        user.setPhone(request.phone());
        user.setProfilePhotoDataUrl(request.profilePhotoDataUrl());
        return toResponse(userRepository.save(user));
    }

    @Transactional
    public void changePassword(UUID userId, ChangePasswordRequest request) {
        User user = getOrThrow(userId);
        if (!passwordEncoder.matches(request.currentPassword(), user.getPasswordHash())) {
            throw new InvalidCredentialsException();
        }
        user.setPasswordHash(passwordEncoder.encode(request.newPassword()));
        userRepository.save(user);
    }

    private User getOrThrow(UUID userId) {
        return userRepository.findById(userId).orElseThrow(() -> new NotFoundException("User not found: " + userId));
    }

    private UserResponse toResponse(User user) {
        var roles = user.getRoles().stream().map(role -> role.getCode()).toList();
        var permissions = user.getRoles().stream()
                .flatMap(role -> role.getPermissions().stream())
                .map(permission -> permission.getCode())
                .distinct()
                .toList();
        return new UserResponse(
                user.getId().toString(),
                user.getUsername(),
                user.getEmail(),
                user.getDisplayName(),
                user.getPhone(),
                user.getProfilePhotoDataUrl(),
                roles,
                permissions);
    }
}
