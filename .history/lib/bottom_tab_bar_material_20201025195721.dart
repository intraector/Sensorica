import 'package:ZapApp/constants/app_colors.dart';
import 'package:ZapApp/constants/app_paths.dart';
import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:sailor/sailor.dart';
import 'package:ZapApp/models/ModelNotifState.dart';
import 'package:ZapApp/models/UserRole.dart';
import 'package:ZapApp/models/ModelUser.dart';
import 'package:ZapApp/services/service_notifications.dart';
import 'package:ZapApp/services/routes.dart';

class BottomTabBarMaterial extends StatelessWidget {
  BottomTabBarMaterial(this._index);
  final int _index;

  @override
  Widget build(BuildContext context) {
    final user = GetIt.I<ModelUser>();
    var srvcNotifications = Provider.of<ServiceNotifications>(context, listen: false);
    Widget _screenCars;
    Widget _usersList;
    Widget _service;
    Widget _messages;
    Widget _account;
    Widget _catalog;
    // Widget _adminNotifs;
    final _inactiveColor = AppColors.primaryAccent;
    final _disabledColor = AppColors.secondary;
    final double _iconSize = 26;
    var _list = <Widget>[];
    //----------------------------------------_screenCars
    _screenCars = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: Selector<ModelNotifState, bool>(
            selector: (_, notifState) => notifState.car,
            builder: (_, isNewCar, __) => Badge(showBadge: isNewCar, child: Icon(Icons.list)),
          ),
          iconSize: _iconSize,
          disabledColor: _disabledColor,
          color: _inactiveColor,
          onPressed: _index == 0
              ? null
              : () {
                  srvcNotifications.bottomNavigationIndex = 0;
                  srvcNotifications.carSeen;
                  return Routes.sailor
                      .navigate(AppPaths.cars, navigationType: NavigationType.pushReplace);
                },
        ),
        Text(
          'Запросы',
          style: TextStyle(color: _index == 0 ? _disabledColor : _inactiveColor),
        ),
      ],
    );
    //----------------------------------------_messages
    _messages = Selector<ModelNotifState, bool>(
      selector: (_, notifState) => notifState.msg,
      builder: (_, isNewMsg, __) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Badge(showBadge: isNewMsg, child: Icon(Icons.message)),
              iconSize: _iconSize,
              disabledColor: _disabledColor,
              color: _inactiveColor,
              onPressed: _index == 1
                  ? null
                  : () {
                      srvcNotifications.bottomNavigationIndex = 1;
                      srvcNotifications.msgSeen;
                      return Routes.sailor.navigate(AppPaths.messages,
                          navigationType: NavigationType.pushReplace,
                          removeUntilPredicate: (_) => false);
                    },
            ),
            Text(
              'Сообщения',
              style: TextStyle(color: _index == 1 ? _disabledColor : _inactiveColor),
            )
          ],
        );
      },
    );
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
    //----------------------------------------_usersList
    _usersList = IconButton(
      icon: Icon(Icons.supervised_user_circle),
      iconSize: _iconSize,
      disabledColor: _disabledColor,
      color: _inactiveColor,
      onPressed: _index == 4
          ? null
          : () {
              srvcNotifications.bottomNavigationIndex = 4;
              return Routes.sailor
                  .navigate('ScreenUsers', navigationType: NavigationType.pushReplace);
            },
    );
    //----------------------------------------_service
    _service = IconButton(
      icon: Icon(Icons.settings_ethernet),
      iconSize: _iconSize,
      disabledColor: _disabledColor,
      color: _inactiveColor,
      onPressed: _index == 5
          ? null
          : () {
              srvcNotifications.bottomNavigationIndex = 5;
              return Routes.sailor
                  .navigate('ScreenService', navigationType: NavigationType.pushReplace);
            },
    );

    //----------------------------------------_adminNotifs
    // _adminNotifs = IconButton(
    //   icon: Icon(Icons.notifications),
    //   iconSize: _iconSize,
    //   disabledColor: _disabledColor,
    //   color: _inactiveColor,
    //   onPressed: _index == 6
    //       ? null
    //       : () {
    //           srvcNotifications.bottonNavigationIndex = 6;
    //           return Routes.sailor
    //               .navigate('ScreenAdminNotifs', navigationType: NavigationType.pushReplace);
    //         },
    // );

    switch (user.role) {
      case UserRole.user:
        _list = [_screenCars, _messages, _catalog, _account];
        break;
      case UserRole.partner:
        {
          _list = [_screenCars, _messages, _catalog, _account];
          // if (user.partnerApproved)
          // else
          //   _list = [_newCar];
        }
        break;
      case UserRole.admin:
        {
          _list = [_screenCars, _messages, _catalog, _account, _usersList, _service];
        }
        break;
      default:
        _list = [];
        break;
    }
    return BottomAppBar(
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: _list,
      ),
    );
  }
}
