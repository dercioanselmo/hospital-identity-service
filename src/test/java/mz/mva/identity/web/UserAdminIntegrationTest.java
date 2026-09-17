package mz.mva.identity.web;

import static org.assertj.core.api.Assertions.assertThat;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.test.web.client.TestRestTemplate;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.test.context.DynamicPropertyRegistry;
import org.springframework.test.context.DynamicPropertySource;
import org.testcontainers.containers.PostgreSQLContainer;
import org.testcontainers.junit.jupiter.Container;
import org.testcontainers.junit.jupiter.Testcontainers;

/**
 * Exercises the full admin-creates-a-user round trip: create -> the new user
 * can actually log in and gets that role's real permissions in their JWT.
 * This is the exact gap Phase 9a/9b's live verification had been working
 * around by reusing the bootstrap admin account instead.
 */
@Testcontainers
@SpringBootTest(webEnvironment = SpringBootTest.WebEnvironment.RANDOM_PORT)
class UserAdminIntegrationTest {

    @Container
    static PostgreSQLContainer<?> postgres = new PostgreSQLContainer<>("postgres:16-alpine");

    @DynamicPropertySource
    static void datasourceProperties(DynamicPropertyRegistry registry) {
        registry.add("spring.datasource.url", postgres::getJdbcUrl);
        registry.add("spring.datasource.username", postgres::getUsername);
        registry.add("spring.datasource.password", postgres::getPassword);
        registry.add("eureka.client.enabled", () -> "false");
        registry.add("eureka.client.register-with-eureka", () -> "false");
        registry.add("eureka.client.fetch-registry", () -> "false");
    }

    @Autowired
    private TestRestTemplate restTemplate;

    private String adminToken() {
        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_JSON);
        HttpEntity<String> request =
                new HttpEntity<>("{\"username\":\"admin\",\"password\":\"ChangeMe123!\"}", headers);
        ResponseEntity<String> response = restTemplate.postForEntity("/auth/login", request, String.class);
        String body = response.getBody();
        return body.substring(body.indexOf("\"token\":\"") + 9, body.indexOf("\",", body.indexOf("\"token\":\"")));
    }

    private HttpEntity<String> authedJson(String token, String body) {
        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_JSON);
        headers.setBearerAuth(token);
        return new HttpEntity<>(body, headers);
    }

    @Test
    void adminCreatesADoctorUserWhoCanThenLoginWithDoctorPermissions() {
        String token = adminToken();

        ResponseEntity<String> createResponse = restTemplate.exchange(
                "/users",
                HttpMethod.POST,
                authedJson(
                        token,
                        "{\"username\":\"dra.ana\",\"email\":\"ana@mva.local\",\"password\":\"password123\","
                                + "\"roleCodes\":[\"DOCTOR\"]}"),
                String.class);

        assertThat(createResponse.getStatusCode().value()).isEqualTo(201);
        assertThat(createResponse.getBody()).contains("\"username\":\"dra.ana\"").contains("DOCTOR");

        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_JSON);
        ResponseEntity<String> loginResponse = restTemplate.postForEntity(
                "/auth/login",
                new HttpEntity<>("{\"username\":\"dra.ana\",\"password\":\"password123\"}", headers),
                String.class);

        assertThat(loginResponse.getStatusCode().value()).isEqualTo(200);
        assertThat(loginResponse.getBody()).contains("CLINICAL_RECORD_VIEW").contains("CLINICAL_ORDER_CREATE");
    }

    @Test
    void nonAdminCannotCreateUsers() {
        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_JSON);
        restTemplate.exchange(
                "/users",
                HttpMethod.POST,
                authedJson(
                        adminToken(),
                        "{\"username\":\"plain.doctor\",\"email\":\"plain@mva.local\",\"password\":\"password123\","
                                + "\"roleCodes\":[\"DOCTOR\"]}"),
                String.class);

        ResponseEntity<String> doctorLogin = restTemplate.postForEntity(
                "/auth/login",
                new HttpEntity<>("{\"username\":\"plain.doctor\",\"password\":\"password123\"}", headers),
                String.class);
        String doctorBody = doctorLogin.getBody();
        String doctorToken =
                doctorBody.substring(doctorBody.indexOf("\"token\":\"") + 9, doctorBody.indexOf("\",", doctorBody.indexOf("\"token\":\"")));

        ResponseEntity<String> response = restTemplate.exchange(
                "/users",
                HttpMethod.POST,
                authedJson(
                        doctorToken,
                        "{\"username\":\"should.fail\",\"email\":\"fail@mva.local\",\"password\":\"password123\","
                                + "\"roleCodes\":[\"DOCTOR\"]}"),
                String.class);

        assertThat(response.getStatusCode().value()).isEqualTo(403);
    }
}
