import '../../domain/entities/delivery_entity.dart';

class DeliveryModel extends DeliveryEntity {
  const DeliveryModel({
    required super.from,
    required super.to,
    required super.fromLatitude,
    required super.fromLongitude,
    required super.toLatitude,
    required super.toLongitude,
  });

  factory DeliveryModel.fromEntity(
      DeliveryEntity entity,
      ) {
    return DeliveryModel(
      from: entity.from,
      to: entity.to,
      fromLatitude: entity.fromLatitude,
      fromLongitude: entity.fromLongitude,
      toLatitude: entity.toLatitude,
      toLongitude: entity.toLongitude,
    );
  }

  factory DeliveryModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return DeliveryModel(
      from: json['from']?.toString() ?? '',
      to: json['to']?.toString() ?? '',
      fromLatitude:
      (json['fromLatitude'] as num? ?? 0).toDouble(),
      fromLongitude:
      (json['fromLongitude'] as num? ?? 0).toDouble(),
      toLatitude:
      (json['toLatitude'] as num? ?? 0).toDouble(),
      toLongitude:
      (json['toLongitude'] as num? ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'from': from,
      'to': to,
      'fromLatitude': fromLatitude,
      'fromLongitude': fromLongitude,
      'toLatitude': toLatitude,
      'toLongitude': toLongitude,
    };
  }
}