import 'package:flutter/material.dart';

import 'home.dart';

void main() {
  runApp(const MaterialApp(
      home: Home()
  ));
}

class SandBox extends StatelessWidget {
  const SandBox({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: const Text('SandBox'),
            backgroundColor: Colors.grey,
        ),
        body: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
                Container(
                    height: 100,
                    color: Colors.orange,
                    child: const Text('one')
                ),
                Container(
                    height: 200,
                    color: Colors.red,
                    child: const Text('two')
                ),
                Container(
                    height: 300,
                    color: Colors.black,
                    child: const Text('three')
                ),
            ],
        ),
    );
  }
}











