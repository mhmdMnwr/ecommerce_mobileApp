import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// A widget that renders the complete app logo.
/// 
/// Since `flutter_svg` does not render base64 image patterns inside SVGs,
/// this widget overlays the extracted `app_icon.png` over the empty space
/// in `logo.svg` (which only renders the text paths).
class AppLogo extends StatelessWidget {
  final double height;
  final double width;

  const AppLogo({
    super.key,
    this.height = 100,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    // The original logo.svg is 584 x 147.
    // The image portion is approximately 168x147.
    final scale = width / 584;
    final imageHeight = 147 * scale;
    final imageWidth = 168 * scale;

    return SizedBox(
      width: width,
      height: imageHeight,
      child: Stack(
        alignment: Alignment.centerLeft,
        children: [
          // Renders the SVG text portion (image portion is transparent)
          SvgPicture.asset(
            'assets/icons/logo.svg',
            width: width,
            height: imageHeight,
            fit: BoxFit.contain,
          ),
          // Renders the extracted high-quality app icon in the transparent space
          Image.asset(
            'assets/images/app_icon.png',
            width: imageWidth,
            height: imageHeight,
            fit: BoxFit.contain,
          ),
        ],
      ),
    );
  }
}
