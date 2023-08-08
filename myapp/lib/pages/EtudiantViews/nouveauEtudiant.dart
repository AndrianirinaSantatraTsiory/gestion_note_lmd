import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import '../../Models/Etudiant.dart';
import '../../services/EtudiantService.dart';

class NouveauEtudiant extends StatefulWidget {
  const NouveauEtudiant({super.key});

  @override
  State<NouveauEtudiant> createState() => _NouveauEtudiantState();
}

class _NouveauEtudiantState extends State<NouveauEtudiant> {
  EtudiantService etudServ=EtudiantService();
  TextEditingController matriculeController=TextEditingController();
  TextEditingController nomController=TextEditingController();
  TextEditingController prenomController=TextEditingController();
  TextEditingController mailController=TextEditingController();
  TextEditingController phoneContoller=TextEditingController();
  TextEditingController parcoursController=TextEditingController();
  //TextEditingController niveauController=TextEditingController();
  String niveauValue="L1";
  String parcoursValue="GB";
  List<String> niveaux=['L1','L2','L3','M1','M2'];
  List<String> parcours=['GB','SR','IG'];
  String matriculeError="";
  String nomError="";
  String mailError="";
  String prenomError="";
  String phoneError="";
  final _formKey = GlobalKey<FormState>();
  @override
  void initState(){
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        title: Text("Nouveau Etudiant"),
        centerTitle: true,
      ),
      body: Form(
        key:_formKey,
        child: ListView(
          padding: EdgeInsets.all(20.0),
          children: <Widget>[

            TextFormField(

              controller: matriculeController,
              decoration: InputDecoration(
                  hintText: 'N°Matricule',
                  border: OutlineInputBorder(),
                  errorText:(matriculeError!="")?matriculeError:null,
              ),
              //errorText: matriculeController.text.isEmpty ? 'Veuillez remplir le champ N°Matricule' : null,
            ),
            SizedBox(height: 15.0),
            TextFormField(
              controller: nomController,
              decoration: InputDecoration(
                  hintText: 'Nom',
                  border: OutlineInputBorder(),
                  errorText:(nomError!="")?nomError:null,
              ),
            ),
            SizedBox(height: 15.0),
            TextFormField(
              controller: prenomController,
              decoration: InputDecoration(
                  hintText: 'Prenom',
                  border: OutlineInputBorder(),
                  errorText:(prenomError!="")?prenomError:null,
              ),
            ),
            SizedBox(height: 15.0),
            //manomboka etoooooooooooooooooo
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

            //mifarana etoooooooooooooooooooo
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

            TextFormField(
              controller: mailController,
              decoration: InputDecoration(
                  hintText: 'Mail',
                  border: OutlineInputBorder(),
                  errorText:(mailError!="")?mailError:null,
              ),
            ),
            TextFormField(
              controller: phoneContoller,
              onChanged:(value){
                setState(() {
                  phoneError="";
                });
                if(value.length>10){
                  setState(() {
                    phoneError="le numero téléphone est trop long";
                  });
                }
              },
              decoration: InputDecoration(
                  hintText: 'Téléphone',
                  border: OutlineInputBorder(),
                  errorText:(phoneError!="")?phoneError:null,
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20,),
            ElevatedButton(onPressed: (){submitData();}, child: Text("Valider")),
          ],
        ),
      ),
    );
  }
  void submitData() async{
    String matricule=matriculeController.text;
    String nom=nomController.text;
    String mail=mailController.text;
    String phone=phoneContoller.text;
    String prenom=prenomController.text;
    print(prenom);
    Etudiant etud=Etudiant(matricule, nom,prenom, niveauValue,parcoursValue, phone, mail);
    //showSuccessMessage("Ajout avec succès");
    showDialog(
      context: context,
      barrierDismissible:false,
      builder: (context) {
        return Center(child: CircularProgressIndicator());
      },
    );
    Map<dynamic,dynamic> reponse=await etudServ.createEtudiant(etud);
    Navigator.of(context).pop();
    if(reponse["status"]){
     showSuccessMessage("Ajout avec succès");
     Navigator.pushReplacementNamed(context, '/listEtudiant');
    }else{
      showErrorMessage("Echec de l'ajout");
      Map<String,String> message=reponse["message"];
      if(message["N_mat"]!=null){
        setState(() {
          matriculeError=message["N_mat"]!;
        });
      }
      if(message["Nom"]!=null){
        setState(() {
          nomError=message["Nom"]!;
        });
      }
      if(message["Prenom"]!=null){
        setState(() {
          prenomError=message["Prenom"]!;
        });
      }
      if(message["Mail"]!=null){
        setState(() {
          mailError=message["Mail"]!;
        });
      }
      if(message["Phone"]!=null){
        setState(() {
          phoneError=message["Phone"]!;
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
