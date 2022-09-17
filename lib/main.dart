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
          "CREATE TABLE chat(id INTEGER PRIMARY KEY, isMine INTEGER, text TEXT, favRate INTEGER)",
        );
      },
      version: 1,
    );
  }



  late Database chatDb;
  int chatSize = 0;
  int favRate = 1;

  void setFavRate(int rate) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('favRate', rate);

    setState(() {
      favRate = rate;
    });
  }

  void initFav() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      favRate = prefs.getInt('favRate') ?? 1;
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

    sanCheck(log['text']);
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

  void sanCheck(String text) async{
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
    }catch(error){
      throw Exception(error.toString());
    }
  }

  void addOpponentChatLog(List<double> tmp, List<double> pre, List<double> slr){
    String text="hoge";
    text="今の気温は"+tmp[0].toStringAsFixed(1)+"度だよ\nちなみに降水量は"+pre[0].toStringAsFixed(1)+"mmだね";

    ChatLog chatLog = ChatLog(
      id: chatSize,
      isMine: 0,
      text:  text,
      favRate: 1,
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
    setFavRate(1);
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
  final int favRate;

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
