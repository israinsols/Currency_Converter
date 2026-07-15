import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'constants/app_constants.dart';
import 'theme/app_theme.dart';
import 'providers/services_provider.dart';
import 'providers/theme_provider.dart';
import 'services/storage_service.dart';
import 'screens/splash_screen.dart';
import 'screens/home_screen.dart';
import 'screens/currency_selection_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/about_screen.dart';
import 'screens/privacy_screen.dart';
import 'screens/terms_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  
  final storageService = StorageService();
  await storageService.init();
  
  runApp(
    ProviderScope(
      overrides: [
        storageServiceProvider.overrideWithValue(storageService),
      ],
      child: const CurrencyConverterApp(),
    ),
  );
}

class CurrencyConverterApp extends ConsumerWidget {
  const CurrencyConverterApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeModeIndex = ref.watch(themeModeProvider);

    ThemeMode themeMode;
    switch (themeModeIndex) {
      case 1:
        themeMode = ThemeMode.light;
        break;
      case 2:
        themeMode = ThemeMode.dark;
        break;
      default:
        themeMode = ThemeMode.system;
    }

    return MaterialApp(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: themeMode,
      initialRoute: '/splash',
      routes: {
        '/splash': (_) => const SplashScreen(),
        '/home': (_) => const HomeScreen(),
        '/currency_selection': (_) => const CurrencySelectionScreen(),
        '/settings': (_) => const SettingsScreen(),
        '/about': (_) => const AboutScreen(),
        '/privacy': (_) => const PrivacyScreen(),
        '/terms': (_) => const TermsScreen(),
      },
    );
  }
}
