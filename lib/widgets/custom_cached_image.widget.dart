import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CustomCachedImage extends StatelessWidget {
  const CustomCachedImage({Key? key, required this.imageUrl}) : super(key: key);
  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    return imageUrl == null
        ? Image.asset('assets/images/image_placeholder.png')
        : CachedNetworkImage(
            imageUrl: imageUrl.toString(),
            // httpHeaders: ,
            fit: BoxFit.cover,
            progressIndicatorBuilder: (context, url, downloadProgress) =>
                Center(
              child: CircularProgressIndicator(
                strokeWidth: 1.5,
                value: downloadProgress.totalSize != null
                    ? downloadProgress.downloaded / downloadProgress.totalSize!
                    : null,
              ),
            ),
            errorWidget: (context, url, error) => const Center(
              child: Icon(
                Icons.error,
              ),
            ),
          );
  }
}
