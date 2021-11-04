import 'package:http/http.dart' as http;
import 'package:wru_fe/global_constants.dart';
import 'dart:convert';

// ignore: non_constant_identifier_names
final Uri SIGNUP_API = Uri.parse('${API_URL!}/auth/signup');
// ignore: non_constant_identifier_names
final Uri SIGNIN_API = Uri.parse('${API_URL!}/auth/signin');
// ignore: non_constant_identifier_names
final Uri LOGOUT_API = Uri.parse('${API_URL!}/auth/logout');
// ignore: non_constant_identifier_names
final Uri VERIFY_TOKEN = Uri.parse('${API_URL!}/auth/verify_token');
// ignore: non_constant_identifier_names
final String GRAPHQL_API = '${API_URL!}/graphql';

Future<http.Response> publicPostRequest({
  required Uri url,
  required Map<String, dynamic> body,
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
  required Uri url,
  required Map<String, dynamic> body,
  required String jwtToken,
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
