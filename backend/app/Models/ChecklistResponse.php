<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use App\Models\Checklist;
use App\Models\ChecklistItem;

class ChecklistResponse extends Model
{
    use HasFactory;
    protected $fillable = ['checklist_id', 'item_id', 'value', 'photo_path'];

    public function checklist()
    {
        return $this->belongsTo(Checklist::class);
    }

    public function item()
    {
        return $this->belongsTo(ChecklistItem::class, 'item_id');
    }
}
