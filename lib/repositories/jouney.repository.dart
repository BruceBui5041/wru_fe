import 'package:graphql/client.dart';
import 'package:wru_fe/dto/fetch_jouney.dto.dart';
import 'package:wru_fe/dto/response.dto.dart';

class JouneyRepository {
  JouneyRepository({required this.client});
  final GraphQLClient client;

  String fetchJouneyQuery(FetchJouneyDto fetchJouneyDto) {
    return '''
      query {
        jouneys {
          uuid
          name
          createdAt
          image
          description
          visibility
          markerCount
        }
      }
      ''';
  }

  String fetchJouneyByIdQuery(String jouneyId) {
    return '''
      query {
        jouney (id: "$jouneyId") {
          uuid
          name
          markerCount
          markers {
            uuid
            name
            visibility
            description
            lat
            lng
            image
          }
        }
      }
      ''';
  }

  Future<ResponseDto> fetchJouney(FetchJouneyDto fetchJouneyDto) async {
    ////////////////////////////////////////
    final String readRepositories = fetchJouneyQuery(fetchJouneyDto);
    /////////////////////////////////////////

    print(readRepositories);
    final QueryOptions options = QueryOptions(document: gql(readRepositories));

    final QueryResult result = await client.query(options);

    if (result.hasException) {
      assert(!result.hasException);
      return ResponseDto(
        errorCode: result.exception?.graphqlErrors[0].extensions?.entries
            .toList()[1]
            .value['response']['statusCode'],
        message: result.exception?.graphqlErrors[0].message,
        result: result.data,
      );
    }

    return ResponseDto(
      result: result.data,
    );
  }

  Future<ResponseDto> fetchJouneyById(String jouneyId) async {
    ////////////////////////////////////////
    final String readRepositories = fetchJouneyByIdQuery(jouneyId);
    /////////////////////////////////////////

    print(readRepositories);
    final QueryOptions options = QueryOptions(document: gql(readRepositories));

    final QueryResult result = await client.query(options);

    if (result.hasException) {
      assert(!result.hasException);
      return ResponseDto(
        errorCode: result.exception?.graphqlErrors[0].extensions?.entries
            .toList()[1]
            .value['response']['statusCode'],
        message: result.exception?.graphqlErrors[0].message,
        result: result.data,
      );
    }

    return ResponseDto(
      result: result.data,
    );
  }
}
