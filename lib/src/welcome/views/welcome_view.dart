import 'package:flutter/material.dart';

class WelcomeView extends StatelessWidget {
  const WelcomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Column(
        children: [
          const Expanded(child: Text('')),
          Expanded(child: Row()),
        ],
      ),
    );
  }
}
