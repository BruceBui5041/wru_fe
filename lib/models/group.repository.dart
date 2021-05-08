import 'dart:convert';
import 'package:graphql/client.dart';
import 'package:wru_fe/dto/create_group.dto.dart';
import 'package:wru_fe/dto/fetch_group.dto.dart';
import 'package:wru_fe/dto/response.dto.dart';

class GroupRepository {
  final GraphQLClient client;

  GroupRepository({required this.client});

  Future<ResponseDto> fetchGroup(FetchGroupDto fetchGroupDto) async {
    ////////////////////////////////////////
    String readRepositories = '''
      query {
        fetchMyGroups(fetchingOptions: { 
          own: ${fetchGroupDto.own}, 
          ids: ${json.encode(fetchGroupDto.ids)} 
        }) {
          uuid
          groupName
          createdAt
          groupImageUrl
          description
          owner {
            uuid
            username
            email
            profile {
              uuid
              avatarUrl
            }
          }
        }
      }
      ''';
    /////////////////////////////////////////

    final QueryOptions options = QueryOptions(
      documentNode: gql(readRepositories),
    );

    QueryResult result = await this.client.query(options);

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

  Future<ResponseDto> createGroup(CreateGroupDto input) async {
    ////////////////////////////////////////
    String readRepositories = '''
      mutation {
        createGroup(createGroupInput: {
          groupName: "${input.groupName}", 
          description: "${input.description}"
        }){
          groupName
          groupImageUrl
          description
        }
      }
      ''';
    /////////////////////////////////////////

    print(readRepositories);
    final MutationOptions options = MutationOptions(
      documentNode: gql(readRepositories),
    );

    QueryResult result = await this.client.mutate(options);

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
