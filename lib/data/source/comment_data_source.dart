import 'package:dio/dio.dart';
import 'package:nike_ecommerce/common/http_response_validator.dart';
import 'package:nike_ecommerce/data/comment.dart';

abstract class ICommentDataSource {
  Future<List<CommentEntity>> getAll(int productId);
}

class CommentRemoteDataSource
    with HttpResponseValidation
    implements ICommentDataSource {
  final Dio httpClient;

  CommentRemoteDataSource(this.httpClient);
  @override
  Future<List<CommentEntity>> getAll(int productId) async {
    final response = await httpClient.get('comment/list?product_id=$productId');

    validateResposnse(response);

    final List<CommentEntity> comments = [];

    (response.data as List).forEach((element) {
      comments.add(CommentEntity.formJson(element));
    });

    return comments;
  }
}
