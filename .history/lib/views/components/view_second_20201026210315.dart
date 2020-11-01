import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:photo_view/photo_view.dart';

class ViewSecond extends StatefulWidget {
  ViewSecond({Key key}) : super(key: key);

  @override
  _ViewSecondState createState() => _ViewSecondState();
}

class _ViewSecondState extends State<ViewSecond> with TickerProviderStateMixin {
  AnimationController _controllerRotate;
  Animation<double> _animationRotate;
  AnimationController _controllerCurl;
  Animation<int> _animationCurl;
  double slider1Value = 0.0;
  double slider2Value = 0.0;

  @override
  void initState() {
    super.initState();
    _controllerRotate = AnimationController(
      vsync: this,
      value: 0.0,
      duration: const Duration(seconds: 2),
    );
    _animationRotate = CurvedAnimation(
      parent: _controllerRotate,
      curve: Curves.linear,
    );
    _controllerCurl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 0),
    );
    _animationCurl = IntTween(begin: 1, end: 182).animate(_controllerCurl);
  }

  double childSizeRatio;

  double calcRatio() {
    var image = Image.asset('assets/brush/output001.png');
    var width = image.width;
    var height = image.height;
    var hypotenuse = sqrt(pow(width, 2) + pow(height, 2));
    return max(width, height) / hypotenuse;
  }

  @override
  Widget build(BuildContext context) {
    var parentSize = MediaQuery.of(context).size.width * 1;
    return Scaffold(
      appBar: AppBar(
        title: Text('Second'),
      ),
      body: ListView(
        shrinkWrap: true,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                  child: ClipOval(
                    child: Container(
                      // alignment: Alignment.center,
                      height: parentSize,
                      width: parentSize,
                      color: Colors.black,
                      child: RotationTransition(
                        turns: _animationRotate,
                        child: Center(
                          child: AnimatedBuilder(
                            animation: _animationCurl,
                            builder: (BuildContext context, Widget child) {
                              String frame = _animationCurl.value.toString().padLeft(3, '0');
                              // return PhotoView(
                              //     maxScale: 1.0,
                              //     minScale: PhotoViewComputedScale.contained,
                              //     gaplessPlayback: true,
                              //     imageProvider: AssetImage(
                              //       'assets/brush/output${_animationCurl.value.toString().padLeft(3, '0')}.png',
                              //     ));
                              return Image.asset('assets/brush/output$frame.png',
                                  gaplessPlayback: true);
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                  onVerticalDragStart: (drag) {},
                  onVerticalDragEnd: (drag) {},
                  onVerticalDragUpdate: (drag) {
                    var newValue = _controllerCurl.value + -(drag.delta.dy * 0.01);
                    print('---------- $newValue');
                    if (newValue < 0.0) {
                      newValue += 1;
                    } else if (newValue > 1.0) {
                      newValue -= 1.0;
                    }
                    _controllerCurl.value = newValue;
                  },
                  onHorizontalDragUpdate: (drag) {
                    var newValue = _controllerRotate.value + -(drag.delta.dx / 500);
                    if (newValue < 0.0) {
                      newValue += 1;
                    } else if (newValue > 1.0) {
                      newValue -= 1.0;
                    }
                    _controllerRotate.value = newValue;
                  }),
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
