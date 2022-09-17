import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:async/async.dart';
import 'package:geolocator/geolocator.dart';

class OtenkiAppbar extends StatelessWidget with PreferredSizeWidget {
  OtenkiAppbar({Key? key}) : super(key: key);

  double height = 178;

  @override
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
                  onPressed: () => {onPushWeatherButton()},
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

  @override
  Size get preferredSize => const Size.fromHeight(160);
}

void onPushWeatherButton() async{
  Future<String> token=getWeatherToken();
  //String token="hoge";
  token.then((value) => {
    print(value),
    getTemperatureData(value),
    getPrecipitationData(value),
    getSolarData(value)
  });
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

void getTemperatureData(String token) async{
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
    print(response.body);
    //気温をこねこね
  }catch(error){
    throw Exception(error.toString());
  }
}

void getPrecipitationData(String token) async{
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
    print(response.body);
    //降水量をこねこね
  }catch(error){
    throw Exception(error.toString());
  }
}

void getSolarData(String token) async{
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
    print(response.body);
    //日射量をこねこね
  }catch(error){
    throw Exception(error.toString());
  }
}
