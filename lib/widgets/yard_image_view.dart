import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class YardImageView extends StatelessWidget {
  final String? imagePath;
  final BoxFit fit;
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;

  const YardImageView({
    super.key,
    required this.imagePath,
    this.fit = BoxFit.cover,
    this.width,
    this.height,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    Widget content;
    final path = imagePath?.trim() ?? '';

    if (path.isEmpty) {
      content = Container(
        width: width,
        height: height,
        color: const Color(0xFFE9F3EB),
        child: const Center(
          child: Icon(
            Icons.domain_rounded,
            size: 36,
            color: AppColors.primaryGreen,
          ),
        ),
      );
    } else if (path.startsWith('http://') || path.startsWith('https://')) {
      content = Image.network(
        path,
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (_, __, ___) => Container(
          width: width,
          height: height,
          color: const Color(0xFFE9F3EB),
          child: const Center(
            child: Icon(
              Icons.domain_rounded,
              size: 36,
              color: AppColors.primaryGreen,
            ),
          ),
        ),
      );
    } else {
      content = Image.asset(
        path,
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (_, __, ___) => Container(
          width: width,
          height: height,
          color: const Color(0xFFE9F3EB),
          child: const Center(
            child: Icon(
              Icons.domain_rounded,
              size: 36,
              color: AppColors.primaryGreen,
            ),
          ),
        ),
      );
    }

    if (borderRadius != null) {
      return ClipRRect(
        borderRadius: borderRadius!,
        child: content,
      );
    }
    return content;
  }
}
