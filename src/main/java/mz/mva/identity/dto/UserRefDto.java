package mz.mva.identity.dto;

import java.util.UUID;
import mz.mva.identity.domain.User;

/** Minimal shape for Phase 8f's role-broadcast lookup — no email/roles, unlike {@link UserAdminDto}. */
public record UserRefDto(UUID id, String username) {

    public static UserRefDto from(User user) {
        return new UserRefDto(user.getId(), user.getUsername());
    }
}
