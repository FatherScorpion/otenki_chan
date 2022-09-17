import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:async/async.dart';
import 'package:geolocator/geolocator.dart';

class OtenkiAppbar extends StatefulWidget with PreferredSizeWidget {
  final Function addChatLog;
  final Function addOpponentChatLog;
  OtenkiAppbar({Key? key, required this.addChatLog, required this.addOpponentChatLog}) : super(key: key);

  @override
  State<OtenkiAppbar> createState() => _OtenkiAppbar();

  @override
  Size get preferredSize => const Size.fromHeight(160);
}

class _OtenkiAppbar extends State<OtenkiAppbar> {
  double height = 178;

  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          decoration: const BoxDecoration(color: Colors.cyanAccent),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                width: height,
                height: height,
                child: Image.asset('images/teresakunn.png', fit: BoxFit.contain),
              ),
              SizedBox(
                width: 150,
                height: height,
                child: ElevatedButton(
                  onPressed: () => {
                    widget.addChatLog('天気を教えて！'),
                    onPushWeatherButton(widget.addOpponentChatLog),
                  },
                  style: ElevatedButton.styleFrom(
                      elevation: 0,
                      primary: Colors.greenAccent,
                      onPrimary: Colors.white
                  ),
                  child: const Text('天気\n教えて！', style: TextStyle(fontSize: 29, fontWeight: FontWeight.bold)),
                ),
              ),
              Container(
                height: height,
                color: Colors.redAccent,
                child: IconButton(
                  color: Colors.white,
                  onPressed: () => {},
                  icon: const Icon(Icons.delete),
                  iconSize: 75,
                ),
              ),
            ],
          ),
        ),
        const Divider(
          color: Colors.cyan,
          thickness: 5,
          height: 0,
        ),
      ],
    );
  }
}

void onPushWeatherButton(Function addOpponentChatLog) async{
  var token=await getWeatherToken();
  //String token="hoge";
  var tmp=await getTemperatureData(token);
  var pre=await getPrecipitationData(token);
  var slr=await getSolarData(token);
  addOpponentChatLog(tmp,pre,slr);
}

Future<String> getWeatherToken() async{
  var serverURL="https://hackathon-api.compass.tenchijin.co.jp/v1/access-token";
  Uri _uri=Uri.parse(serverURL);
  String query= '{"username": "s19007@tokyo.kosen-ac.jp","password": "hH3xswLZ"}';
  final requestUtf8 = utf8.encode(query);

  try{
    final response=await http.post(_uri,body: requestUtf8, headers: {"content-type": "application/json"});
    return jsonDecode(response.body)['token'] as String;
  }catch(error){
    throw Exception(error.toString());
  }
}

Future<List<double>> getTemperatureData(String token) async{
  double lat,lng;
  Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  lat=position.latitude;
  lng=position.longitude;

  var serverURL="https://hackathon-api.compass.tenchijin.co.jp/v1/forecast/temperature/latest";
  Uri _uri=Uri.parse(serverURL);
  Map<String, double> query= {"lat": lat,"lng": lng};
  final requestUtf8 = jsonEncode(query);

  try{
    final response=await http.post(_uri,body: requestUtf8, headers: {"content-type": "application/json", "Authorization": "Bearer ${token}"});
    Map<String,dynamic> map=jsonDecode(response.body);
    final ret=<double>[map['data'][6]['temperature'],map['data'][10]['temperature']];
    print(ret);
    return ret;
  }catch(error){
    throw Exception(error.toString());
  }
}

Future<List<double>> getPrecipitationData(String token) async{
  double lat,lng;
  Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  lat=position.latitude;
  lng=position.longitude;

  var serverURL="https://hackathon-api.compass.tenchijin.co.jp/v1/forecast/precipitation/latest";
  Uri _uri=Uri.parse(serverURL);
  Map<String, double> query= {"lat": lat,"lng": lng};
  final requestUtf8 = jsonEncode(query);

  try{
    final response=await http.post(_uri,body: requestUtf8, headers: {"content-type": "application/json", "Authorization": "Bearer ${token}"});
    Map<String,dynamic> map=jsonDecode(response.body);
    final ret=<double>[map['data'][6]['precipition'],map['data'][10]['precipition']];
    print(ret);
    return ret;
  }catch(error){
    throw Exception(error.toString());
  }
}

Future<List<double>> getSolarData(String token) async{
  double lat,lng;
  Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  lat=position.latitude;
  lng=position.longitude;

  var serverURL="https://hackathon-api.compass.tenchijin.co.jp/v1/forecast/solar-radiation/latest";
  Uri _uri=Uri.parse(serverURL);
  Map<String, double> query= {"lat": lat,"lng": lng};
  final requestUtf8 = jsonEncode(query);

  try{
    final response=await http.post(_uri,body: requestUtf8, headers: {"content-type": "application/json", "Authorization": "Bearer ${token}"});
    Map<String,dynamic> map=jsonDecode(response.body);
    final ret=<double>[map['data'][6]['solarRadiation'],map['data'][10]['solarRadiation']];
    print(ret);
    return ret;
  }catch(error){
    throw Exception(error.toString());
  }
}
