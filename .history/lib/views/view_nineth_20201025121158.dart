import 'package:Sensorica/views/components/parallax.dart';
import 'package:flutter/material.dart';

class ViewNineth extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var parentSize = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(title: Text('Nineth')),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: parentSize,
                width: parentSize,
                color: Colors.blue,
                child: Parallax(parentSize),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
