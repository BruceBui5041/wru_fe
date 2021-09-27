import 'dart:convert';
import 'package:graphql/client.dart';
import 'package:wru_fe/dto/create_group.dto.dart';
import 'package:wru_fe/dto/fetch_group.dto.dart';
import 'package:wru_fe/dto/response.dto.dart';

class GroupRepository {
  GroupRepository({required this.client});
  final GraphQLClient client;

  String fetchGroupQuery(FetchGroupDto fetchGroupDto) {
    return '''
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
  }

  String fetchGroupMembersQuery(List<String> ids) {
    return '''
      query {
        fetchMyGroups(fetchingOptions: { 
          own: false, 
          ids: ${json.encode(ids)} 
        }) {
          uuid
          members {
            uuid
            username
            email
          }
        }
      }
      ''';
  }

  Future<ResponseDto> fetchGroup(FetchGroupDto fetchGroupDto) async {
    ////////////////////////////////////////
    final String readRepositories = fetchGroupQuery(fetchGroupDto);
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

  Future<ResponseDto> fetchGroupMembers(List<String> ids) async {
    ////////////////////////////////////////
    final String readRepositories = fetchGroupMembersQuery(ids);
    /////////////////////////////////////////

    print(readRepositories);
    final QueryOptions options = QueryOptions(
      document: gql(readRepositories),
    );

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

  Future<ResponseDto> createGroup(CreateGroupDto input) async {
    ////////////////////////////////////////
    const String readRepositories = r'''
      mutation {
        createGroup(createGroupInput: {
          groupName: "${input.groupName}", 
          description: "${input.description}"
        }){
          uuid
          groupName
          groupImageUrl
          description
        }
      }
      ''';
    /////////////////////////////////////////

    print(readRepositories);

    final MutationOptions options = MutationOptions(
      document: gql(readRepositories),
      variables: <String, dynamic>{},
    );

    final QueryResult result = await client.mutate(options);

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
