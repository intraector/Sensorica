import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ViewPhotoFromUrl extends StatelessWidget {
  final String url;
  final double size;
  ViewPhotoFromUrl(this.url, [this.size]);
  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      child: CachedNetworkImage(
        imageUrl: url,
        placeholder: (context, url) => SizedBox(
          width: size,
          height: size,
          child: Container(
            alignment: Alignment.center,
            width: 40,
            height: 40,
            child: CircularProgressIndicator(
              backgroundColor: Colors.white,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.grey),
            ),
          ),
        ),
        errorWidget: (context, url, error) => Icon(Icons.error),
        fit: BoxFit.cover,
      ),
    );
  }
}
