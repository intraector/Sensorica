import 'package:Sensorica/views/components/parallax.dart';
import 'package:Sensorica/views/components/rotation_and_curl.dart';
import 'package:flutter/material.dart';

class ViewNineth extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var parentSize = MediaQuery.of(context).size.width * 1;
    return Scaffold(
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
                  child: Parallax(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
