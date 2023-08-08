<?php

namespace App\Http\Controllers\API;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use App\Http\Controllers\Controller;
use App\Models\Note;
use Illuminate\Support\Facades\Validator;

class NoteController extends Controller
{
    //http://127.0.0.1:8000/api/note
    public function listNote()
    {
        $note = Note::orderBy("N_mat", "asc")->get();

        if(count($note)==0){
            return response()->json([
                'status' => false,
                'note' => $note
            ], 404);
        }

        return response()->json([
            'status' => true,
            'message' => 'Listes de note',
            'note' => $note
        ], 200);
    }

    //http://127.0.0.1:8000/api/creerNote
    public function createNote(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'Id_Mat' => 'required|exists:matiere,Id_Mat',
            'N_mat' => 'required|exists:etudiant,N_mat',
            'note' => 'required',
            'Annee' => 'required',
            'Niveau' => 'required',
            'Parcours' => 'required',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'status' => false,
                'message' => $validator->errors()
            ], 400);
        }

        $note = new Note();
        $note->Id_Mat = $request->Id_Mat;
        $note->N_mat = $request->N_mat;
        $note->note = $request->note;
        $note->Annee = $request->Annee;
        $note->Niveau = $request->Niveau;
        $note->Parcours = $request->Parcours;

        $note->save();

        //$etudiant = Etudiant::create($request->all());
        return response()->json([
            'status' => true,
            'message' => 'Note créer avec success',
            'note' => $note
        ], 201);
    }

    //http://127.0.0.1:8000/api/note/Id_Note
    public function getNote($Id_Note)
    {
        $note = Note::find($Id_Note);

        if (!$note) {
            return response()->json([
                'status' => false,
                'message' => 'Note introuvable'
            ], 404);
        }

        return response()->json([
            'status' => true,
            'message' => 'Note trouvé',
            'note' => $note
        ], 200);
    }

    //http://127.0.0.1:8000/api/modifierNote/Id_Note
    public function updateNote(Request $request, $Id_Note)
    {
        $note = Note::find($Id_Note);

        if (!$note) {
            return response()->json([
                'status' => false,
                'message' => 'Note introuvable'
            ], 404);
        }

        $validator = Validator::make($request->all(), [
            'Id_Mat' => 'required|exists:matiere,Id_Mat',
            'N_mat' => 'required|exists:etudiant,N_mat',
            'note' => 'required',
            'Annee' => 'required',
            'Niveau' => 'required',
            'Parcours' => 'required',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'status' => false,
                'message' => $validator->errors()
            ], 400);
        }

        $note->Id_Mat = $request->Id_Mat;
        $note->N_mat = $request->N_mat;
        $note->note = $request->note;
        $note->Annee = $request->Annee;
        $note->Niveau = $request->Niveau;
        $note->Parcours = $request->Parcours;

        $note->update();

        return response()->json([
            'status' => true,
            'message' => 'L\'information de note a été modifié avec succés',
            'note' => $note
        ], 200);
    }

    //http://127.0.0.1:8000/api/supprimerNote/Id_Note
    public function deleteNote($Id_Note)
    {
        $note = Note::find($Id_Note);

        if (!$note) {
            return response()->json([
                'status' => false,
                'message' => 'Note introuvable'
            ], 404);
        }

        $note = DB::delete("DELETE FROM note WHERE Id_Note = '$Id_Note'");


        return response()->json([
            'status' => true,
            'message' => 'Note a été supprimé'
        ], 200);
    }

    //http://127.0.0.1:8000/api/rechercherNote?keyword=Id_Note
    public function searchNote(Request $request)
    {
        $rech = $request->input('keyword');

        $note = Note::where('Id_Mat', 'like', "%$rech%")
                            ->orWhere('N_mat', 'like', "%$rech%")
                            ->orWhere('note', 'like', "%$rech%")
                            ->orWhere('Annee', 'like', "%$rech%")
                            ->orWhere('Niveau', 'like', "%$rech%")
                            ->orWhere('Parcours', 'like', "%$rech%")
                            ->get();

        if (count($note)==0) {
            return response()->json([
                'status' => false,
                'note' => $note
            ], 404);
        }

        return response()->json([
            'status' => true,
            'note' => $note
        ], 200);
    }

    //Listes des matieres qui n'ont pas de note
    public function matierePasNote($N_mat, $Niveau, $Parcours){
        $matiere = DB::select("SELECT matiere.Id_Mat, matiere.Designation FROM matiere,ue WHERE (matiere.Id_UE = ue.Id_UE) AND ue.Niveau = '$Niveau' AND ue.Parcours = '$Parcours' AND matiere.Id_Mat NOT IN (Select note.Id_Mat FROM note WHERE note.N_mat = '$N_mat' AND note.niveau = '$Niveau' AND note.Parcours = '$Parcours' ) ");

        if (count($matiere)==0) {
            return response()->json([
                'status' => false,
                'matiere' => $matiere
            ], 404);
        }

        return response()->json([
            'status' => true,
            'messege' => 'Listes des matieres qui n\'ont pas de note',
            'matiere' => $matiere
        ], 200);
    }
}
