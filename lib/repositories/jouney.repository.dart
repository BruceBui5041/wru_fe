import 'package:graphql/client.dart';
import 'package:wru_fe/dto/create_jouney.dto.dart';
import 'package:wru_fe/dto/fetch_jouney.dto.dart';
import 'package:wru_fe/dto/response.dto.dart';
import 'package:wru_fe/dto/update_jouney.dto.dart';
import 'package:wru_fe/utils.dart';

class JouneyRepository {
  JouneyRepository({required this.client});
  final GraphQLClient client;

  String fetchJouneyQuery(FetchJouneyDto? fetchJouneyDto) {
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

  String fetchJouneyDetailsByIdQuery(String jouneyId) {
    return '''
      query {
        jouney (id: "$jouneyId") {
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

  String createJouneyMutation(CreateJouneyDto createJouneyDto) {
    return '''
      mutation {
        createJouney(
          jouney:{
            name: "${createJouneyDto.name}", 
            ${transformString("description", createJouneyDto.description)}
            ${transformString("image", createJouneyDto.image)}
          }) 
        {
          uuid
          name
          visibility
        }
      }
      ''';
  }

  String updateJouneyMutation(UpdateJouneyDto updateJouneyDto) {
    return '''
      mutation {
        updateJouney(
          id: "${updateJouneyDto.jouneyId}",
          jouney:{
            ${transformString("name", updateJouneyDto.name)}
            ${transformString("description", updateJouneyDto.description)}
            ${transformString("image", updateJouneyDto.image)}
            ${transformVisibility(updateJouneyDto.visibility)}
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

  Future<ResponseDto> fetchJouney(FetchJouneyDto? fetchJouneyDto) async {
    ////////////////////////////////////////
    final String readRepositories = fetchJouneyQuery(fetchJouneyDto);
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

  Future<ResponseDto> fetchJouneyById(String jouneyId) async {
    ////////////////////////////////////////
    final String readRepositories = fetchJouneyByIdQuery(jouneyId);
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

  Future<ResponseDto> fetchJouneyDetailsById(String jouneyId) async {
    ////////////////////////////////////////
    final String readRepositories = fetchJouneyDetailsByIdQuery(jouneyId);
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

  Future<ResponseDto> createJouney(CreateJouneyDto createJouneyDto) async {
    ////////////////////////////////////////
    final String readRepositories = createJouneyMutation(createJouneyDto);
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

  Future<ResponseDto> updateJouney(UpdateJouneyDto updateJouneyDto) async {
    ////////////////////////////////////////
    final String readRepositories = updateJouneyMutation(updateJouneyDto);
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
