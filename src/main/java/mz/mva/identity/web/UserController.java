package mz.mva.identity.web;

import jakarta.validation.Valid;
import java.util.List;
import java.util.UUID;
import mz.mva.identity.domain.UserStatus;
import mz.mva.identity.dto.CreateUserRequest;
import mz.mva.identity.dto.UpdateUserRolesRequest;
import mz.mva.identity.dto.UserAdminDto;
import mz.mva.identity.service.UserAdminService;
import org.springframework.http.HttpStatus;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.RestController;

/**
 * The user-management API this platform has been missing since Phase 1 --
 * the one Flyway-seeded bootstrap SUPER_ADMIN was the only account that
 * could ever exist before this. See docs/security.md.
 */
@RestController
@RequestMapping("/users")
@PreAuthorize("hasAuthority('USER_MANAGE')")
public class UserController {

    private final UserAdminService userAdminService;

    public UserController(UserAdminService userAdminService) {
        this.userAdminService = userAdminService;
    }

    @GetMapping
    public List<UserAdminDto> findAll() {
        return userAdminService.findAll();
    }

    @GetMapping("/{id}")
    public UserAdminDto findById(@PathVariable UUID id) {
        return userAdminService.findById(id);
    }

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public UserAdminDto create(@Valid @RequestBody CreateUserRequest request) {
        return userAdminService.create(request);
    }

    @PutMapping("/{id}/roles")
    public UserAdminDto updateRoles(@PathVariable UUID id, @Valid @RequestBody UpdateUserRolesRequest request) {
        return userAdminService.updateRoles(id, request.roleCodes());
    }

    @PostMapping("/{id}/activate")
    public UserAdminDto activate(@PathVariable UUID id) {
        return userAdminService.setStatus(id, UserStatus.ACTIVE);
    }

    @PostMapping("/{id}/deactivate")
    public UserAdminDto deactivate(@PathVariable UUID id) {
        return userAdminService.setStatus(id, UserStatus.INACTIVE);
    }
}
