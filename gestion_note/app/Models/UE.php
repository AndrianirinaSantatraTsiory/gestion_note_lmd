<?php

namespace App\Models;

use App\Models\Matiere;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;

class UE extends Model
{
    use HasFactory;

    protected $table = "ue";

    protected $primaryKey = 'Id_UE';
    protected $fillable = ['Designation', 'Credit', 'Niveau', 'Parcours'];

    public function matiere()
    {
        return $this->hasMany(Matiere::class);
    }
}
