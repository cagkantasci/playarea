<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use App\Models\Checklist;
use App\Models\User;

class Approval extends Model
{
    use HasFactory;
    protected $fillable = ['checklist_id', 'approved_by', 'approved_at'];

    public function checklist()
    {
        return $this->belongsTo(Checklist::class);
    }

    public function approver()
    {
        return $this->belongsTo(User::class, 'approved_by');
    }
}
