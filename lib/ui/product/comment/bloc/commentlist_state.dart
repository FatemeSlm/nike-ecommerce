part of 'commentlist_bloc.dart';

abstract class CommentListState extends Equatable {
  const CommentListState();

  @override
  List<Object> get props => [];
}

class CommentListLoading extends CommentListState {}

class CommentListSuccess extends CommentListState {
  final List<CommentEntity> comments;

  const CommentListSuccess(this.comments);

  @override
  List<Object> get props => [comments];
}

class CommentListerror extends CommentListState {
  final AppException exception;

  const CommentListerror(this.exception);

  @override
  List<Object> get props => [exception];
}
