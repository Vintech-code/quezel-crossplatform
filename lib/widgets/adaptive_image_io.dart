import 'dart:io';

import 'package:flutter/material.dart';

Widget buildFileImage({
  required String path,
  required BoxFit fit,
  double? height,
  double? width,
}) {
  if (path.startsWith('http://') || path.startsWith('https://')) {
    return Image.network(path, fit: fit, height: height, width: width);
  }

  return Image.file(File(path), fit: fit, height: height, width: width);
}
