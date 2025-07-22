<?php

namespace App\Http\Controllers;

use App\Models\Machine;
use Illuminate\Http\Request;

class MachineController extends Controller
{
    // Listele
    public function index()
    {
        return Machine::all();
    }

    // Oluştur
    public function store(Request $request)
    {
        $validated = $request->validate([
            'name' => 'required|string|max:255',
            'category_id' => 'required|exists:categories,id',
            'assigned_user_id' => 'nullable|exists:users,id',
        ]);
        $machine = Machine::create($validated);
        return response()->json($machine, 201);
    }

    // Göster
    public function show(Machine $machine)
    {
        return $machine;
    }

    // Güncelle
    public function update(Request $request, Machine $machine)
    {
        $validated = $request->validate([
            'name' => 'sometimes|required|string|max:255',
            'category_id' => 'sometimes|required|exists:categories,id',
            'assigned_user_id' => 'nullable|exists:users,id',
        ]);
        $machine->update($validated);
        return response()->json($machine);
    }

    // Sil
    public function destroy(Machine $machine)
    {
        $machine->delete();
        return response()->json(null, 204);
    }
}
