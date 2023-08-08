<?php

namespace App\Http\Controllers\API;

use App\Models\UE;
use App\Models\Etudiant;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use App\Http\Controllers\Controller;
use Illuminate\Support\Facades\Validator;
use PHPUnit\Framework\Constraint\IsFalse;

use function PHPUnit\Framework\assertFalse;

class EtudiantController extends Controller
{
    //http://127.0.0.1:8000/api/etudiant
    public function listEtudiant()
    {
        $etudiant = Etudiant::orderBy("N_mat", "asc")->get();

        if(count($etudiant)==0){
            return response()->json([
                'status' => false,
                'etudiant' => $etudiant
            ], 404);
        }

        return response()->json([
            'status' => true,
            'message' => 'Listes etudiants',
            'etudiant' => $etudiant
        ], 200);
    }

    //http://127.0.0.1:8000/api/creerEtudiant
    public function createEtudiant(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'N_mat' => 'required|unique:etudiant',
            'Nom' => 'required',
            'Prenom' => 'required',
            'Niveau' => 'required',
            'Parcours' => 'required',
            'Phone' => 'required|unique:etudiant',
            'Mail' => 'required|email|unique:etudiant',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'status' => false,
                'message' => $validator->errors()
            ], 400);
        }

        $etudiant = new Etudiant();
        $etudiant->N_mat = $request->N_mat;
        $etudiant->Nom = $request->Nom;
        $etudiant->Prenom = $request->Prenom;
        $etudiant->Niveau = $request->Niveau;
        $etudiant->Parcours = $request->Parcours;
        $etudiant->Phone = $request->Phone;
        $etudiant->Mail = $request->Mail;

        $etudiant->save();

        //$etudiant = Etudiant::create($request->all());
        return response()->json([
            'status' => true,
            'message' => 'Etudiant créer avec success',
            'etudiant' => $etudiant
        ], 201);
    }

    //http://127.0.0.1:8000/api/etudiant/N_mat
    public function getEtudiant($N_mat)
    {
        $etudiant = Etudiant::find($N_mat);

        if (!$etudiant) {
            return response()->json([
                'status' => false,
                'message' => 'Etudiant introuvable'
            ], 404);
        }

        return response()->json([
            'status' => true,
            'message' => 'Etudiant trouvé',
            'etudiant' => $etudiant
        ], 200);
    }

    //http://127.0.0.1:8000/api/modifierEtudiant/N_mat
    public function updateEtudiant(Request $request, $N_mat)
    {
        $etudiant = Etudiant::find($N_mat);

        if (!$etudiant) {
            return response()->json([
                'status' => false,
                'message' => 'Etudiant introuvable'
            ], 404);
        }

        $validator = Validator::make($request->all(), [
            'Nom' => 'required',
            'Prenom' => 'required',
            'Niveau' => 'required',
            'Parcours' => 'required',
            'Phone' => 'required|unique:etudiant,Phone,' . $N_mat . ',N_mat',
            'Mail' => 'required|email|unique:etudiant,Mail,' . $N_mat . ',N_mat',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'status' => false,
                'message' => $validator->errors()
            ], 400);
        }

        $etudiant->Nom = $request->Nom;
        $etudiant->Prenom = $request->Prenom;
        $etudiant->Niveau = $request->Niveau;
        $etudiant->Parcours = $request->Parcours;
        $etudiant->Phone = $request->Phone;
        $etudiant->Mail = $request->Mail;

        $etudiant->update();
        //$etudiant->update($request->all());

        return response()->json([
            'status' => true,
            'message' => 'L\'information d\'etudiant a été modifié avec succés',
            'etudiant' => $etudiant
        ], 200);
    }

    //http://127.0.0.1:8000/api/supprimerEtudiant/N_mat
    public function deleteEtudiant($N_mat)
    {
        $etudiant = Etudiant::find($N_mat);

        if (!$etudiant) {
            return response()->json([
                'status' => false,
                'message' => 'Etudiant introuvable'
            ], 404);
        }

        //$etudiant->delete();
        $etudiant = DB::delete("DELETE FROM etudiant WHERE N_mat = '$N_mat'");


        return response()->json([
            'status' => true,
            'message' => 'Etudiant a été supprimé'
        ], 200);
    }

    //http://127.0.0.1:8000/api/rechercherEtudiant?keyword=N_mat
    public function searchEtudiant(Request $request)
    {
        $rech = $request->input('keyword');

        //$etudiant = DB::select("SELECT * FROM etudiant WHERE N_mat LIKE '%$term%' OR Nom LIKE '%$term%' OR Prenom LIKE '%$term%' ");

        $etudiant = Etudiant::where('N_mat', 'like', "%$rech%")
                            ->orWhere('Nom', 'like', "%$rech%")
                            ->orWhere('Prenom', 'like', "%$rech%")
                            ->orWhere('Niveau', 'like', "%$rech%")
                            ->orWhere('Parcours', 'like', "%$rech%")
                            ->orWhere('Phone', 'like', "%$rech%")
                            ->orWhere('Mail', 'like', "%$rech%")
                            ->get();

        if (count($etudiant)==0) {
            return response()->json([
                'status' => false,
                'etudiant' => $etudiant
            ], 404);
        }

        return response()->json([
            'status' => true,
            'etudiant' => $etudiant
        ], 200);
    }
    public function genererReleveNotes($N_mat, $niveau, $parcours)
    {
        // Récupérer l'étudiant
        $etudiant = Etudiant::findOrFail($N_mat);

        // Récupérer toutes les UE associées au niveau et au parcours donnés
        $ues = UE::where('Niveau', $niveau)->where('Parcours', $parcours)->get();

        // Initialiser les tableaux pour stocker les moyennes de chaque UE et les notes par UE
        $moyennesUE = [];
        $notesUE = [];
        $listmoyennesUE = [];
        $valideNiveau = true;
        $valideUE = true;

        // Parcourir toutes les UE
        foreach ($ues as $ue) {
            // Récupérer tous les matiere associés à cette UE
            $matiereUE = DB::table('matiere')->where('Id_UE', $ue->Id_UE)->get();

            // Initialiser le tableau pour stocker les notes de chaque cours
            $notesMatiere = [];
            $listnotesMatiere = [];

            // Parcourir tous les cours de cette UE
            foreach ($matiereUE as $matiere) {
                // Récupérer la note de l'étudiant pour ce matiere
                $note = DB::table('note')->where('N_mat', $etudiant->N_mat)->where('Id_Mat', $matiere->Id_Mat)->first();

                // Si une note est trouvée, l'ajouter au tableau des notes de matiere
                if ($note) {
                    $notesMatiere[] = $note->note;
                    $listnotesMatiere[] = DB::select("SELECT note.Id_Mat,matiere.Designation,note.note FROM matiere,note WHERE (matiere.Id_Mat = note.Id_Mat) AND note.note = '$note->note'");
                }

            }

            // Calculer la moyenne de l'UE en ajoutant les notes et en divisant par le nombre de cours
            if (count($notesMatiere) > 0) {
                $moyenneUE = array_sum($notesMatiere) / count($notesMatiere);

            } else {
                $moyenneUE = 0;
            }
            //////////////////////
            if($moyenneUE < 10){
                $valideUE = false;
                $valideNiveau = false;
            }
            elseif($moyenneUE >= 10){
                $valideUE = true;
                $valideNiveau = true;
            }

            // Ajouter la moyenne de l'UE au tableau des moyennes d'UE
            $moyennesUE[$ue->Id_UE] = $moyenneUE;
            $listmoyennesUE[] = ['UE'=> DB::select("SELECT ue.Id_UE,ue.Designation,ue.Credit,$moyenneUE as moyenne FROM ue WHERE ue.Id_UE = '$ue->Id_UE'"),
                'valide' => $valideUE ,
                'detail_matiere' =>  $listnotesMatiere];

            // Ajouter les notes de l'UE au tableau des notes d'UE

            $notesUE[$ue->Id_UE] = $listnotesMatiere;

        }

        // Calculer la moyenne générale de toutes les UE en ajoutant les moyennes des UE et en divisant par le nombre d'UE
        if (count($moyennesUE) > 0) {
            $moyenneGenerale = array_sum($moyennesUE) / count($moyennesUE);

        } else {
            $moyenneGenerale = 0;
        }

        // Sauvegarder les résultats dans la base de données

        // TODO: Enregistrez les résultats dans les tables pertinentes (par exemple, une table pour le relevé de notes)

        // Retourner les résultats dans la réponse JSON
        return response()->json([
            'etudiant' => $etudiant,
            'moyennes_ue' => $listmoyennesUE,
            'valide_niveau'=> $valideNiveau,
            'moyenne_generale' => $moyenneGenerale,
        ], 200);
    }
}
