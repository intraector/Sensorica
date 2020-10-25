import 'dart:collection';
import 'dart:math';
import 'package:flutter_sensors/flutter_sensors.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

const int _xAmount = 10;
const int _zAmount = 10;
const int maxFrames = 91;

class RotationAndCurl extends StatefulWidget {
  @override
  _RotationAndCurlState createState() => _RotationAndCurlState();
}

class _RotationAndCurlState extends State<RotationAndCurl> with SingleTickerProviderStateMixin {
  var matrix = Matrix4.identity();
  var xAccStore = ListQueue<double>()..addAll(List.generate(_xAmount, (index) => 0.0));
  var zAccStore = ListQueue<double>()..addAll(List.generate(_zAmount, (index) => 0.0));
  AnimationController _curlController;

  @override
  void initState() {
    super.initState();
    _curlController = AnimationController(
      upperBound: 91.0,
      value: 46.0,
      lowerBound: 1.0,
      duration: Duration(milliseconds: 100),
      vsync: this,
    );
    listen();
  }

  double lastValue = 0.0;
//-------------------------------------
  Future<void> listen() async {
    final streamAcc = await SensorManager().sensorUpdates(
      sensorId: Sensors.ACCELEROMETER,
      interval: Sensors.SENSOR_DELAY_GAME,
    );
    streamAcc.listen((SensorEvent event) {
      if (event == null) return;
      xAccStore.removeFirst();
      xAccStore.add(event.data[0]);
      zAccStore.removeFirst();
      zAccStore.add(event.data[2]);
      setState(() {
        rotate();
        curl();
      });
    });
  }

//-------------------------------------
  void rotate() {
    var angle = (xAccStore.reduce((first, next) => first + next) / _xAmount / 50);
    matrixRotate(angle);
  }

//-------------------------------------
  int count = 0;
  void curl() {
    count++;
    // if (count < 3) return;
    count = 0;
    var incoming = zAccStore.reduce((first, next) => first + next) / _zAmount;
    var value = (incoming + 10).clamp(0, 20) * 5 / 100;
    value = maxFrames - (value * maxFrames);
    _curlController.value = value;
    lastValue = value;
  }

//-------------------------------------
  Matrix4 matrixRotate(double angle) => matrix = Matrix4.identity().clone()
    ..translate(180.0, 180.0, 0.0)
    ..rotateZ(angle * 2 * pi)
    ..translate(-180.0, -180.0, 0.0);

//-------------------------------------
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 10),
      transform: matrix,
      child: AspectRatio(
        aspectRatio: 1.89 / 1,
        child: PhotoView(
          gaplessPlayback: true,
          maxScale: 1.0,
          minScale: PhotoViewComputedScale.contained,
          imageProvider: AssetImage(
            'assets/brushHD/output${_curlController.value.toInt().toString().padLeft(3, '0')}.png',
          ),
        ),
      ),
    );
  }
}
