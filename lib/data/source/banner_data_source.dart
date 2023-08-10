import 'package:nike_ecommerce/common/http_response_validator.dart';
import '../banner.dart';
import 'package:dio/dio.dart';

abstract class IBannerDataSource {
  Future<List<BannerEntity>> getAll();
}

class BannerRemoteDataSource with HttpResponseValidation implements IBannerDataSource {
  final Dio httpClient;

  BannerRemoteDataSource(this.httpClient);

  @override
  Future<List<BannerEntity>> getAll() async {
    final response = await httpClient.get('banner/slider');
    validateResposnse(response);
    final banners = <BannerEntity>[];
    (response.data as List).forEach((element) {
      banners.add(BannerEntity.fromJsoin(element));
    });

    return banners;
  }

}
