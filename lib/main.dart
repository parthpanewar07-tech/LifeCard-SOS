import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/database/secure_db.dart';
import 'core/theme/app_theme.dart';
import 'core/routing/app_router.dart';
import 'shared/providers.dart';

void main() async {
  // Ensure native bindings are active
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize secure encrypted database (Hive CE + KeyStore)
  await SecureDb.init();

  runApp(
    const ProviderScope(
      child: LifeCardApp(),
    ),
  );
}

class LifeCardApp extends ConsumerWidget {
  const LifeCardApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final settingsAsync = ref.watch(settingsProvider);

    return settingsAsync.when(
      data: (settings) {
        ThemeMode themeMode;
        ThemeData theme;
        ThemeData? darkTheme;

        // Parse theme settings
        switch (settings.themeMode) {
          case 'light':
            themeMode = ThemeMode.light;
            theme = AppTheme.lightTheme;
            darkTheme = AppTheme.darkTheme;
          case 'dark':
            themeMode = ThemeMode.dark;
            theme = AppTheme.lightTheme;
            darkTheme = AppTheme.darkTheme;
          case 'amoled':
            themeMode = ThemeMode.dark;
            theme = AppTheme.lightTheme;
            darkTheme = AppTheme.amoledTheme;
          case 'system':
          default:
            themeMode = ThemeMode.system;
            theme = AppTheme.lightTheme;
            darkTheme = AppTheme.darkTheme;
        }

        return MaterialApp.router(
          title: 'LifeCard SOS',
          debugShowCheckedModeBanner: false,
          themeMode: themeMode,
          theme: theme,
          darkTheme: darkTheme,
          routerConfig: router,
        );
      },
      loading: () => const MaterialApp(
        home: Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      ),
      error: (err, stack) => MaterialApp(
        home: Scaffold(
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Text(
                'Initialization Error:\n$err',
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
