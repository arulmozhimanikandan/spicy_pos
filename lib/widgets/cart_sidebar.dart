
import 'package:flutter/material.dart';
import '../models/cart_item.dart';

class CartSidebar extends StatelessWidget {
  final List<CartItem> cartItems;
  final double total;
  final Function(CartItem) onRemove;
  final VoidCallback onCheckout;

  const CartSidebar({super.key, required this.cartItems, required this.total, required this.onRemove, required this.onCheckout});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280,
      color: Colors.grey.shade100,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text("Order Summary", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: cartItems.length,
              itemBuilder: (_, index) {
                final item = cartItems[index];
                return ListTile(
                  title: Text(item.name),
                  subtitle: Text("Qty: ${item.quantity} x €${item.price.toStringAsFixed(2)}"),
                  trailing: IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () => onRemove(item),
                  ),
                );
              },
            ),
          ),
          Divider(),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text("Total: €${total.toStringAsFixed(2)}",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
          if (cartItems.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: ElevatedButton(
                onPressed: onCheckout,
                child: Text("Checkout"),
              ),
            )
        ],
      ),
    );
  }
}
