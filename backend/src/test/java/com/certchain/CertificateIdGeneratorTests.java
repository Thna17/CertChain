package com.certchain;

import com.certchain.certificate.CertificateIdGenerator;
import java.time.Clock;
import java.time.Instant;
import java.time.ZoneOffset;
import org.junit.jupiter.api.Test;
import org.springframework.jdbc.core.JdbcTemplate;
import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.mockito.ArgumentMatchers.anyInt;
import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

class CertificateIdGeneratorTests {
    @Test
    void usesInjectedClockAndFormatsNumber() {
        JdbcTemplate jdbc = mock(JdbcTemplate.class);
        when(jdbc.queryForObject(anyString(), eq(Long.class), anyInt())).thenReturn(42L);
        CertificateIdGenerator generator = new CertificateIdGenerator(jdbc,
            Clock.fixed(Instant.parse("2031-01-01T00:00:00Z"), ZoneOffset.UTC));
        assertEquals("CERT-2031-000042", generator.nextId());
        verify(jdbc).queryForObject(anyString(), eq(Long.class), eq(2031));
    }
}
