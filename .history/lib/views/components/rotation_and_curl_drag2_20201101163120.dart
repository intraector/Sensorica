import 'dart:collection';

import 'package:flutter/cupertino.dart';
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
      // duration: const Duration(milliseconds: 500),
      duration: const Duration(seconds: 1),
    );
    _animationCurl = IntTween(begin: 1, end: 182).animate(_controllerCurl);
  }

  String _path = _Folders.brush800;
  @override
  Widget build(BuildContext context) {
    var parentSize = MediaQuery.of(context).size.width * 1;
    return Scaffold(
      // backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('Rotation&Curl Drag'),
      ),
      body: ListView(
        shrinkWrap: true,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ClipRect(
                child: GestureDetector(
                    child: Container(
                      // alignment: Alignment.center,
                      height: parentSize * 1.5,
                      width: parentSize,
                      color: Colors.black,
                      child: RotationTransition(
                        turns: _animationRotate,
                        child: Center(
                          child: AnimatedBuilder(
                            animation: _animationCurl,
                            builder: (BuildContext context, Widget child) {
                              // return Image.asset(
                              //   'assets/brushFullHDJpgLow/output${_animationCurl.value.toString().padLeft(3, '0')}.jpg',
                              //   gaplessPlayback: true,
                              // );
                              return PhotoView(
                                  maxScale: 1.0,
                                  minScale: PhotoViewComputedScale.contained / 1.5,
                                  gaplessPlayback: true,
                                  filterQuality: FilterQuality.none,
                                  imageProvider: AssetImage(
                                    'assets/$_path/output${_animationCurl.value.toString().padLeft(3, '0')}.jpg',
                                  ));
                            },
                          ),
                        ),
                      ),
                    ),
                    onVerticalDragUpdate: (drag) {
                      var newValue = _controllerRotate.value + (drag.delta.dy / 500);
                      if (newValue < 0.0) {
                        newValue += 1;
                      } else if (newValue > 1.0) {
                        newValue -= 1.0;
                      }
                      _controllerRotate.value = newValue;
                    },
                    onHorizontalDragUpdate: (drag) {
                      xAccStore.removeFirst();
                      xAccStore.add(drag.delta.dx);
                      // var shift = (xAccStore.reduce((first, next) => first + next) / _xAmount);
                      // var newValue = (_controllerCurl.value + -(shift / 200)).clamp(0.0, 10.0);
                      var newValue =
                          (_controllerCurl.value + (drag.delta.dx / 200)).clamp(0.0, 10.0);
                      setState(() {
                        _controllerCurl.value = newValue;
                      });
                    }),
              ),
            ],
          ),
          InkWell(
            child: Row(
              children: [
                _path == _Folders.brush800
                    ? Icon(CupertinoIcons.hexagon_fill, color: Colors.blue, size: 20)
                    : Icon(CupertinoIcons.hexagon_fill, color: Colors.grey, size: 20),
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('800x601', style: TextStyle(fontSize: 16)),
                  ),
                ),
              ],
            ),
            onTap: () => setState(() => _path = _Folders.brush800),
          ),
          // Slider(
          //     value: slider1Value,
          //     onChanged: (value) {
          //       setState(() {
          //         slider1Value = value;
          //       });
          //       _controllerRotate.animateTo(value);
          //     }),
          // Slider(
          //     value: slider2Value,
          //     onChanged: (value) {
          //       setState(() {
          //         slider2Value = value;
          //         // var _positionInMilliseconds =
          //         //     (_vidController.value.duration.inMilliseconds.toDouble() * slider2Value)
          //         //         .toInt();
          //       });
          //       _controllerCurl.animateTo(value);
          //     }),
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

class _Folders {
  static const String brush800 = 'brush800';
  static const String brush1000 = 'brush1000';
  static const String brush1000Bmp = 'brush1000Bmp';
  static const String brush1280 = 'brush1280';
  static const String brush1920 = 'brush1920';
  static const String brush2048 = 'brush2048';
  static const String brush3840 = 'brush3840';
}

 Map<String,String> paths = {
'800x601' : 'brush800',
'1000x999' : 'brush1000',
'1000x999 bmp' : 'brush1000Bmp',
'1280x720 (HD)' : 'brush1280',
'1920x1080 (FullHD)' : 'brush1920',
'2048x999 (2k)' : 'brush2048',
'2840x2160 (4k)' : 'brush3840',
}
