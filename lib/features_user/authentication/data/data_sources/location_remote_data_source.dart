import 'dart:convert';

import 'package:http/http.dart' as http;

abstract class LocationRemoteDataSource {
  Future<String> getAddressFromCoordinates({
    required double latitude,
    required double longitude,
  });
}

class LocationRemoteDataSourceImpl
    implements LocationRemoteDataSource {
  LocationRemoteDataSourceImpl({
    required this.client,
  });

  final http.Client client;

  @override
  Future<String> getAddressFromCoordinates({
    required double latitude,
    required double longitude,
  }) async {
    final Uri uri = Uri.https(
      'nominatim.openstreetmap.org',
      '/reverse',
      {
        'format': 'jsonv2',
        'lat': latitude.toString(),
        'lon': longitude.toString(),
        'addressdetails': '1',
        'accept-language': 'ar,en',
      },
    );

    final http.Response response = await client.get(
      uri,
      headers: const {
        'User-Agent':
        'tracking_provider/1.0 '
            '(com.example.tracking_provider)',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode != 200) {
      throw Exception(
        'Reverse geocoding failed: ${response.statusCode}',
      );
    }

    final Map<String, dynamic> json =
    jsonDecode(response.body) as Map<String, dynamic>;

    final String? displayName =
    json['display_name'] as String?;

    if (displayName != null &&
        displayName.trim().isNotEmpty) {
      return displayName.trim();
    }

    final Map<String, dynamic>? address =
    json['address'] as Map<String, dynamic>?;

    if (address == null) {
      return 'Selected location';
    }

    return _buildAddress(address);
  }

  String _buildAddress(
      Map<String, dynamic> address,
      ) {
    final List<String?> parts = [
      address['road'] as String?,
      address['neighbourhood'] as String?,
      address['suburb'] as String?,
      address['city'] as String?,
      address['town'] as String?,
      address['village'] as String?,
      address['state'] as String?,
      address['country'] as String?,
    ];

    final List<String> result = [];

    for (final String? part in parts) {
      final String value = part?.trim() ?? '';

      if (value.isNotEmpty &&
          !result.contains(value)) {
        result.add(value);
      }
    }

    if (result.isEmpty) {
      return 'Selected location';
    }

    return result.join(', ');
  }
}