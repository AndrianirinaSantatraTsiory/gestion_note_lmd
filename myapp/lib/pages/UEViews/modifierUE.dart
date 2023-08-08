import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:myapp/services/matiereService.dart';
import 'package:myapp/services/ueService.dart';

import '../../Models/Matiere.dart';
import '../../Models/UE.dart';
class ModifierUE extends StatefulWidget {
  final String base;
  const ModifierUE({super.key, required this.base});

  @override
  State<ModifierUE> createState() => _ModifierUEState();
}

class _ModifierUEState extends State<ModifierUE> {
   int identifiantUE=0;
   List<Matiere> matieres=[];
   ueService ueServ=ueService();
   MatiereService matServ=MatiereService();
   TextEditingController designationController=TextEditingController();
   TextEditingController creditController=TextEditingController();
   String niveauValue="L1";
   String parcoursValue="GB";
   List<String> niveaux=['L1','L2','L3','M1','M2'];
   List<String> parcours=['GB','SR','IG'];
   String designationError="";
   String creditError="";

   void _modal(BuildContext context) => showModalBottomSheet(
     context: context,
     builder: (context) => ListView(
       children:<Widget>[
         Column(
             children:<Widget>[
               Column(
                 children: matieres.map((matiere){
                   int id =matiere.Id_Mat;
                   return ListTile(
                     //leading: Text(item.N_mat),
                       title: Text(matiere.Designation),
                       subtitle: Column(
                         crossAxisAlignment: CrossAxisAlignment.stretch,
                         children: <Widget>[
                           Text('poids : '+'${matiere.poids}'),
                         ],
                       ),
                       trailing: PopupMenuButton(
                         onSelected: (value){
                           if(value == 'edit'){
                             Navigator.pushNamed(context, '/modifierMatiere',arguments: {"id":id,"id_UE":identifiantUE});
                           }else if(value == 'delete'){
                             _modalSupr(context, id);
                           }
                         },
                         itemBuilder: (context){
                           return [
                             PopupMenuItem(
                               child: Icon(
                                 Icons.edit,
                               ),
                               value: 'edit',
                             ),
                             PopupMenuItem(
                               child: Icon(
                                 Icons.delete,
                               ),
                               value: 'delete',
                             ),
                           ];
                         },)
                   );
                 }).toList(),
               ),
               Row(
                 mainAxisAlignment: MainAxisAlignment.end,
                 crossAxisAlignment: CrossAxisAlignment.end,
                 children: [
                   TextButton(
                     onPressed: (){Navigator.pop(context);},
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

   void _modalSupr(BuildContext context,int id) => showModalBottomSheet(
     context: context,
     builder: (context) => Column(
         children:<Widget>[
           SizedBox(height: 30.0),
           Column(
               children:<Widget>[
                 Column(
                   crossAxisAlignment: CrossAxisAlignment.center,
                   children: <Widget>[
                     Text(
                       "Voulez vous vraiment supprimé?",
                       style: TextStyle(fontSize: 20.0),
                     ),
                   ],
                 ),

                 Row(
                   mainAxisAlignment: MainAxisAlignment.end,
                   crossAxisAlignment: CrossAxisAlignment.end,
                   children: [
                     TextButton(
                       onPressed: (){Navigator.pop(context);},
                       child: Text(
                         "annuller",
                       ),
                     ),
                     TextButton(
                       onPressed: (){
                         deleteById(id);
                         Navigator.pop(context);
                       },
                       child: Text(
                         "oui",
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
  void didChangeDependencies() {
    super.didChangeDependencies();
    Map<String, dynamic> param =
    ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
    if (param != null) {
      setState(() {
        identifiantUE = param["id"];
      });
      settingData();
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar:AppBar(
        title: Text("Modifier UE"),
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
          Text("Matières"),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Expanded(flex:4,child: IconButton(onPressed:(){_modal(context);}, icon: Icon(Icons.list)),),
              Expanded(child: IconButton(onPressed:(){Navigator.pushNamed(context, '/nouveauMatiere',arguments: {"id":identifiantUE});}, icon: Icon(Icons.add)),),
            ],
          ),
          SizedBox(height: 20,),
          ElevatedButton(onPressed: (){submitData();}, child: Text("Valider")),
        ],
      ),
    );
  }

  void settingData() async {
    UE selectedUE=await ueServ.getUE(identifiantUE,widget.base);
    List<Matiere> matiereList=await matServ.getMatiereUE(identifiantUE);
    setState(() {
      designationController.text=selectedUE.Designation;
      creditController.text='${selectedUE.Credit}';
      niveauValue=selectedUE.Niveau;
      parcoursValue=selectedUE.Parcours;
      matieres=matiereList;
    });
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
    Map<dynamic,dynamic> reponse=await ueServ.updateUE(identifiantUE, ue,widget.base);
    Navigator.of(context).pop();
    if(reponse["status"]){
      showSuccessMessage("Mise à jours effectué");
      Navigator.pushReplacementNamed(context, '/listUE');
    }else {
      showErrorMessage("Echec de la mise à jours");
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

   Future<void> deleteById(int id) async{
     //http.Response response=await http.delete(Uri.parse('http://10.0.2.2:5000/medecin/remove/$id'));
     if(await matServ.deleteById(id)){
       showSuccessMessage("Matière supprimé avec succès");
       List<Matiere> matiereList=await matServ.getMatiereUE(identifiantUE);
       setState(() {
         matieres=matiereList;
       });
     }else{
       showErrorMessage("Erreur de suppression");
     }
     Navigator.pop(context);
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
