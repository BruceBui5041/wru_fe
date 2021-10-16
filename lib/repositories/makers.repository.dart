import 'package:graphql/client.dart';
import 'package:wru_fe/dto/create_marker.dto.dart';
import 'package:wru_fe/dto/fetch_marker.dto.dart';
import 'package:wru_fe/dto/response.dto.dart';

class MarkerRepository {
  MarkerRepository({required this.client});
  final GraphQLClient client;

  String fetchMarkerQuery(FetchMarkerDto fetchMarkerDto) {
    return '''
      query {
        markers(jouneyId: "${fetchMarkerDto.journeyId}") {
          uuid
          name
          description
          lat
          lng
          image
          createdAt
        }
      }
      ''';
  }

  String createMarkerMutation(CreateMarkerDto createMarkerDto) {
    return '''
      mutation {
        createMarker(
          jouneyId: "${createMarkerDto.journeyId}",
          marker: {
              lng: ${createMarkerDto.lng}, 
              lat: ${createMarkerDto.lat}, 
              name: "${createMarkerDto.name}", 
              description: "${createMarkerDto.description}",
              image: ${createMarkerDto.image == null ? null : "\"${createMarkerDto.image}\""}
            }
        ) {
          uuid
          lat
          lng
          jouney {
            uuid
          }
        }
      }
      ''';
  }

  Future<ResponseDto> createMarker(CreateMarkerDto createMarkerDto) async {
    ////////////////////////////////////////
    final String readRepositories = createMarkerMutation(createMarkerDto);
    /////////////////////////////////////////

    print(readRepositories);
    final MutationOptions options =
        MutationOptions(document: gql(readRepositories));

    final QueryResult result = await client.mutate(options);

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
