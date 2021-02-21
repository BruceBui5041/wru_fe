import 'package:graphql/client.dart';
import 'package:wru_fe/dto/response.dto.dart';

class GroupRepository {
  final GraphQLClient client;

  GroupRepository({this.client});

  Future<ResponseDto> fetchGroup() async {
    ////////////////////////////////////////
    const String readRepositories = r'''
        query{
        fetchMyGroups(fetchingOptions:{}) {
          groupName
          owner{
            username
          }
        }
      }
      ''';
    /////////////////////////////////////////

    final QueryOptions options =
        QueryOptions(documentNode: gql(readRepositories));

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
      errorCode: "200",
      message: "Get data success!",
      result: result.data,
    );
  }
}
