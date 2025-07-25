<?php

namespace Tests\Feature;

use Illuminate\Foundation\Testing\RefreshDatabase;
use Tests\TestCase;

class ApiTest extends TestCase
{
    use RefreshDatabase;

    public function test_api_endpoints_are_accessible(): void
    {
        // Test API routes are defined
        $response = $this->getJson('/api/issues');
        $response->assertStatus(200);

        $response = $this->getJson('/api/machines');
        $response->assertStatus(200);

        $response = $this->getJson('/api/checklists');
        $response->assertStatus(200);
    }

    public function test_login_endpoint_exists(): void
    {
        $response = $this->postJson('/api/login', [
            'email' => 'test@example.com',
            'password' => 'password123'
        ]);
        
        // Should return validation error or auth error, not 404
        $this->assertNotEquals(404, $response->status());
    }
}
