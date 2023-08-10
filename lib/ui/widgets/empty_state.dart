import 'package:flutter/material.dart';

class EmptyView extends StatelessWidget {
  final String message;
  final Widget? callToAction;
  final Widget image;

  const EmptyView(
      {Key? key, required this.message, this.callToAction, required this.image})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          image,
          Padding(
            padding:
                const EdgeInsets.only(left: 40, right: 40, top: 30, bottom: 16),
            child: Text(
              message,
              style:
                  Theme.of(context).textTheme.headline6!.copyWith(fontSize: 14),
              textAlign: TextAlign.center,
            ),
          ),
          if (callToAction != null) callToAction!
        ],
      ),
    );
  }
}
