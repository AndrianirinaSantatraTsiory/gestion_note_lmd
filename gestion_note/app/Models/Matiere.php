<?php

namespace App\Models;

use App\Models\UE;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;

class Matiere extends Model
{
    use HasFactory;

    protected $table = "matiere";

    protected $primaryKey = 'Id_Mat';
    protected $fillable = ['Designation', 'Poids', 'Id_UE'];

    public function ue()
    {
        return $this->belongsTo(UE::class);
    }

    public function note()
    {
        return $this->hasMany(Note::class);
    }
}
