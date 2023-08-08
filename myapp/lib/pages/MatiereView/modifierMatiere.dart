import 'package:flutter/material.dart';

import '../../Models/Matiere.dart';
import '../../services/matiereService.dart';
class ModifierMatiere extends StatefulWidget {
  const ModifierMatiere({super.key});

  @override
  State<ModifierMatiere> createState() => _ModifierMatiereState();
}

class _ModifierMatiereState extends State<ModifierMatiere> {
  int identifiantUE=0;
  int id_Mat=0;
  MatiereService matServ=MatiereService();
  TextEditingController designationController=TextEditingController();
  TextEditingController poidsController=TextEditingController();
  String designationError="";
  String poidsError="";

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    settingData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        title: Text("Modifier Matiere"),
        centerTitle: true,
      ),
      body: ListView(
        padding: EdgeInsets.all(20.0),
        children: <Widget>[
          TextFormField(
            controller: designationController,
            decoration: InputDecoration(
              hintText: 'Designation',
              border: OutlineInputBorder(),
              errorText: (designationError!="")?designationError:null,
            ),
          ),
          SizedBox(height: 15.0),
          TextFormField(
            controller: poidsController,
            decoration: InputDecoration(
              hintText: 'Poids',
              border: OutlineInputBorder(),
              errorText: (poidsError!="")?poidsError:null,
            ),
            keyboardType: TextInputType.number,
          ),
          SizedBox(height: 20,),
          ElevatedButton(onPressed: (){submitData();}, child: Text("Valider")),
        ],
      ),
    );
  }

  void submitData() async{
    String designation=designationController.text;
    double poids=double.parse(poidsController.text);
    Matiere matiere=Matiere(0, designation,poids,identifiantUE);
    showDialog(
      context: context,
      barrierDismissible:false,
      builder: (context) {
        return Center(child: CircularProgressIndicator());
      },
    );
    Map<dynamic,dynamic> reponse=await matServ.updateMatiere(id_Mat,matiere);
    Navigator.of(context).pop();
    if(reponse["status"]){
      showSuccessMessage("Modification effectué");
      Navigator.pushReplacementNamed(context, '/modifierUE', arguments: {"id":identifiantUE});

    }else {
      showErrorMessage("Echec de la modification");
      Map<String, String> message = reponse["message"];
      if (message["Designation"] != null) {
        setState(() {
          designationError = message["Designation"]!;
        });
      }
      if (message["Poids"] != null) {
        setState(() {
          poidsError = message["Poids"]!;
        });
      }
    }
  }

  void settingData() async{
    Map<String, dynamic> param =
    ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
    Matiere matiere=await matServ.getMatiere(param["id"]);
    if (param != null) {
      setState(() {
        id_Mat=param["id"];
        identifiantUE = param["id_UE"];
        designationController.text=matiere.Designation;
        poidsController.text="${matiere.poids}";
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
