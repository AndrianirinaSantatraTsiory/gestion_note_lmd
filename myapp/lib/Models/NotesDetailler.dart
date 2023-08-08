import 'package:myapp/Models/Matiere.dart';

import '../services/matiereService.dart';


import 'Matiere.dart';
import 'Note.dart';

class NoteDetailler{
  int Id_Note=0;
  String Matiere="";
  String N_Mat="";
  double note=0.0;
  String Annee="";
  String Niveau="";
  String Parcours="";

  //NoteDetailler()


  Map toJson() => {
    'Id_Note':Id_Note,
    'Matiere':Matiere,
    'N_mat':N_Mat,
    'note':note,
    'Annee':Annee,
    'Niveau':Niveau,
    'Parcours':Parcours,
  };

}