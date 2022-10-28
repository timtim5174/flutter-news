import 'package:http/http.dart' show Client;
import 'dart:convert';
import 'dart:async';

import '../models/item_model.dart';
import 'source.dart';

class NewsApiProvider implements Source {
  Client client = Client();
  final String _domain = 'https://hacker-news.firebaseio.com/v0';

  @override
  Future<List<int>> fetchTopIds() async {
    final response = await client.get(Uri.parse('$_domain/topstories.json'));
    final ids = json.decode(response.body);
    return ids.cast<int>();
  }

  @override
  Future<ItemModel> fetchItem(int id) async {
    final response = await client.get(Uri.parse('$_domain/item/$id.json'));
    final parsedJson = json.decode(response.body);
    return ItemModel.fromJson(parsedJson);
  }
}
