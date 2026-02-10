# Flutter Animations Guide

## Overview

There are two main types of animations in Flutter:

1. **Drawing-based animations** - Created in design tools and exported
2. **Code-based animations** - Written programmatically in Dart

---

## 1. Drawing-Based Animations

Drawing-based animations are created using design tools and then imported into Flutter. This approach is ideal for complex vector animations, character animations, or animations designed by non-developers.

### Popular Tools

#### Lottie

JSON-based animations exported from Adobe After Effects using the Bodymovin plugin.

**Add dependency:**
```yaml
# pubspec.yaml
dependencies:
  lottie: ^3.0.0
```

**Example:**
```dart
import 'package:lottie/lottie.dart';

// Load from assets
Lottie.asset('assets/animations/loading.json')

// Load from network
Lottie.network('https://example.com/animation.json')

// With controller
Lottie.asset(
  'assets/animations/success.json',
  repeat: false,
  animate: true,
)
```

#### Rive

Interactive animations with state machines, created in Rive editor.

**Add dependency:**
```yaml
# pubspec.yaml
dependencies:
  rive: ^0.13.0
```

**Example:**
```dart
import 'package:rive/rive.dart';

RiveAnimation.asset(
  'assets/animations/character.riv',
  fit: BoxFit.cover,
)

// With state machine
RiveAnimation.asset(
  'assets/animations/button.riv',
  stateMachines: ['State Machine 1'],
  onInit: (artboard) {
    // Access state machine inputs
  },
)
```

---

## 2. Code-Based Animations

Code-based animations are written in Dart and divided into two categories:

### 2.1 Implicit Animations

Implicit animations are **simple, built-in animations** that automatically animate between values. You just specify the target value and duration, and Flutter handles the animation automatically.

#### When to Use Implicit Animations

Use implicit animations when **ALL** of the following are true:
- Animation does **NOT** repeat forever
- Animation is **continuous** (not discontinuous/choppy)
- Only a **single widget** is being animated

#### Pattern

Implicit animations follow the naming pattern: **`AnimatedFoo`**

#### Common Examples

##### AnimatedContainer
Animates changes to container properties.

```dart
AnimatedContainer(
  duration: const Duration(seconds: 1),
  curve: Curves.easeInOut,
  width: _isExpanded ? 200 : 100,
  height: _isExpanded ? 200 : 100,
  color: _isExpanded ? Colors.blue : Colors.red,
  child: const Center(child: Text('Tap me')),
)
```

##### AnimatedOpacity
Animates opacity changes.

```dart
AnimatedOpacity(
  opacity: _isVisible ? 1.0 : 0.0,
  duration: const Duration(milliseconds: 500),
  child: const Text('Fading text'),
)
```

##### AnimatedPositioned
Animates position within a Stack.

```dart
Stack(
  children: [
    AnimatedPositioned(
      duration: const Duration(milliseconds: 300),
      left: _isMoved ? 100 : 0,
      top: _isMoved ? 100 : 0,
      child: Container(
        width: 50,
        height: 50,
        color: Colors.green,
      ),
    ),
  ],
)
```

##### Other Implicit Animations

- `AnimatedSize` - Animates size changes
- `AnimatedPadding` - Animates padding
- `AnimatedAlign` - Animates alignment
- `AnimatedDefaultTextStyle` - Animates text style
- `AnimatedCrossFade` - Crossfades between two widgets

#### TweenAnimationBuilder - Custom Implicit Animations

When you need a custom animation and don't find a built-in implicit animation widget, use `TweenAnimationBuilder`.

**Example - Animating a custom property:**
```dart
TweenAnimationBuilder<double>(
  tween: Tween<double>(begin: 0, end: 1),
  duration: const Duration(seconds: 2),
  builder: (context, value, child) {
    return Opacity(
      opacity: value,
      child: Transform.rotate(
        angle: value * 2 * pi,
        child: child,
      ),
    );
  },
  child: const Icon(Icons.star, size: 100),
)
```

**Example - Animating a color:**
```dart
TweenAnimationBuilder<Color?>(
  tween: ColorTween(begin: Colors.red, end: Colors.blue),
  duration: const Duration(seconds: 2),
  builder: (context, color, child) {
    return ColorFiltered(
      colorFilter: ColorFilter.mode(color!, BlendMode.modulate),
      child: child,
    );
  },
  child: const Icon(Icons.favorite, size: 100),
)
```

