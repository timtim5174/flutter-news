import 'dart:async';
import 'package:flutter/material.dart';
import 'package:news/src/widgets/loading_container.dart';
import '../models/item_model.dart';

class Comment extends StatelessWidget {
  final int itemId;
  final Map<int, Future<ItemModel?>> itemMap;
  final int depth;

  const Comment({Key? key,
    required this.itemId,
    required this.itemMap,
    required this.depth})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: itemMap[itemId],
        builder: (BuildContext context, AsyncSnapshot<ItemModel?> snapshot) {
          if (!snapshot.hasData) {
            return const LoadingContainer();
          }

          final item = snapshot.data;
          final children = <Widget>[
            ListTile(
              title: buildText(item!),
              subtitle: Text(item.by as String),
              contentPadding: EdgeInsets.only(
                left: depth * 16.0,
                right: 16.0,
              ),
            ),
            const Divider(),
          ];

          snapshot.data?.kids?.forEach((kidId) {
            children.add(
              Comment(
                itemId: kidId,
                itemMap: itemMap,
                depth: depth + 1,
              ),
            );
          });

          return Column(children: children);
        });
  }

  Widget buildText(ItemModel item) {
    final text = item.text!
        .replaceAll('&#x27;', "'")
        .replaceAll('<p>', '\n\n')
        .replaceAll('</p>', '');
    return Text(text);
  }
}
