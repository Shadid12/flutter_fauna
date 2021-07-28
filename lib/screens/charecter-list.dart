import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:todo_app/screens/charecter-tile.dart';


String readCharecters = """
query ListAllCharecters {
  listAllCharecters(_size: 100) {
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


class AllCharecters extends StatelessWidget {
  const AllCharecters({Key key}) : super(key: key);

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
              'Charecters',
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
                document: gql(readCharecters),
                pollInterval: Duration(seconds: 120),
              ), 
              builder: (QueryResult result, { VoidCallback refetch, FetchMore fetchMore }) {
                if (result.isLoading) {
                  return Text('Loading');
                }
                return Column(
                  children: [
                    for (var item in result.data['listAllCharecters']['data'])
                      CharacterTile(charecter: item, refetch: refetch),
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