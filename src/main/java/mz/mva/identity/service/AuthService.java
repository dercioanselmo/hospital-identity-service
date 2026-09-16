package mz.mva.identity.service;

import mz.mva.identity.domain.User;
import mz.mva.identity.dto.LoginRequest;
import mz.mva.identity.dto.LoginResponse;
import mz.mva.identity.repository.UserRepository;
import mz.mva.identity.security.JwtService;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

@Service
public class AuthService {

    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;
    private final JwtService jwtService;

    public AuthService(UserRepository userRepository, PasswordEncoder passwordEncoder, JwtService jwtService) {
        this.userRepository = userRepository;
        this.passwordEncoder = passwordEncoder;
        this.jwtService = jwtService;
    }

    public LoginResponse login(LoginRequest request) {
        User user = userRepository
                .findByUsername(request.username())
                .orElseThrow(InvalidCredentialsException::new);

        if (!user.isActive() || !passwordEncoder.matches(request.password(), user.getPasswordHash())) {
            throw new InvalidCredentialsException();
        }

        String token = jwtService.issueToken(user);
        return new LoginResponse(
                token,
                user.getId().toString(),
                user.getUsername(),
                user.getRoles().stream().map(role -> role.getCode()).toList(),
                user.getRoles().stream()
                        .flatMap(role -> role.getPermissions().stream())
                        .map(permission -> permission.getCode())
                        .distinct()
                        .toList());
    }
}
