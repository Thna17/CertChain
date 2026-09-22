package com.certchain;

import org.springframework.boot.SpringApplication;

public class TestCertChainBackendApplication {

	public static void main(String[] args) {
		SpringApplication.from(CertChainBackendApplication::main).with(TestcontainersConfiguration.class).run(args);
	}

}
