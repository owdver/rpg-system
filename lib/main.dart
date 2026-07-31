import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'app/router.dart';
import 'app/theme/app_theme.dart';
import 'core/services/logger_service.dart';

// Startup trace logger
final _trace = LoggerService.instance.getLogger('StartupTrace');

// Global error tracking
final _errorLog = <String>[];
void _logError(String msg) {
  final timestamp = DateTime.now().toIso8601String();
  final entry = '[$timestamp] ERROR: $msg';
  _errorLog.add(entry);
  debugPrint(entry);
}

// Install global error handlers
void _installErrorHandlers() {
  debugPrint('[STARTUP] Installing global error handlers...');

  // FlutterError handler - catches Flutter framework errors
  FlutterError.onError = (FlutterErrorDetails details) {
    final msg = 'FlutterError: ${details.exceptionAsString()}\n'
        'Summary: ${details.summary}\n'
        'Stack:\n${details.stack}';
    _logError(msg);
    debugPrint('[STARTUP] FlutterError caught: $msg');
    FlutterError.presentError(details);
  };

  // PlatformDispatcher onError - catches platform-level errors
  // Note: In Flutter 3.24, we use the binding's error handler
  // PlatformDispatcher.instance.onError is not directly accessible this way
  // Instead we rely on FlutterError.onError

  debugPrint('[STARTUP] Error handlers installed');
}

void main() async {
  // Install global error handlers FIRST
  _installErrorHandlers();

  _trace.startOperation('MAIN_ENTRY');

  _trace.enter('WidgetsFlutterBinding.ensureInitialized');
  try {
    WidgetsFlutterBinding.ensureInitialized();
    _trace.exit('WidgetsFlutterBinding.ensureInitialized');
  } catch (e, st) {
    _trace.failOperation('WidgetsFlutterBinding.ensureInitialized', e, st);
    _logError('FATAL in ensureInitialized: $e\n$st');
    rethrow;
  }

  // Initialize logging
  _trace.enter('LoggerService.initialize');
  LoggerService.instance.initialize(
    minimumLevel: LogLevel.debug,
    enableConsole: true,
  );
  _trace.exit('LoggerService.initialize');

  // Set preferred orientations
  _trace.enter('SystemChrome.setPreferredOrientations');
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  _trace.exit('SystemChrome.setPreferredOrientations');

  // Set system UI overlay style
  _trace.enter('SystemChrome.setSystemUIOverlayStyle');
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Color(0xFF0B1428),
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );
  _trace.exit('SystemChrome.setSystemUIOverlayStyle');

  // Enable edge-to-edge mode
  _trace.enter('SystemChrome.setEnabledSystemUIMode');
  SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.edgeToEdge,
  );
  _trace.exit('SystemChrome.setEnabledSystemUIMode');

  _trace.enter('runApp');
  runApp(
    ProviderScope(
      child: RpgSystemApp(),
      overrides: [],
    ),
  );
  _trace.exit('runApp');

  _trace.completeOperation('MAIN_ENTRY');
}

/// Custom ErrorWidget to show rendering errors prominently
Widget _errorBuilder(Widget child, FlutterError error) {
  debugPrint('[ERROR WIDGET] Showing error');
  debugPrint('[ERROR WIDGET] Message: ${error.message}');

  return MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Scaffold(
      backgroundColor: Colors.red.shade900,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, color: Colors.white, size: 64),
              const SizedBox(height: 24),
              const Text(
                'RENDERING ERROR',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.black26,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Message:',
                        style: TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        error.message,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontFamily: 'monospace'),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Occurred at: ${DateTime.now().toIso8601String()}',
                style: const TextStyle(color: Colors.white70, fontSize: 10),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

/// The root application widget.
class RpgSystemApp extends ConsumerWidget {
  const RpgSystemApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    _trace.enter('RpgSystemApp.build');

    _trace.enter('routerProvider.watch');
    final router = ref.watch(routerProvider);
    _trace.exit('routerProvider.watch', router);

    _trace.enter('MaterialApp.router.build');
    final result = MaterialApp.router(
      title: 'System',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.dark,
      routerConfig: router,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', 'US'),
      ],
      builder: (context, child) {
        _trace.enter('MaterialApp.builder');
        // Wrap with error boundary
        Widget result = child ?? const SizedBox.shrink();
        result = _ErrorBoundary(child: result);
        result = MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaler: TextScaler.noScaling,
          ),
          child: result,
        );
        _trace.exit('MaterialApp.builder');
        return result;
      },
    );
    _trace.exit('MaterialApp.router.build');
    _trace.exit('RpgSystemApp.build');

    return result;
  }
}

/// Error boundary widget to catch and display rendering errors
class _ErrorBoundary extends StatefulWidget {
  final Widget child;
  const _ErrorBoundary({required this.child});

  @override
  State<_ErrorBoundary> createState() => _ErrorBoundaryState();
}

class _ErrorBoundaryState extends State<_ErrorBoundary> {
  Object? _error;
  StackTrace? _stackTrace;

  @override
  void initState() {
    super.initState();
    debugPrint('[ERROR BOUNDARY] Initialized');
  }

  @override
  Widget build(BuildContext context) {
    if (_error != null) {
      debugPrint('[ERROR BOUNDARY] Rendering error widget');
      return _errorWidget(_error!, _stackTrace);
    }
    return widget.child;
  }

  Widget _errorWidget(Object error, StackTrace? stack) {
    debugPrint('[ERROR BOUNDARY] Error: $error');
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: const Color(0xFF8B0000),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Icon(Icons.bug_report, color: Colors.white, size: 80),
                const SizedBox(height: 24),
                const Text(
                  'RENDERING ERROR',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 4,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  DateTime.now().toIso8601String(),
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
                const SizedBox(height: 32),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.black38,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white24),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Exception:',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      SelectableText(
                        error.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontFamily: 'monospace',
                        ),
                      ),
                      if (stack != null) ...[
                        const SizedBox(height: 24),
                        const Text(
                          'Stack Trace:',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          constraints: const BoxConstraints(maxHeight: 300),
                          child: SingleChildScrollView(
                            child: SelectableText(
                              stack.toString(),
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 11,
                                fontFamily: 'monospace',
                              ),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
