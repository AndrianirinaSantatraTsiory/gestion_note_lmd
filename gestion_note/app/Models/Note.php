<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Note extends Model
{
    use HasFactory;

    protected $table = "note";

    protected $primaryKey = 'Id_Note';
    protected $fillable = ['Id_Mat', 'N_mat', 'note', 'Annee', 'Niveau', 'Parcours'];
}
