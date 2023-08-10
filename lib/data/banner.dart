class BannerEntity {
  final int id;
  final String image;

  BannerEntity.fromJsoin(Map<String, dynamic> json):
  id = json['id'],
  image = json['image'];
}