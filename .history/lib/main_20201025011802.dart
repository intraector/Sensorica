import 'package:Sensorica/views/view_nineth.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Scaffold(
      appBar: AppBar(title: Text('Nineth')),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ClipOval(
                child: Container(
                  height: parentSize,
                  width: parentSize,
                  color: Colors.black,
                  child: RotationAndCurl(),
                ),
              ),
            ],
          ),
        ],
      ),
    ),
    );
  }
}
