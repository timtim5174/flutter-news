import 'dart:async';
import 'package:flutter/material.dart';
import 'package:news/src/widgets/loading_container.dart';
import '../models/item_model.dart';
import '../blocs/stories_provider.dart';

class NewsListTile extends StatelessWidget {
  final int itemId;

  const NewsListTile({Key? key, required this.itemId});

  @override
  Widget build(BuildContext context) {
    final bloc = StoriesProvider.of(context);
    return StreamBuilder(
        stream: bloc.items,
        builder:
            (context, AsyncSnapshot<Map<int, Future<ItemModel?>>> snapshot) {
          if (!snapshot.hasData) {
            return LoadingContainer();
          }
          return FutureBuilder(
              future: snapshot.data![itemId],
              builder: (context, AsyncSnapshot<ItemModel?> itemSnapshot) {
                if (!itemSnapshot.hasData) {
                  return LoadingContainer();
                }
                return buildTile(context, itemSnapshot.data);
              });
        });
  }

  Widget buildTile(BuildContext context, ItemModel? item) {
    return Column(
      children: [
        ListTile(
          title: Text(item?.text as String),
          subtitle: Text('${item?.score} points'),
          trailing: Column(
            children: [
              const Icon(Icons.comment),
              Text('${item?.descendants ?? 0}')
            ],
          ),
          onTap: () {
            Navigator.pushNamed(context, '${item?.id}');
          },
        ),
        const Divider(
          height: 8.0,
        )
      ],
    );
  }
}
