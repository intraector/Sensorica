import 'package:Sensorica/views/components/rotation_and_curl.dart';
import 'package:flutter/material.dart';

class BottomTabBarMaterial extends StatelessWidget {
  BottomTabBarMaterial(this._index);
  final int _index;

  @override
  Widget build(BuildContext context) {
    Widget rotation;
    Widget parallax;
    final _inactiveColor = Colors.green;
    final _disabledColor = Colors.brown;
    final double _iconSize = 26;
    var _list = <Widget>[];
    //----------------------------------------catalog
    rotation = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
            icon: Icon(Icons.apps),
            iconSize: _iconSize,
            disabledColor: _disabledColor,
            color: _inactiveColor,
            onPressed: _index == 2
                ? null
                : () => Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => ViewRotation()), (route) => false)),
        Text(
          'Каталог',
          style: TextStyle(color: _index == 2 ? _disabledColor : _inactiveColor),
        ),
      ],
    );
    //----------------------------------------account
    parallax = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: Icon(Icons.account_circle),
          iconSize: _iconSize,
          disabledColor: _disabledColor,
          color: _inactiveColor,
          onPressed: _index == 3
              ? null
              : () => Routes.sailor(AppPaths.account, navigationType: NavigationType.pushReplace),
        ),
        Text(
          'Аккаунт',
          style: TextStyle(color: _index == 3 ? _disabledColor : _inactiveColor),
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
