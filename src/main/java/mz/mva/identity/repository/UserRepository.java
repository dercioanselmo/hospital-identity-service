package mz.mva.identity.repository;

import java.util.Optional;
import java.util.UUID;
import mz.mva.identity.domain.User;
import org.springframework.data.jpa.repository.JpaRepository;

public interface UserRepository extends JpaRepository<User, UUID> {

    Optional<User> findByUsername(String username);
}
