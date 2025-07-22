<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use App\Models\ChecklistTemplate;
use App\Models\ChecklistResponse;

class ChecklistItem extends Model
{
    use HasFactory;
    protected $fillable = ['template_id', 'title', 'is_required', 'requires_photo'];

    public function template()
    {
        return $this->belongsTo(ChecklistTemplate::class, 'template_id');
    }

    public function responses()
    {
        return $this->hasMany(ChecklistResponse::class, 'item_id');
    }
}
