import 'package:graphql/client.dart';
import 'package:wru_fe/dto/create_jouney.dto.dart';
import 'package:wru_fe/dto/fetch_journey.dto.dart';
import 'package:wru_fe/dto/response.dto.dart';
import 'package:wru_fe/dto/update_journey.dto.dart';
import 'package:wru_fe/utils.dart';

class JourneyRepository {
  JourneyRepository({required this.client});
  final GraphQLClient client;

  String fetchJourneyQuery(FetchJourneyDto? fetchJourneyDto) {
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

  String fetchJourneyByIdQuery(String journeyId) {
    return '''
      query {
        jouney (id: "$journeyId") {
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

  String fetchJourneyDetailsByIdQuery(String journeyId) {
    return '''
      query {
        jouney (id: "$journeyId") {
          uuid
          name
          image
          description
          markerCount
          visibility
          markers {
            uuid
            name
            visibility
            description
            image
          }
        }
      }
      ''';
  }

  String createJourneyMutation(CreateJourneyDto createJourneyDto) {
    return '''
      mutation {
        createJouney(
          jouney:{
            name: "${createJourneyDto.name}", 
            ${transformString("description", createJourneyDto.description)}
            ${transformString("image", createJourneyDto.image)}
          }) 
        {
          uuid
          name
          visibility
        }
      }
      ''';
  }

  String updateJourneyMutation(UpdateJourneyDto updateJourneyDto) {
    return '''
      mutation {
        updateJouney(
          id: "${updateJourneyDto.journeyId}",
          jouney:{
            ${transformString("name", updateJourneyDto.name)}
            ${transformString("description", updateJourneyDto.description)}
            ${transformString("image", updateJourneyDto.image)}
            ${transformVisibility(updateJourneyDto.visibility)}
          }) 
        {
          uuid
          name
          image
          visibility
          description
          markerCount
          markers {
            uuid
            name
            visibility
            description
            image
          }
        }
      }
      ''';
  }

  Future<ResponseDto> fetchJourney(FetchJourneyDto? fetchJourneyDto) async {
    ////////////////////////////////////////
    final String readRepositories = fetchJourneyQuery(fetchJourneyDto);
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

  Future<ResponseDto> fetchJourneyById(String journeyId) async {
    ////////////////////////////////////////
    final String readRepositories = fetchJourneyByIdQuery(journeyId);
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

  Future<ResponseDto> fetchJourneyDetailsById(String journeyId) async {
    ////////////////////////////////////////
    final String readRepositories = fetchJourneyDetailsByIdQuery(journeyId);
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

  Future<ResponseDto> createJourney(CreateJourneyDto createJourneyDto) async {
    ////////////////////////////////////////
    final String readRepositories = createJourneyMutation(createJourneyDto);
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

  Future<ResponseDto> updateJourney(UpdateJourneyDto updateJourneyDto) async {
    ////////////////////////////////////////
    final String readRepositories = updateJourneyMutation(updateJourneyDto);
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
}
