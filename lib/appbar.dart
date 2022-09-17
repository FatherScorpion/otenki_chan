import 'package:flutter/material.dart';

class OtenkiAppbar extends StatelessWidget with PreferredSizeWidget {
  OtenkiAppbar({Key? key}) : super(key: key);

  double height = 150;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          decoration: const BoxDecoration(color: Colors.cyanAccent),
          height: height,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Image.asset('images/teresakunn.png'),
              SizedBox(
                width: 150,
                height: height,
                child: ElevatedButton(
                  onPressed: () => {},
                  style: ElevatedButton.styleFrom(
                      elevation: 0,
                      primary: Colors.greenAccent,
                      onPrimary: Colors.white
                  ),
                  child: const Text('天気\n教えて！', style: TextStyle(fontSize: 29, fontWeight: FontWeight.bold)),
                ),
              ),
              Container(
                height: height,
                color: Colors.redAccent,
                child: IconButton(
                  color: Colors.white,
                  onPressed: () => {},
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

  @override
  Size get preferredSize => const Size.fromHeight(150);
}