---

### 2.2 Explicit Animations

Explicit animations give you **full control** over the animation using an **`AnimationController`**. They require more setup but offer greater flexibility.

#### When to Use Explicit Animations

Use explicit animations if **ANY** of the following are true:

1. **Does the animation repeat forever?** (e.g., loading spinner)
2. **Is the animation discontinuous?** (e.g., jumping, bouncing with stops)
3. **Are multiple widgets being animated together?** (coordinated animations)

If any of these conditions are met, you need **explicit animations**.

#### AnimationController

The core of explicit animations. Requires a `TickerProvider` (usually from `SingleTickerProviderStateMixin` or `TickerProviderStateMixin`).

```dart
class _MyWidgetState extends State<MyWidget> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this, // Provides ticker
    );

    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _controller.repeat(reverse: true); // Repeat forever
  }

  @override
  void dispose() {
    _controller.dispose(); // Always dispose!
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animation,
      child: const Icon(Icons.star, size: 100),
    );
  }
}
```

#### Built-in Transition Widgets

Explicit animations follow the naming pattern: **`FooTransition`**

##### FadeTransition
```dart
FadeTransition(
  opacity: _animation,
  child: const Text('Fading text'),
)
```

##### ScaleTransition
```dart
ScaleTransition(
  scale: _animation,
  child: const Icon(Icons.favorite, size: 50),
)
```

##### SlideTransition
```dart
SlideTransition(
  position: Tween<Offset>(
    begin: const Offset(-1, 0),
    end: Offset.zero,
  ).animate(_controller),
  child: const Card(child: Padding(padding: EdgeInsets.all(16), child: Text('Slide in'))),
)
```

##### RotationTransition
```dart
RotationTransition(
  turns: _animation,
  child: const Icon(Icons.refresh, size: 50),
)
```

##### Other Transitions
- `SizeTransition` - Animates size
- `PositionedTransition` - Animates position in Stack
- `DecoratedBoxTransition` - Animates decoration
- `AlignTransition` - Animates alignment

#### AnimatedWidget

Create a custom widget that rebuilds when the animation changes.

```dart
class SpinningWidget extends AnimatedWidget {
  const SpinningWidget({
    super.key,
    required Animation<double> animation,
    required this.child,
  }) : super(listenable: animation);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final animation = listenable as Animation<double>;
    return Transform.rotate(
      angle: animation.value * 2 * pi,
      child: child,
    );
  }
}

// Usage
SpinningWidget(
  animation: _controller,
  child: const Icon(Icons.star, size: 100),
)
```

#### AnimatedBuilder

More flexible approach that separates animation logic from the widget tree. **Preferred over AnimatedWidget** in most cases.

```dart
AnimatedBuilder(
  animation: _controller,
  builder: (context, child) {
    return Transform.rotate(
      angle: _controller.value * 2 * pi,
      child: Opacity(
        opacity: _controller.value,
        child: child,
      ),
    );
  },
  child: const Icon(Icons.star, size: 100), // Built once, reused
)
```

**Benefits:**
- Child widget is built once and reused (performance)
- Can animate multiple properties easily
- More readable for complex animations

---

## 3. CustomPainter - Performance-Critical Animations

If you're experiencing **performance issues** with standard widgets and animations, or need to draw complex custom graphics, use `CustomPainter`.

`CustomPainter` draws directly to Flutter's **low-level Canvas API**, providing:
- Maximum performance
- Full control over rendering
- Ability to create complex custom shapes and animations

**When to use:**
- Complex custom graphics (charts, graphs, shapes)
- Performance-critical animations with many elements
- Drawing operations that can't be achieved with standard widgets
- Games and interactive visualizations

**Example - Animated Circle:**
```dart
class CirclePainter extends CustomPainter {
  final double progress;
  
  CirclePainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.fill;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 * progress;

    canvas.drawCircle(center, radius, paint);
  }

  @override
  bool shouldRepaint(CirclePainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}

// Usage with AnimationController
class AnimatedCircle extends StatefulWidget {
  const AnimatedCircle({super.key});

  @override
  State<AnimatedCircle> createState() => _AnimatedCircleState();
}

class _AnimatedCircleState extends State<AnimatedCircle>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          size: const Size(200, 200),
          painter: CirclePainter(_controller.value),
        );
      },
    );
  }
}
```

