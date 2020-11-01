import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:photo_view/photo_view.dart';

class ViewRotationDrag extends StatefulWidget {
  ViewRotationDrag({Key key}) : super(key: key);

  @override
  _ViewRotationDragState createState() => _ViewRotationDragState();
}

const int _xAmount = 10;

class _ViewRotationDragState extends State<ViewRotationDrag> with TickerProviderStateMixin {
  AnimationController _controllerRotate;
  Animation<double> _animationRotate;
  AnimationController _controllerCurl;
  Animation<int> _animationCurl;
  double slider1Value = 0.0;
  double slider2Value = 0.0;
  var xAccStore = ListQueue<double>()..addAll(List.generate(_xAmount, (index) => 0.0));

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
      duration: const Duration(seconds: 5),
    );
    _animationCurl = IntTween(begin: 1, end: 181).animate(_controllerCurl);
  }

  int count = 0;
  @override
  Widget build(BuildContext context) {
    var parentSize = MediaQuery.of(context).size.width * 1;
    return Scaffold(
      appBar: AppBar(
        title: Text('Rotation&Curl Drag'),
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
                              return PhotoView(
                                  maxScale: 1.0,
                                  minScale: PhotoViewComputedScale.contained,
                                  gaplessPlayback: true,
                                  imageProvider: AssetImage(
                                    'assets/brush2k/output${_animationCurl.value.toString().padLeft(3, '0')}.png',
                                  ));
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                  onVerticalDragUpdate: (drag) {
                    xAccStore.removeFirst();
                    xAccStore.add(drag.delta.dy);
                    count++;
                    if (count > 10) {
                      var angle = (xAccStore.reduce((first, next) => first + next) / _xAmount);
                      var newValue = _controllerCurl.value + -(angle * 0.01);
                      if (newValue < 0.0) {
                        newValue += 1;
                      } else if (newValue > 1.0) {
                        newValue -= 1.0;
                      }
                      print('---------- newValue : ${newValue}');
                      _controllerCurl.animateTo(newValue);
                      count = 0;
                    }
                  },
                  onHorizontalDragUpdate: (drag) {
                    // var newValue = _controllerRotate.value + -(drag.delta.dx / 500);
                    // if (newValue < 0.0) {
                    //   newValue += 1;
                    // } else if (newValue > 1.0) {
                    //   newValue -= 1.0;
                    // }
                    // _controllerRotate.value = newValue;
                  }),
            ],
          ),
          Slider(
              value: slider1Value,
              onChanged: (value) {
                setState(() {
                  slider1Value = value;
                });
                _controllerRotate.animateTo(value);
              }),
          Slider(
              value: slider2Value,
              onChanged: (value) {
                setState(() {
                  slider2Value = value;
                  // var _positionInMilliseconds =
                  //     (_vidController.value.duration.inMilliseconds.toDouble() * slider2Value)
                  //         .toInt();
                });
                _controllerCurl.animateTo(value);
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
