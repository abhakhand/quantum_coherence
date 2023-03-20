import 'dart:developer';
import 'dart:math' hide log;

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:quantum_coherence/src/auth/bloc/auth_bloc.dart';
import 'package:quantum_coherence/src/home/models/session.dart';

class VideoMeetView extends StatefulWidget {
  const VideoMeetView({required this.session, super.key});

  final Session session;

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<VideoMeetView> {
  int uid = 0;

  late final RtcEngine _engine;
  bool _isReadyPreview = false;

  bool isJoined = false;
  bool switchCamera = true;
  bool switchRender = true;
  Set<int> remoteUid = {};
  final bool _isUseFlutterTexture = false;
  final bool _isUseAndroidSurfaceView = false;
  final _channelProfileType = ChannelProfileType.channelProfileLiveBroadcasting;

  bool videoOff = false;
  bool micOff = false;
  bool remoteVideoOff = false;

  @override
  void initState() {
    super.initState();
    uid = Random().nextInt(100) + 1000;
    _initEngine();
  }

  @override
  void dispose() {
    _dispose();
    super.dispose();
  }

  Future<void> _dispose() async {
    await _engine.leaveChannel();
    await _engine.release();
  }

  Future<void> _initEngine() async {
    _engine = createAgoraRtcEngine();
    await _engine.initialize(
      const RtcEngineContext(appId: ''),
    );

    _engine.registerEventHandler(
      RtcEngineEventHandler(
        onError: (ErrorCodeType err, String msg) {
          log('[onError] err: $err, msg: $msg');
        },
        onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
          log(
            '[onJoinChannelSuccess] connection: ${connection.toJson()}'
            ' elapsed: $elapsed',
          );
          setState(() {
            isJoined = true;
          });
        },
        onUserJoined: (RtcConnection connection, int rUid, int elapsed) {
          log(
            '[onUserJoined] connection: ${connection.toJson()}'
            ' remoteUid: $rUid elapsed: $elapsed',
          );
          setState(() {
            remoteUid.add(rUid);
          });
        },
        onUserOffline:
            (RtcConnection connection, int rUid, UserOfflineReasonType reason) {
          log(
            '[onUserOffline] connection: ${connection.toJson()}'
            '  rUid: $rUid reason: $reason',
          );
          setState(() {
            remoteUid.removeWhere((element) => element == rUid);
          });
        },
        onLeaveChannel: (RtcConnection connection, RtcStats stats) {
          log(
            '[onLeaveChannel] connection: ${connection.toJson()}'
            ' stats: ${stats.toJson()}',
          );
          setState(() {
            isJoined = false;
            remoteUid.clear();
          });
        },
        onUserMuteVideo: (connection, remoteUid, muted) {
          setState(() {
            remoteVideoOff = muted;
          });
        },
      ),
    );

    await _engine.enableVideo();

    await _engine.setVideoEncoderConfiguration(
      const VideoEncoderConfiguration(
        dimensions: VideoDimensions(width: 640, height: 360),
        frameRate: 15,
        bitrate: 0,
      ),
    );

    await _engine.startPreview();

    setState(() {
      _isReadyPreview = true;
    });
  }

  Future<void> _joinChannel(BuildContext context) async {
    final user = context.read<AuthBloc>().state.user;

    await _engine.joinChannel(
      token: user.token,
      channelId: widget.session.id,
      uid: uid,
      options: ChannelMediaOptions(
        channelProfile: _channelProfileType,
        clientRoleType: ClientRoleType.clientRoleBroadcaster,
      ),
    );
  }

  Future<void> _switchCamera() async {
    await _engine.switchCamera();
    setState(() {
      switchCamera = !switchCamera;
    });
  }

  Future<void> _switchVideo() async {
    if (videoOff) {
      await _engine.enableLocalVideo(true);
      setState(() {
        videoOff = false;
      });
    } else {
      await _engine.enableLocalVideo(false);
      setState(() {
        videoOff = true;
      });
    }
  }

