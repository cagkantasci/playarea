use App\Http\Controllers\ChecklistTemplateController;
use App\Http\Controllers\ChecklistItemController;
use App\Http\Controllers\ChecklistController;
use App\Http\Controllers\ChecklistResponseController;
use App\Http\Controllers\IssueController;
use App\Http\Controllers\ApprovalController;
use App\Http\Controllers\MachineController;
use App\Http\Controllers\CategoryController;
<?php
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\UserController;

Route::post('/login', [App\Http\Controllers\AuthController::class, 'login']);
Route::post('/register', [App\Http\Controllers\AuthController::class, 'register']);

Route::middleware('auth:sanctum')->group(function () {
    Route::post('/logout', [App\Http\Controllers\AuthController::class, 'logout']);
    // Diğer korumalı API uçları buraya
});

// Auth routes
Route::post('/register', [UserController::class, 'register']);
Route::post('/login', [UserController::class, 'login']);

// Makine ve kategori CRUD
Route::apiResource('machines', MachineController::class);
Route::apiResource('categories', CategoryController::class);

// Diğer ana modeller için CRUD
Route::apiResource('checklist-templates', ChecklistTemplateController::class);
Route::apiResource('checklist-items', ChecklistItemController::class);
Route::apiResource('checklists', ChecklistController::class);
Route::apiResource('checklist-responses', ChecklistResponseController::class);
Route::apiResource('issues', IssueController::class);
Route::apiResource('approvals', ApprovalController::class);
