import 'package:http/http.dart' as http;
import 'dart:convert';
import '../Models/UE.dart';

class ueService{
  Future<List<UE>> lister(String base) async{
    //print(context.base);
    http.Response response=await http.get(Uri.parse(base+'/api/UE'));
    Map data=jsonDecode(response.body);

    List<dynamic> listue=data["unite d'enseignement"];
    print(listue);

    List<UE> ues=[];

    ues=listue.map((reponse) => UE(reponse["Id_UE"],reponse["Designation"],reponse["Credit"],reponse["Niveau"],reponse["Parcours"])).toList();
    return ues;
  }

  Future<List<UE>> listerRecherche(String to_search,String base) async{
    http.Response response=await http.get(Uri.parse(base+'/api/rechercherUE?keyword=$to_search'));
    Map data=jsonDecode(response.body);
    List<dynamic> listue=data["unite d'enseignement"];
    print(listue);
    List<UE> ues=[];

    ues=listue.map((reponse) => UE(reponse["Id_UE"],reponse["Designation"],reponse["Credit"],reponse["Niveau"],reponse["Parcours"])).toList();
    return ues;
  }

  //Supprimer étudiants
  Future<bool> deleteById(int id,String base) async{
    http.Response response=await http.delete(Uri.parse(base+'/api/supprimerUE/${id}'));
    Map data=jsonDecode(response.body);
    return (data["status"]);
  }

  //Creer étudiants
  Future<Map> createUE(UE ue,String base) async{
    Map<String,String> message={};
    Map<String,dynamic> retour={};

    http.Response response = await http.post(
      Uri.parse(base+'/api/creerUE'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(ue),
    );

    Map reponse=jsonDecode(response.body);
    if(!reponse["status"]){
      if(reponse["message"]!=null){
        Map<String,dynamic> errors=reponse["message"];
        if(errors["Designation"]!=null){
          List<dynamic> mess=errors["Designation"]!;
          message.putIfAbsent("Designation", () => mess[0]);
        }
        if(errors["Credit"]!=null){
          List<dynamic> mess=errors["Credit"]!;
          message.putIfAbsent("Credit", () => mess[0]);
        }
      }
    }
    print(reponse["message"]);
    retour.putIfAbsent("status", () => reponse["status"]);
    retour.putIfAbsent("message", () => message);
    return retour;
  }

  //Selectionner un étudiants
  Future<UE> getUE(int id,String base) async{
    print("le id est $id");
    http.Response response=await http.get(Uri.parse(base+'/api/UE/${id}'));
    Map data=jsonDecode(response.body);
    Map selectedUE=data["unite d'enseignement"];
    return UE(selectedUE["Id_UE"],selectedUE["Designation"],selectedUE["Credit"],selectedUE["Niveau"],selectedUE["Parcours"]);
  }

  Future<Map> updateUE(int id, UE ue,String base) async{
    Map<String,String> message={};
    Map<String,dynamic> retour={};
    http.Response response = await http.put(
      Uri.parse(base+'/api/modifierUE/${id}'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(ue),
    );
    Map reponse=jsonDecode(response.body);
    if(!reponse["status"]){
      if(reponse["errors"]!=null){
        Map<String,dynamic> errors=reponse["errors"];
        if(errors["Designation"]!=null){
          List<dynamic> mess=errors["Designation"]!;
          message.putIfAbsent("Designation", () => mess[0]);
        }
        if(errors["Credit"]!=null){
          List<dynamic> mess=errors["Credit"]!;
          message.putIfAbsent("Credit", () => mess[0]);
        }
      }
    }
    print(reponse["message"]);
    retour.putIfAbsent("status", () => reponse["status"]);
    retour.putIfAbsent("message", () => message);
    return retour;
  }

}