---

## Decision Flow

```
Animation Needed
    ├── Drawing-based? → Use Lottie or Rive
    └── Code-based?
        ├── Does it repeat forever? → YES → Explicit Animation
        ├── Is it discontinuous? → YES → Explicit Animation
        ├── Multiple widgets? → YES → Explicit Animation
        └── None of the above? → Implicit Animation
            ├── Built-in widget exists? → Use AnimatedFoo
            └── Custom needed? → Use TweenAnimationBuilder
```

---

## Performance Tips

1. **Use `const` constructors** when possible to avoid unnecessary rebuilds
2. **Dispose controllers** - Always dispose AnimationControllers in the dispose method
3. **Use `AnimatedBuilder`** - Keeps child widgets from rebuilding unnecessarily
4. **Prefer implicit over explicit** when possible - Less code, simpler to maintain
5. **Use `RepaintBoundary`** - Isolate animated widgets to prevent unnecessary repaints
6. **Profile your animations** - Use Flutter DevTools to identify performance bottlenecks

```dart
// Good: Child is built once
AnimatedBuilder(
  animation: _controller,
  builder: (context, child) {
    return Transform.rotate(
      angle: _controller.value,
      child: child, // Reused
    );
  },
  child: const ExpensiveWidget(), // Built once
)

// Bad: ExpensiveWidget rebuilds on every frame
AnimatedBuilder(
  animation: _controller,
  builder: (context, child) {
    return Transform.rotate(
      angle: _controller.value,
      child: const ExpensiveWidget(), // Rebuilt every frame!
    );
  },
)
```

---

## Common Animation Curves

Flutter provides many built-in curves to control animation easing:

```dart
Curves.linear         // Constant speed
Curves.easeIn         // Slow start, fast end
Curves.easeOut        // Fast start, slow end
Curves.easeInOut      // Slow start and end
Curves.bounceIn       // Bouncing effect at start
Curves.bounceOut      // Bouncing effect at end
Curves.elasticIn      // Elastic/spring effect at start
Curves.elasticOut     // Elastic/spring effect at end
Curves.fastOutSlowIn  // Material Design standard
```

**Usage:**
```dart
CurvedAnimation(
  parent: _controller,
  curve: Curves.elasticOut,
)
```

---

## Summary Table

| Type | Use Case | Setup Complexity | Examples |
|------|----------|------------------|----------|
| **Drawing-based** | Complex vector animations from design tools | Low (just import files) | Lottie, Rive |
| **Implicit Animations** | Simple, single-widget, one-time animations | Very Low (no controller) | AnimatedContainer, AnimatedOpacity |
| **TweenAnimationBuilder** | Custom implicit animations | Low (no controller) | Custom property tweening |
| **Explicit Animations** | Repeating, discontinuous, multi-widget | Medium (requires controller) | FadeTransition, AnimationController |
| **AnimatedBuilder** | Complex explicit animations with optimization | Medium (requires controller) | Multiple coordinated animations |
| **CustomPainter** | Performance-critical custom graphics | High (manual canvas drawing) | Charts, games, complex shapes |

---

## Quick Reference

### Choose Implicit When:
✅ Single widget animation  
✅ One-time or triggered animation  
✅ Continuous (smooth) animation  

### Choose Explicit When:
✅ Repeating forever  
✅ Discontinuous (choppy/stepped)  
✅ Multiple widgets together  
✅ Need precise control  

### Choose CustomPainter When:
✅ Performance issues with widgets  
✅ Custom graphics/shapes  
✅ Complex canvas operations  

---

## Additional Resources

- [Flutter Animation Documentation](https://docs.flutter.dev/development/ui/animations)
- [Animation Tutorial](https://docs.flutter.dev/development/ui/animations/tutorial)
- [Animation Samples](https://flutter.github.io/samples/animations.html)
- [Lottie Package](https://pub.dev/packages/lottie)
- [Rive Package](https://pub.dev/packages/rive)
