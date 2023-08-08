import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

import '../../Models/Matiere.dart';
import '../../services/matiereService.dart';

class NouveauMatiere extends StatefulWidget {
  const NouveauMatiere({super.key});

  @override
  State<NouveauMatiere> createState() => _NouveauMatiereState();
}

class _NouveauMatiereState extends State<NouveauMatiere> {
  int identifiantUE=0;
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
        title: Text("Nouveau Matiere"),
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
    print(poids);
    Matiere matiere=Matiere(0, designation,poids,identifiantUE);
    showDialog(
      context: context,
      barrierDismissible:false,
      builder: (context) {
        return Center(child: CircularProgressIndicator());
      },
    );
    Map<dynamic,dynamic> reponse=await matServ.createMatiere(matiere);
    Navigator.of(context).pop();
    if(reponse["status"]){
      showSuccessMessage("Ajout avec succès");
      Navigator.pushReplacementNamed(context, '/modifierUE', arguments: {"id":identifiantUE});
    }else {
      showErrorMessage("Echec de l'ajout");
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

  void settingData(){
    Map<String, dynamic> param =
    ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
    if (param != null) {
      print("id UE"+'${param["id"]}');
      setState(() {
        identifiantUE = param["id"];
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
