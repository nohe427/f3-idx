import 'dart:math';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  ThemeData _buildTheme(Brightness brightness) {
    const seed = Color(0xFFFFCA28);
    final colors = ColorScheme.fromSeed(
      seedColor: seed,
      brightness: brightness,
    );
    return ThemeData(
      colorScheme: colors,
      useMaterial3: true,
      brightness: brightness,
      textTheme: GoogleFonts.spaceMonoTextTheme().apply(
        bodyColor: colors.onBackground,
        displayColor: colors.onBackground,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Counter',
      debugShowCheckedModeBanner: false,
      theme: _buildTheme(Brightness.light),
      darkTheme: _buildTheme(Brightness.dark),
      home: const CounterExample(),
    );
  }
}

class CounterExample extends StatefulWidget {
  const CounterExample({super.key});

  @override
  State<CounterExample> createState() => _CounterExampleState();
}

class _CounterExampleState extends State<CounterExample>
    with SingleTickerProviderStateMixin {
  final _locations = <(Offset, double, double)>[];

  void _incrementCounter() {
    final random = Random();
    const minValue = -0.0;
    const maxValue = 1.0;

    final newOffset = Offset(
      random.nextDouble() * (maxValue - minValue) + minValue,
      random.nextDouble() * (maxValue - minValue) + minValue,
    );
    final newSize = max(30.0, 60.0 * random.nextDouble());
    final newSpeed = random.nextDouble();

    setState(() {
      _locations.add((newOffset, newSize, newSpeed));
    });
  }

  void _decrementCounter() {
    if (_locations.isEmpty) return;

    setState(() {
      _locations.removeLast();
    });
  }

  void _resetCounter() {
    if (_locations.isEmpty) return;

    setState(() {
      _locations.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar.large(
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            title: const Text('Flutter Counter'),
            actions: [
              IconButton(
                tooltip: 'Reset Counter',
                icon: const Icon(Icons.restore),
                onPressed: _locations.isEmpty
                    ? null
                    : () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog.adaptive(
                            title: const Text('Reset Counter'),
                            content: const Text('Are you sure?'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(),
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  _resetCounter();
                                },
                                child: const Text('Reset'),
                              ),
                            ],
                          ),
                        );
                      },
              ),
            ],
          ),
          SliverFillRemaining(
            hasScrollBody: false,
            child: SizedBox.expand(
              child: Stack(
                children: [
                  Positioned.fill(
                    child: GridPaper(
                      color: Theme.of(context)
                          .colorScheme
                          .outline
                          .withOpacity(0.58),
                    ),
                  ),
                  for (final (offset, radius, speed) in _locations)
                    Builder(builder: (context) {
                      final size = MediaQuery.of(context).size;
                      final normalizeOffset = Offset(
                        size.width * offset.dx,
                        size.height * offset.dy,
                      );
                      return AnimatedPositioned.fromRect(
                        duration: kThemeAnimationDuration,
                        rect: normalizeOffset & Size.square(radius),
                        child: PreviewWidget(speed: speed),
                      );
                    }),
                  Positioned.fill(
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Text(
                              'Distrubted Counter Value:',
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineSmall!
                                  .copyWith(
                                shadows: const [
                                  Shadow(
                                    blurRadius: 0.1,
                                    color: Colors.white,
                                    offset: Offset(1.0, 1.0),
                                  ),
                                ],
                              ),
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              '${_locations.length}',
                              style: Theme.of(context)
                                  .textTheme
                                  .displaySmall
                                  ?.copyWith(
                                fontWeight: FontWeight.bold,
                                shadows: const [
                                  Shadow(
                                    blurRadius: 0.1,
                                    color: Colors.white,
                                    offset: Offset(1.0, 1.0),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton.small(
            onPressed: _incrementCounter,
            tooltip: 'Increment',
            child: const Icon(Icons.add),
          ),
          const SizedBox(width: 10),
          FloatingActionButton.small(
            onPressed: _locations.isEmpty ? null : _decrementCounter,
            tooltip: 'Decrement',
            child: const Icon(Icons.remove),
          ),
        ],
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class PreviewWidget extends StatefulWidget {
  const PreviewWidget({super.key, required this.speed});

  final double speed;

  @override
  State<PreviewWidget> createState() => _PreviewWidgetState();
}

class _PreviewWidgetState extends State<PreviewWidget> {
  double turns = Random().nextDouble();

  @override
  void initState() {
    super.initState();
    Timer.periodic(Duration(milliseconds: max(300, 500 * widget.speed).round()),
        (_) {
      _changeRotation();
    });
  }

  void _changeRotation() {
    setState(() => turns += 1.0 / 8.0);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedRotation(
      turns: turns,
      duration: const Duration(seconds: 1),
      child: const FlutterLogo(),
    );
  }
}
