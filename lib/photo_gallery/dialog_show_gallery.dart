import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'view_photo_galery.dart';

typedef ViewInteractionWidget = Widget Function(BuildContext context, Map result);

dialogShowGallery(
  BuildContext context, {
  List<String> paths,
  List<String> urls,
  File file,
  List<Uint8List> uint8s,
  List<Asset> assets,
  ViewInteractionWidget showUserInteractionUi,
  bool edit = false,
}) {
  return showGeneralDialog(
      context: context,
      barrierDismissible: false,
      transitionDuration: const Duration(milliseconds: 100),
      useRootNavigator: false,
      pageBuilder: (_, __, ___) {
        return ViewPhotoGalery(
          paths: paths,
          file: file,
          uint8s: uint8s,
          urls: urls,
          assets: assets,
          showUserInteractionUi: showUserInteractionUi,
          edit: edit,
        );
      });
}
