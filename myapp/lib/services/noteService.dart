import 'package:http/http.dart' as http;
import 'dart:convert';
import '../Models/Matiere.dart';
import '../Models/Note.dart';
import '../Models/NotesDetailler.dart';
import 'matiereService.dart';

class NoteService{
  Future<List<NoteDetailler>> lister() async{
    http.Response response=await http.get(Uri.parse('http://10.0.2.2:8000/api/note'));
    Map data=jsonDecode(response.body);
    print(data["matiere"]);
    List<dynamic> listnote=data["note"];
    //List<dynamic> listnote=[];
    /**listnote.add({
      'Id_Note':1,
      'Id_Mat':8,
      'N_Mat':"254",
      'note':15.5,
      'Annee':"2020-2022",
      'Niveau':"L3",
      'Parcours':"GB",
    });*/
    print(listnote.length);
    List<NoteDetailler> notes=[];
    for(int i=0;i<listnote.length;i++){
      Map<String,dynamic> reponse=listnote[i];
      Note noty = Note(reponse["Id_Note"],reponse["Id_Mat"],reponse["N_mat"],reponse["note"].toDouble(),reponse["Annee"],reponse["Niveau"],reponse["Parcours"]);
      notes.add(await detailler(noty));
    }
    return notes;
  }

  Future<List<NoteDetailler>> listerRecherche(String to_search) async{
    http.Response response=await http.get(Uri.parse('http://10.0.2.2:8000/api/rechercherNote?keyword=$to_search'));
    Map data=jsonDecode(response.body);
    List<dynamic> listnote=data["note"];
    print(listnote.length);
    List<NoteDetailler> notes=[];
    for(int i=0;i<listnote.length;i++){
      Map<String,dynamic> reponse=listnote[i];
      Note noty = Note(reponse["Id_Note"],reponse["Id_Mat"],reponse["N_mat"],reponse["note"].toDouble(),reponse["Annee"],reponse["Niveau"],reponse["Parcours"]);
      notes.add(await detailler(noty));
    }
    return notes;
  }

  //Supprimer étudiants
  Future<bool> deleteById(int id) async{
    http.Response response=await http.delete(Uri.parse('http://10.0.2.2:8000/api/supprimerNote/${id}'));
    Map data=jsonDecode(response.body);
    return (data["status"]);
  }

