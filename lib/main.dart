import 'package:flutter/material.dart';
import 'footer.dart';
import 'chat.dart';
import 'appbar.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: OtenkiAppbar(addChatLog: addChatLog, addOpponentChatLog: addOpponentChatLog),
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
