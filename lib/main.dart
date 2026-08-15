import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'ui/viewmodels/auth_viewmodel.dart';
import 'ui/viewmodels/password_viewmodel.dart';
import 'ui/screens/pin_screen.dart';
import 'ui/screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthViewModel()..checkPinState()),
        ChangeNotifierProvider(create: (_) => PasswordViewModel()),
      ],
      child: const PasswordManagerApp(),
    ),
  );
}

class PasswordManagerApp extends StatefulWidget {
  const PasswordManagerApp({super.key});

  @override
  State<PasswordManagerApp> createState() => _PasswordManagerAppState();
}

class _PasswordManagerAppState extends State<PasswordManagerApp> with WidgetsBindingObserver {
  Timer? _inactivityTimer;
  // Dynamic inactivity timeout (misal: 3 menit)
  static const _timeoutDuration = Duration(minutes: 3);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _resetInactivityTimer();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _inactivityTimer?.cancel();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused || state == AppLifecycleState.inactive) {
      // Kunci aplikasi jika masuk ke background / minimised
      context.read<AuthViewModel>().lockApp();
    }
  }

  void _resetInactivityTimer() {
    _inactivityTimer?.cancel();
    _inactivityTimer = Timer(_timeoutDuration, () {
      if (mounted) {
        context.read<AuthViewModel>().lockApp();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isAuthenticated = context.watch<AuthViewModel>().isAuthenticated;

    return Listener(
      behavior: HitTestBehavior.translucent,
      onPointerDown: (_) => _resetInactivityTimer(),
      onPointerMove: (_) => _resetInactivityTimer(),
      child: MaterialApp(
        title: 'Password Manager',
        debugShowCheckedModeBanner: false,
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
        themeMode: ThemeMode.system,
        home: isAuthenticated ? const HomeScreen() : const PinScreen(),
      ),
    );
  }
}
