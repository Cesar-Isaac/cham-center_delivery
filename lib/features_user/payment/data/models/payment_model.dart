import '../../domain/entities/payment_entity.dart';


class PaymentModel extends PaymentEntity {


  const PaymentModel({

    required super.orderId,

    required super.amount,

    required super.description,

  });



  factory PaymentModel.fromEntity(
      PaymentEntity entity,
      ) {

    return PaymentModel(

      orderId: entity.orderId,

      amount: entity.amount,

      description: entity.description,

    );

  }


}