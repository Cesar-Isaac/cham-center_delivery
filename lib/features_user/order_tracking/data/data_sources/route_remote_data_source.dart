import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/route_point_model.dart';

abstract class RouteRemoteDataSource {
  Future<List<RoutePointModel>> getRoute({
    required double startLatitude,
    required double startLongitude,
    required double endLatitude,
    required double endLongitude,
  });
}

class RouteRemoteDataSourceImpl
    implements RouteRemoteDataSource {
  final http.Client client;

  RouteRemoteDataSourceImpl(this.client);

  static const String _baseUrl =
      'https://router.project-osrm.org';

  @override
  Future<List<RoutePointModel>> getRoute({
    required double startLatitude,
    required double startLongitude,
    required double endLatitude,
    required double endLongitude,
  }) async {
    final uri = Uri.parse(
      '$_baseUrl/route/v1/driving/'
          '$startLongitude,$startLatitude;'
          '$endLongitude,$endLatitude',
    ).replace(
      queryParameters: {
        'overview': 'full',
        'geometries': 'geojson',
        'steps': 'false',
      },
    );

    final response = await client.get(
      uri,
      headers: {
        'Accept': 'application/json',
        'User-Agent':
        'com.example.tracking_provider',
      },
    ).timeout(
      const Duration(seconds: 15),
      onTimeout: () {
        throw Exception(
          'انتهت مهلة الاتصال بخدمة المسار.',
        );
      },
    );

    if (response.statusCode != 200) {
      throw Exception(
        'فشل تحميل المسار. '
            'رمز الخطأ: ${response.statusCode}',
      );
    }

    final decodedBody = jsonDecode(response.body);

    if (decodedBody is! Map<String, dynamic>) {
      throw const FormatException(
        'صيغة استجابة المسار غير صحيحة.',
      );
    }

    final code = decodedBody['code'];

    if (code != 'Ok') {
      final message =
          decodedBody['message']?.toString() ??
              'لم يتم العثور على مسار مناسب.';

      throw Exception(message);
    }

    final routes = decodedBody['routes'];

    if (routes is! List || routes.isEmpty) {
      throw Exception(
        'لم يتم العثور على طريق بين الموقعين.',
      );
    }

    final firstRoute = routes.first;

    if (firstRoute is! Map) {
      throw const FormatException(
        'بيانات الطريق غير صحيحة.',
      );
    }

    final routeMap = Map<String, dynamic>.from(
      firstRoute,
    );

    final geometry = routeMap['geometry'];

    if (geometry is! Map) {
      throw const FormatException(
        'بيانات خط الطريق غير موجودة.',
      );
    }

    final geometryMap = Map<String, dynamic>.from(
      geometry,
    );

    final coordinates = geometryMap['coordinates'];

    if (coordinates is! List || coordinates.isEmpty) {
      throw Exception(
        'نقاط مسار التوصيل غير متوفرة.',
      );
    }

    return coordinates.map((coordinate) {
      if (coordinate is! List) {
        throw const FormatException(
          'إحدى نقاط المسار غير صحيحة.',
        );
      }

      return RoutePointModel.fromOsrmCoordinates(
        coordinate,
      );
    }).toList();
  }
}