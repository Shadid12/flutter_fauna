import 'package:flutter/material.dart';
import 'package:todo_app/client_provider.dart';
import 'package:todo_app/screens/character-list.dart';
import 'package:todo_app/screens/new.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

void main() async {
  await initHiveForFlutter();
  runApp(MyApp());
}

final graphqlEndpoint = 'https://graphql.fauna.com/graphql';

class MyApp extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return ClientProvider(
      uri: graphqlEndpoint,
      child: MaterialApp(
        title: 'Start Trek Charecters',
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        routes: {
          '/': (_) => AllCharacters(),
          '/new': (_) => NewCharecter(),
        }
      ),
    );
  }
}