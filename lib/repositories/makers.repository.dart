import 'package:graphql/client.dart';
import 'package:wru_fe/dto/fetch_marker.dto.dart';
import 'package:wru_fe/dto/response.dto.dart';

class MarkerRepository {
  MarkerRepository({required this.client});
  final GraphQLClient client;

  String fetchMarkerQuery(FetchMarkerDto fetchMarkerDto) {
    return '''
      query {
        markers(jouneyId: "${fetchMarkerDto.jouneyId}") {
          uuid
          name
          visibility
          description
          lat
          lng
          image
          image1
          image2
          image3
          image4
          image5
          createdAt
        }
      }
      ''';
  }

  Future<ResponseDto> fetchMarker(FetchMarkerDto fetchMarkerDto) async {
    ////////////////////////////////////////
    final String readRepositories = fetchMarkerQuery(fetchMarkerDto);
    /////////////////////////////////////////

    print(readRepositories);
    final QueryOptions options = QueryOptions(document: gql(readRepositories));

    final QueryResult result = await client.query(options);

    if (result.hasException) {
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
