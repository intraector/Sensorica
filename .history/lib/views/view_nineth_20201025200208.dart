import 'package:Sensorica/views/components/rotation_and_curl.dart';
import 'package:flutter/material.dart';

class ViewNineth extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    return Scaffold(
      appBar: AppBar(title: Text('Sensorica')),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ClipOval(
                child: Container(
                  height: mediaQuery.size.width,
                  width: mediaQuery.size.width,
                  color: Colors.blue,
                  child: RotationAndCurl(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
