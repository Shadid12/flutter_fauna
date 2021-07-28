import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:todo_app/screens/edit.dart';


String deleteCharecter = """
  mutation DeleteCharecter(\$id: ID!) {
    deleteCharecter(id: \$id) {
      _id
      name
    }
  }
""";

class CharacterTile extends StatelessWidget {
  final charecter;
  final VoidCallback refetch;
  final VoidCallback updateParent;

  const CharacterTile({
    Key key, 
    @required this.charecter, 
    @required this.refetch,
    this.updateParent,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        showModalBottomSheet(
          context: context,
          builder: (BuildContext context) {
            print(charecter['picture']);
            return Mutation(
              options: MutationOptions(
                document: gql(deleteCharecter),
                onCompleted: (dynamic resultData) {
                  print(resultData);
                  this.refetch();
                },
              ), 
              builder: (
                RunMutation runMutation,
                QueryResult result,
              ) {
                return Container(
                  height: 400,
                  padding: EdgeInsets.all(30),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text(charecter['description']),
                        ElevatedButton(
                          child: Text('Delete Charecter'),
                          onPressed: () {
                            runMutation({
                              'id': charecter['_id'],
                            });
                            Navigator.pop(context);
                          },
                        ),
                        SizedBox(height: 10),
                        ElevatedButton(
                          child: Text('Edit Charecter'),
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(
                              builder: (context) {
                                return EditCharecter(charecter: charecter);
                              }
                            ));
                          },
                        )
                      ],
                    ),
                  ),
                ); 
              }
            );
          }
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            Container(
              height: 90,
              width: 90,
              decoration: BoxDecoration(
                color: Colors.amber,
                borderRadius: BorderRadius.circular(15),
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage(charecter['picture'])
                )
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    charecter['name'],
                    style: TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    charecter['description'],
                    style: TextStyle(
                      color: Colors.black87,
                    ),
                    maxLines: 2,
                  ),
                ],
              )
            )
          ],
        ),
      ),
    );
  }
}