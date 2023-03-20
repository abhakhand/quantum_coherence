import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quantum_coherence/src/auth/bloc/auth_bloc.dart';
import 'package:quantum_coherence/src/auth/views/login_view.dart';
import 'package:quantum_coherence/src/home/views/home_view.dart';

class StartupView extends StatefulWidget {
  const StartupView({super.key});

  @override
  State<StartupView> createState() => _StartupViewState();
}

class _StartupViewState extends State<StartupView> {
  double logoScale = 0;

  @override
  void initState() {
    super.initState();
    Future<void>.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        logoScale = 1;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state.authStatus == AuthStatus.authenticated) {
            context.read<AuthBloc>().add(UserRequested());
            Navigator.of(context).pushReplacement<void, void>(
              MaterialPageRoute(
                builder: (context) => const HomeView(),
              ),
            );
          }

          if (state.authStatus == AuthStatus.unauthenticated) {
            Navigator.of(context).pushReplacement<void, void>(
              MaterialPageRoute(
                builder: (context) => const LoginView(),
              ),
            );
          }
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AnimatedScale(
              duration: const Duration(milliseconds: 350),
              scale: logoScale,
              curve: Curves.easeIn,
              child: const Hero(
                tag: 'Logo',
                child: FlutterLogo(size: 70),
              ),
            ),
            const SizedBox(height: 12),
            AnimatedScale(
              duration: const Duration(milliseconds: 350),
              scale: logoScale,
              curve: Curves.easeIn,
              child: Hero(
                tag: 'Logo Text',
                child: Text(
                  'Quantum Coherence',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
