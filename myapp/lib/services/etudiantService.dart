import 'package:http/http.dart' as http;
import 'dart:convert';


import '../Models/Etudiant.dart';

class EtudiantService{
  Future<List<Etudiant>> lister() async{
    http.Response response=await http.get(Uri.parse('http://10.0.2.2:8000/api/etudiant'));
    Map data=jsonDecode(response.body);

    List<dynamic> listetudiants=data["etudiant"];
    print(listetudiants);

    List<Etudiant> etudiants=[];

    etudiants=listetudiants.map((reponse) => Etudiant(reponse["N_mat"],reponse["Nom"],reponse["Prenom"],reponse["Niveau"],reponse["Parcours"],reponse["Phone"],reponse["Mail"])).toList();
    //print(etudiants[0].Nom);
    return etudiants;
  }

  Future<List<Etudiant>> listerRecherche(String to_search) async{
    http.Response response=await http.get(Uri.parse('http://10.0.2.2:8000/api/rechercherEtudiant?keyword=$to_search'));
    Map data=jsonDecode(response.body);
    List<dynamic> listetudiants=data["etudiant"];
    print(listetudiants);
    List<Etudiant> etudiants=[];

    etudiants=listetudiants.map((reponse) => Etudiant(reponse["N_mat"],reponse["Nom"],reponse["Prenom"],reponse["Niveau"],reponse["Parcours"],reponse["Phone"],reponse["Mail"])).toList();
    //print(etudiants[0].Nom);
    return etudiants;
  }

  //Supprimer étudiants
  Future<bool> deleteById(String id) async{
    http.Response response=await http.delete(Uri.parse('http://10.0.2.2:8000/api/supprimerEtudiant/$id'));
    Map data=jsonDecode(response.body);
    return (data["status"]);
  }

  //Creer étudiants
  Future<Map> createEtudiant(Etudiant etud) async{
    Map<String,String> message={};
    Map<String,dynamic> retour={};
    //message.putIfAbsent("dsd", () => "dskfj");

    http.Response response = await http.post(
      Uri.parse('http://10.0.2.2:8000/api/creerEtudiant'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(etud),
    );

    Map reponse=jsonDecode(response.body);
    if(!reponse["status"]){
      if(reponse["message"]!=null){
        Map<String,dynamic> errors=reponse["message"];
        if(errors["N_mat"]!=null){
          List<dynamic> mess=errors["N_mat"]!;
          message.putIfAbsent("N_mat", () => mess[0]);
        }
        if(errors["Nom"]!=null){
          List<dynamic> mess=errors["Nom"]!;
          message.putIfAbsent("Nom", () => mess[0]);
        }
        if(errors["Prenom"]!=null){
          List<dynamic> mess=errors["Prenom"]!;
          message.putIfAbsent("Prenom", () => mess[0]);
        }
        if(errors["Mail"]!=null){
          List<dynamic> mess=errors["Mail"]!;
          message.putIfAbsent("Mail", () => mess[0]);
        }
        if(errors["Phone"]!=null){
          List<dynamic> mess=errors["Phone"]!;
          message.putIfAbsent("Phone", () => mess[0]);
        }
      }
    }
    print(reponse["message"]);
    retour.putIfAbsent("status", () => reponse["status"]);
    retour.putIfAbsent("message", () => message);
    return retour;
  }

  //Selectionner un étudiants
  Future<Etudiant> getEtudiant(String id) async{
    print("le id est $id");
    http.Response response=await http.get(Uri.parse('http://10.0.2.2:8000/api/etudiant/$id'));
    Map data=jsonDecode(response.body);
    Map selectedEt=data["etudiant"];
    return Etudiant(selectedEt["N_mat"],selectedEt["Nom"],selectedEt["Prenom"],selectedEt["Niveau"],selectedEt["Parcours"],selectedEt["Phone"],selectedEt["Mail"]);
  }

  Future<Map> updateEtudiant(String id, Etudiant etud) async{
    Map<String,String> message={};
    Map<String,dynamic> retour={};
    http.Response response = await http.put(
      Uri.parse('http://10.0.2.2:8000/api/modifierEtudiant/$id'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(etud),
    );
    Map reponse=jsonDecode(response.body);
    if(!reponse["status"]){
      if(reponse["message"]!=null){
        Map<String,dynamic> errors=reponse["message"];
        if(errors["N_mat"]!=null){
          List<dynamic> mess=errors["N_mat"]!;
          message.putIfAbsent("N_mat", () => mess[0]);
        }
        if(errors["Nom"]!=null){
          List<dynamic> mess=errors["Nom"]!;
          message.putIfAbsent("Nom", () => mess[0]);
        }
        if(errors["Prenom"]!=null){
          List<dynamic> mess=errors["Prenom"]!;
          message.putIfAbsent("Prenom", () => mess[0]);
        }
        if(errors["Mail"]!=null){
          List<dynamic> mess=errors["Mail"]!;
          message.putIfAbsent("Mail", () => mess[0]);
        }
        if(errors["Phone"]!=null){
          List<dynamic> mess=errors["Phone"]!;
          message.putIfAbsent("Phone", () => mess[0]);
        }
      }
    }
    print(reponse["message"]);
    retour.putIfAbsent("status", () => reponse["status"]);
    retour.putIfAbsent("message", () => message);
    return retour;
  }

}