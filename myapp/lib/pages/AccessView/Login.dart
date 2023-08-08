import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController identifiantController=TextEditingController();
  TextEditingController mdpController=TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        title: Text("Login"),
      ),
      body: Column(
        children: <Widget>[
          SizedBox(height: 50.0,),
          Padding(
            padding: EdgeInsets.all(10),
            child: TextField(
              controller: identifiantController,
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Identifiant',
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(10),
            child: TextField(
              obscureText: true,
              controller: mdpController,
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Mot de passe',
              ),
                keyboardType: TextInputType.visiblePassword
            ),
          ),
          SizedBox(height: 30.0,),
          Container(
            height: 50,
            width: 250,
            decoration: BoxDecoration(
                color: Colors.blue, borderRadius: BorderRadius.circular(20)),
            child: TextButton(
              onPressed: () {
                String id=identifiantController.text;
                String mdp=mdpController.text;
                if((id=="SC1"&&mdp=="123")||(id=="SC2"&&mdp=="1234")||(id=="SC3"&&mdp=="1245")){
                  Navigator.pushReplacementNamed(context, '/listEtudiant');
                  showSuccessMessage("Bienvenue");
                }else{
                  showErrorMessage("Identifiant ou mot de passe incorect");
                }
              },
              child: Text(
                'Login',
                style: TextStyle(color: Colors.white, fontSize: 25),
              ),
            ),
          ),
        ],
      ),
    );
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
