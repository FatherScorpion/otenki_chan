import 'package:flutter/material.dart';

class Chat extends StatefulWidget {
  final List<Map<String, dynamic>> chatLogs;
  Chat({Key? key, required this.chatLogs}) : super(key: key);

  @override
  _Chat createState() => _Chat();
}

class _Chat extends State<Chat> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        itemCount: widget.chatLogs.length,
        reverse: true,
        itemBuilder: (BuildContext context, int index) {
          return _messageItem(widget.chatLogs[index]);
        },
      ),
    );
  }

  final _style = const TextStyle(
    fontSize: 20,
  );

  final List<Widget> _favIcons = [
    const Text(
      "☹",
      style: TextStyle(fontSize: 50),
    ),
    const Text(
      "😐",
      style: TextStyle(fontSize: 50),
    ),
    const Text(
      "😊",
      style: TextStyle(fontSize: 50),
    ),
  ];

  Widget _messageItem(Map<String,dynamic> log){
    if(log['isMine'] == 1){
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
                style: _style,
              ),
            ),
          ),
        ],
      );
    }else{
      return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          _favIcons[log['favRate'].round()],
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
                style: _style,
              ),
            ),
          ),
        ],
      );
    }
  }
}