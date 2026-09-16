package mz.mva.identity.dto;

import java.util.List;

public record LoginResponse(
        String token, String userId, String username, List<String> roles, List<String> permissions) {
}
