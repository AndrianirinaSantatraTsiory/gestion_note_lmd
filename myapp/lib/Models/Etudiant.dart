
class Etudiant{
  String N_mat="";
  String Nom="";
  String Prenom="";
  String Classe="";
  String Phone="";
  String Mail="";
  String Parcours="";

  Etudiant(this.N_mat, this.Nom,this.Prenom, this.Classe, this.Parcours, this.Phone, this.Mail);

  Map toJson() => {
    'N_mat':N_mat,
    'Nom':Nom,
    'Prenom':Prenom,
    'Niveau':Classe,
    'Parcours':Parcours,
    'Phone':Phone,
    'Mail':Mail
  };

}