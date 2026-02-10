import 'package:flutter/material.dart';

class HeroScreen extends StatelessWidget {
  const HeroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Hero Animation'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Tap on any image to see Hero animation',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 20),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemCount: 6,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HeroDetailScreen(
                            tag: 'hero-$index',
                            color: _getColor(index),
                            index: index,
                          ),
                        ),
                      );
                    },
                    child: Hero(
                      tag: 'hero-$index',
                      child: Container(
                        decoration: BoxDecoration(
                          color: _getColor(index),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Icon(
                            _getIcon(index),
                            size: 50,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getColor(int index) {
    final colors = [
      Colors.blue,
      Colors.red,
      Colors.green,
      Colors.purple,
      Colors.orange,
      Colors.teal,
    ];
    return colors[index % colors.length];
  }

  IconData _getIcon(int index) {
    final icons = [
      Icons.favorite,
      Icons.star,
      Icons.rocket_launch,
      Icons.emoji_emotions,
      Icons.wb_sunny,
      Icons.flight,
    ];
    return icons[index % icons.length];
  }
}

class HeroDetailScreen extends StatelessWidget {
  final String tag;
  final Color color;
  final int index;

  const HeroDetailScreen({
    super.key,
    required this.tag,
    required this.color,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Hero(
              tag: tag,
              child: Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                  child: Icon(
                    _getIcon(index),
                    size: 120,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
            Text(
              'Item ${index + 1}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'This is a Hero animation demo',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getIcon(int index) {
    final icons = [
      Icons.favorite,
      Icons.star,
      Icons.rocket_launch,
      Icons.emoji_emotions,
      Icons.wb_sunny,
      Icons.flight,
    ];
    return icons[index % icons.length];
  }
}
