<?php

namespace App\Http\Controllers;

use App\Models\Issue;
use Illuminate\Http\Request;

class IssueController extends Controller
{
    public function index()
    {
        return Issue::all();
    }

    public function store(Request $request)
    {
        $validated = $request->validate([
            'checklist_id' => 'required|exists:checklists,id',
            'description' => 'required|string',
            'image_path' => 'nullable|string',
            'is_resolved' => 'required|boolean',
        ]);
        $issue = Issue::create($validated);
        return response()->json($issue, 201);
    }

    public function show(Issue $issue)
    {
        return $issue;
    }

    public function update(Request $request, Issue $issue)
    {
        $validated = $request->validate([
            'checklist_id' => 'sometimes|required|exists:checklists,id',
            'description' => 'sometimes|required|string',
            'image_path' => 'nullable|string',
            'is_resolved' => 'sometimes|required|boolean',
        ]);
        $issue->update($validated);
        return response()->json($issue);
    }

    public function destroy(Issue $issue)
    {
        $issue->delete();
        return response()->json(null, 204);
    }
}
