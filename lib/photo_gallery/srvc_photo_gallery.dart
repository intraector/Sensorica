import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:path_provider/path_provider.dart';

class ServicePhotoGallery {
  final List<String> paths;
  final List<String> urls;
  final List<Asset> assets;
  File file;
  List<Uint8List> uint8s;
  ServicePhotoGallery({this.paths, this.urls, this.uint8s, this.assets, this.file}) {
    init();
  }

  ProviderType type;
  Future<int> itemCount;
  List elements;
  int currentIndex;

  Future<void> init() async {
    if (paths != null && paths.isNotEmpty) {
      type = ProviderType.paths;
      itemCount = Future.value(paths.length);
      elements = paths;
    }
    if (urls != null && urls.isNotEmpty) {
      type = ProviderType.urls;
      itemCount = Future.value(urls.length);
      elements = urls;
    }
    if (uint8s != null && uint8s.isNotEmpty) {
      type = ProviderType.uint8s;
      itemCount = Future.value(uint8s.length);
      elements = uint8s;
    }
    if (assets != null && assets.isNotEmpty) {
      type = ProviderType.uint8s;
      uint8s = [];
      var _futures = <Future>[];

      itemCount = Future(() async {
        for (var asset in assets) {
          var _byteData = await asset.getByteData();
          var future = FlutterImageCompress.compressWithList(
            _byteData.buffer.asUint8List(),
            minWidth: 1280,
            quality: 50,
          );
          _futures.add(future);
          uint8s.add(Uint8List.fromList(await future));
        }
        await Future.wait(_futures);

        return uint8s.length;
      });

      elements = uint8s;
    }

    if (file != null) {
      type = ProviderType.file;
      itemCount = Future.value(1);
      elements = [file];
    }
    currentIndex = 0;
  }

  Widget getImageProvider(int index) {
    Widget result;
    switch (type) {
      case ProviderType.paths:
        result = Image.file(File(paths[index]));
        break;
      case ProviderType.urls:
        result = CachedNetworkImage(imageUrl: urls[index]);
        break;
      case ProviderType.file:
        result = Image.file(file);
        break;
      case ProviderType.uint8s:
        result = Image.memory(uint8s[index]);
        break;
    }
    return result;
  }

  Widget getImage(dynamic element) {
    switch (type) {
      case ProviderType.uint8s:
        return Image.memory(element);
      case ProviderType.urls:
        return CachedNetworkImage(imageUrl: element);
      case ProviderType.file:
        return Image.file(element);
      case ProviderType.paths:
        return Image.file(File(element));
      default:
        return null;
    }
  }

  Future<String> getFilePathForCropper() async {
    switch (type) {
      case ProviderType.uint8s:
        return writeToFile(uint8s[currentIndex]);
      case ProviderType.urls:
        {
          // var _image = await get(urls[currentIndex]);
          // return writeToFile(_image.bodyBytes);
          return '';
        }
      case ProviderType.file:
        return file.path;
      case ProviderType.paths:
        return paths[currentIndex];
      default:
        return null;
    }
  }

  Future<String> writeToFile(Uint8List data) async {
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path + '/photo' + DateTime.now().millisecondsSinceEpoch.toString();
    await File(tempPath).writeAsBytes(data);
    return tempPath;
  }

  Future<void> applyEditedPhoto(File _newFile) async {
    if (_newFile != null) {
      switch (type) {
        case ProviderType.uint8s:
          uint8s[currentIndex] = await _newFile.readAsBytes();
          break;
        case ProviderType.urls:
          return;
        case ProviderType.file:
          return file = _newFile;
        case ProviderType.paths:
          paths[currentIndex] = _newFile.path;
          break;
        default:
          return null;
      }
    }
  }
}

enum ProviderType { paths, urls, file, uint8s }
