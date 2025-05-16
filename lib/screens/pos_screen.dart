import 'package:flutter/material.dart';
import '../models/product.dart';
import '../models/cart_item.dart';
import '../widgets/cart_sidebar.dart';
import '../widgets/product_grid.dart';
import '../widgets/top_nav.dart';
import '../services/woocommerce_service.dart';

class POSScreen extends StatefulWidget {
  @override
  _POSScreenState createState() => _POSScreenState();
}

class _POSScreenState extends State<POSScreen> {
  List<Product> products = [];
  List<Product> filteredProducts = [];
  List<CartItem> cart = [];

  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }

  void _fetchProducts() async {
    final service = WooCommerceService();
    final fetched = await service.fetchProducts();
    setState(() {
      products =
          fetched
              .map(
                (p) => Product(
                  p['name'],
                  double.tryParse(p['price'].toString()) ?? 0,
                ),
              )
              .toList();
      filteredProducts = List.from(products);
    });
  }

  void _addToCart(Product p) {
    setState(() {
      final existing = cart.indexWhere((item) => item.name == p.name);
      if (existing >= 0) {
        cart[existing].quantity++;
      } else {
        cart.add(CartItem(name: p.name, quantity: 1, price: p.price));
      }
    });
  }

  void _removeFromCart(CartItem item) {
    setState(() {
      cart.removeWhere((i) => i.name == item.name);
    });
  }

  void _search(String query) {
    setState(() {
      filteredProducts =
          products
              .where((p) => p.name.toLowerCase().contains(query.toLowerCase()))
              .toList();
    });
  }

  void _checkout() {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: Text("Checkout"),
            content: Text("Simulated payment success."),
            actions: [
              TextButton(
                onPressed: () {
                  setState(() => cart.clear());
                  Navigator.pop(context);
                },
                child: Text("OK"),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final total = cart.fold(
      0.0,
      (sum, item) => sum + item.price * item.quantity,
    );
    return Column(
      children: [
        TopNav(onSearch: _search),
        Expanded(
          child: Row(
            children: [
              CartSidebar(
                cartItems: cart,
                total: total,
                onRemove: _removeFromCart,
                onCheckout: _checkout,
              ),
              Expanded(
                child: ProductGrid(
                  products: filteredProducts,
                  onAdd: _addToCart,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
