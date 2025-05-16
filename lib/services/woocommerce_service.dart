
import 'dart:convert';
import 'package:http/http.dart' as http;

class WooCommerceService {
  final String baseUrl = 'https://spicytulip.com/wp-json/wc/v3';
  final String consumerKey = 'ck_ac47b18e4c973848c557b417cbcf4fdd7f7d0f41';
  final String consumerSecret = 'cs_4ee0fb053930c20c3ad0cff9343f9f699f48411e';

  Future<List<dynamic>> fetchProducts() async {
    try {
      final String url =
          '$baseUrl/products?consumer_key=$consumerKey&consumer_secret=$consumerSecret&per_page=20';

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        print('WooCommerce API error: ${response.statusCode} ${response.body}');
        return [];
      }
    } catch (e) {
      print('Error fetching products: $e');
      return [];
    }
  }
}