  Future<void> _switchAudio() async {
    // await _engine.setRemoteRenderMode(
    //   uid: uid,
    //   renderMode: RenderModeType.renderModeFit,
    //   mirrorMode: VideoMirrorModeType.videoMirrorModeAuto,
    // );
    if (micOff) {
      await _engine.enableLocalAudio(true);
      setState(() {
        micOff = false;
      });
    } else {
      await _engine.enableLocalAudio(false);
      setState(() {
        micOff = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: ExampleActionsWidget(
        session: widget.session,
        displayContentBuilder: (context, isLayoutHorizontal) {
          if (!_isReadyPreview) return Container();
          return Stack(
            children: [
              // Remote User
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                transitionBuilder: (child, animation) => SizeTransition(
                  sizeFactor: animation,
                  child: child,
                ),
                child: remoteUid.isEmpty
                    ? const SizedBox.shrink()
                    : remoteVideoOff
                        ? ColoredBox(
                            color: Colors.grey.shade800,
                            child: Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.videocam_off_outlined,
                                    size: 40,
                                    color: Colors.grey,
                                  ),
                                  if (remoteUid.isEmpty)
                                    const Text(
                                      'Your video is turned off!',
                                      style: TextStyle(
                                        color: Colors.grey,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          )
                        : AgoraVideoView(
                            controller: VideoViewController.remote(
                              rtcEngine: _engine,
                              canvas: VideoCanvas(uid: remoteUid.first),
                              connection: RtcConnection(
                                channelId: widget.session.id,
                              ),
                              useFlutterTexture: _isUseFlutterTexture,
                              useAndroidSurfaceView: _isUseAndroidSurfaceView,
                            ),
                          ),
              ),

              // Current User
              Align(
                alignment:
                    remoteUid.isEmpty ? Alignment.center : Alignment.topLeft,
                child: SizedBox(
                  height: remoteUid.isEmpty ? null : 120,
                  width: remoteUid.isEmpty ? null : 120,
                  child: videoOff
                      ? ColoredBox(
                          color: Colors.grey.shade800,
                          child: Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.videocam_off_outlined,
                                  size: 40,
                                  color: Colors.grey,
                                ),
                                if (remoteUid.isEmpty)
                                  const Text(
                                    'Your video is turned off!',
                                    style: TextStyle(
                                      color: Colors.grey,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        )
                      : AgoraVideoView(
                          controller: VideoViewController(
                            rtcEngine: _engine,
                            canvas: const VideoCanvas(uid: 0),
                            useFlutterTexture: _isUseFlutterTexture,
                            useAndroidSurfaceView: _isUseAndroidSurfaceView,
                          ),
                        ),
                ),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        widget.session.mentor.name,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Image.asset(
                        widget.session.mentor.image,
                        height: 24,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
        actionsBuilder: (context, isLayoutHorizontal) {
          // final channelProfileType = [
          //   ChannelProfileType.channelProfileLiveBroadcasting,
          //   ChannelProfileType.channelProfileCommunication,
          // ];
          // final items = channelProfileType
          //     .map(
          //       (e) => DropdownMenuItem(
          //         value: e,
          //         child: Text(e.toString().split('.')[1]),
          //       ),
          //     )
          //     .toList();

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // if (!kIsWeb &&
              //     (defaultTargetPlatform == TargetPlatform.android ||
              //         defaultTargetPlatform == TargetPlatform.iOS))
              //   Row(
              //     mainAxisSize: MainAxisSize.min,
              //     children: [
              //       if (defaultTargetPlatform == TargetPlatform.iOS)
              //         Column(
              //           crossAxisAlignment: CrossAxisAlignment.start,
              //           mainAxisSize: MainAxisSize.min,
              //           children: [
              //             const Text('Rendered by Flutter texture: '),
              //             Switch(
              //               value: _isUseFlutterTexture,
              //               onChanged: isJoined
              //                   ? null
              //                   : (changed) {
              //                       setState(() {
              //                         _isUseFlutterTexture = changed;
              //                       });
              //                     },
              //             )
              //           ],
              //         ),
              //       if (defaultTargetPlatform == TargetPlatform.android)
              //         Column(
              //           crossAxisAlignment: CrossAxisAlignment.start,
              //           mainAxisSize: MainAxisSize.min,
              //           children: [
              //             const Text('Rendered by Android SurfaceView: '),
              //             Switch(
              //               value: _isUseAndroidSurfaceView,
              //               onChanged: isJoined
              //                   ? null
              //                   : (changed) {
              //                       setState(() {
              //                         _isUseAndroidSurfaceView = changed;
              //                       });
              //                     },
              //             ),
              //           ],
              //         ),
              //     ],
              //   ),
              // const SizedBox(height: 20),
              // const Text('Channel Profile: '),
              // DropdownButton<ChannelProfileType>(
              //   items: items,
              //   value: _channelProfileType,
              //   onChanged: isJoined
              //       ? null
              //       : (v) {
              //           setState(() {
              //             _channelProfileType = v!;
              //           });
              //         },
              // ),
              // const SizedBox(height: 20),

              if (defaultTargetPlatform == TargetPlatform.android ||
                  defaultTargetPlatform == TargetPlatform.iOS) ...[
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        shape: const CircleBorder(),
                        padding: const EdgeInsets.all(12),
                        backgroundColor:
                            switchCamera ? Colors.transparent : Colors.green,
                        foregroundColor:
                            switchCamera ? Colors.green : Colors.white,
                      ),
                      onPressed: _switchCamera,
                      child: const Icon(Icons.cameraswitch_rounded),
                    ),
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        shape: const CircleBorder(),
                        padding: const EdgeInsets.all(12),
                        backgroundColor:
                            !videoOff ? Colors.transparent : Colors.green,
                        foregroundColor:
                            !videoOff ? Colors.green : Colors.white,
                      ),
                      onPressed: _switchVideo,
                      child: Icon(
                        videoOff
                            ? Icons.videocam_off_rounded
                            : Icons.videocam_rounded,
                      ),
                    ),
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        shape: const CircleBorder(),
                        padding: const EdgeInsets.all(12),
                        backgroundColor:
                            !micOff ? Colors.transparent : Colors.green,
                        foregroundColor: !micOff ? Colors.green : Colors.white,
                      ),
                      onPressed: _switchAudio,
                      child: Icon(
                        micOff ? Icons.mic_off_rounded : Icons.mic_rounded,
                      ),
                    ),
                    SizedBox(
                      width: 120,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: const StadiumBorder(),
                          padding: const EdgeInsets.all(12),
                          backgroundColor: isJoined ? Colors.red : Colors.green,
                        ),
                        onPressed: () {
                          HapticFeedback.lightImpact();

                          if (isJoined) {
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: [
                                        const Text(
                                          'Leave Session?',
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        const Text(
                                          'By clicking yes you will be '
                                          'disconnected from this session.',
                                          style: TextStyle(
                                            color: Colors.grey,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
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
                          } else {
                            _joinChannel(context);
                            Fluttertoast.showToast(msg: 'Session Joined!');
                          }
                        },
                        child: Text(isJoined ? 'Leave' : 'Join'),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          );
        },
      ),
    );
  }
}

typedef ExampleActionsBuilder = Widget Function(
  BuildContext context,
  bool isLayoutHorizontal,
);

class ExampleActionsWidget extends StatelessWidget {
  const ExampleActionsWidget({
    required this.session,
    required this.displayContentBuilder,
    this.actionsBuilder,
    super.key,
  });

  final Session session;
  final ExampleActionsBuilder displayContentBuilder;
  final ExampleActionsBuilder? actionsBuilder;

  @override
  Widget build(BuildContext context) {
    final mediaData = MediaQuery.of(context);
    final isLayoutHorizontal = mediaData.size.aspectRatio >= 1.5 ||
        (kIsWeb ||
            !(defaultTargetPlatform == TargetPlatform.android ||
                defaultTargetPlatform == TargetPlatform.iOS));

    if (actionsBuilder == null) {
      return displayContentBuilder(context, isLayoutHorizontal);
    }

    final actionsTitle = Text(
      session.name,
      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
    );

    if (isLayoutHorizontal) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.fromLTRB(16, 24, 16, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    actionsTitle,
                    actionsBuilder!(context, isLayoutHorizontal),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: displayContentBuilder(context, isLayoutHorizontal),
          ),
        ],
      );
    }

    return Column(
      children: [
        Expanded(
          child: displayContentBuilder(context, isLayoutHorizontal),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24)
              .copyWith(top: 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              actionsTitle,
              Flexible(
                child: Text(
                  session.description,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ),
              actionsBuilder!(context, isLayoutHorizontal),
            ],
          ),
        ),
      ],
    );
  }
}
