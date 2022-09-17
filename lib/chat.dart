import 'package:flutter/material.dart';

class Chat extends StatefulWidget {
  const Chat();

  @override
  _Chat createState() => _Chat();
}

class _Chat extends State {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Icon(
        Icons.chat,
        color: Colors.black,
        size: 100.0,
      ),
    );
  }
}