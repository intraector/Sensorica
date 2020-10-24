import 'dart:typed_data';
import 'package:flutter/material.dart';

class PhotoFromUint8 extends StatelessWidget {
  final Uint8List photoUint8;
  final double size;
  PhotoFromUint8(this.photoUint8, this.size);
  @override
  Widget build(BuildContext context) => SizedBox(
        width: size,
        height: size,
        child: FittedBox(fit: BoxFit.cover, child: Image.memory(photoUint8)),
      );
}
