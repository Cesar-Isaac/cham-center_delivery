import '../entities/payment_entity.dart';
import '../repositories/payment_repository.dart';


class InitializePaymentUseCase {


  final PaymentRepository repository;


  InitializePaymentUseCase(
      this.repository,
      );


  Future<PaymentEntity> call({

    required int orderId,

    required int amount,

    required String description,

  }) async {


    return await repository.initializePayment(

      orderId: orderId,

      amount: amount,

      description: description,

    );

  }

}