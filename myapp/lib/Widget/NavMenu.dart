import 'package:flutter/material.dart';
class NavMenu extends StatelessWidget {
  const NavMenu({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      icon: Icon(
        Icons.list_outlined,
      ),
      onSelected: (value){
        if(value == 'etudiant'){
          Navigator.pushReplacementNamed(context, '/listEtudiant');
        }else if(value == 'note'){
          Navigator.pushReplacementNamed(context, '/listNote');
        }
        else if(value == 'ue'){
          Navigator.pushReplacementNamed(context, '/listUE');
        }
        else if(value == 'deconnecter'){
          print("deconnecter");
          Navigator.pushReplacementNamed(context, '/mainPage');
        }
      },
      itemBuilder: (context){
        return [
          PopupMenuItem(
            child: Text("Etudiant"),
            value: 'etudiant',
          ),
          PopupMenuItem(
            child: Text("Unité d'enseignement"),
            value: 'ue',
          ),
          PopupMenuItem(
            child: Text("Note"),
            value: 'note',
          ),
          PopupMenuItem(
            child: Text("Deconnecter"),
            value: 'deconnecter',
          ),
        ];
      },);
  }
}
