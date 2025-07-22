<?php

namespace App\Http\Controllers;

use App\Models\Checklist;
use Illuminate\Http\Request;

class ChecklistController extends Controller
{
    public function index()
    {
        return Checklist::all();
    }

    public function store(Request $request)
    {
        $validated = $request->validate([
            'machine_id' => 'required|exists:machines,id',
            'user_id' => 'required|exists:users,id',
            'status' => 'required|string',
            'submitted_at' => 'nullable|date',
        ]);
        $checklist = Checklist::create($validated);
        return response()->json($checklist, 201);
    }

    public function show(Checklist $checklist)
    {
        return $checklist;
    }

    public function update(Request $request, Checklist $checklist)
    {
        $validated = $request->validate([
            'machine_id' => 'sometimes|required|exists:machines,id',
            'user_id' => 'sometimes|required|exists:users,id',
            'status' => 'sometimes|required|string',
            'submitted_at' => 'nullable|date',
        ]);
        $checklist->update($validated);
        return response()->json($checklist);
    }

    public function destroy(Checklist $checklist)
    {
        $checklist->delete();
        return response()->json(null, 204);
    }
}
