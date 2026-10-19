import 'package:flutter/material.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';
import '../core/constants/zego_constants.dart';
import '../models/call_history_model.dart';
import '../models/user_model.dart';
import 'call_history_service.dart';

class AuthService extends ChangeNotifier {
  static final AuthService instance = AuthService._internal();
  AuthService._internal();

  UserModel? currentUser;

  Future<void> login(String email, String password) async {
    final userId = email.replaceAll(RegExp(r'[^a-zA-Z0-9]'), '_');
    final userName = email.split('@').first.toUpperCase();

    currentUser = UserModel(
      id: userId,
      name: userName,
      email: email,
      isOnline: true,
      avatarUrl: "https://api.dicebear.com/7.x/bottts/png?seed=$userId",
    );

    _initZegoCallService();
    notifyListeners();
  }

  void _initZegoCallService() {
    if (currentUser == null) return;

    DateTime? callStartTime;

    ZegoUIKitPrebuiltCallInvitationService().init(
      appID: ZegoConstants.appID,
      appSign: ZegoConstants.appSign,
      userID: currentUser!.id,
      userName: currentUser!.name,
      plugins: [ZegoUIKitSignalingPlugin()],
      requireConfig: (ZegoCallInvitationData data) {
        final config = data.type == ZegoCallInvitationType.videoCall
            ? ZegoUIKitPrebuiltCallConfig.oneOnOneVideoCall()
            : ZegoUIKitPrebuiltCallConfig.oneOnOneVoiceCall();

        // 1. Enable In-Call Duration Timer
        config.duration.isVisible = true;

        // 2. Enable In-App Call Minimization (PiP floating window)
        config.topMenuBarConfig.isVisible = true;
        config.topMenuBarConfig.buttons = [
          ZegoCallMenuBarButtonName.minimizingButton,
          ZegoCallMenuBarButtonName.showMemberListButton,
        ];

        // 3. Customize Bottom Bar Buttons
        if (data.type == ZegoCallInvitationType.videoCall) {
          config.bottomMenuBarConfig.buttons = [
            ZegoCallMenuBarButtonName.toggleMicrophoneButton,
            ZegoCallMenuBarButtonName.switchAudioOutputButton,
            ZegoCallMenuBarButtonName.hangUpButton,
            ZegoCallMenuBarButtonName.toggleCameraButton,
            ZegoCallMenuBarButtonName.switchCameraButton,
          ];
        } else {
          config.bottomMenuBarConfig.buttons = [
            ZegoCallMenuBarButtonName.toggleMicrophoneButton,
            ZegoCallMenuBarButtonName.switchAudioOutputButton,
            ZegoCallMenuBarButtonName.hangUpButton,
          ];
        }

        callStartTime = DateTime.now();
        return config;
      },
      events: ZegoUIKitPrebuiltCallEvents(
        onCallEnd: (ZegoCallEndEvent event, VoidCallback defaultAction) {
          final durationSec = callStartTime != null
              ? DateTime.now().difference(callStartTime!).inSeconds
              : 0;
          final durationFormatted =
              "${(durationSec ~/ 60).toString().padLeft(2, '0')}:${(durationSec % 60).toString().padLeft(2, '0')}";

          // Log completed call in call history
          CallHistoryService.instance.addRecord(
            userName: "Peer Contact",
            type: CallType.video,
            status: CallStatus.incoming,
            duration: durationFormatted,
          );

          defaultAction.call();
        },
      ),
      invitationEvents: ZegoUIKitPrebuiltCallInvitationEvents(
        onIncomingCallDeclineButtonPressed: () {
          CallHistoryService.instance.addRecord(
            userName: "Caller",
            type: CallType.audio,
            status: CallStatus.declined,
            duration: "Declined",
          );
        },
        onIncomingCallTimeout: (String callID, ZegoCallUser caller) {
          CallHistoryService.instance.addRecord(
            userName: caller.name,
            type: CallType.audio,
            status: CallStatus.missed,
            duration: "Missed",
          );
        },
      ),
    );
  }

  void logout() {
    ZegoUIKitPrebuiltCallInvitationService().uninit();
    currentUser = null;
    notifyListeners();
  }
}