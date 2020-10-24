import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

Future<List<Asset>> showMultiImagePicker({BuildContext context, int maxImages}) async {
  List<Asset> resultList;
  Permission permission = Platform.isAndroid ? Permission.storage : Permission.photos;
  var permissionStatus = await permission.request();
  if (permissionStatus.isGranted) {
    try {
      resultList = await MultiImagePicker.pickImages(
        enableCamera: true,
        materialOptions: MaterialOptions(
            useDetailsView: true,
            allViewTitle: 'Все фото',
            actionBarTitle: 'Альбомы',
            actionBarColor: '#666666',
            statusBarColor: '#666666',
            selectCircleStrokeColor: '#ff0000',
            // startInAllView: true,
            // okButtonDrawable: 'adadfsf',
            selectionLimitReachedText: 'Выбрано маскимальное количество'),
        maxImages: maxImages,
      );
    } catch (e) {
      print(e);
    }
  } else {
    showPlatformDialog(
      context: context,
      builder: (_) => PlatformAlertDialog(
        title: Text('Нет разрешения'),
        content: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Text(
              'Приложению требуется доступ к фото. Разрешить доступ можно в настройках приватности на вашем устройстве.'),
        ),
        actions: <Widget>[
          PlatformDialogAction(
            child: Text('OK'),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }
  return resultList;
}
