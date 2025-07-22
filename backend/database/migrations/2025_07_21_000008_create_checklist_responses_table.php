<?php
use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration {
    public function up(): void
    {
        Schema::create('checklist_responses', function (Blueprint $table) {
            $table->id();
            $table->engine = 'InnoDB';
            $table->unsignedBigInteger('checklist_id');
            $table->unsignedBigInteger('item_id');
            $table->string('value')->nullable();
            $table->string('photo_path')->nullable();
            $table->timestamps();
            $table->foreign('checklist_id')->references('id')->on('checklists');
            $table->foreign('item_id')->references('id')->on('checklist_items');
        });
    }
    public function down(): void
    {
        Schema::dropIfExists('checklist_responses');
    }
};
