import 'package:flutter/material.dart';

class BottomTabBarMaterial extends StatelessWidget {
  BottomTabBarMaterial(this._index);
  final int _index;

  @override
  Widget build(BuildContext context) {
    Widget _account;
    Widget _catalog;
    final _inactiveColor = Colors.green;
    final _disabledColor = Colors.brown;
    final double _iconSize = 26;
    var _list = <Widget>[];
    //----------------------------------------catalog
    _catalog = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: Icon(Icons.apps),
          iconSize: _iconSize,
          disabledColor: _disabledColor,
          color: _inactiveColor,
          onPressed: _index == 2
              ? null
              : () => Routes.sailor(AppPaths.catalog,
                  params: {'type': 'junkyard'}, navigationType: NavigationType.pushReplace),
        ),
        Text(
          'Каталог',
          style: TextStyle(color: _index == 2 ? _disabledColor : _inactiveColor),
        ),
      ],
    );
    //----------------------------------------account
    _account = Column(
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
    _list = [_catalog, _account];
    return BottomAppBar(
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: _list,
      ),
    );
  }
}
