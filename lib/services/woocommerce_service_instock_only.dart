
import 'dart:convert';
import 'package:http/http.dart' as http;

class WooCommerceService {
  final String baseUrl = 'https://spicytulip.com/wp-json/wc/v3';
  final String consumerKey = 'ck_ac47b18e4c973848c557b417cbcf4fdd7f7d0f41';
  final String consumerSecret = 'cs_4ee0fb053930c20c3ad0cff9343f9f699f48411e';

  Future<List<dynamic>> fetchAllProductsWithVariations() async {
    List<dynamic> allProducts = [];
    List<int> parentIds = [];
    int page = 1;
    const int perPage = 100;

    while (true) {
      final url = '$baseUrl/products?consumer_key=$consumerKey&consumer_secret=$consumerSecret&stock_status=instock&per_page=$perPage&page=$page';
      final response = await http.get(Uri.parse(url));
      if (response.statusCode != 200) break;

      final List<dynamic> batch = json.decode(response.body);
      if (batch.isEmpty) break;

      parentIds.addAll(batch.map((p) => p['id']).cast<int>());
      allProducts.addAll(batch);
      if (batch.length < perPage) break;
      page++;
    }

    for (final id in parentIds) {
      int vpage = 1;
      while (true) {
        final vurl = '$baseUrl/products/$id/variations?consumer_key=$consumerKey&consumer_secret=$consumerSecret&stock_status=instock&per_page=100&page=$vpage';
        final vres = await http.get(Uri.parse(vurl));
        if (vres.statusCode != 200) break;

        final List<dynamic> vbatch = json.decode(vres.body);
        if (vbatch.isEmpty) break;

        allProducts.addAll(vbatch);
        if (vbatch.length < 100) break;
        vpage++;
      }
    }

    return allProducts;
  }
}
