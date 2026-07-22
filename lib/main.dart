import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:home_widget/home_widget.dart';
import 'core/database/secure_db.dart';
import 'core/theme/app_theme.dart';
import 'core/routing/app_router.dart';
import 'shared/providers.dart';

void main() async {
  // Ensure native bindings are active
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize secure encrypted database (Hive CE + KeyStore)
  await SecureDb.init();

  // Retrieve initial launch URI from widget/shortcut
  final launchUri = await HomeWidget.initiallyLaunchedFromHomeWidget();
  String initialLocation = '/';
  
  if (launchUri != null && launchUri.scheme.toLowerCase() == 'lifecard') {
    final host = launchUri.host.toLowerCase();
    final path = launchUri.path.toLowerCase();
    if (host == 'sos' || path == '/sos') {
      initialLocation = '/sos';
    } else if (host == 'medical' || path == '/medical') {
      initialLocation = '/medical_view';
    }
  }

  runApp(
    ProviderScope(
      overrides: [
        initialLocationProvider.overrideWithValue(initialLocation),
      ],
      child: const LifeCardApp(),
    ),
  );
}

class LifeCardApp extends ConsumerStatefulWidget {
  const LifeCardApp({super.key});

  @override
  ConsumerState<LifeCardApp> createState() => _LifeCardAppState();
}

class _LifeCardAppState extends ConsumerState<LifeCardApp> {
  StreamSubscription<Uri?>? _widgetClickedSubscription;

  @override
  void initState() {
    super.initState();
    _initHomeWidgetListener();
  }

  @override
  void dispose() {
    _widgetClickedSubscription?.cancel();
    super.dispose();
  }

  void _initHomeWidgetListener() {
    // Listen for clicks when app is in memory (warm start)
    _widgetClickedSubscription = HomeWidget.widgetClicked.listen((Uri? uri) {
      debugPrint('LifeCardApp HomeWidget.widgetClicked: $uri');
      if (mounted) {
        _handleUri(uri);
      }
    });

    // Force update widget on startup to bind click handlers
    HomeWidget.updateWidget(
      name: 'SosWidgetProvider',
      androidName: 'SosWidgetProvider',
    );
  }

  void _handleUri(Uri? uri) {
    if (uri == null) return;
    debugPrint('LifeCardApp _handleUri: $uri');
    if (uri.scheme.toLowerCase() == 'lifecard') {
      final router = ref.read(routerProvider);
      final host = uri.host.toLowerCase();
      final path = uri.path.toLowerCase();
      
      if (host == 'sos' || path == '/sos') {
        router.push('/sos');
      } else if (host == 'medical' || path == '/medical') {
        router.push('/medical_view');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
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

        return GetMaterialApp.router(
          title: 'LifeCard SOS',
          debugShowCheckedModeBanner: false,
          themeMode: themeMode,
          theme: theme,
          darkTheme: darkTheme,
          routeInformationProvider: router.routeInformationProvider,
          routeInformationParser: router.routeInformationParser,
          routerDelegate: router.routerDelegate,
          backButtonDispatcher: router.backButtonDispatcher,
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
