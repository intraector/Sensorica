import 'dart:async';
import 'dart:collection';
import 'package:Sensorica/bottom_tab_bar_material.dart';
import 'package:flutter_sensors/flutter_sensors.dart';
import 'package:flutter/material.dart';

class ViewParallax extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    return Scaffold(
      appBar: AppBar(title: Text('Sensorica')),
      bottomNavigationBar: BottomTabBarMaterial(1),
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
                  child: Parallax(mediaQuery),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

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
  StreamSubscription<SensorEvent> _subsc;
  double slideAmount2 = 0.0;
  var scale2 = 0.8;
  var slideOffset2 = Offset.zero;
  double slideAmount3 = 0.0;
  var scale3 = 0.6;
  var slideOffset3 = Offset.zero;
  double slideAmount4 = 0.0;
  var scale4 = 0.4;
  var slideOffset4 = Offset.zero;

  var yAccStore = ListQueue<double>()..addAll(List.generate(_yAmount, (index) => 0.0));
  var xAccStore = ListQueue<double>()..addAll(List.generate(_xAmount, (index) => 0.0));

  @override
  void initState() {
    super.initState();
    slideAmount2 = widget.mediaQuery.size.width * 0.1;
    slideAmount3 = widget.mediaQuery.size.width * 0.2;
    slideAmount4 = widget.mediaQuery.size.width * 0.3;
    listen();
  }

//-------------------------------------
  Future<void> listen() async {
    var streamAcc = await SensorManager().sensorUpdates(
      sensorId: Sensors.ACCELEROMETER,
      interval: Sensors.SENSOR_DELAY_GAME,
    );
    _subsc = streamAcc.listen((SensorEvent event) {
      if (event == null) return;
      yAccStore.removeFirst();
      yAccStore.add(event.data[1]);
      xAccStore.removeFirst();
      xAccStore.add(event.data[0]);
      setState(() {
        slideOffset2 = slide(slideAmount2);
        slideOffset3 = slide(slideAmount3);
        slideOffset4 = slide(slideAmount4);
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
          'assets/clouds/cloud.png',
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
          child: Transform.scale(
            scale: scale2,
            child: Image.asset(
              'assets/clouds/cloud.png',
              gaplessPlayback: true,
            ),
          )),
      AnimatedContainer(
          alignment: Alignment.center,
          duration: Duration(milliseconds: 10),
          transform: Transform.translate(offset: slideOffset3).transform,
          // color: Colors.yellow,
          child: Transform.scale(
            scale: scale3,
            child: Image.asset(
              'assets/clouds/cloud.png',
              gaplessPlayback: true,
            ),
          )),
      AnimatedContainer(
          alignment: Alignment.center,
          duration: Duration(milliseconds: 10),
          transform: Transform.translate(offset: slideOffset4).transform,
          // color: Colors.yellow,
          child: Transform.scale(
            scale: scale4,
            child: Image.asset(
              'assets/clouds/cloud.png',
              gaplessPlayback: true,
            ),
          )),
    ]);
  }

  @override
  void dispose() {
    _subsc?.cancel();
    super.dispose();
  }
}
