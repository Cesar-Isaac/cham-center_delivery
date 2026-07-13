import '../../domain/entities/driver_entity.dart';

class DriverModel extends DriverEntity {

  const DriverModel({
    required super.id,
    required super.name,
    required super.phone,
  });


  factory DriverModel.fromJson(
      Map<String, dynamic> json,
      ) {

    return DriverModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
    );

  }

  factory DriverModel.fromEntity(DriverEntity entity) {
    return DriverModel(
      id: entity.id,
      name: entity.name,
      phone: entity.phone,
    );
  }


  Map<String, dynamic> toJson() {

    return {
      'id': id,
      'name': name,
      'phone': phone,
    };

  }

}
