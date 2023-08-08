import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:myapp/Models/Etudiant.dart';
import 'package:myapp/services/matiereService.dart';
import 'package:myapp/services/noteService.dart';

import '../../Models/Matiere.dart';
import '../../Models/Note.dart';
import '../../services/EtudiantService.dart';

class ModifierNote extends StatefulWidget {
  const ModifierNote({super.key});

  @override
  State<ModifierNote> createState() => _ModifierNoteState();
}

class _ModifierNoteState extends State<ModifierNote> {
  int id=0;
  EtudiantService etudServ=EtudiantService();
  MatiereService matiereServ=MatiereService();
  TextEditingController anneeController = TextEditingController();
  TextEditingController matriculeController = TextEditingController();
  TextEditingController noteController = TextEditingController();
  String niveauValue="L1";
  String parcoursValue="GB";
  String matiereValue="0";
  List<String> niveaux=['L1','L2','L3','M1','M2'];
  List<String> parcours=['GB','SR','IG'];
  List<Matiere> matieres=[];
  String anneeError="";
  String noteError="";
  String matriculeError="";
  NoteService noteServ=NoteService();

  @override
  void initState(){

    //matieres.add(Matiere(1, "choix de matière", 0, 0));
  }

  @override
  Future<void> didChangeDependencies() async {
    super.didChangeDependencies();
    settingData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        title: Text("Modifier Note"),
        centerTitle: true,
      ),
      body: ListView(
        padding: EdgeInsets.all(20.0),
        children: <Widget>[
          TextFormField(
            controller: matriculeController,
            onChanged: (value)async{
              print(value);
              setState(() {
                matriculeError="";
              });
              List<Etudiant> etudiants=await etudServ.listerRecherche(value);
              if(etudiants.length==0){
                setState(() {
                  matriculeError="Le numero matricule n'existe pas";
                });
              }
            },
            decoration: InputDecoration(
              hintText: 'Matricule',
              border: OutlineInputBorder(),
              errorText: (matriculeError!="")?matriculeError:null,
            ),
          ),
          SizedBox(height: 15.0),
          TextFormField(
            controller: anneeController,
            decoration: InputDecoration(
              hintText: 'Annee',
              border: OutlineInputBorder(),
              errorText: (anneeError!="")?anneeError:null,
            ),
          ),
          SizedBox(height: 15.0),

          Text("Niveau"),
          DropdownButtonHideUnderline(
            child: DropdownButton2<String>(
              isExpanded: true,
              hint: Text(
                'Select Item',
                style: TextStyle(
                  fontSize: 14,
                  color: Theme.of(context).hintColor,
                ),
              ),
              items: niveaux
                  .map((niveau) => DropdownMenuItem<String>(
                value: niveau,
                child: Text(
                  niveau,
                  style: const TextStyle(
                    fontSize: 14,
                  ),
                ),
              ))
                  .toList(),
              value: niveauValue,
              onChanged: (String? value) {
                setState(() {
                  print(value);
                  niveauValue = value!;
                });
                setMatiereInit( niveauValue, parcoursValue);
              },
              buttonStyleData: const ButtonStyleData(
                padding: EdgeInsets.symmetric(horizontal: 16),
                height: 40,
                width: 140,
              ),
              menuItemStyleData: const MenuItemStyleData(
                height: 40,
              ),
            ),
          ),

          SizedBox(height: 15.0),
          Text("Parcours"),
          DropdownButtonHideUnderline(
            child: DropdownButton2<String>(
              isExpanded: true,
              hint: Text(
                'Veuillez choisir le parcours',
                style: TextStyle(
                  fontSize: 14,
                  color: Theme.of(context).hintColor,
                ),
              ),
              items: parcours
                  .map((parcour) => DropdownMenuItem<String>(
                value: parcour,
                child: Text(
                  parcour,
                  style: const TextStyle(
                    fontSize: 14,
                  ),
                ),
              ))
                  .toList(),
              value: parcoursValue,
              onChanged: (String? value) {
                setState(() {
                  print(value);
                  parcoursValue = value!;
                });
                setMatiereInit( niveauValue, parcoursValue);
              },
              buttonStyleData: const ButtonStyleData(
                padding: EdgeInsets.symmetric(horizontal: 16),
                height: 40,
                width: 140,
              ),
              menuItemStyleData: const MenuItemStyleData(
                height: 40,
              ),
            ),
          ),

          SizedBox(height: 15.0),
          Text("Matieres"),
          DropdownButtonHideUnderline(
            child: DropdownButton2<String>(
              isExpanded: true,
              hint: Text(
                'Veuillez choisir le matiere',
                style: TextStyle(
                  fontSize: 14,
                  color: Theme.of(context).hintColor,
                ),
              ),
              items: matieres
                  .map((matiere) => DropdownMenuItem<String>(
                value: '${matiere.Id_Mat}',
                child: Text(
                  '${matiere.Designation}',
                  style: const TextStyle(
                    fontSize: 14,
                  ),
                ),
              ))
                  .toList(),
              value: matiereValue,
              onChanged: (String? value) {
                setState(() {
                  print(value);
                  matiereValue = value!;
                });
              },
              buttonStyleData: const ButtonStyleData(
                padding: EdgeInsets.symmetric(horizontal: 16),
                height: 40,
                width: 140,
              ),
              menuItemStyleData: const MenuItemStyleData(
                height: 40,
              ),
            ),
          ),
          SizedBox(height: 15.0),
          TextFormField(
            controller: noteController,
            decoration: InputDecoration(
              hintText: 'Note',
              border: OutlineInputBorder(),
              errorText: (noteError!="")?noteError:null,
            ),
          ),
          SizedBox(height: 20,),
          ElevatedButton(onPressed: (){submitData();}, child: Text("Valider")),
        ],
      ),
    );
  }


  void submitData() async{
    String matricule=matriculeController.text;
    String annee=anneeController.text;
    double note=double.parse(noteController.text);
    int Id_Mat=int.parse(matiereValue);
    print(note);
    Note noty=Note(0,Id_Mat,matricule,note,annee,niveauValue,parcoursValue);
    showDialog(
      context: context,
      barrierDismissible:false,
      builder: (context) {
        return Center(child: CircularProgressIndicator());
      },
    );
    Map<dynamic,dynamic> reponse=await noteServ.updateNote(id,noty);
    Navigator.of(context).pop();
    if(reponse["status"]){
      showSuccessMessage("Ajout avec succès");
      Navigator.pushReplacementNamed(context, '/listNote');
    }else {
      showErrorMessage("Echec de l'ajout");
      Map<String, String> message = reponse["message"];
      if (message["N_Mat"] != null) {
        setState(() {
          matriculeError = message["N_Mat"]!;
        });
      }
      if (message["note"] != null) {
        setState(() {
          noteError = message["note"]!;
        });
      }
      if (message["Annee"] != null) {
        setState(() {
          noteError = message["Annee"]!;
        });
      }

    }
  }

  Future<void> setMatiereInit(String niveau,String parcours) async {
    List<Matiere> listes=await matiereServ.getNiveauParcours(niveau, parcours);
    print("le liste de matiere est");

    setState((){
      //matiereValue="${matieres[0].Id_Mat}";
      matiereValue = "0";
      listes.add(Matiere(0, "Choix de matière", 0.0, 0));
      matieres=listes;
      print(matieres[0].Designation);
    });
  }

  void settingData() async{
    Map<String, dynamic> param =
    ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
    Note note=await noteServ.getNote(param["id"]);
    if (param != null) {
      setState((){
        id=param["id"];
        matriculeController.text = note.N_Mat;
        anneeController.text = note.Annee;
        niveauValue=note.Niveau;
        parcoursValue = note.Parcours;
        noteController.text = '${note.note}';
      });
      await setMatiereInit(niveauValue, parcoursValue);
      setState(() {
        matiereValue = '${note.Id_Mat}';
        print(matiereValue);
      });
      //settingData();
    }
  }

  void showSuccessMessage(String message){
    SnackBar snackBar=SnackBar(
      content: Text(message),
      backgroundColor: Colors.lightGreen,
    );
    ScaffoldMessenger.of(context as BuildContext).showSnackBar(snackBar);
  }

  void showErrorMessage(String message){
    SnackBar snackBar=SnackBar(
      content: Text(message,style: TextStyle(color: Colors.white),),
      backgroundColor: Colors.red,
    );
    ScaffoldMessenger.of(context as BuildContext).showSnackBar(snackBar);
  }
}
