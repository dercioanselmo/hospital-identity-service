package mz.mva.identity.domain;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import java.util.UUID;

/**
 * Lightweight local reference to a department. The Administration service is the
 * source of truth for hospital structure — this table only exists so Identity can
 * enforce department-aware authorization without calling out on every request.
 */
@Entity
@Table(name = "departments_ref")
public class DepartmentRef {

    @Id
    private UUID id;

    @Column(nullable = false, unique = true)
    private String code;

    @Column(nullable = false)
    private String name;

    protected DepartmentRef() {
    }

    public DepartmentRef(UUID id, String code, String name) {
        this.id = id;
        this.code = code;
        this.name = name;
    }

    public UUID getId() {
        return id;
    }

    public String getCode() {
        return code;
    }

    public String getName() {
        return name;
    }
}
