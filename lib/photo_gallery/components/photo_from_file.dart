import 'dart:io';
import 'package:flutter/material.dart';

class PhotoFromFile extends StatelessWidget {
  final File file;
  final double size;
  PhotoFromFile(this.file, this.size);
  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      margin: EdgeInsets.only(top: 8.0),
      child: FittedBox(fit: BoxFit.cover, child: Image.file(file)),
    );
  }
}
