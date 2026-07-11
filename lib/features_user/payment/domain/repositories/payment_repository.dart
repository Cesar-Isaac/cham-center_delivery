import '../entities/payment_entity.dart';


abstract class PaymentRepository {


  Future<PaymentEntity> initializePayment({

    required int orderId,

    required int amount,

    required String description,

  });


}