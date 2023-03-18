import 'package:flutter/material.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quantum Coherence',
      theme: ThemeData(primarySwatch: Colors.green),
      home: WelcomeView(),
    );
  }
}
