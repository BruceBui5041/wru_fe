import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:wru_fe/global_constants.dart';
import 'package:wru_fe/hive_config.dart';

class CustomCachedImage extends StatelessWidget {
  CustomCachedImage({Key? key, required this.imageUrl}) : super(key: key);
  final String? imageUrl;

  final _hiveConfig = getIt<HiveConfig>();

  @override
  Widget build(BuildContext context) {
    String token = _hiveConfig.storeBox!.get(ACCESS_TOKEN_KEY);

    return imageUrl == null
        ? Image.asset('assets/images/image_placeholder.png')
        : CachedNetworkImage(
            imageUrl: imageUrl.toString(),
            httpHeaders: {"Authorization": "Bearer $token"},
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
