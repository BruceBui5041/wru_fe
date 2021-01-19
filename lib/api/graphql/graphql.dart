// ...

import 'package:graphql/client.dart';
import 'package:wru_fe/api/api.dart';
import 'package:wru_fe/models/auth.repository.dart';
import 'package:wru_fe/utils.dart';

class GraphQlUtil {
  GraphQlUtil();
  static GraphQLClient client() {
    HttpLink _httpLink = HttpLink(
      uri: GRAPHQL_API,
    );

    final AuthLink _authLink = AuthLink(
      getToken: () async =>
          'Bearer $getValueFromSharePreference(${AuthRepository.tokenKey})',
    );
    final Link _link = _authLink.concat(_httpLink);

    return GraphQLClient(
      cache: InMemoryCache(),
      link: _link,
    );
  }
}
