import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:quantum_coherence/src/auth/bloc/auth_bloc.dart';
import 'package:quantum_coherence/src/auth/views/login_view.dart';
import 'package:quantum_coherence/src/community/views/community_view.dart';
import 'package:quantum_coherence/src/core/domain/helpers/helpers.dart';
import 'package:quantum_coherence/src/home/views/home_page.dart';
import 'package:quantum_coherence/src/profile/views/profile_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late PageController _pageController;
  int pageIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  static const navBarItems = <BottomNavigationBarItem>[
    BottomNavigationBarItem(
      icon: Icon(PhosphorIcons.house),
      activeIcon: Icon(PhosphorIcons.houseFill),
      label: 'Home',
    ),
    BottomNavigationBarItem(
      icon: Icon(PhosphorIcons.usersThree),
      activeIcon: Icon(PhosphorIcons.usersThreeFill),
      label: 'Community',
    ),
    BottomNavigationBarItem(
      icon: Icon(PhosphorIcons.user),
      activeIcon: Icon(PhosphorIcons.userFill),
      label: 'Profile',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: pageIndex == 0
              ? AppBar(
                  title: BlocBuilder<AuthBloc, AuthState>(
                    builder: (context, state) {
                      if (state.user.name.isEmpty) {
                        return Text('Good ${sessionName()} 👋');
                      } else {
                        return Text(
                          'Hello, ${state.user.name.split(' ').first} 👋',
                        );
                      }
                    },
                  ),
                )
              : null,
          body: PageView(
            physics: const NeverScrollableScrollPhysics(),
            controller: _pageController,
            children: const [
              HomePage(),
              CommunityView(),
              ProfileView(),
            ],
          ),
          bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            items: List.generate(
              navBarItems.length,
              (index) => navBarItems[index],
            ),
            currentIndex: pageIndex,
            onTap: (index) {
              setState(() {
                pageIndex = index;
              });

              _pageController.animateToPage(
                pageIndex,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeIn,
              );
            },
          ),
        ),
        BlocConsumer<AuthBloc, AuthState>(
          listenWhen: (p, c) => p.logoutStatus != c.logoutStatus,
          listener: (context, state) {
            if (state.logoutStatus.isSuccess) {
              Navigator.of(context).pushReplacement<void, void>(
                MaterialPageRoute(
                  builder: (context) => const LoginView(),
                ),
              );
            }
          },
          builder: (context, state) {
            if (state.logoutStatus.isLoading) {
              return const SizedBox.expand(
                child: ColoredBox(
                  color: Colors.black54,
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
    );
  }
}
