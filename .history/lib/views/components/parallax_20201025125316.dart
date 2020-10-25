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
  var yAccStore = ListQueue<double>()..addAll(List.generate(_yAmount, (index) => 0.0));
  var zAccStore = ListQueue<double>()..addAll(List.generate(_zAmount, (index) => 0.0));
  double frame = 46.0;

  @override
  void initState() {
    super.initState();
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

  var ySlideOffset = Offset(50, 50);

//-------------------------------------
  void slideY() {
    var angle = (yAccStore.reduce((first, next) => first + next) / _yAmount);
    print('ANGLE: ${angle}');
  }

//-------------------------------------
  void slideZ() {
    var incoming = zAccStore.reduce((first, next) => first + next) / _zAmount;
    var value = (incoming + 10).clamp(0, 20) * 5 / 100;
    value = maxFrames - (value * maxFrames);
    frame = value.clamp(1.0, maxFrames);
  }

//-------------------------------------
  @override
  Widget build(BuildContext context) {
    matrix2Origin = Matrix4.identity();
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
          // transform: matrix2,
          color: Colors.yellow,
          child: Transform.scale(
            scale: matrix2Scale,
            child: Transform.translate(
              offset: ySlideOffset,
              child: Image.asset(
                'assets/clouds/cloud2.png',
                gaplessPlayback: true,
              ),
            ),
          )),
    ]);
  }
}
