import 'package:flutter/material.dart';

Widget buildFileImage({
  required String path,
  required BoxFit fit,
  double? height,
  double? width,
}) {
  return Image.network(path, fit: fit, height: height, width: width);
}
