import 'package:Sensorica/photo_gallery/Uint8sContainer.dart';
import 'package:Sensorica/photo_gallery/components/photo_from_uint8.dart';
import 'package:Sensorica/photo_gallery/components/show_submit_btn_ui.dart';
import 'package:flutter/material.dart';
import '../dialog_show_gallery.dart';
import '../show_multiImage_picker.dart';

class ViewAddPhotos extends StatefulWidget {
  final Uint8sContainer container;
  final int length;
  ViewAddPhotos(this.container, this.length);

  @override
  _ViewAddPhotosState createState() => _ViewAddPhotosState();
}

class _ViewAddPhotosState extends State<ViewAddPhotos> {
  int emptyCells;

  @override
  void initState() {
    super.initState();
    emptyCells = widget.length - widget.container.photoUint8s.length;
    createThumbs();
  }

  @override
  Widget build(BuildContext context) => Row(
        children: <Widget>[
          Expanded(
            child: widget.container.photoUint8s.isEmpty
                ? Center(
                    child: RaisedButton.icon(
                        icon: Icon(Icons.attachment),
                        color: Colors.white,
                        elevation: 1.0,
                        textColor: Theme.of(context).accentColor,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
                        label: Text('Прикрепить фотографии'),
                        onPressed: () async {
                          var resultList =
                              await showMultiImagePicker(context: context, maxImages: 3);
                          if (!mounted) return;
                          if (resultList != null && resultList.isNotEmpty) {
                            var resultMap = await dialogShowGallery(
                              context,
                              assets: resultList,
                              showUserInteractionUi: showSubmitBtnUi,
                              edit: true,
                            );
                            if (resultMap != null) {
                              if (mounted)
                                setState(() {
                                  for (int i = 0; i < resultMap['uint8s'].length; i++)
                                    widget.container.photoUint8s[i.toString()] =
                                        resultMap['uint8s'][i];

                                  emptyCells = widget.length - widget.container.photoUint8s.length;
                                });
                            }
                          }
                        }),
                  )
                : Wrap(
                    alignment: WrapAlignment.center,
                    children: createThumbs(),
                  ),
          ),
        ],
      );

  List<Widget> createThumbs() {
    var thumbs = <Widget>[];
    thumbs.clear();
    for (int i = 0; i < widget.container.photoUint8s.length; i++)
      thumbs.add(Stack(
        children: <Widget>[
          Container(
            margin: const EdgeInsets.fromLTRB(0.0, 12.0, 15.0, 0.0),
            child: PhotoFromUint8(widget.container.photoUint8s[i.toString()], 55),
          ),
          Positioned(
            top: 0.0,
            right: 0.0,
            child: Material(
              child: InkWell(
                child: ClipOval(
                  child: Container(
                      color: Colors.white,
                      child: Icon(Icons.cancel, color: Colors.black, size: 30.0)),
                ),
                onTap: () {
                  setState(() {
                    var tmpList = widget.container.photoUint8s.values.toList()..removeAt(i);
                    widget.container.photoUint8s =
                        tmpList.asMap().map((k, v) => MapEntry(k.toString(), v));
                    emptyCells = widget.length - widget.container.photoUint8s.length;
                  });
                },
              ),
            ),
          ),
        ],
      ));
    for (int i = 0; i < emptyCells; i++) {
      thumbs.add(
        Container(
          margin: const EdgeInsets.fromLTRB(0.0, 12.0, 15.0, 0.0),
          child: Material(
            child: InkWell(
                child: Container(
                  width: 55,
                  height: 55,
                  margin: EdgeInsets.only(top: 8.0),
                  child: Icon(
                    Icons.camera_alt,
                    color: Colors.grey,
                    size: 48.0,
                  ),
                ),
                onTap: () async {
                  var resultList =
                      await showMultiImagePicker(context: context, maxImages: emptyCells);
                  if (!mounted) return;
                  if (resultList != null && resultList.isNotEmpty) {
                    var resultMap = await dialogShowGallery(
                      context,
                      assets: resultList,
                      showUserInteractionUi: showSubmitBtnUi,
                      edit: true,
                    );
                    if (resultMap != null) {
                      setState(() {
                        var tmpList = widget.container.photoUint8s.values.toList();
                        tmpList.addAll(resultMap['uint8s']);
                        widget.container.photoUint8s =
                            tmpList.asMap().map((k, v) => MapEntry(k.toString(), v));
                        emptyCells = widget.length - widget.container.photoUint8s.length;
                      });
                    }
                  }
                }),
          ),
        ),
      );
    }
    return thumbs;
  }
}
