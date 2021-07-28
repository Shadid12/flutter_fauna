import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:flutter/material.dart';


ValueNotifier<GraphQLClient> clientFor({
  @required String uri,
  String subscriptionUri,
}) {
  
  final HttpLink httpLink = HttpLink(
    uri,
  );

  final AuthLink authLink = AuthLink(
    getToken: () async => 'Bearer fnAEPAjy8QACRJ8iwZcuya2DbtsB6mesrDEgZ2-2',
  );

  Link link = authLink.concat(httpLink);

  return ValueNotifier<GraphQLClient>(
    GraphQLClient(
      cache: GraphQLCache(store: HiveStore()),
      link: link,
    ),
  );
}

/// Wraps the root application with the `graphql_flutter` client.
/// We use the cache for all state management.
class ClientProvider extends StatelessWidget {
  ClientProvider({
    @required this.child,
    @required String uri,
  }) : client = clientFor(
          uri: uri,
        );

  final Widget child;
  final ValueNotifier<GraphQLClient> client;

  @override
  Widget build(BuildContext context) {
    return GraphQLProvider(
      client: client,
      child: child,
    );
  }
}