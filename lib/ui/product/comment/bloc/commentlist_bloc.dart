import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:nike_ecommerce/common/exceptions.dart';
import 'package:nike_ecommerce/data/comment.dart';
import 'package:nike_ecommerce/data/repo/comment_repository.dart';

part 'commentlist_event.dart';
part 'commentlist_state.dart';

class CommentListBloc extends Bloc<CommentListEvent, CommentListState> {
  final ICommentRepository repository;
  final int productId;

  CommentListBloc({required this.repository, required this.productId})
      : super(CommentListLoading()) {
    on<CommentListEvent>((event, emit) async {
      emit(CommentListLoading());

      if (event is CommentListStarted) {
        try {
          final comments = await repository.getAll(productId: productId);

          emit(CommentListSuccess(comments));
        } catch (e) {
          emit(CommentListerror(e is AppException ? e : AppException()));
        }
      }
    });
  }
}
