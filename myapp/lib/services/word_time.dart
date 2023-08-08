import 'package:http/http.dart' as http;
import 'dart:convert';

class WorldTime{
  String location="";
  String time="";
  String flag="";//drapeau
  String url="";

  WorldTime(location,flag,url){
    this.location=location;
    this.flag=flag;
    this.url=url;
  }
  Future<void> getTime() async {

    http.Response response=await http.get(Uri.parse('http://worldtimeapi.org/api/timezone/$url'));

    Map data=jsonDecode(response.body);
    String datetime=data['datetime'];
    String offset=data['utc_offset'].substring(1,3);
    DateTime now = DateTime.parse(datetime);
    time=now.toString();

  }

}
