
import 'package:flutter/material.dart';
import '../models/product.dart';

class ProductGrid extends StatelessWidget {
  final List<Product> products;
  final Function(Product) onAdd;

  const ProductGrid({super.key, required this.products, required this.onAdd});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: EdgeInsets.all(12),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 1.5,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: products.length,
      itemBuilder: (_, index) {
        final product = products[index];
        return GestureDetector(
          onTap: () => onAdd(product),
          child: Card(
            elevation: 2,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(product.name, style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(height: 4),
                  Text("€${product.price.toStringAsFixed(2)}"),
                  Text("SKU: ${product.sku}", style: TextStyle(fontSize: 12)),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
