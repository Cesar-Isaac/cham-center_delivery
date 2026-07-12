import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/style/widgets/custom_bottom.dart';
import '../../../payment/presentation/pages/Payment_options.dart';
import '../manager/cart_cubit.dart';
import '../manager/cart_state.dart';
import '../widgets/cart_card.dart';

class Cart extends StatelessWidget {
  const Cart({super.key});

  static const String route = '/cart';

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CartCubit, CartState>(
      listenWhen: (previous, current) {
        return previous.error != current.error &&
            current.error != null;
      },
      listener: (context, state) {
        if (state.error == null) return;

        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(
              content: Text(state.error!),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
            ),
          );
      },
      builder: (context, state) {
        final cartCubit = context.read<CartCubit>();

        return Scaffold(
          appBar: AppBar(
            title: const Text('Cart'),
            actions: [
              IconButton(
                tooltip: 'Clear cart',
                onPressed: state.items.isEmpty || state.loading
                    ? null
                    : () => _showClearCartDialog(
                  context,
                  cartCubit,
                ),
                icon: const Icon(Icons.delete_forever),
              ),
            ],
          ),
          body: state.items.isEmpty
              ? const _EmptyCart()
              : Column(
            children: [
              Expanded(
                child: Stack(
                  children: [
                    ListView.separated(
                      padding: const EdgeInsets.all(16),
                      itemCount: state.items.length,
                      separatorBuilder: (_, __) =>
                      const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final item = state.items[index];

                        return CartCard(
                          item: item,
                          onIncrease: () {
                            if (state.loading) return;

                            cartCubit.increaseQuantity(
                              item.product.id,
                            );
                          },
                          onDecrease: () {
                            if (state.loading) return;

                            cartCubit.decreaseQuantity(
                              item.product.id,
                            );
                          },
                          onDelete: () {
                            if (state.loading) return;

                            cartCubit.deleteProduct(
                              item.product.id,
                            );
                          },
                        );
                      },
                    ),
                    if (state.loading)
                      const Positioned.fill(
                        child: ColoredBox(
                          color: Color(0x33000000),
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              _CartSummary(
                totalItems: state.totalItems,
                totalPrice: state.totalPrice,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  16,
                  0,
                  16,
                  16,
                ),
                child: SizedBox(
                  width: double.infinity,
                  child: CustomButton(
                    text: 'Pay',
                    onPressed: () {
                      if (state.loading) return;

                      Navigator.pushNamed(
                        context,
                        PaymentOptions.route,
                      );
                    },
                  )
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _showClearCartDialog(
      BuildContext context,
      CartCubit cartCubit,
      ) async {
    final shouldClear = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Clear cart'),
          content: const Text(
            'Are you sure you want to remove all products from the cart?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, false);
              },
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.pop(dialogContext, true);
              },
              child: const Text('Clear'),
            ),
          ],
        );
      },
    );

    if (shouldClear == true) {
      await cartCubit.clearCart();
    }
  }
}

class _EmptyCart extends StatelessWidget {
  const _EmptyCart();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.shopping_cart_outlined,
            size: 72,
            color: Colors.grey,
          ),
          SizedBox(height: 16),
          Text(
            'Cart is empty',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Add products to see them here.',
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}

class _CartSummary extends StatelessWidget {
  final int totalItems;
  final double totalPrice;

  const _CartSummary({
    required this.totalItems,
    required this.totalPrice,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Items: $totalItems',
            style: const TextStyle(fontSize: 16),
          ),
          Text(
            'Total: ${totalPrice.toStringAsFixed(2)}',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}