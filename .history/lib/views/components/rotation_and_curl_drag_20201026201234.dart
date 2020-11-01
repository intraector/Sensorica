import 'dart:async';
import 'dart:collection';
import 'dart:math';
import 'package:Sensorica/bottom_tab_bar_material.dart';
import 'package:flutter_sensors/flutter_sensors.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class ViewRotationDrag extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Sensorica', style: TextStyle(color: Colors.brown[100])),
        backgroundColor: Colors.brown[900],
      ),
      bottomNavigationBar: BottomTabBarMaterial(2),
      backgroundColor: Colors.brown[900],
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
                  child: RotationAndCurlDrag(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

const int _xAmount = 10;
const int _zAmount = 10;
const int maxFrames = 91;

class RotationAndCurlDrag extends StatefulWidget {
  @override
  _RotationAndCurlDragState createState() => _RotationAndCurlDragState();
}

class _RotationAndCurlDragState extends State<RotationAndCurlDrag>
    with SingleTickerProviderStateMixin {
  StreamSubscription<SensorEvent> _subsc;
  var matrix = Matrix4.identity();
  var xAccStore = ListQueue<double>()..addAll(List.generate(_xAmount, (index) => 0.0));
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
    _subsc = streamAcc.listen((SensorEvent event) {
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
  void curl() {
    var incoming = zAccStore.reduce((first, next) => first + next) / _zAmount;
    var value = (incoming + 10).clamp(0, 20) * 5 / 100;
    value = maxFrames - (value * maxFrames);
    frame = value.clamp(1.0, maxFrames);
  }

//-------------------------------------
  Matrix4 matrixRotate(double angle) => matrix = Matrix4.identity().clone()
    ..translate(180.0, 180.0, 0.0)
    ..rotateZ(angle * 2 * pi)
    ..translate(-180.0, -180.0, 0.0);

//-------------------------------------
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: AnimatedContainer(
        duration: Duration(milliseconds: 10),
        transform: matrix,
        child: AspectRatio(
          aspectRatio: 1.89 / 1,
          child: PhotoView(
            gaplessPlayback: true,
            maxScale: 1.0,
            minScale: PhotoViewComputedScale.contained,
            imageProvider: AssetImage(
              'assets/brush/output${frame.toInt().toString().padLeft(3, '0')}.png',
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _subsc?.cancel();
    super.dispose();
  }
}
