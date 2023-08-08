import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:myapp/services/ueService.dart';
import 'package:menu_bar/menu_bar.dart';
import '../../Models/UE.dart';
import '../../Widget/NavMenu.dart';
import 'listUE.dart';
import 'listUE.dart';
class ListUE extends StatefulWidget {
  final String base;
  const ListUE({super.key, required this.base});
  @override
  State<ListUE> createState() => _ListUEState();
}

class _ListUEState extends State<ListUE> {
  bool isLoading=true;
  List<UE> ues=[];
  ueService ueServ=ueService();
  TextEditingController searchController=TextEditingController();

  void _modal(BuildContext context,int id) => showModalBottomSheet(
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
  void initState(){
    lister();
  }
  @override
  Widget build(BuildContext context) {
    print(widget.base);
    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: <Widget>[
            Text("Unité d'enseignement"),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
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
                ),
              ],
            )
          ],
        ),

        //centerTitle: true,
      ),
      body: Visibility(
        visible: isLoading,
        child:Center(child: CircularProgressIndicator(),),
        replacement: RefreshIndicator(
          onRefresh: lister,
          child: ListView.builder(
              itemCount: ues.length,
              itemBuilder: (context,index){
                UE ue=ues[index];
                print(ue.Designation);

                int id =ue.Id_UE;
                return Card(
                  child: ListTile(
                      //leading: Text(item.N_mat),
                      title: Text(ue.Designation),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Text('Niveau : '+'${ue.Niveau}'),
                          Text('Credit : '+'${ue.Credit}'),
                          Text('Parcours : '+'${ue.Parcours}'),
                        ],
                      ),
                      trailing: PopupMenuButton(
                        onSelected: (value){
                          if(value == 'edit'){
                            print("mandalo @ edit");
                            Navigator.pushNamed(context, '/modifierUE',arguments: {"id":id});
                          }else if(value == 'delete'){
                            _modal(context, id);
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
                  ),
                );
              }),
        ),
      ),
      floatingActionButton: FloatingActionButton(onPressed: (){Navigator.pushNamed(context, '/ajoutUE');},child:Text("+")),
      //body:
    );
  }

  Future<void> deleteById(int id) async{
    //http.Response response=await http.delete(Uri.parse('http://10.0.2.2:5000/medecin/remove/$id'));
    if(await ueServ.deleteById(id,widget.base)){
      showSuccessMessage("Suppression effectué");
    }else{
      showErrorMessage("Erreur de suppression");
    }
    lister();
  }
  Future<void> lister() async{
    setState(() {
      isLoading=true;
    });
    List<UE> liste=await ueServ.lister(widget.base);
    setState(()  {
      ues=liste;
      isLoading=false;
    });
  }
  Future<void> rechercher(String to_search)async {
    List<UE> liste=await ueServ.listerRecherche(to_search,widget.base);
    setState(() {
      ues=liste;
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

