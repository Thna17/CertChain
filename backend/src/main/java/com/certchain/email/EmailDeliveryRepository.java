package com.certchain.email;

import java.util.UUID;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;

public interface EmailDeliveryRepository extends JpaRepository<EmailDelivery, UUID> {
    Page<EmailDelivery> findByStatusOrderByCreatedAtAsc(EmailDeliveryStatus status, Pageable pageable);
}
