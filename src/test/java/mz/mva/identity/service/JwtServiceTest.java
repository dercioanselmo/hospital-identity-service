package mz.mva.identity.service;

import static org.assertj.core.api.Assertions.assertThat;

import io.jsonwebtoken.Claims;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.security.Keys;
import java.util.List;
import java.util.UUID;
import javax.crypto.SecretKey;
import mz.mva.identity.domain.Permission;
import mz.mva.identity.domain.Role;
import mz.mva.identity.domain.User;
import mz.mva.identity.domain.UserStatus;
import mz.mva.identity.security.JwtService;
import org.junit.jupiter.api.Test;

class JwtServiceTest {

    private static final String SECRET = "test-secret-key-at-least-32-bytes-long-for-hmac";

    @Test
    void issuedTokenContainsRolesAndPermissions() {
        JwtService jwtService = new JwtService(SECRET, 60);

        Role role = new Role(UUID.randomUUID(), "DOCTOR", "Physician");
        role.getPermissions().add(new Permission(UUID.randomUUID(), "PATIENT_VIEW", "View patients"));

        User user = new User(UUID.randomUUID(), "dr.carlos", "carlos@mva.local", "hash", UserStatus.ACTIVE);
        user.getRoles().add(role);

        String token = jwtService.issueToken(user);

        SecretKey key = Keys.hmacShaKeyFor(SECRET.getBytes());
        Claims claims = Jwts.parser().verifyWith(key).build().parseSignedClaims(token).getPayload();

        assertThat(claims.getSubject()).isEqualTo(user.getId().toString());
        assertThat(claims.get("roles", List.class)).containsExactly("DOCTOR");
        assertThat(claims.get("permissions", List.class)).containsExactly("PATIENT_VIEW");
    }
}
