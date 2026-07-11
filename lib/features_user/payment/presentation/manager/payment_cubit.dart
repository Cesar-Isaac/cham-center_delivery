import 'package:flutter/foundation.dart';

import 'package:flutter_bloc/flutter_bloc.dart';



import '../../domain/usecases/payment_usecase.dart';
import 'payment_state.dart';



class PaymentCubit extends Cubit<PaymentState> {


  final InitializePaymentUseCase initializePaymentUseCase;



  PaymentCubit(
      this.initializePaymentUseCase,
      )
      : super(
    const PaymentInitial(),
  );



  Future<void> initializePayment({

    required int orderId,

    required int amount,

    required String description,

  }) async {


    try {


      debugPrint(
        "========================",
      );


      debugPrint(
        "Payment Cubit Started",
      );


      emit(
        const PaymentLoading(),
      );



      final payment =
      await initializePaymentUseCase(

        orderId: orderId,

        amount: amount,

        description: description,

      );



      debugPrint(
        "Payment Entity Created",
      );


      debugPrint(
        "Order ID : ${payment.orderId}",
      );


      debugPrint(
        "Amount : ${payment.amount}",
      );



      emit(
        PaymentReady(payment),
      );



    } catch(e, stackTrace) {


      debugPrint(
        "========= PAYMENT ERROR =========",
      );


      debugPrint(
        e.toString(),
      );


      debugPrint(
        stackTrace.toString(),
      );



      emit(
        PaymentError(
          e.toString(),
        ),
      );

    }


  }


}