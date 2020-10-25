import 'dart:collection';
import 'dart:math';
import 'package:flutter_sensors/flutter_sensors.dart';
import 'package:flutter/material.dart';

const int _yAmount = 10;
const int _xAmount = 10;
const double cloudWidth = 1000;
const double cloudHeight = 509;

class Parallax extends StatefulWidget {
  Parallax(this.mediaQuery);
  final MediaQueryData mediaQuery;
  @override
  _ParallaxState createState() => _ParallaxState();
}

class _ParallaxState extends State<Parallax> with SingleTickerProviderStateMixin {
  double slideAmount = 0.0;
  var matrix2Scale = 0.5;
  var slideOffset = Offset(50, 50);

  var yAccStore = ListQueue<double>()..addAll(List.generate(_yAmount, (index) => 0.0));
  var xAccStore = ListQueue<double>()..addAll(List.generate(_xAmount, (index) => 0.0));

  @override
  void initState() {
    super.initState();
    slideAmount = widget.mediaQuery.size.width * 0.2;
    listen();
  }

//-------------------------------------
  Future<void> listen() async {
    final streamAcc = await SensorManager().sensorUpdates(
      sensorId: Sensors.ACCELEROMETER,
      interval: Sensors.SENSOR_DELAY_GAME,
    );
    streamAcc.listen((SensorEvent event) {
      if (event == null) return;
      yAccStore.removeFirst();
      yAccStore.add(event.data[1]);
      xAccStore.removeFirst();
      xAccStore.add(event.data[2]);
      setState(() {
        slide();
      });
    });
  }

//-------------------------------------s
  void slide() {
    double yOffset = yAccStore.reduce((first, next) => first + next) / _yAmount;
    print('YOFFSET: ${yOffset}');
    yOffset = (yOffset / 10).clamp(-10.0, 10.0);
    double xOffset = (xAccStore.reduce((first, next) => first + next) / _xAmount);
    // print('XOFFSET: ${xOffset}');
    slideOffset = Offset(xOffset + slideAmount, yOffset * slideAmount);
  }

//-------------------------------------
  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Center(
        child: Image.asset(
          'assets/clouds/cloud2.png',
          width: 1000,
          height: 509,
          gaplessPlayback: true,
        ),
      ),
      AnimatedContainer(
          alignment: Alignment.center,
          duration: Duration(milliseconds: 10),
          transform: Transform.translate(offset: slideOffset).transform,
          // color: Colors.yellow,
          child: Transform.scale(
            scale: matrix2Scale,
            child: Image.asset(
              'assets/clouds/cloud2.png',
              gaplessPlayback: true,
            ),
          )),
    ]);
  }
}
