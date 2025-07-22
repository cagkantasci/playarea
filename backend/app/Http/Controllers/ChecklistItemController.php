<?php

namespace App\Http\Controllers;

use App\Models\ChecklistItem;
use Illuminate\Http\Request;

class ChecklistItemController extends Controller
{
    public function index()
    {
        return ChecklistItem::all();
    }

    public function store(Request $request)
    {
        $validated = $request->validate([
            'template_id' => 'required|exists:checklist_templates,id',
            'title' => 'required|string|max:255',
            'is_required' => 'required|boolean',
            'requires_photo' => 'required|boolean',
        ]);
        $item = ChecklistItem::create($validated);
        return response()->json($item, 201);
    }

    public function show(ChecklistItem $checklistItem)
    {
        return $checklistItem;
    }

    public function update(Request $request, ChecklistItem $checklistItem)
    {
        $validated = $request->validate([
            'template_id' => 'sometimes|required|exists:checklist_templates,id',
            'title' => 'sometimes|required|string|max:255',
            'is_required' => 'sometimes|required|boolean',
            'requires_photo' => 'sometimes|required|boolean',
        ]);
        $checklistItem->update($validated);
        return response()->json($checklistItem);
    }

    public function destroy(ChecklistItem $checklistItem)
    {
        $checklistItem->delete();
        return response()->json(null, 204);
    }
}
