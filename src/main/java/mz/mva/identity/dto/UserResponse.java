package mz.mva.identity.dto;

import java.util.List;

public record UserResponse(
        String id,
        String username,
        String email,
        String displayName,
        String phone,
        String profilePhotoDataUrl,
        List<String> roles,
        List<String> permissions) {
}
