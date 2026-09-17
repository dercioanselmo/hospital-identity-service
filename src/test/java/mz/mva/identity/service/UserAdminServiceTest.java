package mz.mva.identity.service;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.when;

import java.util.List;
import java.util.Optional;
import java.util.Set;
import java.util.UUID;
import mz.mva.identity.domain.Role;
import mz.mva.identity.domain.User;
import mz.mva.identity.domain.UserStatus;
import mz.mva.identity.dto.CreateUserRequest;
import mz.mva.identity.dto.UserAdminDto;
import mz.mva.identity.repository.RoleRepository;
import mz.mva.identity.repository.UserRepository;
import org.junit.jupiter.api.Test;
import org.springframework.security.crypto.password.PasswordEncoder;

class UserAdminServiceTest {

    private final UserRepository userRepository = mock(UserRepository.class);
    private final RoleRepository roleRepository = mock(RoleRepository.class);
    private final PasswordEncoder passwordEncoder = mock(PasswordEncoder.class);
    private final UserAdminService service = new UserAdminService(userRepository, roleRepository, passwordEncoder);

    private final Role doctorRole = new Role(UUID.randomUUID(), "DOCTOR", "Physician");

    @Test
    void createsUserWithHashedPasswordAndResolvedRoles() {
        when(userRepository.findByUsername("carlos")).thenReturn(Optional.empty());
        when(userRepository.findByEmail("carlos@mva.local")).thenReturn(Optional.empty());
        when(roleRepository.findByCodeIn(Set.of("DOCTOR"))).thenReturn(List.of(doctorRole));
        when(passwordEncoder.encode("password123")).thenReturn("hashed");
        when(userRepository.save(any())).thenAnswer(invocation -> invocation.getArgument(0));

        UserAdminDto created = service.create(
                new CreateUserRequest("carlos", "carlos@mva.local", "password123", Set.of("DOCTOR")));

        assertThat(created.username()).isEqualTo("carlos");
        assertThat(created.roles()).containsExactly("DOCTOR");
        assertThat(created.status()).isEqualTo(UserStatus.ACTIVE);
    }

    @Test
    void rejectsDuplicateUsername() {
        when(userRepository.findByUsername("carlos"))
                .thenReturn(Optional.of(new User(UUID.randomUUID(), "carlos", "x@mva.local", "h", UserStatus.ACTIVE)));

        assertThatThrownBy(() -> service.create(
                        new CreateUserRequest("carlos", "new@mva.local", "password123", Set.of("DOCTOR"))))
                .isInstanceOf(UserAlreadyExistsException.class);
    }

    @Test
    void rejectsUnknownRoleCode() {
        when(userRepository.findByUsername("carlos")).thenReturn(Optional.empty());
        when(userRepository.findByEmail("carlos@mva.local")).thenReturn(Optional.empty());
        when(roleRepository.findByCodeIn(Set.of("NOT_A_ROLE"))).thenReturn(List.of());

        assertThatThrownBy(() -> service.create(
                        new CreateUserRequest("carlos", "carlos@mva.local", "password123", Set.of("NOT_A_ROLE"))))
                .isInstanceOf(NotFoundException.class);
    }

    @Test
    void setStatusDeactivatesUser() {
        UUID id = UUID.randomUUID();
        User user = new User(id, "carlos", "carlos@mva.local", "h", UserStatus.ACTIVE);
        when(userRepository.findById(id)).thenReturn(Optional.of(user));
        when(userRepository.save(user)).thenReturn(user);

        UserAdminDto result = service.setStatus(id, UserStatus.INACTIVE);

        assertThat(result.status()).isEqualTo(UserStatus.INACTIVE);
    }

    @Test
    void updateRolesReplacesTheFullSet() {
        UUID id = UUID.randomUUID();
        User user = new User(id, "carlos", "carlos@mva.local", "h", UserStatus.ACTIVE);
        when(userRepository.findById(id)).thenReturn(Optional.of(user));
        when(roleRepository.findByCodeIn(Set.of("DOCTOR"))).thenReturn(List.of(doctorRole));
        when(userRepository.save(user)).thenReturn(user);

        UserAdminDto result = service.updateRoles(id, Set.of("DOCTOR"));

        assertThat(result.roles()).containsExactly("DOCTOR");
    }

    @Test
    void findByRoleReturnsOnlyActiveUsersWithThatRole() {
        User active = new User(UUID.randomUUID(), "joao", "joao@mva.local", "h", UserStatus.ACTIVE);
        when(userRepository.findByRoleCodeAndStatus("STORE_KEEPER", UserStatus.ACTIVE)).thenReturn(List.of(active));

        var result = service.findByRole("STORE_KEEPER");

        assertThat(result).hasSize(1);
        assertThat(result.get(0).username()).isEqualTo("joao");
    }
}
