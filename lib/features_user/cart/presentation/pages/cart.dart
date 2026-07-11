import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/style/widgets/custom_bottom.dart';
import '../../../payment/presentation/pages/Payment_options.dart';
import '../../../payment/presentation/pages/payment_page.dart';
import '../manager/cart_cubit.dart';
import '../manager/cart_state.dart';
import '../widgets/cart_card.dart';

class Cart extends StatelessWidget {
  const Cart({super.key});
  static const route = '/cart';
  @override
  Widget build(BuildContext context) {
    final cubit = context.read<CartCubit>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Cart"),
        actions: [
          IconButton(
           // onPressed: cubit.clearCart,
            onPressed: (){
              Navigator.pushNamed(
                context,
                PaymentOptions.route,
              );
            },
            icon: const Icon(Icons.delete_forever),
          )
        ],
      ),
      body: BlocBuilder<CartCubit, CartState>(
        builder: (context, state) {
          if (state.items.isEmpty) {
            return const Center(
              child: Text("Cart is empty"),
            );
          }

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: state.items.length,
                  itemBuilder: (context, index) {
                    final item = state.items[index];

                    return CartCard(
                      item: item,
                      onIncrease: () =>
                          cubit.increaseQuantity(item.product.id),
                      onDecrease: () =>
                          cubit.decreaseQuantity(item.product.id),
                      onDelete: () =>
                          cubit.deleteProduct(item.product.id),
                    );
                  },
                ),
              ),

              // Total Section
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Items: ${state.totalItems}",
                      style: const TextStyle(fontSize: 16),
                    ),
                    Text(
                      "Total: ${state.totalPrice.toStringAsFixed(2)}",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              CustomButton(text: 'Pay', onPressed: () {  },),
            ],
          );
        },
      ),
    );
  }
}