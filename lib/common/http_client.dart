import 'package:dio/dio.dart';
import 'package:nike_ecommerce/data/repo/auth_repository.dart';

final httpClient =
    Dio(BaseOptions(baseUrl: 'http://expertdevelopers.ir/api/v1/'))
      ..interceptors.add(InterceptorsWrapper(
        onRequest: (options, handler) {
          {
            final authInfo = AuthRepository.authChangeNotifire.value;

            if (authInfo != null && authInfo.accessToken.isNotEmpty) {
              options.headers['Authorization'] =
                  'Bearer ${authInfo.accessToken}';
            }

            handler.next(options);
          }
        },
      ));
