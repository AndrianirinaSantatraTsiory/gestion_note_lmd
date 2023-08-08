import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import '../../Models/Etudiant.dart';
import '../../services/EtudiantService.dart';

class ModificationEtudiant extends StatefulWidget {
  const ModificationEtudiant({super.key});

  @override
  State<ModificationEtudiant> createState() => _ModificationEtudiantState();
}

class _ModificationEtudiantState extends State<ModificationEtudiant> {
  //Etudiant etud=Etudiant("", "", "", "", "","","");
  EtudiantService etudServ=EtudiantService();
  TextEditingController matriculeController=TextEditingController();
  TextEditingController nomController=TextEditingController();
  TextEditingController prenomController=TextEditingController();
  TextEditingController mailController=TextEditingController();
  TextEditingController phoneContoller=TextEditingController();
  TextEditingController parcoursController=TextEditingController();
  String identifiant="";
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
  void didChangeDependencies() {
    super.didChangeDependencies();
    Map<String, dynamic> param =
    ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
    if (param != null) {
      setState(() {
        identifiant = param["id"];
      });
      settingData();
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar:AppBar(
        title: Text("Modification Etudiant"),
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

  void settingData() async {
    Etudiant selectedEtudiant=await etudServ.getEtudiant(identifiant);
    setState(() {
      matriculeController.text=selectedEtudiant.N_mat;
      nomController.text=selectedEtudiant.Nom;
      prenomController.text=selectedEtudiant.Prenom;
      niveauValue=selectedEtudiant.Classe;
      parcoursValue=selectedEtudiant.Parcours;
      phoneContoller.text=selectedEtudiant.Phone;
      mailController.text=selectedEtudiant.Mail;
    });
  }
  void submitData() async{
    String matricule=matriculeController.text;
    String nom=nomController.text;
    String prenom=prenomController.text;
    String mail=mailController.text;
    String phone=phoneContoller.text;
    Etudiant etud=Etudiant(matricule, nom, prenom,niveauValue,parcoursValue, phone, mail);
    showDialog(
      context: context,
      barrierDismissible:false,
      builder: (context) {
        return Center(child: CircularProgressIndicator());
      },
    );
    Map reponse = await etudServ.updateEtudiant(identifiant,etud);
    Navigator.of(context).pop();
    if(reponse["status"]){
      showSuccessMessage("Mise à jours effectué");
      Navigator.pushReplacementNamed(context, '/listEtudiant');
    }else{
      showErrorMessage("Echec de la mise à jours");
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
