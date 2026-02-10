import 'package:flutter/material.dart';

class AnimationScreen extends StatefulWidget {
  const AnimationScreen({super.key});

  @override
  State<AnimationScreen> createState() => _AnimationScreenState();
}

class _AnimationScreenState extends State<AnimationScreen> {
  double _turns = 0.0;

  void _rotate() {
    setState(() {
      _turns += 1.0;
    });
  }

  void _reset() {
    setState(() {
      _turns = 0.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Animation'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedRotation(
              turns: _turns,
              duration: const Duration(milliseconds: 500),
              child: Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Icon(
                  Icons.star,
                  size: 80,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: _rotate,
              child: const Text('Rotate'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _reset,
              child: const Text('Reset'),
            ),
          ],
        ),
      ),
    );
  }
}
