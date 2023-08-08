import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:myapp/services/noteService.dart';
import 'package:myapp/services/word_time.dart';
import 'dart:convert';

class Loading extends StatefulWidget {
  const Loading({super.key});

  @override
  State<Loading> createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  String time="loading...";
  String texte="exemple";
  void getTime() async {
    NoteService noteServ=NoteService();
    await noteServ.getReleveNote("2263", "L1", "GB");

  }
  @override
  void initState(){
    super.initState();
    attente();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[900],
      body: Padding(
        padding: EdgeInsets.all(50.0),
        child: Center(
          child: SpinKitRotatingCircle(
            color: Colors.white,
            size: 50.0,
          ),
        ),
      )
    );
  }
  Future<void> attente() async {
    await Future.delayed(Duration(seconds: 3),(){});
    Navigator.pushReplacementNamed(context, '/mainPage');
  }
}
