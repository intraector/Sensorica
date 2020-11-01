import 'package:Sensorica/views/components/rotation_and_curl_drag2.dart';
import 'package:Sensorica/views/components/parallax.dart';
import 'package:flutter/material.dart';

class BottomTabBarMaterial extends StatelessWidget {
  BottomTabBarMaterial(this._index);
  final int _index;

  @override
  Widget build(BuildContext context) {
    // Widget rotationSensors;
    Widget parallax;
    Widget rotationDrag;
    final _inactiveColor = Colors.brown[400];
    final _disabledColor = Colors.brown[100];
    final double _iconSize = 26;
    var _list = <Widget>[];

    // //----------------------------------------rotationSensors
    // rotationSensors = Column(
    //   mainAxisSize: MainAxisSize.min,
    //   children: [
    //     IconButton(
    //         icon: Icon(Icons.screen_rotation),
    //         iconSize: _iconSize,
    //         disabledColor: _disabledColor,
    //         color: _inactiveColor,
    //         onPressed: _index == 0
    //             ? null
    //             : () => Navigator.of(context).pushAndRemoveUntil(
    //                 MaterialPageRoute(builder: (context) => ViewRotationSensors()),
    //                 (route) => false)),
    //     Text(
    //       'Sensors',
    //       style: TextStyle(color: _index == 0 ? _disabledColor : _inactiveColor),
    //     ),
    //   ],
    // );

    //----------------------------------------parallax
    parallax = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
            icon: Icon(Icons.panorama_fish_eye),
            iconSize: _iconSize,
            disabledColor: _disabledColor,
            color: _inactiveColor,
            onPressed: _index == 1
                ? null
                : () => Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => ViewParallax()), (route) => false)),
        Text(
          'Parallax',
          style: TextStyle(color: _index == 1 ? _disabledColor : _inactiveColor),
        ),
      ],
    );

    //----------------------------------------rotationDrag
    rotationDrag = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
            icon: Icon(Icons.panorama_horizontal),
            iconSize: _iconSize,
            disabledColor: _disabledColor,
            color: _inactiveColor,
            onPressed: _index == 2
                ? null
                : () => Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => ViewRotationDrag2()),
                    (route) => false)),
        Text(
          'Drag',
          style: TextStyle(color: _index == 1 ? _disabledColor : _inactiveColor),
        ),
      ],
    );

    _list = [parallax, rotationDrag];
    return BottomAppBar(
      color: Colors.brown[900],
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: _list,
      ),
    );
  }
}
