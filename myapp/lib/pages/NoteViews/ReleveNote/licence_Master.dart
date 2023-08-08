import 'package:flutter/material.dart';
import 'package:myapp/services/EtudiantService.dart';
import 'package:myapp/services/noteService.dart';

import '../../../Models/Etudiant.dart';
class LicenceMaster extends StatefulWidget {
  const LicenceMaster({super.key});

  @override
  State<LicenceMaster> createState() => _LicenceMasterState();
}

class _LicenceMasterState extends State<LicenceMaster> {
  bool isLoading=true;
  String matricule="2263";
  List<Widget> options=[];
  EtudiantService etudServ=EtudiantService();
  NoteService noteServ=NoteService();
  bool validLicence=false;
  bool validMaster=false;
  @override
  void didChangeDependencies(){
    settingData();
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
            Padding(
                padding:EdgeInsets.fromLTRB(0, 30.0, 0, 20.0) ,
                child: ElevatedButton(
                  onPressed: (){Navigator.pushNamed(context, '/licenceDet',arguments: {"matricule":matricule});},
                  child: Text("Licence"),
                  style:ElevatedButton.styleFrom(
                    primary: (validLicence)?Colors.lightGreen:Colors.red,
                  ),
                )
            ),
            Padding(
                padding:EdgeInsets.fromLTRB(0, 30.0, 0, 20.0) ,
                child: ElevatedButton(
                  onPressed: (){Navigator.pushNamed(context, '/masterDet',arguments: {"matricule":matricule});},
                  child: Text("Master"),
                  style:ElevatedButton.styleFrom(
                    primary: (validMaster)?Colors.lightGreen:Colors.red,
                  ),
                )
            ),
          ],
        ),
      ),
    );
  }
  Future<void> settingData() async {
    Map<String, dynamic> param =
    ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
    setState(() {
      isLoading=true;
    });
    //Matiere matiere=await matServ.getMatiere(param["id"]);
    if (param != null) {
      setState(() {
        matricule=param["matricule"];
      });
    }
    Etudiant etud=await etudServ.getEtudiant(matricule);
    if(await noteServ.isNiveauValid(etud.N_mat, "L1", etud.Parcours)&&await noteServ.isNiveauValid(etud.N_mat, "L2", etud.Parcours)&&await noteServ.isNiveauValid(etud.N_mat, "L3", etud.Parcours)){
      setState(() {
        validLicence=true;
      });
      print(validLicence);
    }
    if(await noteServ.isNiveauValid(etud.N_mat, "M1", etud.Parcours)&&await noteServ.isNiveauValid(etud.N_mat, "M2", etud.Parcours)){
      setState(() {
        validMaster=true;
      });
      print(validLicence);
    }
    setState(() {
      isLoading=false;
    });
  }
}
