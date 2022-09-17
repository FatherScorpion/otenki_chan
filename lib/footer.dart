import 'package:flutter/material.dart';
import 'chat.dart';

class Footer extends StatefulWidget {
  final Function addChatLog;
  Footer({Key? key, required this.addChatLog}) : super(key: key);

  @override
  _Footer createState() => _Footer();
}

class _Footer extends State<Footer> {
  final controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      decoration: BoxDecoration(color: Colors.blue),

      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 300,
            height: 40,
            child: Container(
              decoration: BoxDecoration(color: Colors.white),
              margin: EdgeInsets.all(0),
              child: TextField(
                controller: controller,
                style: TextStyle(fontSize: 30),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(bottom: 18.0),
            child: IconButton(
              icon: Icon(Icons.arrow_forward_rounded,color: Colors.white,
                  size: 50),
              onPressed: () => {
                widget.addChatLog(controller.text),
                controller.text="push!",
              },
            ),
          )
        ],
      ),
    );
  }
}