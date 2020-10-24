import 'package:Sensorica/photo_gallery/components/photo_from_uint8.dart';
import 'package:flutter/material.dart';

import '../Uint8sContainer.dart';
import '../dialog_show_gallery.dart';
import '../show_multiImage_picker.dart';
import 'show_submit_btn_ui.dart';

class AddSinglePhoto extends StatefulWidget {
  final Uint8sContainer container;
  final bool logo;
  AddSinglePhoto(this.container, {this.logo = false});
  @override
  _AddSinglePhotoState createState() => _AddSinglePhotoState();
}

class _AddSinglePhotoState extends State<AddSinglePhoto> {
  @override
  Widget build(BuildContext context) {
    if (widget.container.singleImgUint8 == null)
      return InkWell(
          child: Container(
            margin: const EdgeInsets.all(5.0),
            child: Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
              child: Stack(
                children: <Widget>[
                  Center(
                      child:
                          Icon(Icons.camera_alt, color: Theme.of(context).accentColor, size: 48.0)),
                  if (widget.logo)
                    Center(
                      child: Container(
                          padding: EdgeInsets.all(3.0),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4.0),
                              color: Theme.of(context).accentColor),
                          child: Text(
                            'логотип',
                            softWrap: false,
                            overflow: TextOverflow.fade,
                            style: TextStyle(fontSize: 12.0, color: Colors.white),
                          )),
                    ),
                ],
              ),
            ),
          ),
          onTap: () async {
            var resultList = await showMultiImagePicker(context: context, maxImages: 1);
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
                  widget.container.singleImgUint8 = resultMap['uint8s'][0];
                });
              }
            }
          });
    else
      return Stack(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 10.0, right: 10.0),
            // decoration: BoxDecoration(borderRadius: BorderRadius.circular(5.0)),
            child: Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
              elevation: 3.0,
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(5.0),
                  child: PhotoFromUint8(widget.container.singleImgUint8, 200)),
            ),
          ),
          Positioned(
            top: -0.0,
            right: 0.0,
            child: InkWell(
              child: ClipOval(
                child: Container(
                    color: Colors.white,
                    child: Icon(Icons.cancel, color: Colors.black, size: 30.0)),
              ),
              onTap: () {
                setState(() {
                  widget.container.singleImgUint8 = null;
                });
              },
            ),
          ),
        ],
      );
  }
}
