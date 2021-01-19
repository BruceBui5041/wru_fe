import 'dart:io';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:wru_fe/api/api.dart';
import 'package:wru_fe/dto/response.dto.dart';
import 'package:wru_fe/dto/signin.dto.dart';
import 'dart:convert';

import 'package:wru_fe/dto/signup.dto.dart';

import '../utils.dart';

enum AuthenticationStatus { unknown, authenticated, unauthenticated }

class AuthRepository {
  static const tokenKey = 'accessToken';
  static const messageKey = 'message';
  static const errorKey = 'error';
  static const usernameKey = 'username';
  static const passwordKey = 'password';
  static const confirmPassworkKey = 'confirmPassword';
  static const statusCodeKey = 'statusCode';

  Future<ResponseDto> callSignInApi(SignInDto signInDto) async {
    try {
      final res = await publicPostRequest(
        url: SIGNIN_API,
        body: {
          usernameKey: signInDto.username,
          passwordKey: signInDto.password,
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
      final accessToken = await getStoredAccessToken();
      if (accessToken == null) return false;
      final res = await postRequest(
        url: VERIFY_TOKEN,
        body: {},
        jwtToken: accessToken,
      );

      final resJSON = json.decode(res.body) as Map<String, dynamic>;
      if (resJSON[statusCodeKey] == HttpStatus.unauthorized) return false;
      return true;
    } catch (err) {
      throw err;
    }
  }

  Future<String> getStoredAccessToken() async {
    return getValueFromSharePreference(tokenKey);
  }

  Future<void> saveAccessToken(String accessToken) async {
    assert(accessToken.isEmpty == false);
    setValueToSharePreference(tokenKey, accessToken);
  }
}
