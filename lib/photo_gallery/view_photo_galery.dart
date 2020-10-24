import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'srvc_photo_gallery.dart';

typedef ViewInteractionWidget = Widget Function(BuildContext context, Map result);

class ViewPhotoGalery extends StatefulWidget {
  final List<String> paths;
  final List<String> urls;
  final List<Asset> assets;
  final File file;
  final List<Uint8List> uint8s;
  final bool edit;
  final ViewInteractionWidget showUserInteractionUi;
  ViewPhotoGalery({
    this.paths,
    this.urls,
    this.uint8s,
    this.file,
    this.assets,
    this.showUserInteractionUi,
    this.edit = false,
  });

  @override
  _ViewPhotoGaleryState createState() => _ViewPhotoGaleryState();
}

class _ViewPhotoGaleryState extends State<ViewPhotoGalery> {
  ServicePhotoGallery srvcPhotoGallery;
  Widget userInteractionWidget;
  PageController _ctrlerPhotoView;
  @override
  void didChangeDependencies() {
    _ctrlerPhotoView = PageController();
    super.didChangeDependencies();
    srvcPhotoGallery = ServicePhotoGallery(
        paths: widget.paths,
        urls: widget.urls,
        uint8s: widget.uint8s,
        assets: widget.assets,
        file: widget.file);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black87,
        actions: <Widget>[
          if (widget.edit)
            FlatButton(
              child: Text('Обрезать/повернуть', style: TextStyle(color: Colors.grey[300])),
              onPressed: () async {
                var _newFile = await ImageCropper.cropImage(
                    sourcePath: await srvcPhotoGallery.getFilePathForCropper(),
                    aspectRatioPresets: [
                      CropAspectRatioPreset.original,
                      CropAspectRatioPreset.square,
                      CropAspectRatioPreset.ratio4x3,
                      CropAspectRatioPreset.ratio16x9
                    ],
                    androidUiSettings: AndroidUiSettings(
                      toolbarTitle: 'Редактировать',
                      toolbarColor: Colors.blue,
                      toolbarWidgetColor: Colors.white,
                      initAspectRatio: CropAspectRatioPreset.original,
                      lockAspectRatio: false,
                      activeControlsWidgetColor: Colors.blue,
                      // hideBottomControls: true,
                    ),
                    iosUiSettings: IOSUiSettings(
                      minimumAspectRatio: 1.0,
                    ));
                srvcPhotoGallery.applyEditedPhoto(_newFile);
                if (_ctrlerPhotoView.hasClients)
                  setState(() {
                    _ctrlerPhotoView.jumpToPage(srvcPhotoGallery.currentIndex);
                  });
              },
            )
        ],
      ),
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          FutureBuilder<int>(
            future: srvcPhotoGallery.itemCount,
            initialData: 0,
            builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
              if (snapshot.connectionState != ConnectionState.done)
                return Container(
                  alignment: Alignment.center,
                  width: 50.0,
                  height: 50.0,
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.white,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.grey),
                  ),
                );
              else
                return LayoutBuilder(
                  builder: (context, constraints) => Container(
                    alignment: Alignment.center,
                    child: PhotoViewGallery.builder(
                      pageController: _ctrlerPhotoView,
                      scrollPhysics: const BouncingScrollPhysics(),
                      builder: (BuildContext context, int index) {
                        return PhotoViewGalleryPageOptions.customChild(
                          child: srvcPhotoGallery.getImageProvider(index),
                          childSize: constraints.biggest,
                          maxScale: PhotoViewComputedScale.contained * 2,
                          minScale: PhotoViewComputedScale.contained,
                          initialScale: PhotoViewComputedScale.contained,
                        );
                      },
                      itemCount: snapshot.data,
                      loadingBuilder: (_, chunk) => Container(
                        alignment: Alignment.center,
                        width: 50.0,
                        height: 50.0,
                        child: CircularProgressIndicator(
                          value: chunk.cumulativeBytesLoaded / chunk.expectedTotalBytes,
                          backgroundColor: Colors.white,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.grey),
                        ),
                      ),
                      onPageChanged: (index) => setState(() {
                        srvcPhotoGallery.currentIndex = index;
                      }),
                    ),
                  ),
                );
            },
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                FutureBuilder<int>(
                    future: srvcPhotoGallery.itemCount,
                    initialData: 0,
                    builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
                      if (snapshot.connectionState == ConnectionState.done &&
                          widget.showUserInteractionUi != null)
                        return widget.showUserInteractionUi(context, {
                          'uint8s': srvcPhotoGallery.uint8s,
                          'assets': srvcPhotoGallery.assets,
                          'urls': srvcPhotoGallery.urls,
                          'paths': srvcPhotoGallery.paths,
                          'file': srvcPhotoGallery.file,
                        });
                      else
                        return Container();
                    }),
                FutureBuilder<int>(
                  future: srvcPhotoGallery.itemCount,
                  initialData: 0,
                  builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
                    if (snapshot.connectionState == ConnectionState.done && snapshot.data > 1)
                      return Container(
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Container(
                                alignment: Alignment.center,
                                color: Colors.black54,
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    children: <Widget>[
                                      ...srvcPhotoGallery.elements
                                          .asMap()
                                          .map((index, element) => MapEntry(
                                              index,
                                              InkWell(
                                                onTap: () {
                                                  srvcPhotoGallery.currentIndex = index;
                                                  _ctrlerPhotoView.animateToPage(index,
                                                      duration: Duration(seconds: 1),
                                                      curve: Curves.easeOut);
                                                },
                                                child: Container(
                                                  width: 50.0,
                                                  height: 50.0,
                                                  decoration: BoxDecoration(
                                                      border: Border.all(
                                                          color:
                                                              srvcPhotoGallery.currentIndex == index
                                                                  ? Colors.blue
                                                                  : Colors.transparent)),
                                                  child: srvcPhotoGallery.getImage(element),
                                                ),
                                              )))
                                          .values
                                          .toList(),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    else
                      return Container();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
