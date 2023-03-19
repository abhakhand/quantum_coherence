import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quantum_coherence/app/injector/injector.dart';
import 'package:quantum_coherence/src/auth/bloc/auth_bloc.dart';
import 'package:quantum_coherence/src/startup/startup_view.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<AuthBloc>()..add(AuthStatusChecked()),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Quantum Coherence',
        theme: ThemeData(
          primarySwatch: Colors.green,
          fontFamily: 'Poppins',
        ),
        home: const StartupView(),
      ),
    );
  }
}
