import 'dart:async';

import 'package:flutter/material.dart';
import 'package:news/src/blocs/comments_provider.dart';
import 'package:news/src/widgets/comment.dart';

import '../models/item_model.dart';

class NewsDetail extends StatelessWidget {
  final int itemId;

  const NewsDetail({required this.itemId, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bloc = CommentsProvider.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail'),
      ),
      body: buildBody(bloc),
    );
  }

  Widget buildBody(CommentsBloc bloc) {
    return StreamBuilder(
      stream: bloc.itemWithComments,
      builder: (context, AsyncSnapshot<Map<int, Future<ItemModel?>>> snapshot) {
        if (!snapshot.hasData) {
          return const Text('Loading');
        }

        final $item = snapshot.data![itemId];

        return FutureBuilder(
            future: $item,
            builder: (context, AsyncSnapshot<ItemModel?> itemSnapshot) {
              if (!itemSnapshot.hasData) {
                return const Text('Loading');
              }

              return buildList(itemSnapshot.data!, snapshot.data!);
            });
      },
    );
  }

  Widget buildList(ItemModel item, Map<int, Future<ItemModel?>> itemMap) {
    final children = <Widget>[];
    final commentsList = item.kids?.map((kidId) {
      return Comment(
        itemId: kidId,
        itemMap: itemMap,
        depth: 1,
      );
    }).toList();

    children.add(buildTitle(item));
    children.addAll(commentsList!);

    return ListView(
      children: children
    );
  }

  Widget buildTitle(ItemModel? item) {
    return Container(
      margin: EdgeInsets.all(10),
      alignment: Alignment.topCenter,
      child: Text(
        item?.title as String,
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
      ),
    );
  }
}
