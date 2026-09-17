package mz.mva.identity.service;

import java.util.HashSet;
import java.util.List;
import java.util.Set;
import java.util.UUID;
import mz.mva.identity.domain.Role;
import mz.mva.identity.domain.User;
import mz.mva.identity.domain.UserStatus;
import mz.mva.identity.dto.CreateUserRequest;
import mz.mva.identity.dto.UserAdminDto;
import mz.mva.identity.repository.RoleRepository;
import mz.mva.identity.repository.UserRepository;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

/**
 * The user-management API Phase 9a/9b's live verification kept working around
 * (linking a seeded StaffMember.userId to the bootstrap admin account, since
 * no other login could be created) -- this closes that gap.
 */
@Service
public class UserAdminService {

    private final UserRepository userRepository;
    private final RoleRepository roleRepository;
    private final PasswordEncoder passwordEncoder;

    public UserAdminService(
            UserRepository userRepository, RoleRepository roleRepository, PasswordEncoder passwordEncoder) {
        this.userRepository = userRepository;
        this.roleRepository = roleRepository;
        this.passwordEncoder = passwordEncoder;
    }

    @Transactional(readOnly = true)
    public List<UserAdminDto> findAll() {
        return userRepository.findAll().stream().map(UserAdminDto::from).toList();
    }

    @Transactional(readOnly = true)
    public UserAdminDto findById(UUID id) {
        return UserAdminDto.from(getOrThrow(id));
    }

    @Transactional
    public UserAdminDto create(CreateUserRequest request) {
        if (userRepository.findByUsername(request.username()).isPresent()) {
            throw new UserAlreadyExistsException("Username already in use: " + request.username());
        }
        if (userRepository.findByEmail(request.email()).isPresent()) {
            throw new UserAlreadyExistsException("Email already in use: " + request.email());
        }
        Set<Role> roles = resolveRoles(request.roleCodes());
        User user = new User(
                UUID.randomUUID(),
                request.username(),
                request.email(),
                passwordEncoder.encode(request.password()),
                UserStatus.ACTIVE);
        user.setRoles(roles);
        return UserAdminDto.from(userRepository.save(user));
    }

    @Transactional
    public UserAdminDto updateRoles(UUID id, Set<String> roleCodes) {
        User user = getOrThrow(id);
        user.setRoles(resolveRoles(roleCodes));
        return UserAdminDto.from(userRepository.save(user));
    }

    @Transactional
    public UserAdminDto setStatus(UUID id, UserStatus status) {
        User user = getOrThrow(id);
        user.setStatus(status);
        return UserAdminDto.from(userRepository.save(user));
    }

    private Set<Role> resolveRoles(Set<String> roleCodes) {
        List<Role> found = roleRepository.findByCodeIn(roleCodes);
        if (found.size() != roleCodes.size()) {
            Set<String> foundCodes = found.stream().map(Role::getCode).collect(java.util.stream.Collectors.toSet());
            Set<String> unknown = new HashSet<>(roleCodes);
            unknown.removeAll(foundCodes);
            throw new NotFoundException("Unknown role code(s): " + unknown);
        }
        return new HashSet<>(found);
    }

    private User getOrThrow(UUID id) {
        return userRepository.findById(id).orElseThrow(() -> new NotFoundException("User not found: " + id));
    }
}
