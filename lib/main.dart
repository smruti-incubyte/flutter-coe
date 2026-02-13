import 'package:firebase_core/firebase_core.dart' show Firebase;
import 'package:flutter/material.dart';
import 'package:flutter_coe/firebase_options.dart' show DefaultFirebaseOptions;
import 'screens/home_screen.dart';
import 'screens/responsive_navigation_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter CoE',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      // Start directly with the responsive navigation screen
      home: const ResponsiveNavigationScreen(),
      routes: {
        '/home': (context) => const HomeScreen(),
        '/responsive': (context) => const ResponsiveNavigationScreen(),
      },
    );
  }
}
