import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:quantum_coherence/src/auth/bloc/auth_bloc.dart';
import 'package:quantum_coherence/src/core/domain/helpers/helpers.dart';
import 'package:quantum_coherence/src/video_meet/views/video_meet_view.dart';
import 'package:quantum_coherence/src/welcome/models/mentor.dart';
import 'package:quantum_coherence/src/welcome/models/session.dart';

class WelcomeView extends StatefulWidget {
  const WelcomeView({super.key});

  @override
  State<WelcomeView> createState() => _WelcomeViewState();
}

class _WelcomeViewState extends State<WelcomeView> {
  @override
  void initState() {
    super.initState();
    requestPermissions();
  }

  Future<void> requestPermissions() async {
    await Permission.camera.request();
    await Permission.microphone.request();
  }

  static const mentors = <Mentor>[
    Mentor(
      name: 'Garima Arora',
      image: 'assets/images/avatar1.png',
    ),
    Mentor(
      name: 'Vikas Khanna',
      image: 'assets/images/avatar2.png',
    ),
    Mentor(
      name: 'Pooja Dhingra',
      image: 'assets/images/avatar3.png',
    ),
    Mentor(
      name: 'Ranveer Brar',
      image: 'assets/images/avatar4.png',
    ),
    Mentor(
      name: 'Kunal Kapoor',
      image: 'assets/images/avatar5.png',
    ),
    Mentor(
      name: 'Nita Mehta',
      image: 'assets/images/avatar6.png',
    ),
  ];

  static final sessions = <Session>[
    Session(
      id: 'med-session-101',
      name: 'Meditation',
      description: 'Lorem ipsum dolor sit amet, consecteur adipiscing elit, '
          'sed eiusmod tempor incididunt.',
      image: 'assets/lottie/meditation.json',
      mentor: mentors[3],
    ),
    Session(
      id: 'yoga-session-101',
      name: 'Yoga',
      description: 'Lorem ipsum dolor sit amet, consecteur adipiscing elit, '
          'sed eiusmod tempor incididunt.',
      image: 'assets/lottie/yoga.json',
      mentor: mentors[0],
    ),
    Session(
      id: 'cons-session-101',
      name: 'Consultation',
      description: 'Lorem ipsum dolor sit amet, consecteur adipiscing elit, '
          'sed eiusmod tempor incididunt.',
      image: 'assets/lottie/consultation.json',
      mentor: mentors[2],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            if (state.user.name.isEmpty) {
              return Text('Good ${sessionName()} 👋');
            } else {
              return Text('Hello, ${state.user.name.split(' ').first} 👋');
            }
          },
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 8),
              const Padding(
                padding: EdgeInsets.only(left: 16, bottom: 12),
                child: Text(
                  'Top Mentors',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
              ),
              SizedBox(
                height: 100,
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.only(left: 16),
                  itemCount: mentors.length,
                  itemBuilder: (context, index) {
                    final mentor = mentors[index];

                    return Padding(
                      padding: const EdgeInsets.only(right: 16),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Flexible(
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.grey.shade300),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(2),
                                child: Image.asset(mentor.image),
                              ),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            mentor.name,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 4),
              const Divider(
                height: 30,
                thickness: 1,
                indent: 16,
                endIndent: 16,
              ),
              const Padding(
                padding: EdgeInsets.only(left: 16, bottom: 12),
                child: Text(
                  'Ongoing Sessions',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
              ),
              SizedBox(
                height: 290,
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.only(left: 16),
                  itemCount: sessions.length,
                  itemBuilder: (context, index) {
                    final session = sessions[index];

                    return SizedBox(
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 16, bottom: 16),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(10),
                          onTap: () {
                            Navigator.of(context).push<void>(
                              MaterialPageRoute(
                                builder: (context) =>
                                    VideoMeetView(session: session),
                              ),
                            );
                          },
                          child: Card(
                            elevation: 0,
                            margin: EdgeInsets.zero,
                            color: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                              side: const BorderSide(color: Colors.grey),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Text(
                                    session.name,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.deepPurple,
                                    ),
                                  ),
                                  Text(
                                    session.description,
                                    maxLines: 1,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Flexible(child: Lottie.asset(session.image)),
                                  Row(
                                    children: [
                                      Image.asset(
                                        session.mentor.image,
                                        height: 24,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        session.mentor.name,
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.grey.shade600,
                                        ),
                                      ),
                                      const Spacer(),
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          elevation: 0,
                                          shape: const StadiumBorder(),
                                          backgroundColor: Colors.green,
                                        ),
                                        onPressed: () {
                                          Navigator.of(context).push<void>(
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  VideoMeetView(
                                                session: session,
                                              ),
                                            ),
                                          );
                                        },
                                        child: const Text(
                                          'Join Now',
                                          style: TextStyle(fontSize: 12),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 4),
              const Padding(
                padding: EdgeInsets.only(left: 16, bottom: 12),
                child: Text(
                  'Our Programs',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
              ),
              SizedBox(
                height: 180,
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.only(left: 16),
                  itemCount: 5,
                  itemBuilder: (context, index) => SizedBox(
                    width: MediaQuery.of(context).size.width * 0.7,
                    child: Card(
                      elevation: 0,
                      margin: const EdgeInsets.only(right: 16, bottom: 16),
                      color: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: const BorderSide(color: Colors.grey),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              'Program ${index + 1}',
                              maxLines: 4,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.deepPurple,
                              ),
                            ),
                            Text(
                              'Lorem ipsum dolor sit amet, consecte '
                              'adipiscing elit, sed eiusmod tempor incididunt.',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.shade600,
                              ),
                            ),
                            const Spacer(),
                            Text(
                              DateFormat.yMMMMEEEEd().format(
                                DateTime.now().add(Duration(days: index + 1)),
                              ),
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
