import 'dart:collection';
import 'dart:math';
import 'package:flutter_sensors/flutter_sensors.dart';
import 'package:flutter/material.dart';

const int _yAmount = 10;
const int _zAmount = 10;
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
  var yAccStore = ListQueue<double>()..addAll(List.generate(_yAmount, (index) => 0.0));
  var zAccStore = ListQueue<double>()..addAll(List.generate(_zAmount, (index) => 0.0));

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
    var offset =
        (yAccStore.reduce((first, next) => first + next) / _yAmount / 10).clamp(-10.0, 10.0);

    ySlideOffset = Offset(offset * 30, offset * 30);
  }

//-------------------------------------
  void slideZ() {
    var incoming = zAccStore.reduce((first, next) => first + next) / _zAmount;
  }

//-------------------------------------
  @override
  Widget build(BuildContext context) {
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
