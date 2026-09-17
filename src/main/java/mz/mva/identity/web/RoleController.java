package mz.mva.identity.web;

import java.util.List;
import mz.mva.identity.dto.RoleDto;
import mz.mva.identity.repository.RoleRepository;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

/** Read-only this pass -- feeds the Administration workspace's role-assignment checkboxes. */
@RestController
@RequestMapping("/roles")
public class RoleController {

    private final RoleRepository roleRepository;

    public RoleController(RoleRepository roleRepository) {
        this.roleRepository = roleRepository;
    }

    @GetMapping
    @PreAuthorize("hasAuthority('ROLE_MANAGE')")
    public List<RoleDto> findAll() {
        return roleRepository.findAll().stream().map(RoleDto::from).toList();
    }
}
