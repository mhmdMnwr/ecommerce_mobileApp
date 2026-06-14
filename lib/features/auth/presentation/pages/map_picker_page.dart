import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_button.dart';

/// Result returned by the [MapPickerPage].
class MapPickerResult {
  final double latitude;
  final double longitude;
  final String? address;

  const MapPickerResult({
    required this.latitude,
    required this.longitude,
    this.address,
  });
}

/// Full-screen OpenStreetMap picker.
///
/// Opens on the user's current location if GPS is available,
/// otherwise defaults to Mascara, Algeria.
class MapPickerPage extends StatefulWidget {
  const MapPickerPage({super.key});

  @override
  State<MapPickerPage> createState() => _MapPickerPageState();
}

class _MapPickerPageState extends State<MapPickerPage> {
  // Fallback: Mascara, Algeria
  static const _mascaraCenter = LatLng(35.3978, 0.1403);

  final MapController _mapController = MapController();
  LatLng _initialCenter = _mascaraCenter;
  bool _mapReady = false;

  LatLng? _selectedPoint;
  String? _address;
  bool _loading = false;
  bool _locating = true; // true while detecting user position

  @override
  void initState() {
    super.initState();
    _detectUserLocation();
  }

  // ── Get user's current location ─────────────────

  Future<void> _detectUserLocation() async {
    try {
      // Check if location services are enabled
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        if (mounted) setState(() => _locating = false);
        return;
      }

      // Check / request permission
      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied ||
            permission == LocationPermission.deniedForever) {
          if (mounted) setState(() => _locating = false);
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        if (mounted) setState(() => _locating = false);
        return;
      }

