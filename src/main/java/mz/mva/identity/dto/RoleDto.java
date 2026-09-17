package mz.mva.identity.dto;

import java.util.List;
import mz.mva.identity.domain.Role;

public record RoleDto(String code, String description, List<String> permissions) {

    public static RoleDto from(Role role) {
        return new RoleDto(
                role.getCode(),
                role.getDescription(),
                role.getPermissions().stream().map(permission -> permission.getCode()).sorted().toList());
    }
}
