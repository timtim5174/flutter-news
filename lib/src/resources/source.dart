import '../models/item_model.dart';
import 'dart:async';

abstract class Source {
  Future<ItemModel?> fetchItem(int id);
  Future<List<int>> fetchTopIds();
}