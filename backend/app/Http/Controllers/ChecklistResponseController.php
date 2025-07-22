<?php

namespace App\Http\Controllers;

use App\Models\ChecklistResponse;
use Illuminate\Http\Request;

class ChecklistResponseController extends Controller
{
    public function index()
    {
        return ChecklistResponse::all();
    }

    public function store(Request $request)
    {
        $validated = $request->validate([
            'checklist_id' => 'required|exists:checklists,id',
            'item_id' => 'required|exists:checklist_items,id',
            'value' => 'nullable|string',
            'photo_path' => 'nullable|string',
        ]);
        $response = ChecklistResponse::create($validated);
        return response()->json($response, 201);
    }

    public function show(ChecklistResponse $checklistResponse)
    {
        return $checklistResponse;
    }

    public function update(Request $request, ChecklistResponse $checklistResponse)
    {
        $validated = $request->validate([
            'checklist_id' => 'sometimes|required|exists:checklists,id',
            'item_id' => 'sometimes|required|exists:checklist_items,id',
            'value' => 'nullable|string',
            'photo_path' => 'nullable|string',
        ]);
        $checklistResponse->update($validated);
        return response()->json($checklistResponse);
    }

    public function destroy(ChecklistResponse $checklistResponse)
    {
        $checklistResponse->delete();
        return response()->json(null, 204);
    }
}
