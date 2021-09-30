// ...

import 'package:graphql/client.dart';
import 'package:wru_fe/api/api.dart';
import 'package:wru_fe/repositories/auth.repository.dart';
import 'package:wru_fe/utils.dart';

class GraphQLUtil {
  GraphQLUtil();
  static GraphQLClient client() {
    final HttpLink _httpLink = HttpLink(GRAPHQL_API);

    final AuthLink _authLink = AuthLink(
      headerKey: 'Authorization',
      getToken: () {
        final String token = getValueFromStore(AuthRepository.tokenKey);
        print(token);
        return 'Bearer $token';
      },
    );

    final Link _link = _authLink.concat(_httpLink);

    final Policies policies = Policies(
      fetch: FetchPolicy.noCache,
    );

    return GraphQLClient(
      cache: GraphQLCache(),
      link: _link,
      defaultPolicies: DefaultPolicies(
        watchQuery: policies,
        query: policies,
        mutate: policies,
      ),
    );
  }
}
