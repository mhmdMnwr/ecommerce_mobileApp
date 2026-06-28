import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:ecommerce_app/l10n/app_localizations.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/nominatim_geocoder.dart';
import '../widgets/map_overlays.dart';

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
class MapPickerPage extends StatefulWidget {
  const MapPickerPage({super.key});

  @override
  State<MapPickerPage> createState() => _MapPickerPageState();
}

class _MapPickerPageState extends State<MapPickerPage> {
  static const _defaultCenter = LatLng(35.3978, 0.1403);

  final MapController _mapCtrl = MapController();
  LatLng _initialCenter = _defaultCenter;
  bool _mapReady = false;

  LatLng? _selectedPoint;
  String? _address;
  bool _loading = false;
  bool _locating = true;

  @override
  void initState() {
    super.initState();
    _detectUserLocation();
  }

  Future<void> _detectUserLocation() async {
    try {
      if (!await Geolocator.isLocationServiceEnabled()) {
        if (mounted) setState(() => _locating = false);
        return;
      }

      var perm = await Geolocator.checkPermission();
      if (perm == LocationPermission.denied) {
        perm = await Geolocator.requestPermission();
      }
      if (perm == LocationPermission.denied ||
          perm == LocationPermission.deniedForever) {
        if (mounted) setState(() => _locating = false);
        return;
      }

      final pos = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.medium,
          timeLimit: Duration(seconds: 10),
        ),
      );

      if (!mounted) return;
      final ll = LatLng(pos.latitude, pos.longitude);
      setState(() {
        _initialCenter = ll;
        _locating = false;
      });
      if (_mapReady) _mapCtrl.move(ll, 15);
    } catch (_) {
      if (mounted) setState(() => _locating = false);
    }
  }

  Future<void> _onMapTap(LatLng point) async {
    setState(() {
      _selectedPoint = point;
      _loading = true;
      _address = null;
    });

    final addr = await NominatimGeocoder.reverseGeocode(point);
    if (mounted) {
      setState(() {
        _address = addr;
        _loading = false;
      });
    }
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
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            size: 18.r,
            color: AppColors.textPrimary,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          AppLocalizations.of(context)!.selectLocation,
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18.sp),
        ),
        centerTitle: true,
        surfaceTintColor: Colors.transparent,
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
      ),
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapCtrl,
            options: MapOptions(
              initialCenter: _initialCenter,
              initialZoom: 13,
              onTap: (_, point) => _onMapTap(point),
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
                MarkerLayer(markers: [
                  Marker(
                    point: _selectedPoint!,
                    width: 40.r,
                    height: 40.r,
                    child: Icon(Icons.location_on,
                        color: AppColors.markerRed, size: 40.r),
                  ),
                ]),
            ],
          ),
          if (_locating)
            Positioned(
              top: 16.h,
              left: 0,
              right: 0,
              child: const MapLocatingChip(),
            ),
          if (!_locating && _selectedPoint == null)
            Positioned(
              top: 16.h,
              left: 0,
              right: 0,
              child: const MapInstructionChip(),
            ),
          if (_selectedPoint != null)
            Positioned(
              left: 16.w,
              right: 16.w,
              bottom: MediaQuery.of(context).padding.bottom + 16.h,
              child: MapAddressCard(
                isLoading: _loading,
                address: _address,
                onConfirm: (_loading || _selectedPoint == null)
                    ? null
                    : _confirmLocation,
              ),
            ),
        ],
      ),
    );
  }
}
