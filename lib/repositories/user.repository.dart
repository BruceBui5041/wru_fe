import 'package:graphql/client.dart';
import 'package:wru_fe/dto/response.dto.dart';

class UserRepository {
  UserRepository({required this.client});
  final GraphQLClient client;

  String searchUserQuery(String searchQuery) {
    return '''
    query {
        searchUsers(searchQuery: "$searchQuery") {
          uuid
          username
          email
          profile {
            uuid
            image
          }
        }
      }
      ''';
  }

  Future<ResponseDto> searchUser(String searchQuery) async {
    ////////////////////////////////////////
    final String readRepositories = searchUserQuery(searchQuery);
    /////////////////////////////////////////

    print(readRepositories);
    final QueryOptions options = QueryOptions(document: gql(readRepositories));

    final QueryResult result = await client.query(options);

    if (result.hasException) {
      return ResponseDto(
        errorCode: result.exception?.graphqlErrors[0].extensions?.entries
            .toList()[1]
            .value["statusCode"],
        message: result.exception?.graphqlErrors[0].message,
        result: result.data,
      );
    }

    return ResponseDto(
      result: result.data,
    );
  }
}
