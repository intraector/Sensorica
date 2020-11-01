import 'package:Sensorica/views/components/rotation_and_curl.dart';
import 'package:Sensorica/views/components/parallax.dart';
import 'package:flutter/material.dart';

class BottomTabBarMaterial extends StatelessWidget {
  BottomTabBarMaterial(this._index);
  final int _index;

  @override
  Widget build(BuildContext context) {
    Widget rotation;
    Widget parallax;
    final _inactiveColor = Colors.grey;
    final _disabledColor = Colors.brown[700];
    final double _iconSize = 26;
    var _list = <Widget>[];
    //----------------------------------------catalog
    rotation = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
            icon: Icon(Icons.screen_rotation),
            iconSize: _iconSize,
            disabledColor: _disabledColor,
            color: _inactiveColor,
            onPressed: _index == 0
                ? null
                : () => Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => ViewRotation()), (route) => false)),
        Text(
          'Rotation',
          style: TextStyle(color: _index == 0 ? _disabledColor : _inactiveColor),
        ),
      ],
    );
    //----------------------------------------account
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
    _list = [rotation, parallax];
    return BottomAppBar(
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: _list,
      ),
    );
  }
}
