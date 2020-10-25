import 'dart:collection';
import 'dart:math';
import 'package:flutter_sensors/flutter_sensors.dart';
import 'package:flutter/material.dart';

const int _yAmount = 10;
const int _zAmount = 10;
const int maxFrames = 91;
const double cloudWidth = 1000;
const double cloudHeight = 509;

class Parallax extends StatefulWidget {
  Parallax(this.mediaQuery);
  final MediaQueryData mediaQuery;
  @override
  _ParallaxState createState() => _ParallaxState();
}

class _ParallaxState extends State<Parallax> with SingleTickerProviderStateMixin {
  var matrix2Scale = 0.5;
  var matrix = Matrix4.identity();
  Matrix4 matrix2Origin;
  var matrix2 = Matrix4.identity()..scale(0.9, 0.9, 0.0);
  var yAccStore = ListQueue<double>()..addAll(List.generate(_yAmount, (index) => 0.0));
  var zAccStore = ListQueue<double>()..addAll(List.generate(_zAmount, (index) => 0.0));
  double frame = 46.0;

  @override
  void initState() {
    super.initState();
    var screenWidth = widget.mediaQuery.devicePixelRatio * widget.mediaQuery.size.width;
    print('SCREENWIDTH: ${screenWidth}');
    // ..scale(matrix2Scale, matrix2Scale, 0.0);
    // ..translate((widget.screenWidth * (1 - matrix2Scale)) / 2,
    // (widget.screenWidth * (1 - matrix2Scale)) / 2, 0.0);
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
      zAccStore.removeFirst();
      zAccStore.add(event.data[2]);
      setState(() {
        slideY();
        // slideZ();
      });
    });
  }

//-------------------------------------
  void slideY() {
    var angle = (yAccStore.reduce((first, next) => first + next) / _yAmount * 10) - 90;
    // print('ANGLE: ${angle}');
    matrixTranslate(angle);
  }

//-------------------------------------
  void slideZ() {
    var incoming = zAccStore.reduce((first, next) => first + next) / _zAmount;
    var value = (incoming + 10).clamp(0, 20) * 5 / 100;
    value = maxFrames - (value * maxFrames);
    frame = value.clamp(1.0, maxFrames);
  }

//-------------------------------------
  Matrix4 matrixTranslate(double distance) =>
      matrix2 = matrix2Origin..clone().translate(0.0, distance, 0.0);

//-------------------------------------
  @override
  Widget build(BuildContext context) {
    matrix2Origin = Matrix4.identity()..translate(50.0, 0.0, 0.0);
    return Stack(children: [
      // Center(
      //   child: Image.asset(
      //     'assets/clouds/cloud2.png',
      //     width: 1000,
      //     height: 509,
      //     gaplessPlayback: true,
      //   ),
      // ),
      AnimatedContainer(
          alignment: Alignment.center,
          duration: Duration(milliseconds: 10),
          transform: matrix2,
          color: Colors.yellow,
          child: Image.asset(
            'assets/clouds/cloud2.png',
            gaplessPlayback: true,
          )),
    ]);
  }
}
