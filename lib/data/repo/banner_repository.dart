import 'package:nike_ecommerce/common/http_client.dart';
import 'package:nike_ecommerce/data/banner.dart';
import 'package:nike_ecommerce/data/source/banner_data_source.dart';

final bannerRepository = BannerRepository(BannerRemoteDataSource(httpClient));

abstract class IBannerREpository {
  Future<List<BannerEntity>> getAll();
}

class BannerRepository implements IBannerREpository {
  final IBannerDataSource dataSource;

  BannerRepository(this.dataSource);

  @override
  Future<List<BannerEntity>> getAll() => dataSource.getAll();
}
