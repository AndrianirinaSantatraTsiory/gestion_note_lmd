import 'package:flutter/material.dart';
import 'package:myapp/Models/NotesDetailler.dart';
import 'package:myapp/Widget/NavMenu.dart';
import 'package:myapp/services/noteService.dart';

import '../../Models/Note.dart';
class ListNote extends StatefulWidget {
  const ListNote({super.key});

  @override
  State<ListNote> createState() => _ListNoteState();
}

class _ListNoteState extends State<ListNote> {
  bool isLoading=true;
  List<NoteDetailler> notes=[];
  NoteService noteServ=NoteService();
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
    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: <Widget>[
            Text("Note"),
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
                    decoration: InputDecoration(hintText: 'rechercher'),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: IconButton(
                    onPressed: (){
                      rechercher(searchController.text);
                    },
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
        child: Center(child: CircularProgressIndicator()),
        replacement: RefreshIndicator(
          onRefresh: lister,
          child: ListView.builder(
              itemCount: notes.length,
              itemBuilder: (context,index){
                NoteDetailler note=notes[index];
                int id =note.Id_Note;
                return Card(
                  child: ListTile(
                      title: Text('${note.Matiere}'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          //Text('${note.Prenom}'),
                          Text('Parcours : '+'${note.Parcours}'),
                          Text('Niveau : '+'${note.Niveau}'),
                          Text('Matricule: '+'${note.N_Mat}'),
                          Text('Note : '+'${note.note}'),
                        ],
                      ),
                      trailing: PopupMenuButton(
                        onSelected: (value){
                          if(value == 'edit'){
                            print("mandalo @ edit");
                            Navigator.pushNamed(context, '/modifierNote',arguments: {"id":id});
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
      floatingActionButton: FloatingActionButton(onPressed: (){Navigator.pushNamed(context, '/nouveauNote');},child:Text("+")),
      //body:
    );
  }
  Future<void> deleteById(int id) async{
    //http.Response response=await http.delete(Uri.parse('http://10.0.2.2:5000/medecin/remove/$id'));
    if(await noteServ.deleteById(id)){
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
    List<NoteDetailler> liste=await noteServ.lister();
    setState(()  {
      notes=liste;
      isLoading=false;
    });
  }
  Future<void> rechercher(String to_search)async {
    showDialog(
      context: context,
      barrierDismissible:false,
      builder: (context) {
        return Center(child: CircularProgressIndicator());
      },
    );
    List<NoteDetailler> liste=await noteServ.listerRecherche(to_search);
    Navigator.of(context).pop();
    setState(() {
      notes=liste;
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
