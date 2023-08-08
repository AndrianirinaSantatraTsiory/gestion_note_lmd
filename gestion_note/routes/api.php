<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\API\UEController;
use App\Http\Controllers\API\NoteController;
use App\Http\Controllers\API\MatiereController;
use App\Http\Controllers\API\EtudiantController;
use App\Http\Controllers\API\ReleveNoteController;

/*
|--------------------------------------------------------------------------
| API Routes
|--------------------------------------------------------------------------
|
| Here is where you can register API routes for your application. These
| routes are loaded by the RouteServiceProvider within a group which
| is assigned the "api" middleware group. Enjoy building your API!
|
*/

Route::middleware('auth:sanctum')->get('/user', function (Request $request) {
    return $request->user();
});

/* ----------------------------------------ETUDIANTS------------------------------------------- */

Route::get("etudiant", [EtudiantController::class, "listEtudiant"]);
Route::get("etudiant/{N_mat}", [EtudiantController::class, "getEtudiant"]);
Route::post("creerEtudiant", [EtudiantController::class, "createEtudiant"]);
Route::put("modifierEtudiant/{N_mat}", [EtudiantController::class, "updateEtudiant"]);
Route::delete("supprimerEtudiant/{N_mat}", [EtudiantController::class, "deleteEtudiant"]);
Route::get("rechercherEtudiant", [EtudiantController::class, "searchEtudiant"]);

/* ----------------------------------------UNITE D'ENSEIGNEMENT------------------------------------------- */

Route::get("UE", [UEController::class, "listUE"]);
Route::get("UE/{id}", [UEController::class, "getUE"]);
Route::post("creerUE", [UEController::class, "createUE"]);
Route::put("modifierUE/{Id_UE}", [UEController::class, "updateUE"]);
Route::delete("supprimerUE/{Id_UE}", [UEController::class, "deleteUE"]);
Route::get("rechercherUE", [UEController::class, "searchUE"]);

/* ----------------------------------------MATIERE------------------------------------------- */

Route::get("matiere", [MatiereController::class, "listMatiere"]);
Route::get("matiere/{Id_Mat}", [MatiereController::class, "getMatiere"]);
Route::post("creerMatiere", [MatiereController::class, "createMatiere"]);
Route::put("modifierMatiere/{Id_Mat}", [MatiereController::class, "updateMatiere"]);
Route::delete("supprimerMatiere/{Id_Mat}", [MatiereController::class, "deleteMatiere"]);
Route::get("rechercherMatiere", [MatiereController::class, "searchMatiere"]);
Route::get("listMatiere/{Niveau}/{Parcours}", [MatiereController::class, "matiereParNiveauEtParcours"]);
Route::get("listMatiere/{Id_UE}", [MatiereController::class, "matiereParUE"]);

/* ----------------------------------------NOTE------------------------------------------- */

Route::get("note", [NoteController::class, "listNote"]);
Route::get("note/{Id_Note}", [NoteController::class, "getNote"]);
Route::post("creerNote", [NoteController::class, "createNote"]);
Route::put("modifierNote/{Id_Note}", [NoteController::class, "updateNote"]);
Route::delete("supprimerNote/{Id_Note}", [NoteController::class, "deleteNote"]);
Route::get("rechercherNote", [NoteController::class, "searchNote"]);
Route::get("matierePasNote/{N_mat}/{Niveau}/{Parcours}", [NoteController::class, "matierePasNote"]);

/* ----------------------------------------RELEVE NOTE------------------------------------------- */

Route::get("releveNote/{N_mat}/{Niveau}/{Parcours}", [EtudiantController::class, "genererReleveNotes"]);

