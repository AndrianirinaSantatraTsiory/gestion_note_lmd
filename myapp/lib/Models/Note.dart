class Note{
  int Id_Note;
  int Id_Mat;
  String N_Mat;
  double note;
  String Annee="";
  String Niveau="";
  String Parcours="";

  Note(this.Id_Note,this.Id_Mat, this.N_Mat, this.note, this.Annee, this.Niveau,
      this.Parcours);

  Map toJson() => {
    'Id_Note':Id_Note,
    'Id_Mat':Id_Mat,
    'N_mat':N_Mat,
    'note':note,
    'Annee':Annee,
    'Niveau':Niveau,
    'Parcours':Parcours,
  };

}