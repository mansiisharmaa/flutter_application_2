import 'package:flutter/material.dart';
import 'package:flutter_application_2/screens/splash_screen.dart';
import 'package:flutter_application_2/firebase_options.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:firebase_core/firebase_core.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.light);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // 3. Initialize Zego Service
  ZegoUIKitPrebuiltCallInvitationService().setNavigatorKey(navigatorKey);

  // 4. Run the app
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (_, currentTheme, _) {
        return MaterialApp(
          title: 'ConnectCall',
          navigatorKey: navigatorKey,
          debugShowCheckedModeBanner: false,
          themeMode: currentTheme,
          theme: ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.blueAccent,
              brightness: Brightness.light,
            ),
          ),
          darkTheme: ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.blueAccent,
              brightness: Brightness.dark,
            ),
          ),
          home: SplashScreen(),
        );
      },
    );
  }
}
