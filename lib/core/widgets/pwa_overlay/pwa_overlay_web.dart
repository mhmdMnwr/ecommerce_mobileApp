import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

class PwaOverlayWrapper extends StatefulWidget {
  final Widget child;
  const PwaOverlayWrapper({super.key, required this.child});

  @override
  State<PwaOverlayWrapper> createState() => _PwaOverlayWrapperState();
}

class _PwaOverlayWrapperState extends State<PwaOverlayWrapper> {
  bool _showOverlay = false;

  @override
  void initState() {
    super.initState();
    _checkShowOverlay();
  }

  Future<void> _checkShowOverlay() async {
    try {
      final userAgent = html.window.navigator.userAgent.toLowerCase();
      final isIos = userAgent.contains('iphone') || userAgent.contains('ipad') || userAgent.contains('ipod');
      final isSafari = userAgent.contains('safari') && !userAgent.contains('chrome') && !userAgent.contains('crios');
      
      final isStandalone = html.window.matchMedia('(display-mode: standalone)').matches;
      final dynamic nav = html.window.navigator;
      final isIosStandalone = nav.standalone == true;

      if (isIos && isSafari && !isStandalone && !isIosStandalone) {
        final prefs = await SharedPreferences.getInstance();
        final hasDismissed = prefs.getBool('pwa_overlay_dismissed') ?? false;
        
        if (!hasDismissed) {
          setState(() {
            _showOverlay = true;
          });
        }
      }
    } catch (e) {
      // Ignore
    }
  }

  Future<void> _dismiss() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('pwa_overlay_dismissed', true);
    setState(() {
      _showOverlay = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        if (_showOverlay)
          Positioned(
            bottom: 32,
            left: 16,
            right: 16,
            child: Material(
              color: Colors.transparent,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.apple, size: 40),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                'Install App',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Install this app on your iPhone: tap the Share button below, then "Add to Home Screen".',
                                style: TextStyle(fontSize: 14),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          onPressed: _dismiss,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Icon(Icons.ios_share, color: Colors.blue, size: 28),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}
