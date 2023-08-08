<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Etudiant extends Model
{
    use HasFactory;

    protected $table = "etudiant";

    protected $primaryKey = 'N_mat';
    public $incrementing = false;
    protected $fillable = ['Nom', 'Prenom', 'Niveau', 'Parcours', 'Phone', 'Mail'];

    public function note()
    {
        return $this->hasMany(Note::class);
    }
}
