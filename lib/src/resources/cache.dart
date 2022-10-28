import '../models/item_model.dart';
import 'dart:async';

abstract class Cache {
  Future<int> addItem(ItemModel item);
  Future<int> clear();
}
