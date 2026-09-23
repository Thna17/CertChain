package com.certchain.transaction;

import com.certchain.certificate.Certificate;
import java.util.List;
import java.util.UUID;
import org.springframework.data.jpa.repository.JpaRepository;

public interface BlockchainTransactionRepository extends JpaRepository<BlockchainTransaction, UUID> {
    List<BlockchainTransaction> findByCertificateAndTransactionTypeOrderByCreatedAtDesc(
        Certificate certificate, BlockchainTransactionType transactionType);
    List<BlockchainTransaction> findByCertificateIdAndTransactionTypeOrderByCreatedAtDesc(
        UUID certificateId, BlockchainTransactionType transactionType);
}
