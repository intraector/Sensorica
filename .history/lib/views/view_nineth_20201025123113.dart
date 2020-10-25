import 'package:Sensorica/views/components/parallax.dart';
import 'package:flutter/material.dart';

class ViewNineth extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    return Scaffold(
      appBar: AppBar(title: Text('Nineth')),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: mediaQuery.size.width,
                width: mediaQuery.size.width,
                color: Colors.blue,
                child: Parallax(mediaQuery),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
