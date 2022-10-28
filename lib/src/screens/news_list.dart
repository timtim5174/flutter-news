import 'package:flutter/material.dart';
import 'package:news/src/widgets/news_list_tile.dart';
import 'package:news/src/widgets/refresh.dart';
import '../blocs/stories_provider.dart';

class NewsList extends StatelessWidget {
  const NewsList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Top News'),
      ),
      body: buildList(bloc),
    );
  }

  Widget buildList(StoriesBloc bloc) {
    return StreamBuilder(
        stream: bloc.topIds,
        builder: (context, AsyncSnapshot<List<int>> snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return Refresh(
            child: ListView.builder(
              itemCount: snapshot.data?.length,
              itemBuilder: (context, int index) {
                bloc.fetchItem(snapshot.data![index]);
                return NewsListTile(itemId: snapshot.data![index]);
              },
            ),
          );
        });
  }
}
