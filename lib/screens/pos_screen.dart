import 'package:flutter/material.dart';
import '../models/product.dart';
import '../models/cart_item.dart';
import '../services/woocommerce_service.dart';
import '../widgets/cart_sidebar.dart';
import '../widgets/product_grid.dart';
import '../widgets/top_nav.dart';

class POSScreen extends StatefulWidget {
  @override
  _POSScreenState createState() => _POSScreenState();
}

class _POSScreenState extends State<POSScreen> {
  List<Product> products = [];
  List<Product> filteredProducts = [];
  List<CartItem> cart = [];
  final TextEditingController _controller = TextEditingController();
  final FocusNode searchFocus = FocusNode();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }

  void _fetchProducts() async {
    final service = WooCommerceService();
    final fetched = await service.fetchAllProductsWithVariations();
    print("Total fetched items (in stock only): \${fetched.length}");

    final Map<int, String> parentNames = {};
    for (var p in fetched) {
      final id = p['id'];
      final name = p['name'];
      if (name != null) {
        parentNames[id] = name;
      }
    }

    setState(() {
      products =
          fetched.map((p) {
            final type = (p['type'] ?? '').toLowerCase();
            final baseName = p['name'] ?? '';
            final attrs =
                (p['attributes'] as List?)
                    ?.map((a) {
                      final n = a['name'] ?? '';
                      final o = a['option'] ?? '';
                      return "$n: $o";
                    })
                    .join(', ') ??
                '';

            final fullName = () {
              if (type == 'variation') {
                final parentId = p['parent_id'];
                final parentName = parentNames[parentId] ?? 'Unnamed Parent';
                return '$parentName ($attrs)';
              }
              return attrs.isNotEmpty ? '$baseName ($attrs)' : baseName;
            }();

            final price = double.tryParse(p['price']?.toString() ?? '0') ?? 0;
            final sku = p['sku'] ?? '';
            return Product(fullName, price, sku);
          }).toList();
      filteredProducts = List.from(products);
      isLoading = false;
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
    final lowerQuery = query.trim().toLowerCase();
    print("flutter: $lowerQuery");

    final exact = products.firstWhere(
      (p) => (p.sku ?? '').trim().toLowerCase().contains(lowerQuery),
      orElse: () => Product('', 0.0, ''),
    );

    print(
      "flutter: Checking SKU match against: '\${exact.sku}' — Name: \${exact.name}",
    );
    print(
      "flutter: Match condition: \${exact.name.isNotEmpty && lowerQuery.length >= 10}",
    );

    if (lowerQuery.length >= 10 && exact.name.isNotEmpty) {
      print("flutter: Exact match found — Adding to cart: \${exact.name}");
      _addToCart(exact);
      _controller.clear();
      searchFocus.requestFocus();
      return;
    }

    setState(() {
      filteredProducts =
          products
              .where(
                (p) =>
                    p.name.toLowerCase().contains(lowerQuery) ||
                    (p.sku ?? '').toLowerCase().contains(lowerQuery),
              )
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
    if (isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    return Column(
      children: [
        TopNav(
          onSearch: _search,
          controller: _controller,
          focusNode: searchFocus,
        ),
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
