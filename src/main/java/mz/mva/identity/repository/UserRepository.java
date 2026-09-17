package mz.mva.identity.repository;

import java.util.List;
import java.util.Optional;
import java.util.UUID;
import mz.mva.identity.domain.User;
import mz.mva.identity.domain.UserStatus;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

public interface UserRepository extends JpaRepository<User, UUID> {

    Optional<User> findByUsername(String username);

    Optional<User> findByEmail(String email);

    /** Phase 8f's role-wide broadcast (Notification-Amendment.md §6/§16): every active user with a given role. */
    @Query("SELECT DISTINCT u FROM User u JOIN u.roles r WHERE r.code = :roleCode AND u.status = :status")
    List<User> findByRoleCodeAndStatus(@Param("roleCode") String roleCode, @Param("status") UserStatus status);
}
