import 'package:flutter/material.dart';
import '../../main.dart';
import '../../services/auth_service.dart';
import '../auth/login_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = AuthService.instance.currentUser;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      child: Column(
        children: [
          CircleAvatar(
            radius: 48,
            backgroundColor: Colors.grey.shade300,
            backgroundImage: NetworkImage(
              user?.avatarUrl ?? "https://api.dicebear.com/7.x/bottts/png?seed=me",
            ),
          ),
          const SizedBox(height: 12),
          Text(user?.name ?? 'User', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(user?.email ?? '', style: const TextStyle(color: Colors.grey)),
          const SizedBox(height: 10),
          const Chip(
            avatar: Icon(Icons.circle, color: Colors.white, size: 10),
            label: Text('Active Now', style: TextStyle(color: Colors.white, fontSize: 12)),
            backgroundColor: Colors.green,
          ),
          const SizedBox(height: 28),
          ListTile(
            leading: const Icon(Icons.dark_mode_outlined),
            title: const Text('Dark Mode'),
            trailing: Switch(
              value: isDark,
              onChanged: (_) => themeNotifier.value =
                  isDark ? ThemeMode.light : ThemeMode.dark,
            ),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text('Logout', style: TextStyle(color: Colors.red, fontWeight: FontWeight.w600)),
            onTap: () {
              AuthService.instance.logout();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
                (route) => false,
              );
            },
          ),
        ],
      ),
    );
  }
}