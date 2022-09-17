import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:async/async.dart';
import 'package:geolocator/geolocator.dart';

class OtenkiAppbar extends StatefulWidget with PreferredSizeWidget {
  final Function addChatLog;
  final Function addOpponentChatLog;
  final Function reset;
  final double favRate;
  final int emoType;
  OtenkiAppbar({Key? key, required this.addChatLog, required this.addOpponentChatLog, required this.reset, required this.favRate, required this.emoType}) : super(key: key);

  @override
  State<OtenkiAppbar> createState() => _OtenkiAppbar();

  @override
  Size get preferredSize => const Size.fromHeight(160);
}

class _OtenkiAppbar extends State<OtenkiAppbar> {
  double height = 178;

  final List<List<Widget>> _favIcons = [
    [
      Container(
        width: 178,
        height: 178,
        decoration: const BoxDecoration(
          color: Colors.grey, // アイコンの背景色
          shape: BoxShape.rectangle,
          image: DecorationImage(
              fit: BoxFit.fill,
              image: AssetImage("images/rating0.png")
          ),
        ),
      ),
      Container(
        width: 178,
        height: 178,
        decoration: const BoxDecoration(
          color: Colors.grey, // アイコンの背景色
          shape: BoxShape.rectangle,
          image: DecorationImage(
              fit: BoxFit.fill,
              image: AssetImage("images/rating0_comfort.png")
          ),
        ),
      ),
      Container(
        width: 178,
        height: 178,
        decoration: const BoxDecoration(
          color: Colors.grey, // アイコンの背景色
          shape: BoxShape.rectangle,
          image: DecorationImage(
              fit: BoxFit.fill,
              image: AssetImage("images/rating0_happy.png")
          ),
        ),
      ),
      Container(
        width: 178,
        height: 178,
        decoration: const BoxDecoration(
          color: Colors.grey, // アイコンの背景色
          shape: BoxShape.rectangle,
          image: DecorationImage(
              fit: BoxFit.fill,
              image: AssetImage("images/rating0_surprised.png")
          ),
        ),
      ),
    ],
    [
      Container(
        width: 178,
        height: 178,
        decoration: const BoxDecoration(
          color: Colors.green, // アイコンの背景色
          shape: BoxShape.rectangle,
          image: DecorationImage(
              fit: BoxFit.fill,
              image: AssetImage("images/rating1.png")
          ),
        ),
      ),
      Container(
        width: 178,
        height: 178,
        decoration: const BoxDecoration(
          color: Colors.green, // アイコンの背景色
          shape: BoxShape.rectangle,
          image: DecorationImage(
              fit: BoxFit.fill,
              image: AssetImage("images/rating1_comfort.png")
          ),
        ),
      ),
      Container(
        width: 178,
        height: 178,
        decoration: const BoxDecoration(
          color: Colors.green, // アイコンの背景色
          shape: BoxShape.rectangle,
          image: DecorationImage(
              fit: BoxFit.fill,
              image: AssetImage("images/rating1_happy.png")
          ),
        ),
      ),
      Container(
        width: 178,
        height: 178,
        decoration: const BoxDecoration(
          color: Colors.green, // アイコンの背景色
          shape: BoxShape.rectangle,
          image: DecorationImage(
              fit: BoxFit.fill,
              image: AssetImage("images/rating1_surprised.png")
          ),
        ),
      ),
    ],
    [
      Container(
        width: 178,
        height: 178,
        decoration: const BoxDecoration(
          color: Colors.yellow, // アイコンの背景色
          shape: BoxShape.rectangle,
          image: DecorationImage(
              fit: BoxFit.fill,
              image: AssetImage("images/rating2.png")
          ),
        ),
      ),
      Container(
        width: 178,
        height: 178,
        decoration: const BoxDecoration(
          color: Colors.yellow, // アイコンの背景色
          shape: BoxShape.rectangle,
          image: DecorationImage(
              fit: BoxFit.fill,
              image: AssetImage("images/rating2_comfort.png")
          ),
        ),
      ),
      Container(
        width: 178,
        height: 178,
        decoration: const BoxDecoration(
          color: Colors.yellow, // アイコンの背景色
          shape: BoxShape.rectangle,
          image: DecorationImage(
              fit: BoxFit.fill,
              image: AssetImage("images/rating2_happy.png")
          ),
        ),
      ),
      Container(
        width: 178,
        height: 178,
        decoration: const BoxDecoration(
          color: Colors.yellow, // アイコンの背景色
          shape: BoxShape.rectangle,
          image: DecorationImage(
              fit: BoxFit.fill,
              image: AssetImage("images/rating2_surprised.png")
          ),
        ),
      ),
    ],
  ];

  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          decoration: const BoxDecoration(color: Colors.cyanAccent),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _favIcons[widget.favRate.round()][widget.emoType],
              SizedBox(
                width: 150,
                height: height-15,
                child: ElevatedButton(
                  onPressed: () => {
                    widget.addChatLog({'isMine': 1, 'text': '天気を教えて！', 'favRate': 1.0}),
                    onPushWeatherButton(widget.addOpponentChatLog),
                  },
                  style: ElevatedButton.styleFrom(
                      elevation: 0,
                      primary: Colors.greenAccent,
                      onPrimary: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)
                      ),
                      side: BorderSide(
                        color: Colors.lightGreenAccent,
                        width: 3
                      )
                  ),
                  child: const Text('天気を\n聞く', style: TextStyle(fontSize: 29, fontWeight: FontWeight.bold), textAlign: TextAlign.center,),
                ),
              ),
              Container(
                height: height,
                color: Colors.redAccent,
                child: IconButton(
                  color: Colors.white,
                  onPressed: () => {widget.reset()},
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
  bool serviceEnabled;
  LocationPermission permission;

  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    return Future.error('Location services are disabled.');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      return Future.error('Location permissions are denied');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.');
  }

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
