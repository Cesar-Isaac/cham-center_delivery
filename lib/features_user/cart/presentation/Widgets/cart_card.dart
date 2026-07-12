import 'package:flutter/material.dart';
import '../../domain/entities/cart_entity.dart';

class CartCard extends StatelessWidget {
  final CartEntity item;
  final VoidCallback? onIncrease;
  final VoidCallback? onDecrease;
  final VoidCallback? onDelete;

  const CartCard({
    super.key,
    required this.item,
    required this.onIncrease,
    required this.onDecrease,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10),
      child: ListTile(
        leading: Image.network(
          item.product.image,
          width: 60,
          height: 60,
          fit: BoxFit.cover,
        ),
        title: Text(item.product.name),
        subtitle: Text(
          "Price: ${item.product.price} × ${item.quantity}\nTotal: ${item.totalPrice}",
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              onPressed: onDecrease,
              icon: const Icon(Icons.remove),
            ),
            Text("${item.quantity}"),
            IconButton(
              onPressed: onIncrease,
              icon: const Icon(Icons.add),
            ),
            IconButton(
              onPressed: onDelete,
              icon: const Icon(Icons.delete, color: Colors.red),
            ),
          ],
        ),
      ),
    );
  }
}