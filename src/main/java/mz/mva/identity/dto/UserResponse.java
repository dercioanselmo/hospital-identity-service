package mz.mva.identity.dto;

import java.util.List;

public record UserResponse(
        String id, String username, String email, List<String> roles, List<String> permissions) {
}
