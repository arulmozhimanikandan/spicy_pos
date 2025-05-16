
import 'package:flutter/material.dart';

class POSScreen extends StatelessWidget {
  final List<String> mockProducts = List.generate(10, (i) => "Product \$${i + 1}");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Spicy Tulip POS")),
      body: GridView.builder(
        padding: EdgeInsets.all(10),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 2),
        itemCount: mockProducts.length,
        itemBuilder: (context, index) {
          return Card(
            child: Center(child: Text(mockProducts[index])),
          );
        },
      ),
    );
  }
}
