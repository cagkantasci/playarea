<?php

namespace App\Http\Controllers;

use App\Models\Approval;
use Illuminate\Http\Request;

class ApprovalController extends Controller
{
    public function index()
    {
        return Approval::all();
    }

    public function store(Request $request)
    {
        $validated = $request->validate([
            'checklist_id' => 'required|exists:checklists,id',
            'approved_by' => 'required|exists:users,id',
            'approved_at' => 'nullable|date',
        ]);
        $approval = Approval::create($validated);
        return response()->json($approval, 201);
    }

    public function show(Approval $approval)
    {
        return $approval;
    }

    public function update(Request $request, Approval $approval)
    {
        $validated = $request->validate([
            'checklist_id' => 'sometimes|required|exists:checklists,id',
            'approved_by' => 'sometimes|required|exists:users,id',
            'approved_at' => 'nullable|date',
        ]);
        $approval->update($validated);
        return response()->json($approval);
    }

    public function destroy(Approval $approval)
    {
        $approval->delete();
        return response()->json(null, 204);
    }
}
