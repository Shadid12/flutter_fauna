import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:todo_app/screens/edit.dart';


String deletecharacter = """
  mutation Deletecharacter(\$id: ID!) {
    deleteCharacter(id: \$id) {
      _id
      name
    }
  }
""";

class CharacterTile extends StatelessWidget {
  final character;
  final VoidCallback refetch;
  final VoidCallback updateParent;

  const CharacterTile({
    Key key, 
    @required this.character, 
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
            print(character['picture']);
            return Mutation(
              options: MutationOptions(
                document: gql(deletecharacter),
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
                        Text(character['description']),
                        ElevatedButton(
                          child: Text('Delete character'),
                          onPressed: () {
                            runMutation({
                              'id': character['_id'],
                            });
                            Navigator.pop(context);
                          },
                        ),
                        SizedBox(height: 10),
                        ElevatedButton(
                          child: Text('Edit character'),
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(
                              builder: (context) {
                                return EditCharacter(character: character);
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
                  image: NetworkImage(character['picture'])
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
                    character['name'],
                    style: TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    character['description'],
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