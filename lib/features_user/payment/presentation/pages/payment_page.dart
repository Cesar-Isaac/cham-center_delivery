import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moyasar/moyasar.dart';

import '../manager/payment_cubit.dart';
import '../manager/payment_state.dart';


class PaymentPage extends StatelessWidget {

  final int orderId;

  final int amount;


  const PaymentPage({

    super.key,

    required this.orderId,

    required this.amount,

  });


  static const route = '/payment';



  @override
  Widget build(BuildContext context) {


    WidgetsBinding.instance.addPostFrameCallback((_) {


      final cubit = context.read<PaymentCubit>();


      if (cubit.state is PaymentInitial) {

        cubit.initializePayment(

          orderId: orderId,

          amount: amount,

          description: "Order $orderId",

        );

      }


    });



    return Theme(
        data: ThemeData.light(),
    child:  Scaffold(

      appBar: AppBar(

        title: const Text(
          "الدفع",
        ),

      ),


      body: BlocConsumer<PaymentCubit, PaymentState>(


        listener: (context, state) {


          debugPrint(
            "CURRENT STATE : $state",
          );


          if (state is PaymentError) {


            debugPrint(
              state.message,
            );


          }


        },



        builder: (context, state) {



          if (state is PaymentLoading) {


            return const Center(

              child: CircularProgressIndicator(),

            );


          }



          if (state is PaymentReady) {


            debugPrint(
              "Opening Moyasar Widget",
            );



            final config = PaymentConfig(


              publishableApiKey:
              'pk_test_H4KvysgniSLP5URjTAmv7BNXKTcjmRMt3Yk5UyD6',


              amount:
              state.payment.amount,


              description:
              state.payment.description,


              currency:
              'USD',


            );



            return CreditCard(

              config: config,


              onPaymentResult: (result) {

                debugPrint("Payment Result");


                if (result is PaymentResponse) {


                  if (result.status == PaymentStatus.paid) {


                    debugPrint("PAYMENT SUCCESS");


                    ScaffoldMessenger.of(context).showSnackBar(

                      const SnackBar(


                        content: Text(
                          "تم الدفع بنجاح",
                        ),

                        backgroundColor: Colors.green,
                        behavior: SnackBarBehavior.floating,


                        duration: const Duration(
                          seconds: 2,
                        ),



                      ),


                    );


                    Future.delayed(
                      const Duration(seconds: 1),
                          () {


                      },
                    );


                  } else {


                    debugPrint("PAYMENT FAILED");


                    ScaffoldMessenger.of(context).showSnackBar(

                      const SnackBar(

                        content: Text(
                          "حدث خطأ أثناء الدفع",
                        ),

                        backgroundColor: Colors.red,

                      ),

                    );


                  }


                }

              },

            );


          }



          if (state is PaymentError) {


            return Center(

              child: Text(
                state.message,
              ),

            );


          }



          return const Center(

            child: Text(
              "Preparing Payment...",
            ),

          );


        },


      ),

    ));


  }

}