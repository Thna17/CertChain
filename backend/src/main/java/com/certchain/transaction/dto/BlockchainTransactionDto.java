package com.certchain.transaction.dto;

import com.certchain.transaction.BlockchainTransactionStatus;
import com.certchain.transaction.BlockchainTransactionType;
import java.time.Instant;
import java.util.UUID;

public record BlockchainTransactionDto(
    UUID id, BlockchainTransactionType transactionType, BlockchainTransactionStatus status,
    String transactionHash, String network, long chainId, String contractAddress,
    Long blockNumber, Instant blockTimestamp, Instant submittedAt, Instant confirmedAt
) {}
