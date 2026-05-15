import 'package:flutter/material.dart';

import 'adaptive_image_io.dart'
    if (dart.library.html) 'adaptive_image_web.dart';

class AdaptiveImage extends StatelessWidget {
  final String path;
  final BoxFit fit;
  final double? height;
  final double? width;

  const AdaptiveImage({
    super.key,
    required this.path,
    this.fit = BoxFit.contain,
    this.height,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    if (path.isEmpty) {
      return const SizedBox.shrink();
    }

    if (_isAssetPath(path)) {
      return Image.asset(path, fit: fit, height: height, width: width);
    }

    return buildFileImage(path: path, fit: fit, height: height, width: width);
  }

  bool _isAssetPath(String value) {
    return value.startsWith('assets/');
  }
}
