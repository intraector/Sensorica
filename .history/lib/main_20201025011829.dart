import 'package:Sensorica/views/components/rotation_and_curl.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
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
                    height: MediaQuery.of(context).size.width * 1,
                    width: MediaQuery.of(context).size.width * 1,
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
