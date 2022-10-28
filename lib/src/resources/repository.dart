import '../models/item_model.dart';

import 'cache.dart';
import 'news_api_provider.dart';
import 'news_db_provider.dart';
import 'dart:async';

import 'source.dart';

class Repository {
  List<Source> sources = <Source> [
    NewsDbProvider(),
    NewsApiProvider(),
  ];

  List<Cache> caches = <Cache> [
    NewsDbProvider(),
  ];

  NewsDbProvider dbProvider = NewsDbProvider();
  NewsApiProvider apiProvider = NewsApiProvider();

  Future<List<int>> fetchTopIds() {
    return sources[1].fetchTopIds();
  }

  Future<ItemModel?> fetchItem(int id) async {
    ItemModel? item;
    Source source;

    for (source in sources) {
      item = await source.fetchItem(id);

      if (item != null) {
        break;
      }
    }

    for (var cache in caches) {
      if (item != null) {
        cache.addItem(item);
      }
    }

    return item;
  }

  clearCache() async {
    for (Cache cache in caches) {
      await cache.clear();
    }
  }
}