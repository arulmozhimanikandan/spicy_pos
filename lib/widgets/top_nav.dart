
import 'package:flutter/material.dart';

class TopNav extends StatelessWidget {
  final Function(String) onSearch;

  const TopNav({super.key, required this.onSearch});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.teal.shade100,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          Text("Spicy Tulip POS", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          SizedBox(width: 20),
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: "Search products...",
                fillColor: Colors.white,
                filled: true,
                border: OutlineInputBorder(),
              ),
              onChanged: onSearch,
            ),
          ),
          SizedBox(width: 20),
          Icon(Icons.account_circle, size: 32),
        ],
      ),
    );
  }
}
