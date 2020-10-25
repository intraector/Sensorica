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
  double slideAmount2 = 0.0;
  var scale2 = 0.8;
  var slideOffset2 = Offset(50, 50);

  var yAccStore = ListQueue<double>()..addAll(List.generate(_yAmount, (index) => 0.0));
  var xAccStore = ListQueue<double>()..addAll(List.generate(_xAmount, (index) => 0.0));

  @override
  void initState() {
    super.initState();
    slideAmount2 = widget.mediaQuery.size.width * 0.2;
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
      xAccStore.add(event.data[0]);
      setState(() {
        slideOffset2 = slide(slideAmount2);
      });
    });
  }

//-------------------------------------s
  Offset slide(double slideAmount) {
    var yOffset =
        (yAccStore.reduce((first, next) => first + next) / _yAmount / 10).clamp(-10.0, 10.0);
    var xOffset =
        (xAccStore.reduce((first, next) => first + next) / _xAmount / 10).clamp(-10.0, 10.0);
    return Offset(xOffset * slideAmount, (((yOffset) * slideAmount)));
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
          transform: Transform.translate(offset: slideOffset2).transform,
          // color: Colors.yellow,
          child: Transform(
            transform: Transform.translate(offset: Offset(0.0, 0.0)).transform,
            child: Transform.scale(
              scale: scale2,
              child: Image.asset(
                'assets/clouds/cloud2.png',
                gaplessPlayback: true,
              ),
            ),
          )),
    ]);
  }
}
