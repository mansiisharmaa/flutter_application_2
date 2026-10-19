import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:zego_uikit/zego_uikit.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import '../models/user_model.dart';
import '../services/user_service.dart';

class UserTile extends StatelessWidget {
  final UserModel user;

  const UserTile({super.key, required this.user});

  Future<bool> _checkPermissions(BuildContext context, bool isVideo) async {
    final micStatus = await Permission.microphone.request();
    if (micStatus.isPermanentlyDenied) {
      _showPermissionDialog(context, 'Microphone');
      return false;
    }

    if (isVideo) {
      final camStatus = await Permission.camera.request();
      if (camStatus.isPermanentlyDenied) {
        _showPermissionDialog(context, 'Camera');
        return false;
      }
      return micStatus.isGranted && camStatus.isGranted;
    }
    return micStatus.isGranted;
  }

  void _showPermissionDialog(BuildContext context, String permission) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('$permission Permission Required'),
        content: Text('Please enable $permission permission in app settings to make calls.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              openAppSettings();
            },
            child: const Text('Open Settings'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0.5,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Stack(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundColor: Colors.grey.shade200,
              backgroundImage: NetworkImage(user.avatarUrl),
            ),
            Positioned(
              right: 0,
              bottom: 0,
              child: CircleAvatar(
                radius: 6,
                backgroundColor: user.isOnline ? Colors.green : Colors.grey,
              ),
            ),
          ],
        ),
        title: Text(
          user.name,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            decoration: user.isBlocked ? TextDecoration.lineThrough : null,
          ),
        ),
        subtitle: Text(
          user.isBlocked ? 'Blocked' : (user.isOnline ? 'Online' : 'Offline'),
          style: TextStyle(
            color: user.isBlocked
                ? Colors.red
                : (user.isOnline ? Colors.green.shade700 : Colors.grey),
            fontSize: 13,
          ),
        ),
        trailing: user.isBlocked
            ? IconButton(
                icon: const Icon(Icons.lock_open, color: Colors.blue),
                tooltip: 'Unblock',
                onPressed: () => UserService.instance.toggleBlockUser(user.id),
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ZegoSendCallInvitationButton(
                    isVideoCall: false,
                    resourceID: "zego_data",
                    invitees: [ZegoUIKitUser(id: user.id, name: user.name)],
                    iconSize: const Size(36, 36),
                    buttonSize: const Size(40, 40),
                    onWillPressed: () async => await _checkPermissions(context, false),
                  ),
                  const SizedBox(width: 8),
                  ZegoSendCallInvitationButton(
                    isVideoCall: true,
                    resourceID: "zego_data",
                    invitees: [ZegoUIKitUser(id: user.id, name: user.name)],
                    iconSize: const Size(36, 36),
                    buttonSize: const Size(40, 40),
                    onWillPressed: () async => await _checkPermissions(context, true),
                  ),
                  PopupMenuButton(
                    itemBuilder: (ctx) => [
                      PopupMenuItem(
                        value: 'block',
                        child: Text(user.isBlocked ? 'Unblock' : 'Block User'),
                      ),
                    ],
                    onSelected: (val) {
                      if (val == 'block') {
                        UserService.instance.toggleBlockUser(user.id);
                      }
                    },
                  ),
                ],
              ),
      ),
    );
  }
}