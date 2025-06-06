import 'dart:convert';
import 'package:http/http.dart' as http;

class WooCommerceService {
  final String baseUrl = 'https://spicytulip.com/wp-json/wc/v3';
  final String consumerKey = 'ck_ac47b18e4c973848c557b417cbcf4fdd7f7d0f41';
  final String consumerSecret = 'cs_4ee0fb053930c20c3ad0cff9343f9f699f48411e';

  Future<List<dynamic>> fetchAllProductsWithVariations() async {
    print(">> Starting fetchAllProductsWithVariations()");
    List<dynamic> allProducts = [];
    List<int> variationParentIds = [];
    int page = 1;
    const int perPage = 100;

    while (true) {
      final url =
          '$baseUrl/products?consumer_key=$consumerKey&consumer_secret=$consumerSecret&per_page=$perPage&page=$page';
      final response = await http.get(Uri.parse(url));
      if (response.statusCode != 200) break;

      final List<dynamic> batch = json.decode(response.body);
      print("Fetched product page $page: ${batch.length} items");
      if (batch.isEmpty) break;

      variationParentIds.addAll(
        batch
            .where((p) => (p['type'] ?? '').toLowerCase() == 'variable')
            .map((p) => p['id'])
            .cast<int>(),
      );

      allProducts.addAll(batch);
      if (batch.length < perPage) break;
      page++;
    }

    for (final id in variationParentIds) {
      int vpage = 1;
      while (true) {
        final vurl =
            '$baseUrl/products/$id/variations?consumer_key=$consumerKey&consumer_secret=$consumerSecret&per_page=100&page=$vpage';
        final vres = await http.get(Uri.parse(vurl));
        if (vres.statusCode != 200) break;

        final List<dynamic> vbatch = json.decode(vres.body);
        print(
          "Fetched variations for product $id, page $vpage: ${vbatch.length} items",
        );

        if (vbatch.isEmpty) break;

        allProducts.addAll(vbatch);
        if (vbatch.length < 100) break;
        vpage++;
      }
    }

    final filtered =
        allProducts
            .where((p) => (p['stock_status'] ?? '').toLowerCase() == 'instock')
            .toList();

    print("Total products after filtering (in stock only): ${filtered.length}");
    return filtered;
  }
}
