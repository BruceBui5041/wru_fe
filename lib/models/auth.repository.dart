import 'dart:io';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:wru_fe/api.dart';
import 'package:wru_fe/dto/response.dto.dart';
import 'package:wru_fe/dto/signin.dto.dart';
import 'dart:convert';

import 'package:wru_fe/dto/signup.dto.dart';

enum AuthenticationStatus { unknown, authenticated, unauthenticated }

class AuthRepository {
  Future<ResponseDto> callSignInApi(SignInDto signInDto) async {
    try {
      final res = await publicPostRequest(
        url: SIGNIN_API,
        body: {
          'username': signInDto.username,
          'password': signInDto.password,
        },
      );

      final resJSON = json.decode(res.body) as Map<String, dynamic>;

      return ResponseDto(
        error: resJSON['error'],
        message: resJSON['message'],
        result: resJSON['accessToken'] as String,
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
          'username': signUpDto.username,
          'password': signUpDto.password,
          'confirmPassword': signUpDto.confirmPassword,
        },
      );

      final resJSON = json.decode(res.body) as Map<String, dynamic>;

      return ResponseDto(
        error: resJSON['error'],
        message: resJSON['message'],
        result: resJSON['accessToken'] as String,
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
      if (resJSON['statusCode'] == HttpStatus.unauthorized) return false;
      return true;
    } catch (err) {
      throw err;
    }
  }

  Future<String> getStoredAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('accessToken');
  }

  Future<void> saveAccessToken(String accessToken) async {
    assert(accessToken.isEmpty == false);
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('accessToken', accessToken);
  }
}