  //Creer étudiants
  Future<Map> createNote(Note note) async{
    Map<String,String> message={};
    Map<String,dynamic> retour={};

    http.Response response = await http.post(
      Uri.parse('http://10.0.2.2:8000/api/creerNote'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(note),
    );

    Map reponse=jsonDecode(response.body);
    if(!reponse["status"]){
      if(reponse["message"]!=null){
        Map<String,dynamic> errors=reponse["message"];
        if(errors["N_Mat"]!=null){
          List<dynamic> mess=errors["N_Mat"]!;
          message.putIfAbsent("N_Mat", () => mess[0]);
        }
        if(errors["note"]!=null){
          List<dynamic> mess=errors["note"]!;
          message.putIfAbsent("note", () => mess[0]);
        }
        if(errors["Annee"]!=null){
          List<dynamic> mess=errors["Annee"]!;
          message.putIfAbsent("Annee", () => mess[0]);
        }
      }
    }
    print(reponse["message"]);
    retour.putIfAbsent("status", () => reponse["status"]);
    retour.putIfAbsent("message", () => message);
    return retour;
  }

  //Selectionner un étudiants
  Future<Note> getNote(int id) async{
    print("le id est $id");
    http.Response response=await http.get(Uri.parse('http://10.0.2.2:8000/api/note/${id}'));
    Map data=jsonDecode(response.body);
    Map selectedNote=data["note"];
    return Note(selectedNote["Id_Note"],selectedNote["Id_Mat"],selectedNote["N_mat"],selectedNote["note"].toDouble(),selectedNote["Annee"],selectedNote["Niveau"],selectedNote["Parcours"]);
  }

  Future<Map> updateNote(int id, Note note) async{
    Map<String,String> message={};
    Map<String,dynamic> retour={};
    http.Response response = await http.put(
      Uri.parse('http://10.0.2.2:8000/api/modifierNote/${id}'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(note),
    );
    Map reponse=jsonDecode(response.body);
    if(!reponse["status"]){
      if(reponse["message"]!=null){
        Map<String,dynamic> errors=reponse["message"];
        if(errors["N_Mat"]!=null){
          List<dynamic> mess=errors["N_Mat"]!;
          message.putIfAbsent("N_Mat", () => mess[0]);
        }
        if(errors["note"]!=null){
          List<dynamic> mess=errors["note"]!;
          message.putIfAbsent("note", () => mess[0]);
        }
        if(errors["Annee"]!=null){
          List<dynamic> mess=errors["Annee"]!;
          message.putIfAbsent("Annee", () => mess[0]);
        }
        if(errors["Niveau"]!=null){
          List<dynamic> mess=errors["Niveau"]!;
          message.putIfAbsent("Niveau", () => mess[0]);
        }
        if(errors["Parcours"]!=null){
          List<dynamic> mess=errors["Parcours"]!;
          message.putIfAbsent("Parcours", () => mess[0]);
        }
      }
    }
    print(reponse["message"]);
    retour.putIfAbsent("status", () => reponse["status"]);
    retour.putIfAbsent("message", () => message);
    return retour;
  }
  Future<NoteDetailler> detailler (Note noty) async {
    MatiereService matServ=MatiereService();
    NoteDetailler detail=NoteDetailler();
    Matiere matiere=await matServ.getMatiere(noty.Id_Mat);
    detail.Id_Note=noty.Id_Note;
    detail.Matiere=matiere.Designation;
    detail.N_Mat=noty.N_Mat;
    detail.note=noty.note;
    detail.Annee=noty.Annee;
    detail.Niveau=noty.Niveau;
    detail.Parcours=noty.Parcours;
    return detail;

  }

  Future<bool> isNiveauValid(String matricule,String niveau,String parcours) async{
    http.Response response=await http.get(Uri.parse('http://10.0.2.2:8000/api/releveNote/$matricule/$niveau/$parcours'));
    Map data=jsonDecode(response.body);
    return (data["valide_niveau"]&&data["moyennes_ue"].length>0);
  }

  Future<Map<String,dynamic>> getReleveNote(String matricule,String niveau,String parcours) async {
    Map<String,dynamic> retour={};
    List<dynamic> moyennes_ue=[];
    //à retourner
    Map<String,dynamic> etudiant={};
    List<dynamic> ues=[];
    http.Response response=await http.get(Uri.parse('http://10.0.2.2:8000/api/releveNote/$matricule/$niveau/$parcours'));
    Map<String,dynamic> data=jsonDecode(response.body);
    print(data["moyenne_generale"]);
    retour.putIfAbsent("moyenne_generale", () => data["moyenne_generale"]);
    retour.putIfAbsent("valide_niveau", () => data["valide_niveau"]);
    etudiant=data["etudiant"];

    moyennes_ue=data["moyennes_ue"];
    for(int i=0;i<moyennes_ue.length;i++){
      List<dynamic> matieres=[];//à retourner
      Map<String,dynamic> ue={};

      List<dynamic> UE=moyennes_ue[i]["UE"];
      Map<String,dynamic> det_ue=UE[0];
      ue.putIfAbsent("designation", () => det_ue["Designation"]);//designaion
      ue.putIfAbsent("moyenne", () => det_ue["moyenne"]);//moyenne
      ue.putIfAbsent("valide", () => moyennes_ue[i]["valide"]);//valide
      ue.putIfAbsent("credit", () => det_ue["Credit"]);//credit
      List<dynamic> detail_matiere=moyennes_ue[i]["detail_matiere"];
      for(int j=0;j<detail_matiere.length;j++){
        Map<String,dynamic> matiere=detail_matiere[j][0];
        matieres.add(matiere);
      }
      ue.putIfAbsent("matieres", () => matieres);//liste de map des matières
      ues.add(ue);
    }
    retour.putIfAbsent("etudiant", () => etudiant);
    retour.putIfAbsent("ues", () => ues);
    print(retour);
    return retour;
  }
}