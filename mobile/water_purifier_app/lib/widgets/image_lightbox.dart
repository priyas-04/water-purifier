import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ImageLightbox extends StatelessWidget {
  final String imageUrl;
  final String title;

  const ImageLightbox({
    super.key,
    required this.imageUrl,
    required this.title,
  });

  static void show(BuildContext context, String imageUrl, String title) {
    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        barrierDismissible: true,
        pageBuilder: (BuildContext context, _, __) {
          return ImageLightbox(imageUrl: imageUrl, title: title);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.92),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white, size: 28),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          title,
          style: const TextStyle(color: Colors.white, fontSize: 16),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      body: Center(
        child: InteractiveViewer(
          panEnabled: true,
          boundaryMargin: const EdgeInsets.all(20),
          minScale: 0.8,
          maxScale: 4.0,
          child: Hero(
            tag: imageUrl,
            child: CachedNetworkImage(
              imageUrl: imageUrl,
              fit: BoxFit.contain,
              placeholder: (context, url) => const CircularProgressIndicator(color: Colors.white),
              errorWidget: (context, url, error) => const Icon(Icons.broken_image, color: Colors.white54, size: 60),
            ),
          ),
        ),
      ),
    );
  }
}
