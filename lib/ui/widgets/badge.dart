import 'package:flutter/material.dart';

class Badge extends StatelessWidget {
  final int value;

  const Badge({Key? key, required this.value}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: value > 0,
      child: Container(
        width: 16,
        height: 16,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          shape: BoxShape.circle,
        ),
        child: Text(
          value.toString(),
          style: TextStyle(
              color: Theme.of(context).colorScheme.onPrimary, fontSize: 11),
        ),
      ),
    );
  }
}
