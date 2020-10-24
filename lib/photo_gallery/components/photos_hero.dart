import 'package:Sensorica/photo_gallery/components/photo_from_url.dart';
import 'package:flutter/material.dart';
import '../dialog_show_gallery.dart';

class PhotosHero extends StatelessWidget {
  PhotosHero(this.urls);
  final List<String> urls;
  @override
  Widget build(BuildContext context) {
    if (urls.length == 0) return Container();
    return InkWell(
      child: Stack(
        children: <Widget>[
          AspectRatio(aspectRatio: 1.0, child: ViewPhotoFromUrl(urls[0])),
          if (urls.length > 1)
            Positioned(
              top: 10.0,
              right: 10.0,
              child: Container(
                color: Theme.of(context).accentColor.withOpacity(0.8),
                padding: EdgeInsets.all(5.0),
                child: Text(
                  '${urls.length.toString()} фото',
                  style: TextStyle(fontSize: 15, color: Colors.white),
                ),
              ),
            ),
        ],
      ),
      onTap: () => dialogShowGallery(context, urls: urls),
    );
  }
}
