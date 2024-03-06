import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/painting.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

String generateMapFileName() {
  return "map_${DateTime.now().millisecondsSinceEpoch}.jpg";
}

Future<Uint8List> getCompressedUint8ListFromImageProvider(
    ImageProvider imageProvider) async {
  Completer<ui.Image> completer = Completer<ui.Image>();

  // Using late keyword to declare that the listener will be definitely initialized.
  late ImageStreamListener listener;

  listener = ImageStreamListener((ImageInfo info, bool _) {
    completer.complete(info.image);
    // Remove the listener when the image is loaded.
    imageProvider.resolve(const ImageConfiguration()).removeListener(listener);
  }, onError: (dynamic exception, StackTrace? stackTrace) {
    completer.completeError(exception, stackTrace);
    // Remove the listener in case of an error.
    imageProvider.resolve(const ImageConfiguration()).removeListener(listener);
  });

  imageProvider.resolve(const ImageConfiguration()).addListener(listener);

  final ui.Image uiImage = await completer.future;

  final ByteData? byteData =
      await uiImage.toByteData(format: ui.ImageByteFormat.png);

  final Uint8List? pngBytes = byteData?.buffer.asUint8List();

  return await FlutterImageCompress.compressWithList(
    pngBytes!,
    quality: 10,
  );
}
