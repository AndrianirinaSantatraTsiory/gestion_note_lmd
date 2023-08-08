<?php

namespace App\Http\Controllers\API;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use App\Http\Controllers\Controller;
use App\Models\UE;
use Illuminate\Support\Facades\Validator;

class UEController extends Controller
{
    //http://127.0.0.1:8000/api/UE
    public function listUE()
    {
        $uniteEns = UE::orderBy("Id_UE", "asc")->get();

        if(count($uniteEns)==0){
            return response()->json([
                'status' => false,
                'unite d\'enseignement' => $uniteEns
            ], 404);
        }

        return response()->json([
            'status' => true,
            'message' => 'Listes d\unite d\'enseignement',
            'unite d\'enseignement' => $uniteEns
        ], 200);
    }

    //http://127.0.0.1:8000/api/creerUE
    public function createUE(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'Designation' => 'required|unique:ue',
            'Credit' => 'required',
            'Niveau' => 'required',
            'Parcours' => 'required',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'status' => false,
                'message' => $validator->errors()
            ], 400);
        }

        $uniteEns = new UE();
        $uniteEns->Designation = $request->Designation;
        $uniteEns->Credit = $request->Credit;
        $uniteEns->Niveau = $request->Niveau;
        $uniteEns->Parcours = $request->Parcours;

        $uniteEns->save();

        //$etudiant = Etudiant::create($request->all());
        return response()->json([
            'status' => true,
            'message' => 'Unite d\'enseignement créer avec success',
            'unite d\'enseignement' => $uniteEns
        ], 201);
    }

    //http://127.0.0.1:8000/api/UE/Id_UE
    public function getUE($Id_UE)
    {
        $uniteEns = UE::find($Id_UE);

        if (!$uniteEns) {
            return response()->json([
                'status' => false,
                'message' => 'Unite d\'enseignement introuvable'
            ], 404);
        }

        return response()->json([
            'status' => true,
            'message' => 'Unite d\'enseignement trouvé',
            'unite d\'enseignement' => $uniteEns
        ], 200);
    }

    //http://127.0.0.1:8000/api/modifierUE/Id_UE
    public function updateUE(Request $request, $Id_UE)
    {
        $uniteEns = UE::find($Id_UE);

        if (!$uniteEns) {
            return response()->json([
                'status' => false,
                'message' => 'Unite d\'enseignement introuvable'
            ], 404);
        }

        $validator = Validator::make($request->all(), [
            'Designation' => 'required|unique:ue,Designation,'. $Id_UE . ',Id_UE',
            'Credit' => 'required',
            'Niveau' => 'required',
            'Parcours' => 'required',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'status' => false,
                'errors' => $validator->errors()
            ], 400);
        }

        $uniteEns->Designation = $request->Designation;
        $uniteEns->Credit = $request->Credit;
        $uniteEns->Niveau = $request->Niveau;
        $uniteEns->Parcours = $request->Parcours;

        $uniteEns->update();

        return response()->json([
            'status' => true,
            'message' => 'L\'information d\'unite d\'enseignement a été modifié avec succés',
            'unite d\'enseignement' => $uniteEns
        ], 200);
    }

    //http://127.0.0.1:8000/api/supprimerUE/Id_UE
    public function deleteUE($Id_UE)
    {
        $uniteEns = UE::find($Id_UE);

        if (!$uniteEns) {
            return response()->json([
                'status' => false,
                'message' => 'Unite d\'enseignement introuvable'
            ], 404);
        }

        $uniteEns = DB::delete("DELETE FROM ue WHERE Id_UE = '$Id_UE'");

        return response()->json([
            'status' => true,
            'message' => 'Unite d\'enseignement a été supprimé'
        ], 200);
    }

    //http://127.0.0.1:8000/api/rechercherUE?keyword=Id_UE
    public function searchUE(Request $request)
    {
        $rech = $request->input('keyword');

        $uniteUE = UE::where('Designation', 'like', "%$rech%")
                            ->orWhere('Credit', 'like', "%$rech%")
                            ->orWhere('Niveau', 'like', "%$rech%")
                            ->orWhere('Parcours', 'like', "%$rech%")
                            ->get();

        if (count($uniteUE)==0) {
            return response()->json([
                'status' => false,
                'unite d\'enseignement' => $uniteUE
            ], 404);
        }

        return response()->json([
            'status' => true,
            'unite d\'enseignement' => $uniteUE
        ], 200);
    }
}
