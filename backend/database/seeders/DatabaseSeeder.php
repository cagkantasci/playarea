<?php
namespace Database\Seeders;

use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\Hash;
use App\Models\Role;
use App\Models\User;
use App\Models\Category;
use App\Models\Machine;

class DatabaseSeeder extends Seeder
{
    public function run(): void
    {
        // Roller
        $adminRole = Role::create(['name' => 'admin']);
        $userRole = Role::create(['name' => 'user']);

        // Admin kullanıcı
        User::create([
            'name' => 'Admin',
            'email' => 'admin@example.com',
            'password' => Hash::make('password'),
            'role_id' => $adminRole->id,
        ]);

        // Kategoriler
        $cat1 = Category::create(['name' => 'CNC', 'description' => 'CNC makineleri']);
        $cat2 = Category::create(['name' => 'Pres', 'description' => 'Pres makineleri']);

        // Makineler
        Machine::create(['name' => 'CNC-1', 'category_id' => $cat1->id]);
        Machine::create(['name' => 'Pres-1', 'category_id' => $cat2->id]);
    }
}
