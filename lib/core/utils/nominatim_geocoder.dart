import 'package:dio/dio.dart';
import 'package:latlong2/latlong.dart';

/// Reverse-geocodes a [LatLng] point using the Nominatim API.
///
/// Returns a human-readable address string, or falls back to
/// raw coordinates on failure.
class NominatimGeocoder {
  const NominatimGeocoder._();

  /// Returns a formatted address for the given [point].
  static Future<String> reverseGeocode(LatLng point) async {
    try {
      final res = await Dio().get(
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

      final data = res.data;
      if (data is Map<String, dynamic>) {
        return _formatAddress(data);
      }
    } catch (_) {
      // Fall through to raw coordinates
    }
    return _fallback(point);
  }

  static String _formatAddress(Map<String, dynamic> data) {
    final addr = data['address'];
    if (addr is! Map<String, dynamic>) {
      return (data['display_name'] as String?) ?? '';
    }

    final parts = <String>[];
    final houseNumber = addr['house_number'] as String?;
    final road = addr['road'] ?? addr['pedestrian'] ?? addr['street'];
    if (road != null) {
      parts.add(houseNumber != null ? '$houseNumber $road' : road as String);
    }

    final neighbourhood = addr['neighbourhood'] ??
        addr['suburb'] ??
        addr['quarter'] ??
        addr['hamlet'];
    if (neighbourhood != null) parts.add(neighbourhood as String);

    final city = addr['city'] ??
        addr['town'] ??
        addr['village'] ??
        addr['municipality'];
    if (city != null) parts.add(city as String);

    if (city == null) {
      final state = addr['state'] as String?;
      if (state != null) parts.add(state);
    }

    return parts.isEmpty
        ? ((data['display_name'] as String?) ?? '')
        : parts.join(', ');
  }

  static String _fallback(LatLng point) =>
      '${point.latitude.toStringAsFixed(5)}, '
      '${point.longitude.toStringAsFixed(5)}';
}
