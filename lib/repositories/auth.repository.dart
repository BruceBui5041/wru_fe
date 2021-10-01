import 'dart:io';

import 'package:http/http.dart';
import 'package:wru_fe/api/api.dart';
import 'package:wru_fe/dto/response.dto.dart';
import 'package:wru_fe/dto/signin.dto.dart';
import 'dart:convert';

import 'package:wru_fe/dto/signup.dto.dart';

import '../utils.dart';

enum AuthenticationStatus { unknown, authenticated, unauthenticated }

class AuthRepository {
  static const String tokenKey = 'accessToken';
  static const String messageKey = 'message';
  static const String errorKey = 'error';
  static const String usernameKey = 'username';
  static const String passwordKey = 'password';
  static const String confirmPassworkKey = 'confirmPassword';
  static const String statusCodeKey = 'statusCode';

  Future<ResponseDto> callSignInApi(SignInDto signInDto) async {
    try {
      final Response res = await publicPostRequest(
        url: SIGNIN_API,
        body: {
          usernameKey: signInDto.username,
          passwordKey: signInDto.password,
        },
      );

      final Map<String, dynamic> resJSON =
          json.decode(res.body) as Map<String, dynamic>;

      return ResponseDto(
        errorCode: resJSON[errorKey],
        message: resJSON[messageKey],
        result: resJSON[tokenKey] as String,
      );
    } catch (err) {
      rethrow;
    }
  }

  Future<ResponseDto> callSignUpApi(SignUpDto signUpDto) async {
    try {
      final res = await publicPostRequest(
        url: SIGNUP_API,
        body: {
          usernameKey: signUpDto.username,
          passwordKey: signUpDto.password,
          confirmPassworkKey: signUpDto.confirmPassword,
        },
      );

      final resJSON = json.decode(res.body) as Map<String, dynamic>;

      return ResponseDto(
        errorCode: resJSON[errorKey],
        message: resJSON[messageKey],
        result: resJSON[tokenKey] as String,
      );
    } catch (err) {
      throw err;
    }
  }

  Future<bool> isValidAccessToken() async {
    try {
      final String accessToken = getStoredAccessToken();
      if (accessToken == null) return false;
      final Response res = await postRequest(
        url: VERIFY_TOKEN,
        body: {},
        jwtToken: accessToken,
      );

      final Map<String, dynamic> resJSON =
          json.decode(res.body) as Map<String, dynamic>;
      if (resJSON[statusCodeKey] == HttpStatus.unauthorized) return false;
      return true;
    } catch (err) {
      rethrow;
    }
  }

  String getStoredAccessToken() {
    return getValueFromStore(tokenKey).toString();
  }

  void saveAccessToken(String accessToken) {
    assert(accessToken.isEmpty == false);
    setValueToStore(tokenKey, accessToken);
  }
}
