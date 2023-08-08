import 'package:flutter/material.dart';
import 'package:myapp/services/EtudiantService.dart';

import '../../Models/Etudiant.dart';
class mainPage extends StatefulWidget {
  const mainPage({super.key});

  @override
  State<mainPage> createState() => _mainPageState();
}

class _mainPageState extends State<mainPage> {
  TextEditingController matriculeController=TextEditingController();
  String matriculeError="";
  void _modal(BuildContext context) => showModalBottomSheet(
    context: context,
    builder: (context) => ListView(
        children:<Widget>[
          SizedBox(height: 30.0,),
          Column(
              children:<Widget>[
                TextFormField(
                  controller: matriculeController,
                  decoration: InputDecoration(
                    hintText: 'Matricule',
                    border: OutlineInputBorder(),
                    errorText: (matriculeError!="")?matriculeError:null,
                  ),
                  keyboardType: TextInputType.number,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: (){Navigator.pop(context);},
                      child: Text(
                        "annuler",
                      ),
                    ),
                    TextButton(
                      onPressed: (){submit();},
                      child: Text(
                        "ok",
                      ),
                    ),
                  ],
                )
              ]
          ),
        ]
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("GESTION DE NOTES"),//centerTitle: true,
      ),
        body:Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            TextButton(
                onPressed: (){_modal(context);},
                style: TextButton.styleFrom(
                  primary: Colors.blue,
                  backgroundColor: Colors.white,
                ),
                child: Row(
                  children: <Widget>[
                    Icon(Icons.school),
                    Text("Etudiant",
                      textAlign: TextAlign.center,
                    )
                  ],
            )),
            SizedBox(height: 50.0,),
            TextButton(
                style: TextButton.styleFrom(
                  primary: Colors.blue,
                  backgroundColor: Colors.white,
                ),
                onPressed: (){
                  Navigator.pushReplacementNamed(context, '/login');
                },
                child: Row(
                  children: <Widget>[
                    Icon(Icons.note_alt_outlined),
                    Text("Scolarité")
                  ],
                ))
          ],
        ),
     );
  }
  Future<void> submit() async {
    EtudiantService etudServ = EtudiantService();
    setState(() {
      matriculeError="";
    });
    print(matriculeController.text);
    if(matriculeController.text!=""){
      List<Etudiant> etudiants=await etudServ.listerRecherche(matriculeController.text);
      if(etudiants.length==0){
        showErrorMessage("Le numero matricule n'existe pas");
        setState(() {
          matriculeError="Le numero matricule n'existe pas";
        });
      }else{
        Navigator.pushNamed(context, '/licenceMaster',arguments: {"matricule":matriculeController.text});
      }
    }else{
      showErrorMessage("Vous avez oublié le numéro matricule");
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
