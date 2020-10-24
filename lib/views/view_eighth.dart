import 'dart:collection';
import 'dart:math';

import 'package:sensors/sensors.dart';
import 'package:flutter/material.dart';

import 'package:flutter_sensors/flutter_sensors.dart';

class ViewEighth extends StatefulWidget {
  ViewEighth({Key key}) : super(key: key);

  @override
  _ViewEighthState createState() => _ViewEighthState();
}

class _ViewEighthState extends State<ViewEighth> with TickerProviderStateMixin {
  Matrix4 matrix = Matrix4.identity();
  double radsToDegrees(double rad) {
    return (rad * 180.0) / pi;
  }

  AnimationController _controllerCurl;
  Animation<int> _animationCurl;
  static const int amount = 50;
  var xAccStore = ListQueue<double>()..addAll(List.generate(amount, (index) => 0.0));

  double xGyro = 0.0, yGyro = 0.0, zGyro = 0.0;
  double xAcc = 0.0, yAcc = 0.0, zAcc = 0.0;

  Future<void> listen() async {
    final streamGyro = await SensorManager().sensorUpdates(
      sensorId: Sensors.GYROSCOPE,
      interval: Sensors.SENSOR_DELAY_FASTEST,
    );
    accelerometerEvents.listen((AccelerometerEvent event) {
      xAcc = event.x;
      yAcc = event.y;
      zAcc = event.z;
      xAccStore.removeFirst();
      xAccStore.add(xAcc);
      makeMovement();
    });
    final streamAcc = await SensorManager().sensorUpdates(
      sensorId: Sensors.ACCELEROMETER,
      interval: Sensors.SENSOR_DELAY_FASTEST,
    );

    streamAcc.listen((SensorEvent event) {
      if (event == null) return;
      xAcc = event.data[0];
      yAcc = event.data[1];
      zAcc = event.data[2];
      xAccStore.removeFirst();
      xAccStore.add(xAcc);
      makeMovement();
    });

    streamGyro.listen((SensorEvent event) {
      if (event == null) return;
      xGyro = event.data[0];
      yGyro = event.data[1];
      zGyro = event.data[2];
    });
  }

  void makeMovement() {
    var angle = (xAccStore.reduce((first, next) => first + next) / amount / 50);

    setState(() {
      matrixRotate(angle);
    });
  }

  Matrix4 matrixRotate(double angle) {
    return matrix = Matrix4.identity().clone()
      ..translate(180.0, 180.0, 0.0)
      ..rotateZ(angle * 2 * pi)
      ..translate(-180.0, -180.0, 0.0);
  }

  @override
  void initState() {
    super.initState();

    _controllerCurl = AnimationController(
      value: 0.5,
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _animationCurl = IntTween(begin: 1, end: 219).animate(_controllerCurl);

    listen();
  }

  double childSizeRatio;

  @override
  Widget build(BuildContext context) {
    var parentSize = MediaQuery.of(context).size.width * 1;
    return Scaffold(
      appBar: AppBar(
        title: Text('Eighth'),
        // actions: [
        //   IconButton(
        //     icon: Icon(Icons.golf_course),
        //     onPressed: () {
        //       Navigator.of(context)
        //           .push(MaterialPageRoute(builder: (BuildContext context) => ViewFirst()));
        //     },
        //   ),
        // ],
      ),
      body: ListView(
        shrinkWrap: true,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ClipOval(
                child: Container(
                  // alignment: Alignment.center,
                  height: parentSize,
                  width: parentSize,
                  color: Colors.black,
                  child: FractionallySizedBox(
                    widthFactor: childSizeRatio,
                    heightFactor: childSizeRatio,
                    child: Container(
                      transform: matrix,
                      child: Center(
                        child: AspectRatio(
                          aspectRatio: 1.89 / 1,
                          child: AnimatedBuilder(
                            animation: _animationCurl,
                            builder: (BuildContext context, Widget child) {
                              String frame = _animationCurl.value.toString().padLeft(3, '0');
                              return Image.asset('assets/brush4k/output$frame.png',
                                  gaplessPlayback: true);
                              // return PhotoView(
                              //     gaplessPlayback: true,
                              //     imageProvider: AssetImage(
                              //       'assets/brush4k/output$frame.png',
                              //     ));
                              // return Image.asset('assets/brush/output$frame.png',
                              // // gaplessPlayback: true);
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Gyroscope: '),
                        Text('xGyro: $xGyro'),
                        Text('yGyro: $yGyro'),
                        Text('zGyro: $zGyro'),
                      ],
                    )),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Accelerometer: '),
                        Text('xAcc: $xAcc'),
                        Text('yAcc: $yAcc'),
                        Text('zAcc: $zAcc'),
                      ],
                    )),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

extension Ex on double {
  double toPrecision(int n) => double.parse(toStringAsFixed(n));
}
