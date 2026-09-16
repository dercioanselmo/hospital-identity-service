package mz.mva.identity.service;

import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.when;

import java.util.Optional;
import java.util.UUID;
import mz.mva.identity.domain.User;
import mz.mva.identity.domain.UserStatus;
import mz.mva.identity.dto.LoginRequest;
import mz.mva.identity.repository.UserRepository;
import mz.mva.identity.security.JwtService;
import org.junit.jupiter.api.Test;
import org.springframework.security.crypto.password.PasswordEncoder;

class AuthServiceTest {

    private final UserRepository userRepository = mock(UserRepository.class);
    private final PasswordEncoder passwordEncoder = mock(PasswordEncoder.class);
    private final JwtService jwtService = mock(JwtService.class);
    private final AuthService authService = new AuthService(userRepository, passwordEncoder, jwtService);

    @Test
    void rejectsUnknownUsername() {
        when(userRepository.findByUsername("ghost")).thenReturn(Optional.empty());

        assertThatThrownBy(() -> authService.login(new LoginRequest("ghost", "whatever")))
                .isInstanceOf(InvalidCredentialsException.class);
    }

    @Test
    void rejectsInactiveUser() {
        User inactiveUser =
                new User(UUID.randomUUID(), "joao", "joao@mva.local", "hash", UserStatus.INACTIVE);
        when(userRepository.findByUsername("joao")).thenReturn(Optional.of(inactiveUser));

        assertThatThrownBy(() -> authService.login(new LoginRequest("joao", "any-password")))
                .isInstanceOf(InvalidCredentialsException.class);
    }

    @Test
    void rejectsWrongPassword() {
        User activeUser =
                new User(UUID.randomUUID(), "maria", "maria@mva.local", "hash", UserStatus.ACTIVE);
        when(userRepository.findByUsername("maria")).thenReturn(Optional.of(activeUser));
        when(passwordEncoder.matches("wrong", "hash")).thenReturn(false);

        assertThatThrownBy(() -> authService.login(new LoginRequest("maria", "wrong")))
                .isInstanceOf(InvalidCredentialsException.class);
    }
}
