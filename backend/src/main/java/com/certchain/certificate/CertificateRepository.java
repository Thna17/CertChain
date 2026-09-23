package com.certchain.certificate;

import java.util.Optional;
import java.util.UUID;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

public interface CertificateRepository extends JpaRepository<Certificate, UUID> {
    Optional<Certificate> findByIdAndOrganizationId(UUID id, UUID organizationId);
    Optional<Certificate> findByCertificateId(String certificateId);
    Page<Certificate> findByOrganizationId(UUID organizationId, Pageable pageable);

    @Query("""
        select c from Certificate c where c.organization.id = :organizationId
        and (lower(c.recipientName) like lower(concat('%', :query, '%'))
          or lower(c.programName) like lower(concat('%', :query, '%'))
          or lower(c.certificateId) like lower(concat('%', :query, '%')))
        """)
    Page<Certificate> searchByOrganization(@Param("organizationId") UUID organizationId,
        @Param("query") String query, Pageable pageable);
}
