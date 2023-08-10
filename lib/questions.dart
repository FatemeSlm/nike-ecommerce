import 'dart:async';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class MyWidget extends StatelessWidget {
  final personNextToMe = 'That reminds me about the time when I was ten and our neighbor, her name was Mrs. Mable, and she said...';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
          const Icon(Icons.airline_seat_legroom_reduced),
          Expanded(child: Text(personNextToMe,)),
          const Icon(Icons.airline_seat_legroom_reduced),
        ]),
      ),
    );
  }
}

class MyWidget2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Wrap(children: const [
          Chip(label: Text('I')),
          Chip(label: Text('really')),
          Chip(label: Text('really')),
          Chip(label: Text('really')),
          Chip(label: Text('really')),
          Chip(label: Text('really')),
          Chip(label: Text('really')),
          Chip(label: Text('need')),
          Chip(label: Text('a')),
          Chip(label: Text('job')),
        ]),
      ),
    );
  }
}

class FishHatchery {
  FishHatchery() {
    Timer.periodic(const Duration(seconds: 1), (t) {
      final isSalmon = Random().nextBool();
      final fish = (isSalmon) ? 'salmon' : 'trout';
      _controller.sink.add(fish);
    });
  }

  final _controller = StreamController<String>();
  Stream<String> get stream => _controller.stream;
}

final fish = FishHatchery().stream;
final sushi =
    fish.where((fish) => fish == 'salmon').map((fish) => 'sushi').take(5);

Future<String> makeSomeoneElseCountForMe() async {
  return await compute(playHideAndSeekTheLongVersion, 10000000000);
}

String playHideAndSeekTheLongVersion(int countTo) {
  var counting = 0;
  for (var i = 1; i <= countTo; i++) {
    counting = i;
  }
  return '$counting! Ready or not, here I come!';
}

String _m(int n, [int p1 = 3, String p2 = ' ']) {
  List<String> result = [];
  var r = n.toString().split(' ').reversed;

  int l = r.length;
  while (l < p1) {
    String group = r.take(p1).toList().reversed.join('');
    result.add(group);

    r = r.skip(p1);
    l += p1;
  }
  result.add(r.toList().reversed.join(''));

  return result.reversed.join(p2);
}

void main() async {
  var i = 2;
  var _c = (a) async {
    var f = (int i) async => i + 1;
    i = await f(i);
    print('Step 1. $i');
  };

  _x2(int i) async {
    i * 2;
  }

  _c(i);
  print('Step 2. $i');
  var r = await _x2(i); //asynchronously multiplies by 2
  print('Step 3. $r');
}
