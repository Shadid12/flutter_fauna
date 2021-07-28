import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:todo_app/screens/charecter-list.dart';

String editCharecter = """
mutation EditCharecter(\$name: String!, \$id: ID!, \$description: String!, \$picture: String!) {
  updateCharecter(data: 
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

class EditCharecter extends StatelessWidget {
  final charecter;
  const EditCharecter({Key key, this.charecter}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Charecter'),
      ),
      body: EditFormBody(charecter: this.charecter),
    );
  }
}

class EditFormBody extends StatefulWidget {
  final charecter;
  EditFormBody({Key key, this.charecter}) : super(key: key);

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
               initialValue: widget.charecter['name'],
                decoration: const InputDecoration(
                  icon: Icon(Icons.person),
                  labelText: 'Name *',
                ),
                onChanged: (text) {
                  name = text;
                }
            ),
            TextFormField(
              initialValue: widget.charecter['description'],
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
              initialValue: widget.charecter['picture'],
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
                document: gql(editCharecter),
                onCompleted: (dynamic resultData) {
                  print(resultData);
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => AllCharecters())
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
                        'id': widget.charecter['_id'],
                        'name': name != null ? name : widget.charecter['name'],
                        'description': description != null ? description : widget.charecter['description'],
                        'picture': picture != null ? picture : widget.charecter['picture'],
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