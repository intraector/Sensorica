import 'dart:collection';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
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
  Future<List<Uint8List>> imagesAsUint8;
  var images = <Image>[];
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
      duration: const Duration(milliseconds: 500),
    );
    _animationCurl = IntTween(begin: 1, end: 181).animate(_controllerCurl);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    imagesAsUint8 = loadImages();
  }

  double childSizeRatio;

  double calcRatio() {
    var image = Image.asset('assets/brush800/output001.png');
    var width = image.width;
    var height = image.height;
    var hypotenuse = sqrt(pow(width, 2) + pow(height, 2));
    return max(width, height) / hypotenuse;
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
              FutureBuilder<List<Uint8List>>(
                  future: imagesAsUint8,
                  builder: (context, snapshot) {
                    if (!(snapshot?.hasData ?? true))
                      return Center(
                          child:
                              SizedBox(height: 50, width: 50, child: CircularProgressIndicator()));
                    return GestureDetector(
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
                                    // return PhotoView(
                                    //     maxScale: 1.0,
                                    //     minScale: PhotoViewComputedScale.contained,
                                    //     gaplessPlayback: true,
                                    //     imageProvider: AssetImage(
                                    //       'assets/brush/output${_animationCurl.value.toString().padLeft(3, '0')}.png',
                                    //     ));
                                    return images[_animationCurl.value];
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
                          if (newValue < 0.0) {
                            newValue += 1;
                          } else if (newValue > 1.0) {
                            newValue -= 1.0;
                          }
                          xAccStore.removeFirst();
                          xAccStore.add(newValue);
                          count++;
                          if (count > 10) {
                            var angle =
                                (xAccStore.reduce((first, next) => first + next) / _xAmount);
                            _controllerCurl.animateTo(angle);
                            count = 0;
                          }
                          // _controllerCurl.value = newValue;
                        },
                        onHorizontalDragUpdate: (drag) {
                          // var newValue = _controllerRotate.value + -(drag.delta.dx / 500);
                          // if (newValue < 0.0) {
                          //   newValue += 1;
                          // } else if (newValue > 1.0) {
                          //   newValue -= 1.0;
                          // }
                          // _controllerRotate.value = newValue;
                        });
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

  Future<List<Uint8List>> loadImages() async {
    var futures = <Future<ByteData>>[];
    for (int index = 1; index <= 182; index++) {
      futures.add(rootBundle.load('assets/brush800/output${index.toString().padLeft(3, '0')}.png'));
    }
    var byteDataList = await Future.wait(futures);

    var uint8List = byteDataList.map((byteData) {
      return byteData.buffer.asUint8List();
    }).toList();
    byteDataList = null;

    images = uint8List.map<Image>((e) {
      return Image.memory(e, gaplessPlayback: true);
    }).toList();
    var _futures = <Future>[];
    for (var image in images) {
      _futures.add(precacheImage(image.image, context));
    }
    await Future.wait(_futures);
    return uint8List;
  }
}
