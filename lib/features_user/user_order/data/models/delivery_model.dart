import '../../domain/entities/delivery_entity.dart';

class DeliveryModel extends DeliveryEntity {
  const DeliveryModel({
    required super.from,
    required super.to,
  });

  factory DeliveryModel.fromJson(Map<String, dynamic> json) {
    return DeliveryModel(
      from: json['from'] ?? '',
      to: json['to'] ?? '',
    );
  }

  factory DeliveryModel.fromEntity(DeliveryEntity entity) {
    return DeliveryModel(
      from: entity.from,
      to: entity.to,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'from': from,
      'to': to,
    };
  }
}