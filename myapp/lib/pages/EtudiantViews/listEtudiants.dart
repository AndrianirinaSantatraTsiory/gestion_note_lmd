import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:myapp/Models/Etudiant.dart';
import 'package:myapp/services/EtudiantService.dart';

import '../../Widget/NavMenu.dart';

class ListEtudiants extends StatefulWidget {
  const ListEtudiants({super.key});

  @override
  State<ListEtudiants> createState() => _ListEtudiantsState();
}

class _ListEtudiantsState extends State<ListEtudiants> {
  bool isLoading=true;
  List<Etudiant> items=[];
  EtudiantService etudServ=EtudiantService();
  TextEditingController searchController=TextEditingController();
  @override
  void initState(){
    lister();
  }

  void _modal(BuildContext context,String id) => showModalBottomSheet(
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
  Widget build(BuildContext context) {
    String search="";
    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: <Widget>[
            Text("Etudiant"),
            Row(
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: NavMenu(),
                ),
                Expanded(
                    flex: 3,
                    child: TextField(
                      controller: searchController,
                      onChanged: (String value){
                        rechercher(value);
                        print(value);
                      },
                      decoration: InputDecoration(hintText: 'rechercher'),
                    ),
                ),
                Expanded(
                  flex: 1,
                  child: IconButton(
                    onPressed: null,
                    icon:Icon(Icons.search),
                  ),
                )
              ],
            )
          ],
        ),

        //centerTitle: true,
      ),
      body: Visibility(
        visible: isLoading,
        child: Center(child: CircularProgressIndicator(),),
        replacement: RefreshIndicator(
          onRefresh: lister,
          child: ListView.builder(
              itemCount: items.length,
              itemBuilder: (context,index){
                Etudiant item=items[index];
                print(item.N_mat);

                String id =item.N_mat;
                return Card(
                  child: ListTile(
                      leading: Text(item.N_mat),
                      title: Text(item.Nom),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Text('${item.Prenom}'),
                          Text('Classe : '+'${item.Classe}'),
                          Text('Parcours : '+'${item.Parcours}'),
                          Text('Mail : '+'${item.Mail}'),
                          Text('Téléphone : '+'${item.Phone}'),
                        ],
                      ),
                      trailing: PopupMenuButton(
                        onSelected: (value){
                          if(value == 'edit'){
                            Navigator.pushNamed(context, '/modifierEtudiant',arguments: {"id":id});
                          }else if(value == 'delete'){
                            _modal(context, id);
                            //deleteById(id);
                          }if(value == 'note'){
                            Navigator.pushNamed(context, '/licenceMaster',arguments: {"matricule":id});
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
                            PopupMenuItem(
                              child: Icon(Icons.note_alt),
                              value: 'note',
                            ),
                          ];
                        },)
                  ),
                );
              }),
        ),
      ),
      floatingActionButton: FloatingActionButton(onPressed: (){Navigator.pushNamed(context, '/ajoutEtudiant');},child:Text("+")),
      //body:
    );
  }

  Future<void> deleteById(String id) async{
    //http.Response response=await http.delete(Uri.parse('http://10.0.2.2:5000/medecin/remove/$id'));
    if(await etudServ.deleteById(id)){
      showSuccessMessage("Suppression effectué");
    }else{
      showErrorMessage("Erreur de suppression");
    }
    lister();
  }
  Future<void> lister() async{
    print("mandalo amin'ny loading");
    setState(() {
      isLoading=true;
    });
    List<Etudiant> liste=await etudServ.lister();
    setState(()  {
      items=liste;
      isLoading=false;
    });
  }
  Future<void> rechercher(String to_search)async {
    List<Etudiant> liste=await etudServ.listerRecherche(to_search);
    setState(() {
      items=liste;
    });
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
