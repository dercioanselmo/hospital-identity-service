package mz.mva.identity.web;

import jakarta.validation.Valid;
import java.util.UUID;
import mz.mva.identity.dto.ChangePasswordRequest;
import mz.mva.identity.dto.UpdateProfileRequest;
import mz.mva.identity.dto.UserResponse;
import mz.mva.identity.service.MeService;
import org.springframework.http.HttpStatus;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.RestController;

/** Self-service profile — any authenticated user, regardless of role. */
@RestController
public class MeController {

    private final MeService meService;

    public MeController(MeService meService) {
        this.meService = meService;
    }

    @GetMapping("/me")
    public UserResponse me(Authentication authentication) {
        return meService.findSelf(subject(authentication));
    }

    @PutMapping("/me")
    public UserResponse updateMe(Authentication authentication, @Valid @RequestBody UpdateProfileRequest request) {
        return meService.updateSelf(subject(authentication), request);
    }

    @PostMapping("/me/change-password")
    @ResponseStatus(HttpStatus.NO_CONTENT)
    public void changePassword(Authentication authentication, @Valid @RequestBody ChangePasswordRequest request) {
        meService.changePassword(subject(authentication), request);
    }

    private UUID subject(Authentication authentication) {
        return UUID.fromString((String) authentication.getPrincipal());
    }
}
