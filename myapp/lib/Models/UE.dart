import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:myapp/pages/EtudiantViews/listEtudiants.dart';

class UE{
  int Id_UE;
  String Designation="";
  int Credit;
  String Niveau="";
  String Parcours="";


  UE(this.Id_UE, this.Designation, this.Credit, this.Niveau,this.Parcours);

  Map toJson() => {
    'Id_UE':Id_UE,
    'Designation':Designation,
    'Credit':Credit,
    'Niveau':Niveau,
    'Parcours':Parcours
  };
}