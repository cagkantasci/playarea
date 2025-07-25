<?php

namespace App\Http\Controllers;

use App\Models\Checklist;
use Illuminate\Http\Request;

class ChecklistController extends Controller
{
    public function index()
    {
        $checklists = Checklist::with(['machine', 'template'])->latest()->get();
        return response()->json($checklists);
    }

    public function store(Request $request)
    {
        $request->validate([
            'machine_id' => 'required|exists:machines,id',
            'checklist_template_id' => 'required|exists:checklist_templates,id',
        ]);

        $checklist = Checklist::create([
            'machine_id' => $request->machine_id,
            'checklist_template_id' => $request->checklist_template_id,
            'user_id' => auth()->id(),
            'status' => 'pending',
        ]);

        return response()->json($checklist->load(['machine', 'template']), 201);
    }

    public function show(Checklist $checklist)
    {
        return response()->json($checklist->load(['machine', 'template', 'responses']));
    }

    public function update(Request $request, Checklist $checklist)
    {
        $request->validate([
            'status' => 'in:pending,in_progress,completed',
        ]);

        $checklist->update($request->only(['status']));

        return response()->json($checklist->load(['machine', 'template']));
    }

    public function destroy(Checklist $checklist)
    {
        $checklist->delete();
        return response()->json(['message' => 'Checklist deleted successfully']);
    }
}
