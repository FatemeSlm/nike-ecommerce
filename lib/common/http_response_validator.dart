import 'package:dio/dio.dart';
import 'package:nike_ecommerce/common/exceptions.dart';

mixin HttpResponseValidation {
  validateResposnse(Response response) {
    if (response.statusCode != 200) {
      throw AppException(message: response.data['message']);
    }
  }
}
