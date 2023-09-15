import 'dart:math';
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  ThemeData createTheme(Brightness brightness) {
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
      theme: createTheme(Brightness.light),
      darkTheme: createTheme(Brightness.dark),
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
  var counter = 0;
  final db = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _initFirebase();
  }

  Future<void> _initFirebase() async {
    final fireDoc = db.collection('demo').doc('demo');
    fireDoc.snapshots().listen((event) {
      if (event.exists) {
        setState(() => counter = event.data()!['counter']);
      }
    });
  }

  void _incrementCounter() => updateCounter(counter + 1);
  void _decrementCounter() => updateCounter(counter - 1);
  void _resetCounter() => updateCounter(null);

  void updateCounter(int? count) async {
    final fireDoc = db.collection('demo').doc('demo');
    if (count == null) {
      await fireDoc.update({'counter': 0});
    } else {
      if (count > counter) {
        await fireDoc.update({'counter': FieldValue.increment(1)});
      } else {
        await fireDoc.update({'counter': FieldValue.increment(-1)});
      }
    }
  }

  (Offset offset, double size, double speed) calculateLocation(
      Offset maxSize, int index) {
    final random = Random(index);
    final size = max(30.0, 90.0 * random.nextDouble());
    final speed = random.nextDouble();
    final offset = Offset(random.nextDouble(), random.nextDouble());
    final normalizedOffset = offset.scale(maxSize.dx - size, maxSize.dy - size);
    return (normalizedOffset, size, speed);
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final shadow = Shadow(
      blurRadius: 0.1,
      color: colors.surface,
      offset: const Offset(1.0, 1.0),
    );
    final numberDescriptionStyle = textTheme.headlineMedium!.copyWith(
      shadows: [shadow],
    );
    final numberStyle = textTheme.displaySmall?.copyWith(
      fontWeight: FontWeight.bold,
      fontSize: 96,
      shadows: [shadow],
    );
    final gridColor = colors.outline.withOpacity(0.50);

    final size = MediaQuery.of(context).size;
    final padding = MediaQuery.of(context).padding;
    final maxSize = (size - padding.collapsedSize) as Offset;

    final logos = List<Widget>.generate(counter, (index) {
      final (offset, radius, speed) = calculateLocation(maxSize, index);
      return AnimatedPositioned.fromRect(
        duration: kThemeAnimationDuration,
        rect: offset & Size.square(radius),
        child: LogoWidget(speed: speed),
      );
    });

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar.large(
            backgroundColor: colors.inversePrimary,
            title: const Text('Flutter Counter'),
            actions: [
              IconButton(
                tooltip: 'Reset Counter',
                icon: const Icon(Icons.restore),
                onPressed: counter <= 0
                    ? null
                    : () => showDialog(
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
                        ),
              ),
            ],
          ),
          SliverFillRemaining(
            hasScrollBody: false,
            child: SizedBox.expand(
              child: Stack(
                children: [
                  Positioned.fill(child: GridPaper(color: gridColor)),
                  ...logos,
                  Positioned.fill(
                    child: CounterWidget(
                      numberDescriptionStyle: numberDescriptionStyle,
                      counter: counter,
                      numberStyle: numberStyle,
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
            onPressed: counter == 0 ? null : _decrementCounter,
            tooltip: 'Decrement',
            child: const Icon(Icons.remove),
          ),
        ],
      ),
    );
  }
}

class CounterWidget extends StatelessWidget {
  const CounterWidget({
    super.key,
    required this.numberDescriptionStyle,
    required this.counter,
    required this.numberStyle,
  });

  final TextStyle numberDescriptionStyle;
  final int counter;
  final TextStyle? numberStyle;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text(
          'Distributed Counter:',
          style: numberDescriptionStyle,
        ),
        Text(
          '$counter',
          style: numberStyle,
        ),
      ],
    );
  }
}

class LogoWidget extends StatefulWidget {
  const LogoWidget({super.key, required this.speed});

  final double speed;

  @override
  State<LogoWidget> createState() => _LogoWidgetState();
}

class _LogoWidgetState extends State<LogoWidget> {
  double turns = Random().nextDouble();
  late Timer timer;

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(
      Duration(milliseconds: max(300, 500 * widget.speed).round()),
      (_) => _changeRotation(),
    );
  }

  void _changeRotation() {
    setState(() => turns += 1.0 / 8.0);
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
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
