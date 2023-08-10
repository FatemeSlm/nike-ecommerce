import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nike_ecommerce/data/repo/comment_repository.dart';
import 'package:nike_ecommerce/ui/product/comment/bloc/commentlist_bloc.dart';
import 'package:nike_ecommerce/ui/product/comment/comment.dart';
import 'package:nike_ecommerce/ui/widgets/error.dart';

class CommentList extends StatelessWidget {
  final int productId;

  const CommentList({Key? key, required this.productId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (context) {
      final CommentListBloc bloc =
          CommentListBloc(productId: productId, repository: commentRepository);
      bloc.add(CommentListStarted());
      return bloc;
    }, child: BlocBuilder<CommentListBloc, CommentListState>(
      builder: (context, state) {
        if (state is CommentListSuccess) {
          return SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
            return CommentItem(commment: state.comments[index]);
          }, childCount: state.comments.length));
        } else if (state is CommentListLoading) {
          return const SliverToBoxAdapter(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else if (state is CommentListerror) {
          return SliverToBoxAdapter(
            child: AppErrorWidget(
              exception: state.exception,
              onPressed: () {
                BlocProvider.of<CommentListBloc>(context)
                    .add(CommentListStarted());
              },
            ),
          );
        } else {
          throw Exception('state is not supported');
        }
      },
    ));
  }
}


