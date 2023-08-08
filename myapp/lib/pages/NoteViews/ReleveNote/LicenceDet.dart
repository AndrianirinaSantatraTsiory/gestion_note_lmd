import 'package:flutter/material.dart';
import 'package:myapp/services/EtudiantService.dart';
import 'package:myapp/services/noteService.dart';

import '../../../Models/Etudiant.dart';
class LicenceDet extends StatefulWidget {
  const LicenceDet({super.key});

  @override
  State<LicenceDet> createState() => _LicenceDetState();
}

class _LicenceDetState extends State<LicenceDet> {
  String matricule="";
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
      body: ListView(
        padding: EdgeInsets.all(20.0),
        children: <Widget>[
          Padding(
              padding:EdgeInsets.fromLTRB(0, 30.0, 0, 20.0) ,
              child: ElevatedButton(
                onPressed: (){Navigator.pushNamed(context, '/noteDetaille',arguments: {"matricule":matricule,"niveau":"L1"});},
                child: Text("L1"),
              )
          ),
          Padding(
              padding:EdgeInsets.fromLTRB(0, 30.0, 0, 20.0) ,
              child: ElevatedButton(
                onPressed: (){Navigator.pushNamed(context, '/noteDetaille',arguments: {"matricule":matricule,"niveau":"L2"});},
                child: Text("L2"),
              )
          ),
          Padding(
              padding:EdgeInsets.fromLTRB(0, 30.0, 0, 20.0) ,
              child: ElevatedButton(
                onPressed: (){Navigator.pushNamed(context, '/noteDetaille',arguments: {"matricule":matricule,"niveau":"L3"});},
                child: Text("L3"),
              )
          ),
        ],
      ),
    );
  }
  Future<void> settingData() async {
    Map<String, dynamic> param =
    ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;

    //Matiere matiere=await matServ.getMatiere(param["id"]);
    if (param != null) {
      setState(() {
        matricule=param["matricule"];
      });
    }
  }
}
