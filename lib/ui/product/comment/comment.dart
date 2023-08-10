import 'package:flutter/material.dart';
import 'package:nike_ecommerce/data/comment.dart';

class CommentItem extends StatelessWidget {
  final CommentEntity commment;
  const CommentItem({
    Key? key,
    required this.commment,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    return Container(
      decoration:
          BoxDecoration(border: Border.all(
            color: themeData.dividerColor, 
            width: 1),
            borderRadius: BorderRadius.circular(4)),
      margin: const EdgeInsets.fromLTRB(8, 0, 8, 8),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(commment.title),
                  Text(
                    commment.email,
                    style: themeData.textTheme.caption,
                  )
                ],
              ),
              Text(commment.date, style: themeData.textTheme.caption)
            ],
          ),
          const SizedBox(
            height: 12,
          ),
          Text(commment.content)
        ],
      ),
    );
  }
}