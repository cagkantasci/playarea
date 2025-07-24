<?php
Route::post('/login', [AuthController::class, 'login']);
Route::post('/register', [AuthController::class, 'register']);
Route::middleware('auth:sanctum')->group(function () {
    Route::post('/logout', [AuthController::class, 'logout']);
    Route::apiResource('machines', MachineController::class);
    Route::apiResource('checklists', ChecklistController::class);
    Route::apiResource('issues', IssueController::class);
});