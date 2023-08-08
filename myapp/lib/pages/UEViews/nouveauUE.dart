import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:myapp/services/ueService.dart';
import '../../Models/Etudiant.dart';
import '../../Models/UE.dart';

class NouveauUE extends StatefulWidget {
  final String base;
  const NouveauUE({super.key, required this.base});

  @override
  State<NouveauUE> createState() => _NouveauUEState();
}

class _NouveauUEState extends State<NouveauUE> {
  ueService ueServ=ueService();
  TextEditingController designationController=TextEditingController();
  TextEditingController creditController=TextEditingController();
  String niveauValue="L1";
  String parcoursValue="GB";
  List<String> niveaux=['L1','L2','L3','M1','M2'];
  List<String> parcours=['GB','SR','IG'];
  String designationError="";
  String creditError="";
  @override
  void initState(){
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        title: Text("Nouveau UE"),
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
            controller: creditController,
            decoration: InputDecoration(
              hintText: 'Credit',
              border: OutlineInputBorder(),
              errorText: (creditError!="")?creditError:null,
            ),
            keyboardType: TextInputType.number,
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

          SizedBox(height: 20,),
          ElevatedButton(onPressed: (){submitData();}, child: Text("Valider")),
        ],
      ),
    );
  }
  void submitData() async{
    String designation=designationController.text;
    int credit=int.parse(creditController.text);
    UE ue=UE(0, designation,credit,niveauValue,parcoursValue);
    showDialog(
      context: context,
      barrierDismissible:false,
      builder: (context) {
        return Center(child: CircularProgressIndicator());
      },
    );
    Map<dynamic,dynamic> reponse=await ueServ.createUE(ue,widget.base);
    Navigator.of(context).pop();
    if(reponse["status"]){
      showSuccessMessage("Ajout avec succès");
      Navigator.pushReplacementNamed(context, '/listUE');
    }else {
      showErrorMessage("Echec de l'ajout");
      Map<String, String> message = reponse["message"];
      if (message["Designation"] != null) {
        setState(() {
          designationError = message["Designation"]!;
        });
      }
      if (message["Credit"] != null) {
        setState(() {
          creditError = message["Credit"]!;
        });
      }
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
