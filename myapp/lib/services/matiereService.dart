import 'package:http/http.dart' as http;
import 'dart:convert';
import '../Models/Matiere.dart';

class MatiereService{
  Future<List<Matiere>> lister() async{
    http.Response response=await http.get(Uri.parse('http://10.0.2.2:8000/api/matiere'));
    Map data=jsonDecode(response.body);

    List<dynamic> listmatiere=data["matiere"];
    print(listmatiere);

    List<Matiere> matieres=[];

    matieres=listmatiere.map((reponse) => Matiere(reponse["Id_Mat"],reponse["Designation"],reponse["Poids"],reponse["Id_UE"])).toList();
    return matieres;
  }

  Future<List<Matiere>> listerRecherche(String to_search) async{
    http.Response response=await http.get(Uri.parse('http://10.0.2.2:8000/api/rechercherMatiere?keyword=$to_search'));
    Map data=jsonDecode(response.body);
    List<dynamic> listmatiere=data["matiere"];
    print(listmatiere);

    List<Matiere> matieres=[];

    matieres=listmatiere.map((reponse) => Matiere(reponse["Id_Mat"],reponse["Designation"],reponse["Poids"],reponse["Id_UE"])).toList();
    return matieres;
  }

  //Supprimer étudiants
  Future<bool> deleteById(int id) async{
    http.Response response=await http.delete(Uri.parse('http://10.0.2.2:8000/api/supprimerMatiere/${id}'));
    Map data=jsonDecode(response.body);
    return (data["status"]);
  }

  //Creer étudiants
  Future<Map> createMatiere(Matiere matiere) async{
    Map<String,String> message={};
    Map<String,dynamic> retour={};

    http.Response response = await http.post(
      Uri.parse('http://10.0.2.2:8000/api/creerMatiere'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(matiere),
    );

    Map reponse=jsonDecode(response.body);
    if(!reponse["status"]){
      if(reponse["message"]!=null){
        Map<String,dynamic> errors=reponse["message"];
        if(errors["Designation"]!=null){
          List<dynamic> mess=errors["Designation"]!;
          message.putIfAbsent("Designation", () => mess[0]);
        }
        if(errors["Poids"]!=null){
          List<dynamic> mess=errors["Poids"]!;
          message.putIfAbsent("Poids", () => mess[0]);
        }
      }
    }
    print(reponse["message"]);
    retour.putIfAbsent("status", () => reponse["status"]);
    retour.putIfAbsent("message", () => message);
    return retour;
  }

  //Selectionner un étudiants
  Future<Matiere> getMatiere(int id) async{
    print("le id est $id");
    http.Response response=await http.get(Uri.parse('http://10.0.2.2:8000/api/matiere/${id}'));
    Map data=jsonDecode(response.body);
    Map selectedMat=data["matiere"];
    return Matiere(selectedMat["Id_Mat"],selectedMat["Designation"],selectedMat["Poids"].toDouble(),selectedMat["Id_UE"]);
  }

  Future<Map> updateMatiere(int id, Matiere matiere) async{
    Map<String,String> message={};
    Map<String,dynamic> retour={};
    http.Response response = await http.put(
      Uri.parse('http://10.0.2.2:8000/api/modifierMatiere/${id}'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(matiere),
    );
    Map reponse=jsonDecode(response.body);
    if(!reponse["status"]){
      if(reponse["message"]!=null){
        Map<String,dynamic> errors=reponse["message"];
        if(errors["Designation"]!=null){
          List<dynamic> mess=errors["Designation"]!;
          message.putIfAbsent("Designation", () => mess[0]);
        }
        if(errors["Poids"]!=null){
          List<dynamic> mess=errors["Poids"]!;
          message.putIfAbsent("Poids", () => mess[0]);
        }
      }
    }
    print(reponse["message"]);
    retour.putIfAbsent("status", () => reponse["status"]);
    retour.putIfAbsent("message", () => message);
    return retour;
  }
  Future<List<Matiere>> getNiveauParcours(String niveau,String parcours) async{
    http.Response response=await http.get(Uri.parse('http://10.0.2.2:8000/api/listMatiere/$niveau/$parcours'));
    Map data=jsonDecode(response.body);
    List<dynamic> listmatiere=data["matiere"];
    print(listmatiere);
    List<Matiere> matieres=[];
    matieres=listmatiere.map((reponse) => Matiere(reponse["Id_Mat"],reponse["Designation"],0.0,0)).toList();
    return matieres;
  }

  Future<List<Matiere>> getMatierePasdeNote(String matricule,String niveau,String parcours) async{
    http.Response response=await http.get(Uri.parse('http://10.0.2.2:8000/api/matierePasNote/$matricule/$niveau/$parcours'));
    Map data=jsonDecode(response.body);
    List<dynamic> listmatiere=data["matiere"];
    print(listmatiere);
    List<Matiere> matieres=[];
    matieres=listmatiere.map((reponse) => Matiere(reponse["Id_Mat"],reponse["Designation"],0,0)).toList();
    return matieres;
  }
  Future<List<Matiere>> getMatiereUE(int id) async {
    http.Response response=await http.get(Uri.parse('http://10.0.2.2:8000/api/listMatiere/${id}'));
    Map data=jsonDecode(response.body);
    List<dynamic> listmatiere=data["matiere"];
    print(listmatiere);
    List<Matiere> matieres=[];
    matieres=listmatiere.map((reponse) => Matiere(reponse["Id_Mat"],reponse["Designation"],reponse["Poids"].toDouble(),0)).toList();
    return matieres;
  }
}