      // Get current position
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.medium,
          timeLimit: Duration(seconds: 10),
        ),
      );

      if (!mounted) return;
      final userLatLng = LatLng(position.latitude, position.longitude);

      setState(() {
        _initialCenter = userLatLng;
        _locating = false;
      });

      // Move map to user location if map is already built
      if (_mapReady) {
        _mapController.move(userLatLng, 15);
      }
    } catch (_) {
      // Any failure → stay on Mascara
      if (mounted) setState(() => _locating = false);
    }
  }

  // ── Reverse geocode via Nominatim ────────────────

  Future<void> _reverseGeocode(LatLng point) async {
    setState(() {
      _selectedPoint = point;
      _loading = true;
      _address = null;
    });

    try {
      final dio = Dio();
      final res = await dio.get(
        'https://nominatim.openstreetmap.org/reverse',
        queryParameters: {
          'format': 'json',
          'lat': point.latitude.toString(),
          'lon': point.longitude.toString(),
          'zoom': '18',
          'addressdetails': '1',
        },
        options: Options(headers: {
          'User-Agent': 'EcommerceFlutterApp/1.0',
          'Accept': 'application/json',
        }),
      );

      if (!mounted) return;
      final data = res.data;
      if (data is Map<String, dynamic>) {
        setState(() => _address = _formatAddress(data));
      } else {
        _setFallbackAddress(point);
      }
    } catch (_) {
      if (!mounted) return;
      _setFallbackAddress(point);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  /// Extracts a clean street + city address from Nominatim's response.
  String _formatAddress(Map<String, dynamic> data) {
    final addr = data['address'];
    if (addr is! Map<String, dynamic>) {
      return (data['display_name'] as String?) ?? '';
    }

    final parts = <String>[];

    // Street part
    final houseNumber = addr['house_number'] as String?;
    final road = addr['road'] ?? addr['pedestrian'] ?? addr['street'];
    if (road != null) {
      parts.add(houseNumber != null ? '$houseNumber $road' : road as String);
    }

    // Neighbourhood / suburb
    final neighbourhood = addr['neighbourhood'] ??
        addr['suburb'] ??
        addr['quarter'] ??
        addr['hamlet'];
    if (neighbourhood != null) parts.add(neighbourhood as String);

    // City / town / village
    final city = addr['city'] ??
        addr['town'] ??
        addr['village'] ??
        addr['municipality'];
    if (city != null) parts.add(city as String);

    if (city == null) {
      final state = addr['state'] as String?;
      if (state != null) parts.add(state);
    }

    if (parts.isEmpty) {
      return (data['display_name'] as String?) ?? '';
    }

    return parts.join(', ');
  }

  void _setFallbackAddress(LatLng point) {
    setState(() => _address =
        '${point.latitude.toStringAsFixed(5)}, ${point.longitude.toStringAsFixed(5)}');
  }

  void _confirmLocation() {
    if (_selectedPoint == null) return;
    Navigator.of(context).pop(MapPickerResult(
      latitude: _selectedPoint!.latitude,
      longitude: _selectedPoint!.longitude,
      address: _address,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Select Location',
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18.sp),
        ),
        centerTitle: true,
        surfaceTintColor: Colors.transparent,
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.primary,
        elevation: 0,
      ),
      body: Stack(
        children: [
          // ── Map ──────────────────────────────────
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _initialCenter,
              initialZoom: 13,
              onTap: (_, point) => _reverseGeocode(point),
              onMapReady: () => _mapReady = true,
            ),
            children: [
              TileLayer(
                urlTemplate:
                    'https://{s}.tile.openstreetmap.fr/osmfr/{z}/{x}/{y}.png',
                subdomains: const ['a', 'b', 'c'],
                userAgentPackageName: 'com.ecommerce.app',
              ),
              if (_selectedPoint != null)
                MarkerLayer(
                  markers: [
                    Marker(
                      point: _selectedPoint!,
                      width: 40.r,
                      height: 40.r,
                      child: Icon(
                        Icons.location_on,
                        color: AppColors.markerRed,
                        size: 40.r,
                      ),
                    ),
                  ],
                ),
            ],
          ),

          // ── Locating spinner ─────────────────────
          if (_locating)
            Positioned(
              top: 16.h,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: 20.w, vertical: 10.h),
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(24.r),
                    boxShadow: const [
                      BoxShadow(
                        color: AppColors.shadow,
                        blurRadius: 10,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: 16.r,
                        height: 16.r,
                        child: const CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppColors.primary,
                        ),
                      ),
                      SizedBox(width: 10.w),
                      Text(
                        'Detecting your location...',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textMuted,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

          // ── Instruction chip ─────────────────────
          if (!_locating && _selectedPoint == null)
            Positioned(
              top: 16.h,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: 20.w, vertical: 10.h),
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(24.r),
                    boxShadow: const [
                      BoxShadow(
                        color: AppColors.shadow,
                        blurRadius: 10,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Text(
                    'Tap on the map to select your location',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textMuted,
                    ),
                  ),
                ),
              ),
            ),

          // ── Bottom address card ──────────────────
          if (_selectedPoint != null)
            Positioned(
              left: 16.w,
              right: 16.w,
              bottom: MediaQuery.of(context).padding.bottom + 16.h,
              child: Container(
                padding: EdgeInsets.all(20.r),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(16.r),
                  boxShadow: const [
                    BoxShadow(
                      color: AppColors.shadowMedium,
                      blurRadius: 20,
                      offset: Offset(0, -2),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.location_on,
                            color: AppColors.markerRed, size: 20.r),
                        SizedBox(width: 8.w),
                        Text(
                          'Selected Location',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 15.sp,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10.h),
                    if (_loading)
                      Center(
                        child: SizedBox(
                          width: 20.r,
                          height: 20.r,
                          child: const CircularProgressIndicator(
                              strokeWidth: 2),
                        ),
                      )
                    else
                      Text(
                        _address ?? '',
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: AppColors.textBody,
                          height: 1.4,
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    SizedBox(height: 16.h),
                    AppButton(
                      text: 'Confirm Location',
                      height: 48.h,
                      onPressed: (_loading || _selectedPoint == null)
                          ? null
                          : _confirmLocation,
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
