import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

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
    Container(
      width: 90.0,
      height: 90.0,
      decoration: const BoxDecoration(
        color: Colors.grey, // アイコンの背景色
        shape: BoxShape.circle, // 円形切り抜き
        image: DecorationImage(
            fit: BoxFit.fill,
            image: AssetImage("images/rating0.png")
        ),
      ),
    ),
    Container(
      width: 90.0,
      height: 90.0,
      decoration: const BoxDecoration(
          color: Colors.lightGreen, // アイコンの背景色
          shape: BoxShape.circle, // 円形切り抜き
          image: DecorationImage(
              fit: BoxFit.fill,
              image: AssetImage("images/rating1.png")
          ),
      ),
    ),
    Container(
      width: 90.0,
      height: 90.0,
      decoration: const BoxDecoration(
        color: Colors.yellow, // アイコンの背景色
        shape: BoxShape.circle, // 円形切り抜き
        image: DecorationImage(
            fit: BoxFit.fill,
            image: AssetImage("images/rating2.png")
        ),
      ),
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
      if(log['text'] == ''){
        return Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            _favIcons[log['favRate'].round()],
            const SizedBox(width: 15),
            Container(
              child: LoadingAnimationWidget.staggeredDotsWave(
                color: Colors.green,
                size: 100,
              ),
            ),
          ],
        );
      }
      return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          _favIcons[log['favRate'].round()],
          const SizedBox(width: 5),
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