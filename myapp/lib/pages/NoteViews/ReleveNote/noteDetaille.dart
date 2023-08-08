import 'dart:io';
import 'package:flutter/material.dart';
import 'package:myapp/services/EtudiantService.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw ;
import 'package:path_provider/path_provider.dart';
import '../../../Models/Etudiant.dart';
import '../../../services/noteService.dart';
class NoteDetaille extends StatefulWidget {
  const NoteDetaille({super.key});

  @override
  State<NoteDetaille> createState() => _NoteDetailleState();
}

class _NoteDetailleState extends State<NoteDetaille> {
  bool isLoading=true;
  NoteService noteServ=NoteService();
  List<dynamic> ues=[];
  Map<String,dynamic> notes={};
  String matricule="";
  String nom="";
  String prenom="";
  String niveau="";
  String annee="";
  String parcours="";
  String moyenneGen="";
  bool valideNiveau=false;
  int creditTotal=0;

  @override
  void didChangeDependencies(){
    setNote();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        title: Text("Relevé des notes"),
        centerTitle: true,
      ),
      body: Visibility(
        visible: isLoading,
        child: Center(child: CircularProgressIndicator(),),
        replacement: ListView(
          padding: EdgeInsets.all(20.0),
          children: <Widget>[
            Text("Nom : "+nom+" "+prenom),
            Text("Niveau : "+niveau),
            Text("Parcours : "+parcours),
            SizedBox(height: 20.0,),
            Container(
              decoration:BoxDecoration(
                border:Border.all(color: Colors.black,width: 2.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: ues.map((ue){
                  bool valideUE=true;
                  int credit=0;

                  List<dynamic> matieres=ue["matieres"];
                  return Container(
                    margin: EdgeInsets.fromLTRB(20.0, 10.0, 0.0, 5.0),

                    child: Column(
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                                ue["designation"],
                            ),
                          ],
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(20.0, 10.0, 0.0, 5.0),
                          child: Column(
                            children: matieres.map((matiere){
                              if(matiere["note"]<5||!ue["valide"]){
                                valideUE=false;
                                valideNiveau=false;
                                //valideUE=false;
                              }
                              if(valideUE){
                                credit=ue["credit"];
                                creditTotal=creditTotal+credit;
                              }
                              return Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(matiere["Designation"]),
                                  Text(
                                    '${matiere["note"]}',
                                      style: TextStyle(color: (matiere["note"]>=10)?Colors.lightGreen:Colors.red),
                                  )
                                ],
                              );
                            }).toList()
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Moyenne : "+'${ue["moyenne"]}',
                                style: TextStyle(color: (valideUE)?Colors.lightGreen:Colors.red)
                            ),
                            Text("Credit : "+'${credit}'),
                            Text(
                              (valideUE)?'validé':'non validé',
                                style: TextStyle(color: (valideUE)?Colors.lightGreen:Colors.red)
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                }
                ).toList(),
              ),
            ),
            SizedBox(height: 30.0,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "MOYENNE GEN : "+moyenneGen,
                    style: TextStyle(color: (valideNiveau&&ues.length>0)?Colors.lightGreen:Colors.red),
                ),
                Text("TOTAL CREDIT : "+'${creditTotal}'),
                Text(
                    "VALIDE :"+((valideNiveau&&ues.length>0)?'OUI':'NON'),
                  style: TextStyle(color: (valideNiveau&&ues.length>0)?Colors.lightGreen:Colors.red),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  void setNote() async{
    setState(() {
      isLoading=true;
    });
    await settingData();
    notes=await noteServ.getReleveNote(matricule, niveau, parcours);
    Map<String,dynamic> etudiant=notes["etudiant"];
    setState((){
      moyenneGen='${notes["moyenne_generale"]}';
      ues=notes["ues"];
      valideNiveau=notes["valide_niveau"];
      nom=etudiant["Nom"];
      prenom=etudiant["Prenom"];
      matricule=etudiant["N_mat"];
      parcours=etudiant["Parcours"];
      isLoading=false;
    });
  }

  Future<void> settingData() async {
    Map<String, dynamic> param =
    ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
    EtudiantService etudServ=EtudiantService();
    if (param != null) {
      Etudiant etud=await etudServ.getEtudiant(param["matricule"]);
      setState(() {
        matricule=param["matricule"];
        niveau=param["niveau"];
        parcours=etud.Parcours;
      });
    }
  }
}
