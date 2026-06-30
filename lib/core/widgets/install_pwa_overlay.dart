import 'package:flutter/material.dart';

import 'pwa_overlay/pwa_overlay_stub.dart'
    if (dart.library.html) 'pwa_overlay/pwa_overlay_web.dart';

class InstallPwaOverlay extends StatelessWidget {
  final Widget child;
  const InstallPwaOverlay({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return PwaOverlayWrapper(child: child);
  }
}
