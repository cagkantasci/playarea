<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use App\Models\Machine;
use App\Models\ChecklistTemplate;

class Category extends Model
{
    use HasFactory;
    protected $fillable = ['name', 'description'];

    public function machines()
    {
        return $this->hasMany(Machine::class);
    }

    public function checklistTemplates()
    {
        return $this->hasMany(ChecklistTemplate::class);
    }
}
