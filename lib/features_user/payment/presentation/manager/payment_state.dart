import 'package:equatable/equatable.dart';

import '../../domain/entities/payment_entity.dart';



abstract class PaymentState extends Equatable {


  const PaymentState();


  @override
  List<Object?> get props => [];

}




class PaymentInitial extends PaymentState {

  const PaymentInitial();

}




class PaymentLoading extends PaymentState {

  const PaymentLoading();

}




class PaymentReady extends PaymentState {


  final PaymentEntity payment;


  const PaymentReady(
      this.payment,
      );


  @override
  List<Object?> get props => [
    payment,
  ];

}




class PaymentError extends PaymentState {


  final String message;


  const PaymentError(
      this.message,
      );


  @override
  List<Object?> get props => [
    message,
  ];

}