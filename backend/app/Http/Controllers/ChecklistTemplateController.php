<?php

namespace App\Http\Controllers;

use App\Models\ChecklistTemplate;
use Illuminate\Http\Request;

class ChecklistTemplateController extends Controller
{
    public function index()
    {
        return ChecklistTemplate::all();
    }

    public function store(Request $request)
    {
        $validated = $request->validate([
            'category_id' => 'required|exists:categories,id',
            'name' => 'required|string|max:255',
        ]);
        $template = ChecklistTemplate::create($validated);
        return response()->json($template, 201);
    }

    public function show(ChecklistTemplate $checklistTemplate)
    {
        return $checklistTemplate;
    }

    public function update(Request $request, ChecklistTemplate $checklistTemplate)
    {
        $validated = $request->validate([
            'category_id' => 'sometimes|required|exists:categories,id',
            'name' => 'sometimes|required|string|max:255',
        ]);
        $checklistTemplate->update($validated);
        return response()->json($checklistTemplate);
    }

    public function destroy(ChecklistTemplate $checklistTemplate)
    {
        $checklistTemplate->delete();
        return response()->json(null, 204);
    }
}
