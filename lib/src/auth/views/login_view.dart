import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quantum_coherence/src/auth/bloc/auth_bloc.dart';
import 'package:quantum_coherence/src/welcome/views/welcome_view.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Spacer(),
                const Hero(tag: 'Logo', child: FlutterLogo(size: 70)),
                const SizedBox(height: 12),
                Hero(
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
                const Spacer(flex: 2),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    context.read<AuthBloc>().add(LoggedInWithGoogle());
                  },
                  child: const Text(
                    'Login With Google',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          BlocConsumer<AuthBloc, AuthState>(
            listenWhen: (p, c) => p.loginStatus != c.loginStatus,
            listener: (context, state) {
              if (state.loginStatus.isSuccess) {
                Navigator.of(context).pushReplacement<void, void>(
                  MaterialPageRoute(
                    builder: (context) => const WelcomeView(),
                  ),
                );
              }
            },
            builder: (context, state) {
              if (state.loginStatus.isLoading) {
                return const SizedBox.expand(
                  child: ColoredBox(
                    color: Colors.black45,
                    child: Center(
                      child: CircularProgressIndicator.adaptive(),
                    ),
                  ),
                );
              }

              return const SizedBox.shrink();
            },
          ),
        ],
      ),
    );
  }
}
