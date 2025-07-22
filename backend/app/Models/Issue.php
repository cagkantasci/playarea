<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use App\Models\Checklist;

class Issue extends Model
{
    use HasFactory;
    protected $fillable = ['checklist_id', 'description', 'image_path', 'is_resolved'];

    public function checklist()
    {
        return $this->belongsTo(Checklist::class);
    }
}
