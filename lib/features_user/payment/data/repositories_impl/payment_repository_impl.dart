import 'package:flutter/foundation.dart';

import '../../domain/entities/payment_entity.dart';

import '../../domain/repositories/payment_repository.dart';

import '../data_sources/payment_remote_data_source.dart';



class PaymentRepositoryImpl
    implements PaymentRepository {



  final PaymentRemoteDataSource remoteDataSource;



  PaymentRepositoryImpl(
      this.remoteDataSource,
      );



  @override
  Future<PaymentEntity> initializePayment({

    required int orderId,

    required int amount,

    required String description,

  }) async {


    try {


      debugPrint(
        "Repository Initialize Payment",
      );



      final payment =
      await remoteDataSource.initializePayment(

        orderId: orderId,

        amount: amount,

        description: description,

      );



      debugPrint(
        "Repository Success",
      );



      return payment;



    } catch(e, stackTrace) {


      debugPrint(
        "Repository Error:",
      );


      debugPrint(
        e.toString(),
      );


      debugPrint(
        stackTrace.toString(),
      );


      rethrow;

    }


  }


}