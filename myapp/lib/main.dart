

import 'package:flutter/material.dart';
import 'package:myapp/Models/NotesDetailler.dart';
import 'package:myapp/pages/AccessView/Login.dart';
import 'package:myapp/pages/AccessView/MainPage.dart';
import 'package:myapp/pages/EtudiantViews/listEtudiants.dart';
import 'package:myapp/pages/EtudiantViews/modifierEtudiant.dart';
import 'package:myapp/pages/EtudiantViews/nouveauEtudiant.dart';
import 'package:myapp/pages/MatiereView/modifierMatiere.dart';
import 'package:myapp/pages/MatiereView/nouveauMatiere.dart';
import 'package:myapp/pages/NoteViews/ReleveNote/LicenceDet.dart';
import 'package:myapp/pages/NoteViews/ReleveNote/MasterDet.dart';
import 'package:myapp/pages/NoteViews/ReleveNote/licence_Master.dart';
import 'package:myapp/pages/NoteViews/ReleveNote/noteDetaille.dart';
import 'package:myapp/pages/NoteViews/listNote.dart';
import 'package:myapp/pages/NoteViews/modifierNote.dart';
import 'package:myapp/pages/NoteViews/nouveauNote.dart';
import 'package:myapp/pages/UEViews/listUE.dart';
import 'package:myapp/pages/UEViews/modifierUE.dart';
import 'package:myapp/pages/UEViews/nouveauUE.dart';

import 'package:myapp/pages/loading.dart';
void main() {
  String base="http://10.0.2.2:8000";
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      initialRoute: '/loading',
      routes:{
        //'/':(context) => Loading(),
        '/listEtudiant':(context) => ListEtudiants(),
        '/ajoutEtudiant':(context) => NouveauEtudiant(),
        '/modifierEtudiant':(context) => ModificationEtudiant(),
        '/listUE':(context) => ListUE(base: base,),
        '/ajoutUE':(context) => NouveauUE(base: base,),
        '/modifierUE':(context) => ModifierUE(base: base,),
        '/nouveauMatiere':(context) => NouveauMatiere(),
        '/modifierMatiere':(context) => ModifierMatiere(),
        '/nouveauNote':(context) => NouveauNote(),
        '/listNote':(context) => ListNote(),
        '/modifierNote':(context) => ModifierNote(),
        '/licenceMaster':(context) => LicenceMaster(),
        '/licenceDet':(context) => LicenceDet(),
        '/masterDet':(context) => MasterDet(),
        '/noteDetaille':(context) => NoteDetaille(),
        '/mainPage':(context) => mainPage(),
        '/login':(context) => Login(),
        '/loading':(context) => Loading(),
      },
  ));
}


