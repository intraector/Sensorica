import 'package:Sensorica/views/components/rotation_and_curl_drag2.dart';
import 'package:Sensorica/views/components/view_second.dart';
import 'package:Sensorica/views/view_nineth.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sensorica',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: ViewNineth(),
    );
  }
}
