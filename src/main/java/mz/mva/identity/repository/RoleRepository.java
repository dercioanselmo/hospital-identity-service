package mz.mva.identity.repository;

import java.util.List;
import java.util.Set;
import java.util.UUID;
import mz.mva.identity.domain.Role;
import org.springframework.data.jpa.repository.JpaRepository;

public interface RoleRepository extends JpaRepository<Role, UUID> {

    List<Role> findByCodeIn(Set<String> codes);
}
