import 'package:flutter/material.dart';

/// Widget to display the official OdoTrack logo.
///
/// Uses the official asset image matching the Figma design.
class OdoTrackLogo extends StatelessWidget {
  final double size;
  final double? width;
  final double? height;
  final bool emblemOnly;

  const OdoTrackLogo({
    super.key,
    this.size = 190,
    this.width,
    this.height,
    this.emblemOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    final assetPath = emblemOnly
        ? 'assets/images/odotrack_emblem.png'
        : 'assets/images/odotrack_logo.png';

    return Image.asset(
      assetPath,
      width: width ?? size,
      height: height,
      fit: BoxFit.contain,
    );
  }
}
