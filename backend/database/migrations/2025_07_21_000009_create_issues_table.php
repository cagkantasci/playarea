<?php
use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration {
    public function up(): void
    {
        Schema::create('issues', function (Blueprint $table) {
            $table->engine = 'InnoDB';
            $table->id();
            $table->unsignedBigInteger('checklist_id');
            $table->text('description');
            $table->string('image_path')->nullable();
            $table->boolean('is_resolved')->default(false);
            $table->timestamps();
            $table->foreign('checklist_id')->references('id')->on('checklists');
        });
    }
    public function down(): void
    {
        Schema::dropIfExists('issues');
    }
};
