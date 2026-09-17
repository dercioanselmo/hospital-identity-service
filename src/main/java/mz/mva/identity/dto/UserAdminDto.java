package mz.mva.identity.dto;

import java.util.List;
import java.util.UUID;
import mz.mva.identity.domain.User;
import mz.mva.identity.domain.UserStatus;

/**
 * The admin-facing user representation — separate from {@link UserResponse}
 * (used by {@code /me}) so that contract stays untouched by this addition.
 */
public record UserAdminDto(UUID id, String username, String email, UserStatus status, List<String> roles) {

    public static UserAdminDto from(User user) {
        return new UserAdminDto(
                user.getId(),
                user.getUsername(),
                user.getEmail(),
                user.getStatus(),
                user.getRoles().stream().map(role -> role.getCode()).sorted().toList());
    }
}
