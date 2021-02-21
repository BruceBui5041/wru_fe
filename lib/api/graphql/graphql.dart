// ...

import 'package:graphql/client.dart';
import 'package:wru_fe/api/api.dart';
import 'package:wru_fe/models/auth.repository.dart';
import 'package:wru_fe/utils.dart';

class GraphQLUtil {
  GraphQLUtil();
  static GraphQLClient client() {
    HttpLink _httpLink = HttpLink(
      uri: GRAPHQL_API,
    );

    final AuthLink _authLink = AuthLink(
      headerKey: 'Authorization',
      getToken: () async {
        var token = await getValueFromSharePreference(AuthRepository.tokenKey);
        return 'Bearer $token';
      },
    );

    final Link _link = _authLink.concat(_httpLink);

    return GraphQLClient(
      cache: InMemoryCache(),
      link: _link,
    );
  }
}
