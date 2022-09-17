import 'package:flutter/material.dart';
import 'footer.dart';
import 'chat.dart';
import 'appbar.dart';

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
  List<Map<String, dynamic>> chatLogs = [
    {'isMine': true, 'text': 'hogeeee'},
    {'isMine': true, 'text': 'fuga'},
    {'isMine': false, 'text': 'nyaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa-n', 'favRate': 1},
  ];
  void addChatLog(String text){
    setState(() {
      chatLogs.insert(0,{'isMine': true, 'text': text});
    });
  }

  void addOpponentChatLog(List<double> tmp, List<double> pre, List<double> slr){
    String text="hoge";
    text="今の気温は"+tmp[0].toStringAsFixed(1)+"度だよ\nちなみに降水量は"+pre[0].toStringAsFixed(1)+"mmだね";
    setState(() {
      chatLogs.insert(0,{'isMine': false, 'text': text, 'favRate':1});
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
            Chat(chatLogs: chatLogs),
            Footer(addChatLog: addChatLog),
          ],
        ),
      ),
    );
  }
}
