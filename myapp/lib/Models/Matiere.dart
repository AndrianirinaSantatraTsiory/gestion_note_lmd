
class Matiere{
  int Id_Mat;
  String Designation="";
  double poids;
  int Id_UE;


  Matiere(this.Id_Mat, this.Designation, this.poids, this.Id_UE);

  Map toJson() => {
    'Id_Mat':Id_Mat,
    'Designation':Designation,
    'Poids':poids,
    'Id_UE':Id_UE,
  };
}