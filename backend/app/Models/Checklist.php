<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use App\Models\Machine;
use App\Models\User;
use App\Models\ChecklistResponse;
use App\Models\Issue;
use App\Models\Approval;

class Checklist extends Model
{
    use HasFactory;
    protected $fillable = ['machine_id', 'user_id', 'status', 'submitted_at'];

    public function machine()
    {
        return $this->belongsTo(Machine::class);
    }

    public function user()
    {
        return $this->belongsTo(User::class);
    }

    public function responses()
    {
        return $this->hasMany(ChecklistResponse::class);
    }

    public function issues()
    {
        return $this->hasMany(Issue::class);
    }

    public function approvals()
    {
        return $this->hasMany(Approval::class);
    }
}
