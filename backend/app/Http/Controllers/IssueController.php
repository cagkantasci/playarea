<?php

namespace App\Http\Controllers;

use App\Models\Issue;
use Illuminate\Http\Request;

class IssueController extends Controller
{
    public function index()
    {
        $issues = Issue::with(['machine', 'user'])->latest()->get();
        return response()->json($issues);
    }

    public function store(Request $request)
    {
        $request->validate([
            'title' => 'required|string|max:255',
            'description' => 'required|string',
            'machine_id' => 'required|exists:machines,id',
            'priority' => 'required|in:low,medium,high',
        ]);

        $issue = Issue::create([
            'title' => $request->title,
            'description' => $request->description,
            'machine_id' => $request->machine_id,
            'priority' => $request->priority,
            'status' => 'open',
            'user_id' => auth()->id(),
        ]);

        return response()->json($issue->load(['machine', 'user']), 201);
    }

    public function show(Issue $issue)
    {
        return response()->json($issue->load(['machine', 'user']));
    }

    public function update(Request $request, Issue $issue)
    {
        $request->validate([
            'title' => 'string|max:255',
            'description' => 'string',
            'status' => 'in:open,in_progress,closed',
            'priority' => 'in:low,medium,high',
        ]);

        $issue->update($request->only(['title', 'description', 'status', 'priority']));

        return response()->json($issue->load(['machine', 'user']));
    }

    public function destroy(Issue $issue)
    {
        $issue->delete();
        return response()->json(['message' => 'Issue deleted successfully']);
    }
}
