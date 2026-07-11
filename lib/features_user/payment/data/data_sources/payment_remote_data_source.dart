import 'package:flutter/foundation.dart';

import '../models/payment_model.dart';



abstract class PaymentRemoteDataSource {


  Future<PaymentModel> initializePayment({

    required int orderId,

    required int amount,

    required String description,

  });


}



class PaymentRemoteDataSourceImpl
    implements PaymentRemoteDataSource {



  @override
  Future<PaymentModel> initializePayment({

    required int orderId,

    required int amount,

    required String description,

  }) async {


    try {


      debugPrint(
        "Payment Remote Data Source Started",
      );


      debugPrint(
        "Order ID: $orderId",
      );


      debugPrint(
        "Amount: $amount",
      );


      debugPrint(
        "Description: $description",
      );



      final payment = PaymentModel(

        orderId: orderId,

        amount: amount,

        description: description,

      );



      debugPrint(
        "Payment Data Created Successfully",
      );



      return payment;



    } catch (e, stackTrace) {


      debugPrint(
          "Remote Data Source Error:"
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