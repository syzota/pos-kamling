import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';

class AppShimmerImage extends StatelessWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius? borderRadius;

  const AppShimmerImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final image = FancyShimmerImage(
      imageUrl: imageUrl, // pakai imageUrl (aman untuk versi umum)
      width: width ?? double.infinity,
      height: height ?? 200,
      boxFit: fit,
      shimmerBaseColor: Colors.grey.shade300,
      shimmerHighlightColor: Colors.grey.shade100,
      shimmerBackColor: Colors.grey.shade200,
      errorWidget: const Center(
        child: Icon(Icons.broken_image_outlined, size: 40, color: Colors.grey),
      ),
    );

    if (borderRadius == null) return image;

    return ClipRRect(borderRadius: borderRadius!, child: image);
  }
}
