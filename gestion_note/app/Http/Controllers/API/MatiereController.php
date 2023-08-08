<?php

namespace App\Http\Controllers\API;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use App\Http\Controllers\Controller;
use App\Models\Matiere;
use Illuminate\Support\Facades\Validator;

class MatiereController extends Controller
{
    //http://127.0.0.1:8000/api/matiere
    public function listMatiere()
    {
        $matiere = Matiere::orderBy("Id_Mat", "asc")->get();

        if(count($matiere)==0){
            return response()->json([
                'status' => false,
                'matiere' => $matiere
            ], 404);
        }

        return response()->json([
            'status' => true,
            'message' => 'Listes de matiere',
            'matiere' => $matiere
        ], 200);
    }

    //http://127.0.0.1:8000/api/creerMatiere
    public function createMatiere(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'Designation' => 'required|unique:matiere',
            'Poids' => 'required',
            'Id_UE' => 'required',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'status' => false,
                'message' => $validator->errors()
            ], 400);
        }

        $matiere = new Matiere();
        $matiere->Designation = $request->Designation;
        $matiere->Poids = $request->Poids;
        $matiere->Id_UE = $request->Id_UE;

        $matiere->save();

        //$matiere = Matiere::create($request->all());
        return response()->json([
            'status' => true,
            'message' => 'Matiere créer avec success',
            'matiere' => $matiere
        ], 201);
    }

    //http://127.0.0.1:8000/api/matiere/Id_Mat
    public function getMatiere($Id_Mat)
    {
        $matiere = Matiere::find($Id_Mat);

        if (!$matiere) {
            return response()->json([
                'status' => false,
                'message' => 'Matiere introuvable'
            ], 404);
        }

        return response()->json([
            'status' => true,
            'message' => 'Matiere trouvé',
            'matiere' => $matiere
        ], 200);
    }

    //http://127.0.0.1:8000/api/modifierMatiere/Id_Mat
    public function updateMatiere(Request $request, $Id_Mat)
    {
        $matiere = Matiere::find($Id_Mat);

        if (!$matiere) {
            return response()->json([
                'status' => false,
                'message' => 'Matiere introuvable'
            ], 404);
        }

        $validator = Validator::make($request->all(), [
            'Designation' => 'required|unique:matiere,Designation,'. $Id_Mat . ',Id_Mat',
            'Poids' => 'required',
            'Id_UE' => 'required',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'status' => false,
                'message' => $validator->errors()
            ], 400);
        }

        $matiere->Designation = $request->Designation;
        $matiere->Poids = $request->Poids;
        $matiere->Id_UE = $request->Id_UE;

        $matiere->update();

        return response()->json([
            'status' => true,
            'message' => 'L\'information de matiere a été modifié avec succés',
            'matiere' => $matiere
        ], 200);
    }

    //http://127.0.0.1:8000/api/supprimerMatiere/Id_Mat
    public function deleteMatiere($Id_Mat)
    {
        $matiere = Matiere::find($Id_Mat);

        if (!$matiere) {
            return response()->json([
                'status' => false,
                'message' => 'Matiere introuvable'
            ], 404);
        }

        $matiere = DB::delete("DELETE FROM matiere WHERE Id_Mat = '$Id_Mat'");

        return response()->json([
            'status' => true,
            'message' => 'Matiere a été supprimé'
        ], 200);
    }

    //http://127.0.0.1:8000/api/rechercherMatiere?keyword=Id_Mat
    public function searchMatiere(Request $request)
    {
        $rech = $request->input('keyword');

        $matiere = Matiere::where('Designation', 'like', "%$rech%")
                            ->orWhere('Poids', 'like', "%$rech%")
                            ->get();

        if (count($matiere)==0) {
            return response()->json([
                'status' => false,
                'matiere' => $matiere
            ], 404);
        }

        return response()->json([
            'status' => true,
            'matiere' => $matiere
        ], 200);
    }
    //Liste matiere ataon'ny niveau raika agnaty parcours raika
    public function matiereParNiveauEtParcours( $Niveau, $Parcours){
        $matiere = DB::select("SELECT matiere.Id_Mat, matiere.Designation FROM matiere INNER JOIN ue ON matiere.Id_UE = ue.Id_UE WHERE ue.Niveau = '$Niveau' AND ue.Parcours = '$Parcours'");

        if (count($matiere)==0) {
            return response()->json([
                'status' => false,
                'matiere' => $matiere
            ], 404);
        }
        //$attributsMatiere = collect($matiere)->pluck('Id_Mat', 'Designation', 'Poids');

        return response()->json([
            'status' => true,
            'messege' => 'Listes des matieres de niveau '. $Niveau . ' et de parcours ' . $Parcours . ' ',
            'matiere' => $matiere
        ], 200);
    }
    //Liste matiere par UE
    public function matiereParUE($Id_UE){
        $matiere = DB::select("SELECT matiere.Id_Mat, matiere.Designation, matiere.Poids FROM matiere INNER JOIN ue ON matiere.Id_UE = ue.Id_UE WHERE ue.Id_UE = '$Id_UE' ");

        if (count($matiere)==0) {
            return response()->json([
                'status' => false,
                'matiere' => $matiere
            ], 404);
        }
        //$attributsMatiere = collect($matiere)->pluck('Id_Mat', 'Designation', 'Poids');

        return response()->json([
            'status' => true,
            'messege' => 'Listes des matieres d\'unite d\'enseignement',
            'matiere' => $matiere
        ], 200);
    }
}
