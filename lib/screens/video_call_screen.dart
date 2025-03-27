import 'dart:async';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:get/get.dart';

class VideoCallScreen extends StatefulWidget {
  const VideoCallScreen({Key? key}) : super(key: key);

  @override
  _VideoCallScreenState createState() => _VideoCallScreenState();
}

class _VideoCallScreenState extends State<VideoCallScreen> {
  int? _remoteUid;
  bool _localUserJoined = false;
  late RtcEngine _engine;
  
  late String appId;
  late String token;
  late String channel;

  @override
  void initState() {
    super.initState();
    final consulta = Get.arguments['consulta'];
    token = consulta.rtcToken;
    channel = 'consulta_${consulta.id}';
    appId = "0bd5051c48e94ca799ad873e186a761e"; // Certifique-se de carregar do ambiente seguro
    _startVideoCalling();
  }

  Future<void> _startVideoCalling() async {
    await _requestPermissions();
    await _initializeAgoraVideoSDK();
    await _setupLocalVideo();
    _setupEventHandlers();
    await _joinChannel();
  }

  Future<void> _requestPermissions() async {
    await [Permission.microphone, Permission.camera].request();
  }

  Future<void> _initializeAgoraVideoSDK() async {
    _engine = createAgoraRtcEngine();
    await _engine.initialize(const RtcEngineContext(
      appId: "0bd5051c48e94ca799ad873e186a761e",
      channelProfile: ChannelProfileType.channelProfileCommunication,
    ));
  }

  Future<void> _setupLocalVideo() async {
    await _engine.enableVideo();
    await _engine.startPreview();
  }

  void _setupEventHandlers() {
    _engine.registerEventHandler(
      RtcEngineEventHandler(
        onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
          debugPrint("Local user ${connection.localUid} joined");
          setState(() => _localUserJoined = true);
        },
        onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
          debugPrint("Remote user $remoteUid joined");
          setState(() => _remoteUid = remoteUid);
        },
        onUserOffline: (RtcConnection connection, int remoteUid, UserOfflineReasonType reason) {
          debugPrint("Remote user $remoteUid left");
          setState(() => _remoteUid = null);
        },
      ),
    );
  }

  Future<void> _joinChannel() async {
    await _engine.joinChannel(
      token: token,
      channelId: channel,
      options: const ChannelMediaOptions(
        autoSubscribeVideo: true,
        autoSubscribeAudio: true,
        publishCameraTrack: true,
        publishMicrophoneTrack: true,
        clientRoleType: ClientRoleType.clientRoleBroadcaster,
      ),
      uid: 0,
    );
  }

  @override
  void dispose() {
    _cleanupAgoraEngine();
    super.dispose();
  }

  Future<void> _cleanupAgoraEngine() async {
    await _engine.leaveChannel();
    await _engine.release();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Consulta em Andamento'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            _cleanupAgoraEngine();
            Navigator.pop(context);
          },
        ),
      ),
      body: Stack(
        children: [
          Center(child: _remoteVideo()),
          Align(
            alignment: Alignment.topLeft,
            child: SizedBox(
              width: 100,
              height: 150,
              child: Center(
                child: _localUserJoined
                    ? _localVideo()
                    : const CircularProgressIndicator(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _localVideo() {
    return AgoraVideoView(
      controller: VideoViewController(
        rtcEngine: _engine,
        canvas: const VideoCanvas(
          uid: 0,
          renderMode: RenderModeType.renderModeHidden,
        ),
      ),
    );
  }

  Widget _remoteVideo() {
    if (_remoteUid != null) {
      return AgoraVideoView(
        controller: VideoViewController.remote(
          rtcEngine: _engine,
          canvas: VideoCanvas(uid: _remoteUid),
          connection: RtcConnection(channelId: channel),
        ),
      );
    } else {
      return const Text(
        'Aguardando outro participante entrar na chamada...',
        textAlign: TextAlign.center,
      );
    }
  }
}
