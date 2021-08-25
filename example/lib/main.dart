import 'dart:math' as math;

import 'package:example/card_data.dart';
import 'package:flutter/material.dart';
import 'package:swipeable_stack/swipeable_stack.dart';

import 'card_label.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.red,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const Home(),
    );
  }
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late final _controller = SwipeableStackController<CardData>();
  var _cards = CardData.initialDeck();

  String? _inputText;

  String get _ids => '[${_cards.map((cp) => cp.id).join(',')}]';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: FittedBox(
          child: Text(
            'Shuwipe',
          ),
        ),
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: constraints,
                child: Column(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: SwipeableStack<CardData>(
                          stackClipBehaviour: Clip.none,
                          controller: _controller,
                          dataSet: _cards,
                          overlayBuilder: (
                            context,
                            constraints,
                            data,
                            direction,
                            swipeProgress,
                          ) {
                            final opacity = math.min<double>(swipeProgress, 1);

                            final isRight = direction == SwipeDirection.right;
                            final isLeft = direction == SwipeDirection.left;
                            final isUp = direction == SwipeDirection.up;
                            final isDown = direction == SwipeDirection.down;
                            return Padding(
                              padding: const EdgeInsets.all(48),
                              child: Stack(
                                children: [
                                  Opacity(
                                    opacity: isRight ? opacity : 0,
                                    child: CardLabel.right(),
                                  ),
                                  Opacity(
                                    opacity: isLeft ? opacity : 0,
                                    child: CardLabel.left(),
                                  ),
                                  Opacity(
                                    opacity: isUp ? opacity : 0,
                                    child: CardLabel.up(),
                                  ),
                                ],
                              ),
                            );
                          },
                          builder: (context, data, constraints) {
                            return Center(
                              child: ConstrainedBox(
                                constraints: constraints,
                                child: Center(
                                  child: Stack(
                                    children: [
                                      Positioned.fill(
                                        child: Image.asset(
                                          data.path,
                                          height: constraints.maxHeight,
                                        ),
                                      ),
                                      Center(
                                        child: CircleAvatar(
                                          backgroundColor: Colors.white,
                                          child: Text(data.id),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _button(
                          onPressed: _controller.rewind,
                          color: Colors.black,
                          label: 'Back',
                        ),
                        _button(
                          onPressed: () => _controller.next(
                            swipeDirection: SwipeDirection.left,
                          ),
                          color: Colors.black,
                          label: 'UNLIKE',
                        ),
                        _button(
                          onPressed: () => _controller.next(
                            swipeDirection: SwipeDirection.up,
                          ),
                          color: Colors.black,
                          label: 'SuperLIKE',
                        ),
                        _button(
                          onPressed: () => _controller.next(
                            swipeDirection: SwipeDirection.right,
                          ),
                          color: Colors.black,
                          label: 'LIKE',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _button({
    required Color color,
    required String label,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        primary: color,
      ),
      child: Text(label),
    );
  }
}
