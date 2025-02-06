import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: SquareAnimation(),
      ),
    );
  }
}

class SquareAnimation extends StatefulWidget {
  const SquareAnimation({super.key});

  @override
  State<SquareAnimation> createState() => _SquareAnimationState();
}

class _SquareAnimationState extends State<SquareAnimation> {
  static const double squareSize = 50.0;
  double screenWidth = 0;
  double position = 0;
  bool isMoving = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    setState(() {
      // MediaQuery used for getting width dynamically
      screenWidth = MediaQuery.sizeOf(context).width;

      // Start at center position
      position = (screenWidth - squareSize) / 2;
    });
  }

  void _moveSquare(bool moveRight) {
    if (isMoving) return;

    setState(() {
      isMoving = true;    // Button disabled while Square is moving
      position = moveRight ? (screenWidth - squareSize) : 0;
    });

    Future.delayed(const Duration(seconds: 1), () {
      setState(() => isMoving = false);
    });
  }

  // Helpers for moving square to left and right
  bool moveLeft() => !isMoving && position > 0;
  bool moveRight() => !isMoving && position < screenWidth - squareSize;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // AnimatedPositioned used for animating square movement
        AnimatedPositioned(
          duration: const Duration(seconds: 1),
          curve: Curves.easeInOut,
          left: position,
          top: (MediaQuery.of(context).size.height - squareSize) / 2,
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(),
              color: Colors.red
            ),
            width: squareSize,
            height: squareSize,

          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 150),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: moveLeft() ? () => _moveSquare(false) : null,
                  child: const Text('Left'),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: moveRight() ? () => _moveSquare(true) : null,
                  child: const Text('Right'),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
