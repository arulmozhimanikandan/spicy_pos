
import 'package:flutter/material.dart';
import '../services/woocommerce_service.dart';
import 'package:intl/intl.dart';

class POSScreen extends StatefulWidget {
  @override
  _POSScreenState createState() => _POSScreenState();
}

class _POSScreenState extends State<POSScreen> {
  List<dynamic> _products = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }

  void _fetchProducts() async {
    try {
      final service = WooCommerceService();
      final products = await service.fetchProducts();
      setState(() {
        _products = products;
        _loading = false;
      });
    } catch (e) {
      print('Error fetching products: $e');
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat.currency(locale: 'nl_NL', symbol: '€');
    return Scaffold(
      appBar: AppBar(title: Text('Spicy Tulip POS')),
      body: _loading
          ? Center(child: CircularProgressIndicator())
          : GridView.builder(
              padding: EdgeInsets.all(10),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, childAspectRatio: 2),
              itemCount: _products.length,
              itemBuilder: (context, index) {
                final product = _products[index];
                final priceStr = product['price']?.toString() ?? '0';
                final price = double.tryParse(priceStr) ?? 0;
                return Card(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(product['name'] ?? 'No Name', textAlign: TextAlign.center),
                        Text(formatter.format(price)),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
