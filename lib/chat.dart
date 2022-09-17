import 'package:flutter/material.dart';

class Chat extends StatefulWidget {
  const Chat();

  @override
  _Chat createState() => _Chat();
}

class _Chat extends State {
  List<Map<String, dynamic>> chatLogs = [
    {'isMine': true, 'text': 'hogeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee'},
    {'isMine': true, 'text': 'fuga'},
    {'isMine': false, 'text': 'nya-n'},
  ];

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        reverse: true,
        itemBuilder: (BuildContext context, int index) {
          if(index >= chatLogs.length){
            chatLogs.addAll([
              {'isMine': true, 'text': 'hoge'},
              {'isMine': true, 'text': 'fuga'},
              {'isMine': false, 'text': 'nya-n'},
            ]);
          }
          return _messageItem(chatLogs[index]);
        },
      ),
    );
  }

  final _shadowProp = [
    const BoxShadow(
      color: Color(0x80000000),
      offset: Offset(0,2),
      blurRadius: 2,
    ),
  ];

  Widget _messageItem(Map<String,dynamic> log){
    if(log['isMine']){
      return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Flexible(
            child: Container(
              margin: const EdgeInsets.all(5),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.lightGreenAccent,
                borderRadius: BorderRadius.circular(50),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.grey, //色
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: Offset(0, 1),
                  ),
                ],
              ),
              child: Text(
                log['text'],
                style: const TextStyle(
                  fontSize: 20,
                ),
              ),
            ),
          ),
        ],
      );
    }else{
      return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Flexible(
            child: Container(
              margin: const EdgeInsets.all(5),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(50),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.grey, //色
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: Offset(0, 1),
                  ),
                ],
              ),
              child: Text(
                log['text'],
                style: const TextStyle(
                  fontSize: 20,
                ),
              ),
            ),
          ),
        ],
      );
    }
  }
}