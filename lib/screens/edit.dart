import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:todo_app/screens/character-list.dart';

String editCharacter = """
mutation EditCharacter(\$name: String!, \$id: ID!, \$description: String!, \$picture: String!) {
  updateCharacter(data: 
  { 
    name: \$name 
    description: \$description
    picture: \$picture
  }, id: \$id) {
    _id
    name
    description
    picture
  }
}
""";

class EditCharacter extends StatelessWidget {
  final character;
  const EditCharacter({Key key, this.character}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Character'),
      ),
      body: EditFormBody(Character: this.character),
    );
  }
}

class EditFormBody extends StatefulWidget {
  final Character;
  EditFormBody({Key key, this.Character}) : super(key: key);

  @override
  _EditFormBodyState createState() => _EditFormBodyState();
}

class _EditFormBodyState extends State<EditFormBody> {

  String name;
  String description;
  String picture;

  @override
  Widget build(BuildContext context) {
    return Container(
       child: Padding(
         padding: const EdgeInsets.all(8.0),
         child: Column(
           crossAxisAlignment: CrossAxisAlignment.start,
           children: [
            TextFormField(
               initialValue: widget.Character['name'],
                decoration: const InputDecoration(
                  icon: Icon(Icons.person),
                  labelText: 'Name *',
                ),
                onChanged: (text) {
                  name = text;
                }
            ),
            TextFormField(
              initialValue: widget.Character['description'],
              decoration: const InputDecoration(
                icon: Icon(Icons.person),
                labelText: 'Description',
              ),
              minLines: 4,
              maxLines: 4,
              onChanged: (text) {
                description = text;
              }
            ),
            TextFormField(
              initialValue: widget.Character['picture'],
              decoration: const InputDecoration(
                icon: Icon(Icons.image),
                labelText: 'Image Url',
              ),
              onChanged: (text) {
                picture = text;
              },
            ),
            SizedBox(height: 20),
            Mutation(
              options: MutationOptions(
                document: gql(editCharacter),
                onCompleted: (dynamic resultData) {
                  print(resultData);
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => AllCharacters())
                  );
                },
              ),
              builder: (
                RunMutation runMutation,
                QueryResult result,
              ) {
                print(result);
                return Center(
                  child: ElevatedButton(
                    child: const Text('Submit'),
                    onPressed: () {
                      
                      runMutation({
                        'id': widget.Character['_id'],
                        'name': name != null ? name : widget.Character['name'],
                        'description': description != null ? description : widget.Character['description'],
                        'picture': picture != null ? picture : widget.Character['picture'],
                      });
                    },
                  ),
                );
              }
            ),
           ]
         )
       ),
    );
  }
}