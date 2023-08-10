import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ImageLoadingService extends StatelessWidget {
  final String imageUrl;
  final BorderRadius? borderRadius;
  const ImageLoadingService(
      {Key? key, required this.imageUrl, this.borderRadius})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final image = CachedNetworkImage(
      imageUrl: imageUrl,
      fit: BoxFit.cover,
    );

    if (borderRadius != null) {
      return ClipRRect(borderRadius: borderRadius, child: image);
    } else {
      return image;
    }
  }
}
