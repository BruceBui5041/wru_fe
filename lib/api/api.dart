import 'package:http/http.dart' as http;
import 'package:wru_fe/global_constants.dart';
import 'dart:convert';
import 'package:flutter/foundation.dart';

// ignore: non_constant_identifier_names
final SIGNUP_API = API_URL + '/auth/signup';
// ignore: non_constant_identifier_names
final SIGNIN_API = API_URL + '/auth/signin';
// ignore: non_constant_identifier_names
final VERIFY_TOKEN = API_URL + '/auth/verify_token';

// ignore: non_constant_identifier_names
final GRAPHQL_API = API_URL + '/graphql';

Future<http.Response> publicPostRequest({
  @required String url,
  @required Map<String, dynamic> body,
}) {
  return http.post(
    url,
    headers: {
      "Content-Type": 'application/json',
    },
    body: json.encode(body),
  );
}

Future<http.Response> postRequest({
  @required String url,
  @required Map<String, dynamic> body,
  @required String jwtToken,
}) {
  return http.post(
    url,
    headers: {
      "Content-Type": 'application/json',
      "Authorization": 'Bearer $jwtToken'
    },
    body: json.encode(body),
  );
}
