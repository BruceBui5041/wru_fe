import 'dart:convert';
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
        }
      }
      ''';
  }

  Future<ResponseDto> fetchJouney(FetchJouneyDto fetchJouneyDto) async {
    ////////////////////////////////////////
    final String readRepositories = fetchJouneyQuery(fetchJouneyDto);
    /////////////////////////////////////////

    print(readRepositories);
    final QueryOptions options =
        QueryOptions(documentNode: gql(readRepositories));

    final QueryResult result = await client.query(options);

    if (result.hasException) {
      return ResponseDto(
        errorCode: result.exception.graphqlErrors[0].extensions.entries
            .toList()[1]
            .value['response']['statusCode'],
        message: result.exception.graphqlErrors[0].message,
        result: result.data,
      );
    }

    return ResponseDto(
      result: result.data,
    );
  }
}
