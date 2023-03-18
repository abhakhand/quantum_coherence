import 'package:flutter/material.dart';
import 'package:quantum_coherence/src/welcome/views/welcome_view.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quantum Coherence',
      theme: ThemeData(primarySwatch: Colors.green),
      home: const WelcomeView(),
    );
  }
}
