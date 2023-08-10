import 'package:flutter/cupertino.dart';
import 'package:nike_ecommerce/common/http_client.dart';
import 'package:nike_ecommerce/data/auth_info.dart';
import 'package:nike_ecommerce/data/source/auth_data_source.dart';
import 'package:shared_preferences/shared_preferences.dart';

final authRepository = AuthRepository(AuthRemoteDataSource(httpClient));

abstract class IAuthRepository {
  Future<void> login(String username, String password);
  Future<void> register(String username, String password);
  Future<void> refreshToken();
  Future<void> signOut();
}

class AuthRepository implements IAuthRepository {
  final IAuthDataSource dataSource;
  static ValueNotifier<AuthInfo?> authChangeNotifire = ValueNotifier(null);

  AuthRepository(this.dataSource);

  @override
  Future<void> login(String username, String password) async {
    final authInfo = await dataSource.login(username, password);
    _persistAuthTokens(authInfo);
  }

  @override
  Future<void> refreshToken() async {
    if (authChangeNotifire.value != null) {
      final authInfo =
          await dataSource.refreshToken(authChangeNotifire.value!.refreshToken);
      _persistAuthTokens(authInfo);
    }
  }

  @override
  Future<void> register(String username, String password) async {
    final authInfo = await dataSource.register(username, password);
    _persistAuthTokens(authInfo);
  }

  Future<void> _persistAuthTokens(AuthInfo authInfo) async {
    final sp = await SharedPreferences.getInstance();
    sp.setString('access_token', authInfo.accessToken);
    sp.setString('refresh_token', authInfo.refreshToken);
    sp.setString('email', authInfo.email);
    loadAuthInfo();
  }

  Future<void> loadAuthInfo() async {
    final sp = await SharedPreferences.getInstance();
    final accessToken = sp.getString('access_token') ?? '';
    final refreshToken = sp.getString('refresh_token') ?? '';
    final email = sp.getString('email') ?? '';

    if (refreshToken.isNotEmpty && accessToken.isNotEmpty) {
      authChangeNotifire.value = AuthInfo(accessToken, refreshToken, email);
    }
  }

  @override
  Future<void> signOut() async {
    final sp = await SharedPreferences.getInstance();
    sp.clear();
    authChangeNotifire.value = null;
  }
}
