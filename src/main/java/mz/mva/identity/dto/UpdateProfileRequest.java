package mz.mva.identity.dto;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;

/** Self-service profile update — deliberately excludes roles/status/username, admin-only fields. */
public record UpdateProfileRequest(
        String displayName, @NotBlank @Email String email, String phone, String profilePhotoDataUrl) {
}
