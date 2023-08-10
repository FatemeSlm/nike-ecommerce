import 'package:dio/dio.dart';
import 'package:nike_ecommerce/common/constants.dart';
import 'package:nike_ecommerce/common/http_response_validator.dart';
import 'package:nike_ecommerce/data/auth_info.dart';

abstract class IAuthDataSource {
  Future<AuthInfo> login(String username, String password);
  Future<AuthInfo> register(String username, String password);
  Future<AuthInfo> refreshToken(String toekn);
}

class AuthRemoteDataSource
    with HttpResponseValidation
    implements IAuthDataSource {
  final Dio httpClient;

  AuthRemoteDataSource(this.httpClient);

  @override
  Future<AuthInfo> login(String username, String password) async {
    final response = await httpClient.post('auth/token', data: {
      'grant_type': 'password',
      'client_id': 2,
      'client_secret': Constants.clientSceret,
      'username': username,
      'password': password
    });
    validateResposnse(response);
    return AuthInfo(
        response.data['access_token'], response.data['refresh_token'], username);
  }

  @override
  Future<AuthInfo> refreshToken(String toekn) async {
    final response = await httpClient.post('auth/token', data: {
      'grant_type': 'refresh_token',
      'client_id': 2,
      'client_secret': Constants.clientSceret,
      'refresh_token': toekn
    });
    validateResposnse(response);
    return AuthInfo(
        response.data['access_token'], response.data['refresh_token'], '');
  }

  @override
  Future<AuthInfo> register(String username, String password) async {
    final response = await httpClient
        .post('user/register', data: {'email': username, 'password': password});
    validateResposnse(response);
    return login(username, password);
  }
}
