<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Task extends Model
{
    // Allow mass assignment
    protected $fillable = [
        'title',
        'due_date',
        'priority',
        'status'
    ];
}