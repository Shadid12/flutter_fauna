import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:todo_app/screens/character-tile.dart';


String readCharacters = """
query ListAllCharacters {
  listAllCharacters(_size: 100) {
    data {
      _id
      name
      description
      picture
    }
    after
  }
}
""";


class AllCharacters extends StatelessWidget {
  const AllCharacters({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            snap: false,
            floating: true,
            expandedHeight: 160.0,
            title: Text(
              'Characters',
              style: TextStyle(
                fontWeight: FontWeight.w400, 
                fontSize: 36,
              ),
            ),
            actions: <Widget>[
              IconButton(
                padding: EdgeInsets.all(5),
                icon: const Icon(Icons.add_circle),
                tooltip: 'Add new entry',
                onPressed: () { 
                  Navigator.pushNamed(context, '/new');
                },
              ),
            ],
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              Query(options: QueryOptions(
                document: gql(readCharacters),
                pollInterval: Duration(seconds: 600),
              ), 
              builder: (QueryResult result, { VoidCallback refetch, FetchMore fetchMore }) {
                if (result.isLoading) {
                  return Text('Loading');
                }
                print('Data $result');
                return Column(
                  children: [
                    for (var item in result.data['listAllCharacters']['data'])
                      CharacterTile(character: item, refetch: refetch),
                  ],
                );
              })
              // for (var i = 0; i < 100; i++) Text('Recipe $i'),
            ])
          )
        ],
      ),
    );
  }
}