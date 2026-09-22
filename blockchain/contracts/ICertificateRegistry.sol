// SPDX-License-Identifier: MIT
pragma solidity ^0.8.34;

interface ICertificateRegistry {
  struct CertificateRecord {
    bytes32 certificateHash;
    uint64 issuedAt;
    uint64 expiresAt;
    bool revoked;
    address issuer;
  }

  event CertificateIssued(
    bytes32 indexed certificateKey,
    bytes32 indexed certificateHash,
    address indexed issuer,
    uint64 issuedAt,
    uint64 expiresAt
  );

  event CertificateRevoked(
    bytes32 indexed certificateKey,
    address indexed revokedBy,
    uint64 revokedAt
  );

  function issueCertificate(
    bytes32 certificateKey,
    bytes32 certificateHash,
    uint64 expiresAt
  ) external;

  function revokeCertificate(bytes32 certificateKey) external;

  function getCertificate(bytes32 certificateKey)
    external
    view
    returns (CertificateRecord memory);

  function verifyCertificate(
    bytes32 certificateKey,
    bytes32 expectedHash
  ) external view returns (bool exists, bool hashMatches, bool revoked, bool expired);
}

