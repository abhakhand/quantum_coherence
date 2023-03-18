import 'package:agora_uikit/agora_uikit.dart';
import 'package:flutter/material.dart';

class VideoMeetView extends StatefulWidget {
  const VideoMeetView({super.key});

  @override
  State<VideoMeetView> createState() => _VideoMeetViewState();
}

class _VideoMeetViewState extends State<VideoMeetView> {
  final AgoraClient client = AgoraClient(
    agoraConnectionData: AgoraConnectionData(
      appId: 'b4a9c39e8c6442018e118d3744093e68',
      channelName: 'meet:1-1',
    ),
  );

  @override
  void initState() {
    super.initState();
    initAgora();
    Future<void>.delayed(const Duration(milliseconds: 500));
  }

  Future<void> initAgora() async => client.initialize();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            AgoraVideoViewer(client: client),
            AgoraVideoButtons(client: client),
          ],
        ),
      ),
    );
  }
}
