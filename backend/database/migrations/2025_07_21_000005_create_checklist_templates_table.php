<?php
use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration {
    public function up(): void
    {
        Schema::create('checklist_templates', function (Blueprint $table) {
            $table->engine = 'InnoDB';
            $table->id();
            $table->foreignId('category_id')->constrained('categories');
            $table->string('name');
            $table->timestamps();
        });
    }
    public function down(): void
    {
        Schema::dropIfExists('checklist_templates');
    }
};
