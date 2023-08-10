import 'package:flutter/foundation.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:nike_ecommerce/data/product.dart';

final favoriteManager = FavoriteManager();

class FavoriteManager {
  static const _boxName = 'favorites';
  final _box = Hive.box<Product>(_boxName);

  ValueListenable<Box<Product>> get listenable => _box.listenable();

  static init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(ProductAdapter());
    Hive.openBox<Product>(_boxName);
  }

  void addFavorite(Product product) {
    _box.put(product.id, product);
  }

  void deleteFavorite(Product product) {
    _box.delete(product.id);
  }

  List<Product> get favorites => _box.values.toList();

  bool isFavorite(Product product) {
    return _box.containsKey(product.id);
  }
}
