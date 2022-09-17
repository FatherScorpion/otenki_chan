import 'package:flutter/material.dart';
import 'footer.dart';
import 'chat.dart';
import 'appbar.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<Database> chatDatabase() async {
    return openDatabase(
      join(await getDatabasesPath(), 'chat_database.db'),
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE chat(id INTEGER PRIMARY KEY, isMine INTEGER, text TEXT, favRate REAL)",
        );
      },
      version: 1,
    );
  }

  late Database chatDb;
  int chatSize = 0;
  double favRate = 1;

  void setFavRate(double rate) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setDouble('favRate', rate);

    setState(() {
      favRate = rate;
    });
  }

  void initFav() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      favRate = prefs.getDouble('favRate') ?? 1.0;
    });
    print('favRate:'+favRate.toString());
  }

  void initDb() async {
    chatDb = await chatDatabase();
    final List<Map<String, dynamic>> maps = await chatDb.query('chat', orderBy: 'id DESC');

    setState(() {
      chatSize = maps.length;
      chatLogs = List.generate(maps.length, (i) {
        return ChatLog(
            id: maps[i]['id'],
            isMine: maps[i]['isMine'],
            text: maps[i]['text'],
            favRate: maps[i]['favRate']
        );
      });
    });
  }

  @override
  void initState() {
    initDb();
    initFav();
  }

  List<ChatLog> chatLogs = [];

  void changeFavRate(Map<String, dynamic> san){
    List<dynamic> emotionalPhrases = san['result']['emotional_phrase'];
    // 天気を聞きまくったり意味不明な言葉を連投すると好感度が下がる
    double favDiff = -0.15;

    emotionalPhrases.forEach((e) {
      String emotion = e['emotion'];
      print(emotion);
      //TODO ここで感情の場合分けをする！

      switch(emotion) {
        case '喜ぶ':
          favDiff += 0.5;
          break;
        case '怒る':
          favDiff -= 0.5;
          break;
        case '悲しい':
          favDiff -= 0.1;
          break;
        case '不安':
          favDiff -= 0.1;
          break;
        case '恥ずかしい':
          favDiff -= 0.01;
          break;
        case '好ましい':
          favDiff += 0.4;
          break;
        case '嫌':
          favDiff -= 0.4;
          break;
        case '興奮':
          //どっち方面に興奮してるかによる
          favDiff *= 1.2;
          break;
        case '安心':
          favDiff += 0.4;
          break;
        case '驚く':
        //どっち方面に驚いてるかによる
          favDiff *= 1.2;
          break;
        case '切ない':
          favDiff -= 0.1;
          break;
        case '願望':
          favDiff += 0.1;
          break;
        case 'P':
          favDiff += 0.5;
          break;
        case 'N':
          favDiff -= 0.5;
          break;
        case 'PN':
          //変化なし
          break;
        default:
          break;
      }
    });

    double nextRate = favRate + favDiff;
    if(nextRate <= -0.5) nextRate = -0.49;
    if(nextRate >= 2.5) nextRate = 2.49;
    print('favRate:'+nextRate.toString());
    setState(() {
      setFavRate(nextRate);
    });
  }

  void addChatLog(Map<String, dynamic> log) async {
    ChatLog chatLog = ChatLog(
      id: chatSize,
      isMine: log['isMine'],
      text:  log['text'],
      favRate: log['favRate'],
    );

    chatDb.insert(
      'chat',
      chatLog.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    setState(() {
      chatSize++;
      chatLogs.insert(0, chatLog);
    });

    Map<String, dynamic> san = await sanCheck(log['text']);
    changeFavRate(san);
  }

  Future<String> getSanCheckToken() async{
    var serverURL="https://api.ce-cotoha.com/v1/oauth/accesstokens";
    Uri _uri=Uri.parse(serverURL);
    String query= '{"grantType": "client_credentials","clientId": "MxrAblUNeiaq1SOK1pJDFjFxvDKLB0pO","clientSecret": "kwsGBzDgoxXbH6uE"}';
    final requestUtf8 = utf8.encode(query);

    try{
      final response=await http.post(_uri,body: requestUtf8, headers: {"content-type": "application/json"});
      return jsonDecode(response.body)['access_token'] as String;
    }catch(error){
      throw Exception(error.toString());
    }
  }

  Future<Map<String, dynamic>> sanCheck(String text) async{
    var token=await getSanCheckToken();
    print(token);

    var serverURL="https://api.ce-cotoha.com/api/dev/nlp/v1/sentiment";
    Uri _uri=Uri.parse(serverURL);
    String query= '{"sentence": "${text}"}';
    final requestUtf8 = utf8.encode(query);

    try{
      final response=await http.post(_uri,body: requestUtf8, headers: {"content-type": "application/json","Authorization": "Bearer ${token}"});
      var data=utf8.decode(jsonDecode(response.body).toString().runes.toList());
      print(data);
      Map<String, dynamic> info = json.decode(utf8.decode(response.bodyBytes));
      return info;
    }catch(error){
      throw Exception(error.toString());
    }
  }

  void addOpponentChatLog(List<double> tmp, List<double> pre, List<double> slr){
    String text="hoge";
    if(favRate.round() == 0){ //好感度低 気温をざっくり
      if(tmp[0]<15){
        text="今は...まあ寒いんじゃない？\n";
      }else if(tmp[0]<=25){
        text="今は...普通かな。\n";
      }else{
        text="今は...暑いかも...？\n";
      }
      if(tmp[1]<15){
        text+="2時間後は...寒そう。";
      }else if(tmp[1]<=25){
        text+="2時間後は...まあ普通？";
      }else{
        text+="2時間後は...暑そう...。";
      }
    }else if(favRate.round() == 1){ //好感度普通 気温と降水量
      text="今の気温は"+tmp[0].toStringAsFixed(1)+"度だよ。\nちなみに降水量は"+pre[0].toStringAsFixed(1)+"mmだね。\n";
      if(tmp[0]<15){
        text+="寒いね...。\n";
      }else if(tmp[0]<=25){
        text+="過ごしやすそう。\n";
      }else{
        text+="暑いなぁ...。\n";
      }
      text+="2時間後の気温は"+tmp[1].toStringAsFixed(1)+"度になるよ。\n降水量は"+pre[1].toStringAsFixed(1)+"mmらしい。\n";
      if(pre[1]==0){
        text+="傘は要らなそうだね。";
      }else if(pre[1]<=20){
        text+="傘を忘れずに。";
      }else{
        text+="傘があっても濡れちゃいそうだね...。";
      }
    }else{ //好感度高 気温と降水量と日射量
      text="今の気温は"+tmp[0].toStringAsFixed(1)+"度だよ！\nちなみに降水量は"+pre[0].toStringAsFixed(1)+"mmなんだって！\n日射量は"+slr[0].toStringAsFixed(1)+"kW/m2みたい！\n";
      if(slr[0]<=0.2){
        text+="お日様は見えないね...。\n";
      }else if(slr[0]<0.9){
        text+="日差しは気にならなそう！\n";
      }else{
        text+="文句なしの快晴だね！！！\n";
      }
      text+="2時間後の気温は"+tmp[1].toStringAsFixed(1)+"度になるみたい！\n降水量は"+pre[1].toStringAsFixed(1)+"mmになると思う！\n日射量は"+slr[1].toStringAsFixed(1)+"kW/m2になる気がするな！\n";
      if(pre[1]==0){
        text+="やっぱり私は晴れが好き！";
      }else if(pre[1]<=20){
        text+="傘を忘れないでね！私は貸してあげられないよ！";
      }else{
        text+="雨も強いし、家で一緒にお昼寝しようよ！";
      }
    }

    ChatLog chatLog = ChatLog(
      id: chatSize,
      isMine: 0,
      text:  text,
      favRate: favRate,
    );

    chatDb.insert(
      'chat',
      chatLog.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    setState(() {
      chatSize++;
      chatLogs.insert(0, chatLog);
    });
  }

  void reset() async {
    await chatDb.delete('chat');
    setState(() {
      chatLogs = [];
    });
    setFavRate(1.0);
    print('reset chatLog and favRate');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: OtenkiAppbar(addChatLog: addChatLog, addOpponentChatLog: addOpponentChatLog, reset: reset),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Chat(chatLogs: convertChatLogsToMap(chatLogs)),
            Footer(addChatLog: addChatLog),
          ],
        ),
      ),
    );
  }
}

List<Map<String, dynamic>> convertChatLogsToMap(List<ChatLog> logs){
  List<Map<String, dynamic>> ret = [];
  logs.forEach((element) {
    ret.add({
      'isMine': element.isMine,
      'text': element.text,
      'favRate': element.favRate,
    });
  });
  
  return ret;
}

class ChatLog {
  final int id;
  final int isMine;
  final String text;
  final double favRate;

  ChatLog({required this.id,required this.isMine,required this.text,required this.favRate});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'isMine': isMine,
      'text': text,
      'favRate': favRate,
    };
  }
}
