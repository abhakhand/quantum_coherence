import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:quantum_coherence/src/auth/bloc/auth_bloc.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            children: [
              BlocBuilder<AuthBloc, AuthState>(
                builder: (context, state) {
                  final user = state.user;

                  return Row(
                    children: [
                      if (user.imageUrl.isNotEmpty) ...[
                        CircleAvatar(
                          backgroundImage: NetworkImage(user.imageUrl),
                          radius: 30,
                        ),
                        const SizedBox(width: 8),
                      ],
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (user.name.isNotEmpty)
                            Text(
                              user.name,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          if (user.email.isNotEmpty)
                            Text(
                              user.email,
                              style: const TextStyle(color: Colors.grey),
                            ),
                        ],
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 12),
              const Divider(thickness: 1),
              ListTile(
                title: const Text('Logout'),
                trailing: const Icon(PhosphorIcons.signOut, color: Colors.red),
                onTap: () {
                  HapticFeedback.lightImpact();
                  showDialog<void>(
                    context: context,
                    builder: (context) => Center(
                      child: Card(
                        margin: const EdgeInsets.all(36),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              const Text(
                                'Logout?',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                'By clicking yes you will be '
                                'logged out of your profile!',
                                style: TextStyle(color: Colors.grey),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  TextButton(
                                    style: TextButton.styleFrom(
                                      foregroundColor: Colors.grey,
                                    ),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text('No'),
                                  ),
                                  const SizedBox(width: 16),
                                  TextButton(
                                    style: TextButton.styleFrom(
                                      foregroundColor: Colors.red,
                                    ),
                                    onPressed: () {
                                      context
                                          .read<AuthBloc>()
                                          .add(LogoutRequested());
                                      Navigator.of(context).popUntil(
                                        (route) => route.isFirst,
                                      );
                                    },
                                    child: const Text('Yes'),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
