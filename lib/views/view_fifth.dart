import 'package:sensors/sensors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class ViewFifth extends StatefulWidget {
  ViewFifth({Key key}) : super(key: key);

  @override
  _ViewFifthState createState() => _ViewFifthState();
}

class _ViewFifthState extends State<ViewFifth> with TickerProviderStateMixin {
  AnimationController _controllerRotate;
  Animation<double> _animationRotate;
  AnimationController _controllerCurl;
  Animation<int> _animationCurl;
  double slider1Value = 0.0;
  double slider2Value = 0.0;
  double currentCurlPosition = 0.5;
  double newCurlPosition = 0.0;
  double newRotatePosition = 0.0;
  double lastPosition = 0.0;

  @override
  void initState() {
    super.initState();
    // var count = 1;
    gyroscopeEvents.listen((GyroscopeEvent event) {
      double movement = (lastPosition.abs() - event.z.abs()).abs() / 10;
      // print('---------- movement : $movement');
      var pos = _controllerRotate.value;
      if (event.z >= 0) {
        pos = (pos - movement).clamp(0.4, 0.6);
      } else {
        pos = (pos + movement).clamp(0.4, 0.6);
      }
      // newCurlPosition += event.y / 20;
      // if (count == 5) {
      // print('---------- newPosition : $newPosition');
      // if (newCurlPosition.abs() > 0.1) {
      // _controllerCurl.animateTo(_controllerCurl.value + newCurlPosition);
      //   newCurlPosition = 0.0;
      // }
      // count = 0;
      // }
      // // count++;
      // newRotatePosition += event.z / 10;
      // if (newRotatePosition.abs() > 0.005) {
      // print('---------- pos : $pos');
      if (_controllerRotate.value != pos) _controllerRotate.animateTo(pos);
      // if (pos > 1.0) {
      //   _controllerRotate.animateTo(1.0).whenComplete(() {
      //     _controllerRotate.value = 0.0;
      //     pos = pos - pos.toInt().abs();
      //     _controllerRotate.animateTo(pos);
      //   });
      // } else if (pos < 0.0) {
      //   _controllerRotate.animateTo(0.0).whenComplete(() {
      //     _controllerRotate.value = 1.0;
      //     pos = pos + pos.toInt().abs();

      //     _controllerRotate.animateTo(pos);
      //   });
      // } else {
      //   _controllerRotate.animateTo(pos);
      // }
      // newRotatePosition = 0.0;
      // }
      // print('---------- {_controllerRotate.value} : ${_controllerRotate.value}');
      lastPosition = event.z;
    });
    _controllerRotate = AnimationController(
      vsync: this,
      value: 1.0,
      duration: const Duration(milliseconds: 100),
    );
    _animationRotate = CurvedAnimation(
      parent: _controllerRotate,
      curve: Curves.easeInQuint,
    );
    _controllerCurl = AnimationController(
      value: currentCurlPosition,
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _animationCurl = IntTween(begin: 1, end: 219).animate(_controllerCurl);
  }

  double childSizeRatio;

  @override
  Widget build(BuildContext context) {
    var parentSize = MediaQuery.of(context).size.width * 1;
    return Scaffold(
      appBar: AppBar(
        title: Text('Fifth'),
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
                  child: RotationTransition(
                    turns: _animationRotate,
                    child: FractionallySizedBox(
                      widthFactor: childSizeRatio,
                      heightFactor: childSizeRatio,
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
          Slider(
              value: slider1Value,
              onChanged: (value) {
                setState(() {
                  slider1Value = value;
                  _controllerRotate.value = value;
                });
              }),
          Slider(
              value: slider2Value,
              onChanged: (value) {
                setState(() {
                  slider2Value = value;
                  // var _positionInMilliseconds =
                  //     (_vidController.value.duration.inMilliseconds.toDouble() * slider2Value)
                  //         .toInt();
                  _controllerCurl.value = value;
                });
              }),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                StreamBuilder<GyroscopeEvent>(
                  stream: gyroscopeEvents,
                  builder: (_, snap) => Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Gyroscope: '),
                        Text('x: ${snap.data.x.toString().characters.take(4)}'),
                        Text('y: ${snap.data.y.toString().characters.take(4)}'),
                        Text('z: ${snap.data.z.toString().characters.take(4)}'),
                      ],
                    ),
                  ),
                ),
                StreamBuilder<AccelerometerEvent>(
                  stream: accelerometerEvents,
                  builder: (_, snap) => Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Acc: '),
                        Text('x: ${snap.data.x.toString().characters.take(4)}'),
                        Text('y: ${snap.data.y.toString().characters.take(4)}'),
                        Text('z: ${snap.data.z.toString().characters.take(4)}'),
                      ],
                    ),
                  ),
                ),
                StreamBuilder<UserAccelerometerEvent>(
                  stream: userAccelerometerEvents,
                  builder: (_, snap) => Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('UserAcc: '),
                        Text('x: ${snap.data.x.toString().characters.take(4)}'),
                        Text('y: ${snap.data.y.toString().characters.take(4)}'),
                        Text('z: ${snap.data.z.toString().characters.take(4)}'),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controllerRotate.dispose();
    super.dispose();
  }
}
