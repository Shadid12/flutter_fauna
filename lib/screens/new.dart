
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:todo_app/screens/character-list.dart';

String addCharecter = """
  mutation CreateNewCharecter(\$data: CharacterInput!) {
    createCharacter(data: \$data) {
      _id
      name
      description
      picture
    }
  }
""";

class NewCharecter extends StatelessWidget {
  const NewCharecter({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Charecter'),
      ),
      body: AddCharecterForm()
    );
  }
}

class AddCharecterForm extends StatefulWidget {
  AddCharecterForm({Key key}) : super(key: key);

  @override
  _AddCharecterFormState createState() => _AddCharecterFormState();
}

class _AddCharecterFormState extends State<AddCharecterForm> {

  String name;
  String description;
  String imgUrl;

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              decoration: const InputDecoration(
                icon: Icon(Icons.person),
                labelText: 'Name *',
              ),
              onChanged: (text) {
                name = text;
              },
            ),
            TextField(
              decoration: const InputDecoration(
                icon: Icon(Icons.post_add),
                labelText: 'Description',
              ),
              minLines: 4,
              maxLines: 4,
              onChanged: (text) {
                description = text;
              },
            ),
            TextField(
              decoration: const InputDecoration(
                icon: Icon(Icons.image),
                labelText: 'Image Url',
              ),
              onChanged: (text) {
                imgUrl = text;
              },
            ),
            SizedBox(height: 20),
            Mutation(
              options: MutationOptions(
                document: gql(addCharecter),
                onCompleted: (dynamic resultData) {
                  print(resultData);
                  name = '';
                  description = '';
                  imgUrl = '';
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => AllCharacters())
                  );
                },
              ), 
              builder: (
                RunMutation runMutation,
                QueryResult result,
              ) {
                return Center(
                  child: ElevatedButton(
                    child: const Text('Submit'),
                    onPressed: () {
                      runMutation({
                        'data': {
                          "picture": imgUrl,
                          "name": name,
                          "description": description,
                        }
                      });
                    },
                  ),
                );
              }
            )
          ],
        ),
      ),
    );
  }
}