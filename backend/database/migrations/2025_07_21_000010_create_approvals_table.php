<?php
use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration {
    public function up(): void
    {
        Schema::create('approvals', function (Blueprint $table) {
            $table->engine = 'InnoDB';
            $table->id();
            $table->unsignedBigInteger('checklist_id');
            $table->unsignedBigInteger('approved_by');
            $table->timestamp('approved_at')->nullable();
            $table->timestamps();
            $table->foreign('checklist_id')->references('id')->on('checklists');
            $table->foreign('approved_by')->references('id')->on('users');
        });
    }
    public function down(): void
    {
        Schema::dropIfExists('approvals');
    }
};
